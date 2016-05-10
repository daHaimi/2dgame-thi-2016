Class = require "lib.hump.class";

--- FishableObject is the class of all fishable object.
-- @param xPosition: x-position of the object
-- @param yPosition: y-position of the object
-- @param xHitbox: width of the hitbox
-- @param yHitbox: height of the hitbox
-- @param speed: number of the pixels moved per step (can be negativ)
-- @param value: value of the object
-- @param hitpoints: amoung of the hitpoints of the object
local FishableObject = Class {
    init = function(self, name, imageSrc, yPosition, minSpeed, maxSpeed, value, hitpoints, spriteSize, hitbox)
        self.name = name;
        self.image = love.graphics.newImage("assets/" .. imageSrc);
        self.xPosition = math.random(spriteSize, _G._persTable.winDim[1]);
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
};

--- draw the object, still no sprite implementet
function FishableObject:draw()
    if not self.caught then
        love.graphics.setColor(255, 255, 255);
        if self.speed < 0 then
            love.graphics.draw(self.image, self.xPosition, self.yPosition);
            love.graphics.setColor(0, 0, 0);
        else
            love.graphics.scale(-1, 1);
            love.graphics.setColor(255, 255, 255);
            love.graphics.draw(self.image, -self.xPosition, self.yPosition);
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
            else
                love.graphics.setColor (255, 0, 0);
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
function FishableObject:update()
    if not self.caught then
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

--- sets the xPosition
function FishableObject:setXPosition(xPosition)
    self.xPosition = xPosition;
end

--- returns the value of the object
function FishableObject:getValue()
    return self.value;
end

--- returns the remaining hitpoints of the object
function FishableObject:getHitpoints()
    return self.hitpoints;
end

--- returns width of the hitbox of the object
function FishableObject:getHitboxWidth(i)
    return self.hitbox[i].width;
end

--- returns height of the hitbox of the object
function FishableObject:getHitboxHeight(i)
    return self.hitbox[i].height;
end

--- returns x position of the object
function FishableObject:getHitboxXPosition(i)

    if self.speed < 0 then
        return self.xPosition + self.hitbox[i].deltaXPos;
    else
        return self.xPosition + self.hitbox[i].deltaXPos - self.spriteSize;
    end
end

--- returns y the position of the object
function FishableObject:getHitboxYPosition(i)
    return self.yPosition + self.hitbox[i].deltaYPos;
end

--- sets the amount of pixls to move upwards to match the baits movement
function FishableObject:setYMovement(movement)
    self.yMovement = movement;
end

function FishableObject:getYMovement()
    return self.yMovement;
end

--- returns the name of the fishable object
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
