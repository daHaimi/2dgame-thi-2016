Class = require "lib.hump.class";

local Healthbar = Class {
    init = function(self)
        self.icon = love.graphics.newImage("assets/hamster.png");
        self.blackHeart = love.graphics.newImage("assets/heart_grey.png");
        self.redHeart = love.graphics.newImage("assets/heart.png");
        self.unlockedHearts = 1 + _G._persTable.upgrades.moreLife;
        self.currentHearts = self.unlockedHearts;
        self.xPosition = 0;
        self.yPosition = 0;
        self.xOffset = 0;
        self.yOffset = 0;
    end;
};

--- triggerd if the hamster hit an object
function Healthbar:minus()
    if self.currentHearts > 0 then
        self.currentHearts = self.currentHearts - 1;
    end
end

--- Reset the amount of lives to the start value.
function Healthbar:resetHearts()
    self.unlockedHearts = 1 + _G._persTable.upgrades.moreLife;
    self.currentHearts = self.unlockedHearts;
end

--- Function not conform to CC/ implements an interface
--- Set the visible of the element
-- @parm visible: true or false
function Healthbar:draw()
    love.graphics.draw(self.icon, self.xPosition + self.xOffset, self.yPosition + self.yOffset);
    for i = 1, self.unlockedHearts, 1 do
        if i <= self.currentHearts then
            love.graphics.draw(self.redHeart, 
                self.xPosition + 64 + (i - 1) * 35 + self.xOffset, 16 + self.yPosition + self.yOffset);
        else
            love.graphics.draw(self.blackHeart, 
                self.xPosition + 64 + (i - 1) * 35 + self.xOffset, 16 + self.yPosition + self.yOffset);
        end
    end
end

--- sets the offset of the button 
--@param x x offset of the button
--@parma y y offset of the button
function Healthbar:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end

--- retruns the offset of the button
--@return x and y offset of the button
function Healthbar:getOffset()
    return self.xOffset, self.yOffset;
end

--- Function not conform to CC/ implements an interface
--- set the position of the element
-- @parm x: x axis position
-- @parm y: y axis position
function Healthbar:setPos()
    self.yPosition = 0;
    self.xPosition = _G._persTable.winDim[1] - 64 - self.unlockedHearts * 35;
    
end

return Healthbar;
