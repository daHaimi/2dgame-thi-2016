Class = require "lib.hump.class";

local Slider = Class {
    init = function (self, imageUnpressed, imagePressed, xPosition, yPosition, width)
        self.imageUnpressed = imageUnpressed;
        self.imageUnpressedWidth = self.imageUnpressed:getWidth();
        self.imageUnpressedHeight = self.imageUnpressed:getHeight();
        self.imagePressed = imagePressed;
        self.imagePressedWidth = self.imagePressed:getWidth();
        self.imagePressedHeight = self.imagePressed:getHeight();
        self.xPosition = xPosition;
        self.yPosition = yPosition;
        self.xDefaultPosition = xPosition;
        self.yDefaultPosition = yPosition;
        self.width = width;
        self.moveable = false;
        self.range = 100;
        self.xOffset = 0;
        self.yOffset = 0;
    end;
};
--- returns the position of the button
--@return x position and y position of the button
function Slider:getPosition()
    return self.xDefaultPosition, self.yDefaultPosition - 0.5 * self.imageUnpressedHeight;
end

--- sets the position of the button
function Slider:setPosition(x, y)
    self.xPosition = math.min(self.xDefaultPosition + self.width , math.max(self.xDefaultPosition, x));
end

--- return the size of the button
--@retrun width and height of the button
function Slider:getSize()
    return self.width, self.imageUnpressedHeight;
end

--- updates the slider
function Slider:update()
    if self.moveable then
        local x, y = love.mouse:getPosition();
        self:setPosition(x / _G._persTable.scaleFactor, y / _G._persTable.scaleFactor);
    end
end

---draws the slider
function Slider:draw()
    -- draw line for slider
    love.graphics.setColor(0,0,0);
    love.graphics.rectangle("fill", self.xDefaultPosition, self.yDefaultPosition + self.yOffset, self.width, 10);
    love.graphics.setColor(255,255,255);
    
    if self.moveable then 
        love.graphics.draw(self.imagePressed, self.xPosition + self.xOffset  - 0.5 * self.imageUnpressedWidth, 
        self.yPosition + self.yOffset - self.imageUnpressedWidth * 0.5 + 5);
    else
        love.graphics.draw(self.imageUnpressed, self.xPosition + self.xOffset  - 0.5 * self.imageUnpressedWidth, 
        self.yPosition + self.yOffset - self.imageUnpressedWidth * 0.5 + 5);
    end
end

--- sets the offset of the button 
--@param x x offset of the button
--@parma y y offset of the button
function Slider:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end

--- retruns the offset of the button
--@return x and y offset of the button
function Slider:getOffset()
    return self.xOffset, self.yOffset;
end

function Slider:getValue()
    return (self.xPosition - self.xDefaultPosition) * 100 / self.width
end

function Slider:setValue(value)
    self.xPosition = value / 100 * self.width + self.xDefaultPosition
end

function Slider:gotClicked(x, y)
    self.moveable = true;
end

function Slider:release(x, y)
    self.moveable = false;
end

--- returns true if the slider is moving
--@return moveable
function Slider:getMoveable()
    return self.moveable
end
return Slider;