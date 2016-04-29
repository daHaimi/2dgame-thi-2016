Class = require "lib.hump.class";

local Frame = Class {
    init = function(self, frameName, moveInDirection,moveOutDirection, moveSpeed, xStartOffset, yStartOffset)
        self.name = frameName; 
        self.elementsOnFrame = {};
        self.xPosFrame = 0;
        self.yPosFrame = 0;
        self.xStartOffset = xStartOffset;
        self.yStartOffset = yStartOffset;
        self.xOffset = xStartOffset;
        self.yOffset = yStartOffset;
        self.elementPosition ={xPos = {}, yPos = {}};
        self.background = nil;
        self.moveInDirection = moveInDirection;
        self.moveOutDirection = moveOutDirection;
        self.moveSpeed = moveSpeed;
    end;
};

function Frame:addElement(newElement, xPos, yPos)
    table.insert(self.elementsOnFrame, newElement)
    table.insert(self.elementPosition.xPos, xPos);
    table.insert(self.elementPosition.yPos, yPos);
end

function Frame:clearFrame()
    for k, v in pairs (self.elementsOnFrame) do
        v:SetVisible(false);
    end
        self.xOffset = self.xStartOffset;
        self.yOffset = self.yStartOffset;
end

function Frame:getElements()
    return self.elementsOnFrame;
end

function Frame:showFrame()

    for k, v in ipairs (self.elementsOnFrame) do
        v:SetVisible(true)
        v:SetPos(self.elementPosition.xPos[k] + self.xPosFrame + self.xOffset, self.elementPosition.yPos[k] + self.yPosFrame + self.yOffset);
    end
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


function Frame:moveIn()
    if self.moveInDirection == "up" then
        self.yOffset = self.yOffset - self.moveSpeed;
    elseif self.moveInDirection == "down" then
        self.yOffset = self.yOffset + self.moveSpeed;
    elseif self.moveInDirection == "right" then
        self.xOffset = self.xOffset + self.moveSpeed;
    elseif self.moveInDirection == "left" then
        self.xOffset = self.xOffset - self.moveSpeed;
    end
    self:showFrame();
end
function Frame:moveOut()
    if self.moveInDirection == "up" then
        self.yOffset = self.yOffset - self.moveSpeed;
    elseif self.moveInDirection == "down" then
        self.yOffset = self.yOffset + self.moveSpeed;
    elseif self.moveInDirection == "right" then
        self.xOffset = self.xOffset - self.moveSpeed;
    elseif self.moveInDirection == "left" then
        self.xOffset = self.xOffset + self.moveSpeed;
    end
    self:showFrame();
end


function Frame:setBackground(bg)
    --self.background = bg;
end

return Frame;