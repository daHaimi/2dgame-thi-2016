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
    init = function(self, name, imageSrc, yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints, deltaXHitbox, deltaYHitbox)
        self.name = name;
        self.image = love.graphics.newImage("assets/" .. imageSrc);
        self.xPosition = math.random(_G._persTable.winDim[1]);
        self.yPosition = yPosition;
        self.speed = math.random(minSpeed, maxSpeed); -- for decimal numbers
        self.hitboxWidth = xHitbox;
        self.hitboxHeight = yHitbox;
        self.value = value;
        self.hitpoints = hitpoints;
        self.deltaXHitbox = deltaXHitbox;
        self.deltaYHitbox = deltaYHitbox;
    end;
    
    name = "no name";
    xPosition = 0;
    yPosition = 0;
    hitboxWidth = 0;
    hitboxHeight = 0;
    speed = 0;
    value = 0;
    hitpoints = 1;
    deltaXHitbox = 0;
    deltaYHitbox = 0;
    drawIt = true;
};

--- draw the object, still no sprite implementet
function FishableObject:draw()
    if self.drawIt then
        love.graphics.setColor(255, 255, 255);
        if self.speed < 0 then
            love.graphics.draw(self.image, self.xPosition, self.yPosition);
            love.graphics.setColor(0,0,0);
        else
            love.graphics.scale(-1, 1);
            love.graphics.setColor(255, 255, 255);
            love.graphics.draw(self.image, -self.xPosition, self.yPosition);
            love.graphics.scale(-1, 1);
        end
        --[[for showing the Hitbox
        love.graphics.setColor(0,0,0);
        love.graphics.rectangle("line", self:getHitboxXPosition(), self:getHitboxYPosition(), 
        self:getHitboxWidth(), self:getHitboxHeight());
        ]]
    end
end

--- Updates the position of the object depending on its speed
function FishableObject:update()
        if ((self.xPosition + self.hitboxWidth + self.speed) > _G._persTable.winDim[1]) then

            self.xPosition = _G._persTable.winDim[1] - self.hitboxWidth;
            self.speed = self.speed * (-1);

        elseif self.xPosition + self.speed < 0 then

            self.xPosition = math.abs(self.speed) - self.xPosition;
            self.speed = self.speed * (-1);

        else

            self.xPosition = self.xPosition + self.speed;
        end

        self.yPosition = self.yPosition - _G._persTable.moved;
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

--- returns the hitbox of the object
function FishableObject:getHitboxWidth()
    return self.hitboxWidth;
end

--- returns the hitbox of the object
function FishableObject:getHitboxHeight()
    return self.hitboxHeight; 
end

--- returns the position of the object
function FishableObject:getHitboxXPosition()
    if self.speed < 0 then
        return self.xPosition + self.deltaXHitbox;
    else 
        return self.xPosition + self.deltaXHitbox - 64;
    end
end

--- returns the position of the object
function FishableObject:getHitboxYPosition()
    return self.yPosition + self.deltaYHitbox;
end

return FishableObject;
