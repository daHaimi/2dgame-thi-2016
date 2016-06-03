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
            spriteSize, hitbox, animTimeoutMin, animTimeoutMax, animType)
        self.name = name;
        self.image = love.graphics.newImage("assets/" .. imageSrc);
        self.xPosition = math.random(spriteSize + 26, _G._persTable.winDim[1] - 26);
        self.yPosition = yPosition;
        self.value = value;
        self.hitpoints = hitpoints;
        self.spriteSize = spriteSize;
        
        self.hitbox = hitbox;

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
    
    yMovement = 0;
    
    caught = false;
    caughtAt = nil;
    
    soundPlayed = false;
};

--- draw the object
function FishableObject:draw()
    if not self.caught then
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
        
    else
        if math.abs(self.caughtAt - self.yPosition) < 50 then
            if self.value > 0 then
                love.graphics.setColor (0, 255, 0);
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
function FishableObject:update(dt)
    if not self.caught then
        if self.animation then
            self.animation:update(dt);
        end
        
        if ((self.xPosition - self.hitbox[1].deltaXPos) >= _G._persTable.winDim[1]) and self.speed > 0 then

            self.speed = self.speed * -1;
            self.xPosition = _G._persTable.winDim[1] - self:getHitboxWidth(1) - self.hitbox[1].deltaXPos + 
                self.speed * self.speedMulitplicator;

        elseif (self.xPosition + self.hitbox[1].deltaXPos) <= 0 then
            self.speed = self.speed * -1;
            self.xPosition = math.abs(self:getHitboxWidth(1) + self.hitbox[1].deltaXPos + self.speed * self.speedMulitplicator);
        else

            self.xPosition = self.xPosition + self.speed * self.speedMulitplicator;
        end
        self.yPosition = self.yPosition - self.yMovement;
    else
        self.yPosition = self.yPosition + 0.5 * self.yMovement;
    end
end

--- Sets the xPosition
-- @param xPosition The new x position
function FishableObject:setXPosition(xPosition)
    self.xPosition = xPosition;
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

--- sets the amount of pixls to move upwards to match the baits movement
-- @param movement The movement in y direction.
function FishableObject:setYMovement(movement)
    self.yMovement = movement;
end

--- Returns the movement.
-- @return Returns the movement.
function FishableObject:getYMovement()
    return self.yMovement;
end

--- Returns the name of the fishable object.
-- @return Returns the name of the fishable object.
function FishableObject:getName()
    return self.name;
end

--- sets the speed multiplicator to a certain amount
--@param amount prozentage of the slow. 0.25 for slow to 25%
function FishableObject:setSpeedMultiplicator(amount)
    self.speedMulitplicator = amount;
end

--- sets the objects to caught some functions behave in a different way now
function FishableObject:setToCaught()
    self.caught = true;
    self.caughtAt = self.yPosition;
end

return FishableObject;
