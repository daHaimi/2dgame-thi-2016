Class = require "lib.hump.class";

    --FishableObject is the class of all fishable object.
    --@param xPosition: x-position of the object
    --@param yPosition: y-position of the object
    --@param xHitbox: width of the hitbox
    --@param yHitbox: height of the hitbox
    --@param speed: number of the pixels moved per step (can be negativ)
    --@param value: value of the object
    --@param hitpoints: amoung of the hitpoints of the object
local FishableObject = Class {
    --create new FishableObject
    --@param imageSrc: The image of the object
    --@param yPosition: height of the object in the level
    --@param minSpeed: lowerst amount of speed possible
    --@param maxSpeed: highest amount of speed possible
    --@param xHitbox: width of the hitbox
    --@param yHitbox: height of the hitbox
    --@param value: amount of money earned by fishing this object
    --@param hitpoints: amoung of the hitpoints of the object
    init = function (self, imageSrc, yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints)
        self.image = love.graphics.newImage("assets/"..imageSrc);
        self.xPosition = math.random(_G._persTable.winDim[1]);
        self.yPosition = yPosition;
        self.speed = math.random(minSpeed * 10, maxSpeed * 10) / 10; -- for decimal numbers
        self.xHitbox = xHitbox;
        self.yHitbox = yHitbox;
        self.value = value;
        self.hitpoints = hitpoints;
    end;
    
    xPosition = 0;
    yPosition = 0;
    xHitbox = 0;
    yHitbox = 0;
    speed = 0;
    value = 0;    
    hitpoints = 1;
};

--draw the object, still no sprite implementet
function FishableObject:draw()
    
    love.graphics.setColor(255,255,255);
    if self.speed < 0 then
        love.graphics.draw(self.image, self.xPosition, self.yPosition);
    else 
        love.graphics.scale(-1,1);
        love.graphics.draw(self.image, -self.xPosition, self.yPosition);
        love.graphics.scale(-1,1);
    end
    
end

--Updates the position of the object depending on its speed
function FishableObject:update()
    
    if ((self.xPosition + self.xHitbox + self.speed) > _G._persTable.winDim[1]) then
        
        self.xPosition = _G._persTable.winDim[1] - self.xHitbox;
        self.speed = self.speed * (-1); 
        
    elseif self.xPosition + self.speed < 0 then
        
        self.xPosition = math.abs(self.speed) - self.xPosition;
        self.speed = self.speed * (-1);
        
    else
        
        self.xPosition = self.xPosition + self.speed;
        
    end
    
    self.yPosition = self.yPosition - _G._persTable.moved;
    
end

--sets the xPosition
function FishableObject:setXPosition(xPosition)
    self.xPosition = xPosition;
end

--returns the value of the object
function FishableObject:getValue()
    return self.value;
end

--returns the remaining hitpoints of the object
function FishableObject:getHitpoints()
    return self.hitpoints;
end

--returns the hitbox of the object
function FishableObject:getHitbox()
    return self.xHitbox, self.yHitbox;
end

--returns the position of the object
function FishableObject:getPosition()
    return self.xPosition, self.yPosition;
end

return FishableObject;