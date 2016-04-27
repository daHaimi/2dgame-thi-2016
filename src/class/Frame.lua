Class = require "lib.hump.class";

local Frame = Class {
    init = function(self, frameName)
        self.name = frameName; 
        self.elementsOnFrame = {};
        self.amountElements = 0;
        self.xPosFrame = 0;
        self.yPosFrame = 0;
        self.xOffset = 0;
        self.yOffset = 0;
        self.elementPosition ={xPos = {}, yPos = {}};
        self.background = nil;
    end;
};

function Frame:addElement(newElement, xPos, yPos)
    self.amountElements = self.amountElements + 1;
    self.elementsOnFrame[self.amountElements] = newElement;
    self.elementPosition.xPos[self.amountElements] = xPos;
    self.elementPosition.yPos[self.amountElements] = yPos;
end

function Frame:clearFrame()
    for k, v in pairs (self.elementsOnFrame) do
        v:SetVisible(false);
    end
end

function Frame:showFrame()
    for k, v in ipairs (self.elementsOnFrame) do
        v:SetVisible(true)
        v:SetPos(self.elementPosition.xPos[k] + self.xPosFrame + self.xOffset, self.elementPosition.yPos[k] + self.yPosFrame + self.yOffset);
    end
end

function Frame:getElements()
    return self.elementsOnFrame;
end

function Frame:setPosition(xPos, yPos)
    self.xPosFrame = xPos;
    self.yPosFrame = yPos;
end

function Frame:setOffset(newOffsetX, newOffsetY)
    self.xOffset = newOffsetX;
    self.yOffset = newOffsetY;
end

function Frame:onPosition()
    if (self.xOffset == 0 and self.yOffset == 0) then
        return true;
        
    else
        return false;
    end
end


function Frame:flyIn()
    if self.xOffset > 0 then self.xOffset = self.xOffset - 30; 
    elseif self.xOffset < 0 then self.xOffset = self.xOffset + 30;
    end
    if self.yOffset > 0 then self.yOffset = self.yOffset - 30; 
    elseif self.yOffset < 0 then self.yOffset = self.yOffset + 30;
    end
    self:showFrame();
end


function Frame:flyOut(dir)
    if dir == "up" then
        self.yOffset = self.yOffset - 30;
    elseif dir == "down" then
        self.yOffset = self.yOffset + 30;
    end
    self:showFrame();
end


function Frame:setBackground()
end

return Frame;