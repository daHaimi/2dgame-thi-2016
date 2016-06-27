Class = require "lib.hump.class";
--- a frame is a state in the GUI
--@param xPos x Position of the upper left corner
--@param yPos y Position of the upper left corner
--@param moveInDirection direction on appearing
--@param moveOutDirection direction of disappearing
--@param moveSpeed speed of appearing and disappearing
--@param xDefaultOffset starting offset before appearing
--@param yDefaultOffset starting offset before appearing
local Frame = Class {
    init = function(self, xPos, yPos, moveInDirection, moveOutDirection, moveSpeed, xDefaultOffset, yDefaultOffset)
        self.p_xPos = xPos;
        self.p_yPos = yPos;
        self.p_xDefaultOffset = xDefaultOffset; --constant value to reset the x/yOffset at frame change
        self.p_yDefaultOffset = yDefaultOffset;
        self.p_xOffset = xDefaultOffset; --value is changing to animate the move in/ out
        self.p_yOffset = yDefaultOffset;
        self.p_moveInDirection = moveInDirection; --move direction of the "fly in"
        self.p_moveOutDirection = moveOutDirection; --move direction of the "fly out"
        self.p_moveSpeed = moveSpeed; --this value is added each "update" to the x/yOffset
    end;
};

--- Call to set all Elements invisible and reset the x/yOffset
function Frame:clear()
    self.p_xOffset = self.p_xDefaultOffset;
    self.p_yOffset = self.p_yDefaultOffset;
end

---called in the "fly in" state
--@pramam elements all elements on the frame
function Frame:appear(elements)
    if self.p_moveInDirection == "up" then
        self.p_yOffset = self.p_yOffset - self.p_moveSpeed;
    elseif self.p_moveInDirection == "down" then
        self.p_yOffset = self.p_yOffset + self.p_moveSpeed;
    elseif self.p_moveInDirection == "right" then
        self.p_xOffset = self.p_xOffset + self.p_moveSpeed;
    elseif self.p_moveInDirection == "left" then
        self.p_xOffset = self.p_xOffset - self.p_moveSpeed;
    end
    for _, v in pairs(elements) do
        v:setOffset(self.p_xOffset, self.p_yOffset);
    end
end

--called in the "fly out" state
--@param elements all elements on the frame
function Frame:disappear(elements)
    if self.p_moveOutDirection == "up" then
        self.p_yOffset = self.p_yOffset - self.p_moveSpeed;
    elseif self.p_moveOutDirection == "down" then
        self.p_yOffset = self.p_yOffset + self.p_moveSpeed;
    elseif self.p_moveOutDirection == "right" then
        self.p_xOffset = self.p_xOffset + self.p_moveSpeed;
    elseif self.p_moveOutDirection == "left" then
        self.p_xOffset = self.p_xOffset - self.p_moveSpeed;
    end
        for _, v in pairs(elements) do
        v:setOffset(self.p_xOffset, self.p_yOffset);
    end
end

--- return true if the frame is on position /fly in move is finished
--@return true if the appearing is finished
function Frame:checkPosition()
    if (self.p_xOffset == 0 and self.p_yOffset == 0) then
        return true;
    else
        return false;
    end
end

return Frame;
