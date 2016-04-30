---Frame contains all Elements on a GUI state
Class = require "lib.hump.class";

local Frame = Class {
    init = function(self, frameName, moveInDirection, moveOutDirection, moveSpeed, xStartOffset, yStartOffset)
        self.name = frameName; --name of the Frame
        self.elementsOnFrame = {}; --table with all elements on this frame
        self.xPosFrame = 0;--left upper corner the frame
        self.yPosFrame = 0;
        --offset is used to animate the move in/ out
        self.xStartOffset = xStartOffset;--constant value to reset the x/yOffset at frame change
        self.yStartOffset = yStartOffset;
        self.xOffset = xStartOffset;--value is changing to animate the move in/ out
        self.yOffset = yStartOffset;
        --tables with the coordinates of all elemets
        --the index of the elements is equal to the elementsOnFrame table
        self.elementPosition ={xPos = {}, yPos = {}};
        self.moveInDirection = moveInDirection;--move direction of the "fly in"
        self.moveOutDirection = moveOutDirection;--move direction of the "fly out"
        self.moveSpeed = moveSpeed;--this value is added each "update" to the x/yOffset
    end;
};

---Call to add a new Element on the Frame
-- @param newElement: the object which should be added
-- @param xPos: x position of the new element
-- @param yPos: y position of the new element
function Frame:addElement(newElement, xPos, yPos)
    table.insert(self.elementsOnFrame, newElement)
    table.insert(self.elementPosition.xPos, xPos);
    table.insert(self.elementPosition.yPos, yPos);
end

---Call to set all Elements invisible and reset the x/yOffset
function Frame:clearFrame()
    for k, v in pairs (self.elementsOnFrame) do
        v:SetVisible(false);
    end
        self.xOffset = self.xStartOffset;
        self.yOffset = self.yStartOffset;
end

---Call to receive a table with all elements on this frame
function Frame:getElements()
    return self.elementsOnFrame;
end

---Call to set all Elements visible/ set all elements on position
function Frame:showFrame()
    for k, v in ipairs (self.elementsOnFrame) do
        v:SetVisible(true)
        --Coordinates: position of the element + position of the frame + current Offset
        v:SetPos(
            self.elementPosition.xPos[k] + self.xPosFrame + self.xOffset, 
            self.elementPosition.yPos[k] + self.yPosFrame + self.yOffset);
    end
end

---Call to set the position of the frame
function Frame:setPosition(xPos, yPos)
    self.xPosFrame = xPos;
    self.yPosFrame = yPos;
end

---Call to set the offset of the Frame
function Frame:setOffset(newOffsetX, newOffsetY)
    self.xOffset = newOffsetX;
    self.yOffset = newOffsetY;
end

---Return true if the frame is on position (x/yOffset = 0)
function Frame:onPosition()
    if (self.xOffset == 0 and self.yOffset == 0) then
        return true;
    else
        return false;
    end
end

---adjust the offset each "update"
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

---adjust the offset each "update"
function Frame:moveOut()
    if self.moveOutDirection == "up" then
        self.yOffset = self.yOffset - self.moveSpeed;
    elseif self.moveOutDirection == "down" then
        self.yOffset = self.yOffset + self.moveSpeed;
    elseif self.moveOutDirection == "right" then
        self.xOffset = self.xOffset + self.moveSpeed;
    elseif self.moveOutDirection == "left" then
        self.xOffset = self.xOffset - self.moveSpeed;
    end
    self:showFrame();
end

---Returns the X position to the element
-- @param winDimX: X coordinate of the window
-- @param backgroundWidth: Width of the background
-- @param elementWidth: Width of the element
function Frame:centerElementX(winDimX, backgroundWidth, elementWidth)
    return ((backgroundWidth*(winDimX*0.5)/backgroundWidth)/2-elementWidth/2);
end

return Frame;