Class = require "lib.hump.class";
Animate = require "class.Animate";
require "socket" math.randomseed(socket.gettime() * 10000);

--- FishableObject is the class of all fishable objects
-- @param name The name of the fishable object
-- @param imageSrc The name of the image and sprite suffix
-- @param yPosition y-position of the object
-- @param minSpeed The minimum speed of the object
-- @param maxSpeed The maximum speed of the object
-- @param value value of the object
-- @param hitpoints amount of the hitpoints of the object
-- @param spriteSize Size of the sprite in pixels
-- @param hitbox The hitbox table for this object
-- @param animTimeoutMin The min timeout between the images in seconds
-- @param animTimeoutMax The max timeout between the images in seconds
-- @param animType (Animate.AnimType.linear) The animation type of the enum Animate.AnimType
local FishableObject = Class {
    init = function(self, name, imageSrc, yPosition, minSpeed, maxSpeed, value, hitpoints, 
            spriteSize, hitbox, animTimeoutMin, animTimeoutMax, animType, fallSpeed, levMan)
        self.name = name;
        self.image = love.graphics.newImage("assets/" .. imageSrc);
        self.xPosition = math.random(spriteSize + 26, levMan:getCurLevel().winDim[1] - 58 - self.spriteSize);
        -- 58 = 26 (width of level wall) + 32 (0.5 * width of hamster)
        if fallSpeed > 0 then
            self.yPosition = - math.random(100);
        elseif fallSpeed < 0 then
            self.yPosition = levMan:getCurLevel().winDim[2] + math.random(100);
        else
            self.yPosition = yPosition;
        end
        self.value = value;
        self.hitpoints = hitpoints;
        self.spriteSize = spriteSize;
        self.fallSpeed = fallSpeed;
        self.levMan = levMan;
        self.hitbox = hitbox;
        self.outOfArea = false;

        if (math.random() > 0.5) then
            self.speed = math.random() * (maxSpeed - minSpeed) + minSpeed;
        else
            self.speed = -(math.random() * (maxSpeed - minSpeed) + minSpeed);
        end
        
        local spriteFile = "assets/sprites/sprite_" .. imageSrc;
        if love.filesystem.exists(spriteFile) then
            self.sprite = love.graphics.newImage(spriteFile);
            local spriteCols = self.sprite:getWidth() / self.image:getWidth();
            local spriteRows = self.sprite:getHeight() / self.image:getHeight();
            local animTimeout = nil;
            if animTimeoutMin and animTimeoutMax then
                animTimeout = math.random() * (animTimeoutMax - animTimeoutMin) + animTimeoutMin - 
                              math.abs(self.speed / 100); -- animation speed also depended on move speed
            end
            animType = Animate.AnimType[animType];
            self.animation = Animate(self.sprite, spriteCols, spriteRows, animTimeout, animType);
        end
    end;

    name = "no name";
    xPosition = 0;
    yPosition = 0;
    speed = 0;
    speedMulitplicator = 1;
    value = 0;
    hitpoints = 1;
    spriteSize = 0;
    
    hitbox = {};
    
    caught = false;
    caughtAt = nil;
    
    soundPlayed = false;
};

--- draw the object
function FishableObject:draw()
    if not self.caught and not self.outOfArea then
        love.graphics.setColor(255, 255, 255);
        if self.speed <= 0 then
            if self.animation then
                self.animation:draw(self.xPosition, self.yPosition);
            else
                love.graphics.draw(self.image, self.xPosition, self.yPosition);
            end
            
            love.graphics.setColor(0, 0, 0);
        else
            love.graphics.scale(-1, 1);
            love.graphics.setColor(255, 255, 255);
            if self.animation then
                self.animation:draw(-self.xPosition, self.yPosition);
            else
                love.graphics.draw(self.image, -self.xPosition, self.yPosition);
            end
        
            love.graphics.scale(-1, 1);
        end

        --for showing the Hitbox
        --[[for i = 1, #self.hitbox, 1 do 
            love.graphics.setColor(0,0,0);
            love.graphics.rectangle("line", self:getHitboxXPosition(i), self:getHitboxYPosition(i),
            self:getHitboxWidth(i), self:getHitboxHeight(i));
        end]]
        
    elseif self.caught then
        if math.abs(self.caughtAt - self.yPosition) < 50 then
            if self.value > 0 then
                love.graphics.setColor (0, 255, 0);
                _G._persTable.fish.postiveFishCaught = true;
                if not self.soundPlayed then
                    TEsound.play("assets/sound/collectedPositivValue.wav");
                    self.soundPlayed = true;
                end
            elseif self.value < 0 then
                love.graphics.setColor (255, 0, 0);
                if not self.soundPlayed then
                    TEsound.play("assets/sound/collectedNegativValue.wav");
                    self.soundPlayed = true;
                end
            end
            
            if not (self.value == 0) then
                tempFont = love.graphics.getFont();
                love.graphics.setNewFont(20);
                love.graphics.print (math.abs(self.value), self.xPosition, self.yPosition);
                love.graphics.setFont(tempFont);
            end
        end
    end
end

--- Updates the position of the object depending on its speed
-- @param dt Delta time since last update in seconds
function FishableObject:update(dt, speedMulitplicator)
    if math.abs(self.yPosition - self.levMan:getCurPlayer():getPosY()) > self.levMan:getCurLevel().winDim[2] then
        self.outOfArea = true;
    else
        self.outOfArea = false;
    end
    
    if not self.caught then
        if not self.outOfArea then
            if self.animation then
                self.animation:update(dt);
            end
            
            if ((self.xPosition - self.hitbox[1].deltaXPos) >= _G._persTable.winDim[1]) and self.speed > 0 then
                self.speed = self.speed * -1;
                self.xPosition = _G._persTable.winDim[1] - self:getHitboxWidth(1) - self.hitbox[1].deltaXPos + 
                    self.speed * speedMulitplicator;

            elseif (self.xPosition + self.hitbox[1].deltaXPos) <= 0 then
                self.speed = self.speed * -1;
                self.xPosition = math.abs(self:getHitboxWidth(1) + self.hitbox[1].deltaXPos + self.speed * speedMulitplicator);
                
            else
                self.xPosition = self.xPosition + self.speed * speedMulitplicator;
            end
        end
        if self.fallSpeed == 0 then
            self.yPosition = self.yPosition - self.levMan:getCurLevel():getMoved();
        else
            if self.levMan:getCurLevel():getDirection() == 1 then
                self.yPosition = self.yPosition + self.fallSpeed * speedMulitplicator;
            else
                self.yPosition = self.yPosition + self.fallSpeed * speedMulitplicator 
                    - self.levMan:getCurLevel():getMoved();
            end
        end
    else
        self.yPosition = self.yPosition + 0.5 * self.levMan:getCurLevel():getMoved();
    end
end

--- Sets the xPosition
-- @param xPosition The new x position
function FishableObject:setXPosition(xPosition)
    self.xPosition = xPosition;
end

--- Sets the yPosition
-- @param xPosition The new y position
function FishableObject:setYPosition(yPosition)
    self.yPosition = yPosition;
end

--- Returns the value of the fishable object
-- @return Returns the value of the fishable object
function FishableObject:getValue()
    return self.value;
end

--- returns the remaining hitpoints of the object
-- @return Returns the remaining hitpoints of the object
function FishableObject:getHitpoints()
    return self.hitpoints;
end

--- Returns width of the hitbox of the fishable object
-- @param i The index of the hitbox.
-- @return Returns width of the hitbox of the fishablde object
function FishableObject:getHitboxWidth(i)
    return self.hitbox[i].width;
end

--- Returns height of the hitbox of the object
-- @param i The index of the hitbox.
-- @return Returns height of the hitbox of the object
function FishableObject:getHitboxHeight(i)
    return self.hitbox[i].height;
end

--- Returns x position of the object.
-- @param i The index of the hitbox.
-- @return Returns x position of the object.
function FishableObject:getHitboxXPosition(i)
    if self.speed < 0 then
        return self.xPosition + self.hitbox[i].deltaXPos;
    elseif self.speed == 0 then
        return self.xPosition - self.hitbox[i].deltaXPos - self.hitbox[i].width + self.spriteSize;
    else
        return self.xPosition - self.hitbox[i].deltaXPos - self.hitbox[i].width;
    end
end

--- Returns y the position of the object.
-- @param i The index of the hitbox.
-- @return Returns y the position of the object.
function FishableObject:getHitboxYPosition(i)
    return self.yPosition + self.hitbox[i].deltaYPos;
end

--- Returns the name of the fishable object.
-- @return Returns the name of the fishable object.
function FishableObject:getName()
    return self.name;
end

--- sets the objects to caught some functions behave in a different way now
function FishableObject:setToCaught()
    self.caught = true;
    self.caughtAt = self.yPosition;
end

return FishableObject;
