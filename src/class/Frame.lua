Class = require "lib.hump.class";

local Frame = Class {
    init = function(self, xPos, yPos, moveInDirection, moveOutDirection, moveSpeed, xDefaultOffset, yDefaultOffset)
        self.xPos = xPos;
        self.yPos = yPos;
        self.xDefaultOffset = xDefaultOffset; --constant value to reset the x/yOffset at frame change
        self.yDefaultOffset = yDefaultOffset;
        self.xOffset = xDefaultOffset; --value is changing to animate the move in/ out
        self.yOffset = yDefaultOffset;
        self.moveInDirection = moveInDirection; --move direction of the "fly in"
        self.moveOutDirection = moveOutDirection; --move direction of the "fly out"
        self.moveSpeed = moveSpeed; --this value is added each "update" to the x/yOffset
    end;
};

--- Call to set all Elements invisible and reset the x/yOffset
function Frame:clear(elements)
    for k, v in pairs(elements) do
        v.object:SetVisible(false);
    end
    self.xOffset = self.xDefaultOffset;
    self.yOffset = self.yDefaultOffset;
end

--- Call to set all Elements visible/ set all elements on position
function Frame:draw(elements)
    for k, v in pairs(elements) do
        v.object:SetVisible(true)
        v.object:SetPos(v.x + self.xPos + self.xOffset, v.y + self.yPos + self.yOffset);
    end
end


--called in the "fly in" state 
function Frame:appear(elements)
    if self.moveInDirection == "up" then
        self.yOffset = self.yOffset - self.moveSpeed;
    elseif self.moveInDirection == "down" then
        self.yOffset = self.yOffset + self.moveSpeed;
    elseif self.moveInDirection == "right" then
        self.xOffset = self.xOffset + self.moveSpeed;
    elseif self.moveInDirection == "left" then
        self.xOffset = self.xOffset - self.moveSpeed;
    end
    for k, v in pairs(elements) do
        v.object:SetPos(v.x + self.xPos + self.xOffset, v.y + self.yPos + self.yOffset);
    end
end

--called in the "fly out" state
function Frame:disappear(elements)
    if self.moveOutDirection == "up" then
        self.yOffset = self.yOffset - self.moveSpeed;
    elseif self.moveOutDirection == "down" then
        self.yOffset = self.yOffset + self.moveSpeed;
    elseif self.moveOutDirection == "right" then
        self.xOffset = self.xOffset + self.moveSpeed;
    elseif self.moveOutDirection == "left" then
        self.xOffset = self.xOffset - self.moveSpeed;
    end
    for k, v in pairs(elements) do
        v.object:SetPos(self.xPos + v.x + self.xOffset, self.yPos + v.y + self.yOffset);
    end
end

---return true if the frame is on position /fly in move is finished
function Frame:checkPosition()
    if (self.xOffset == 0 and self.yOffset == 0) then
        return true;
    else
        return false;
    end
end

return Frame;
