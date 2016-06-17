Class = require "lib.hump.class";

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
function Frame:clear(elements)
    for _, v in pairs(elements) do
        if v.object ~= nil then
            v.object:SetVisible(false);
        else
            v:setVisible(false);
        end
    end
    self.p_xOffset = self.p_xDefaultOffset;
    self.p_yOffset = self.p_yDefaultOffset;
end

--- Call to set all Elements visible/ set all elements on position
function Frame:draw(elements)
    for _, v in pairs(elements) do
        if v.object ~= nil then
            v.object:SetVisible(true)
            v.object:SetPos(v.x + self.p_xPos + self.p_xOffset, v.y + self.p_yPos + self.p_yOffset);
        else
            v:setVisible(true);
            v:setPosition(v.xPosition + self.p_xPos + self.p_xOffset, v.yPosition + self.p_yPos + self.p_yOffset);
            v:draw();
        end
    end
end


--called in the "fly in" state
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
        if v.object ~= nil then
            v.object:SetPos(v.x + self.p_xPos + self.p_xOffset, v.y + self.p_yPos + self.p_yOffset);
            if (v.object.SetClickable ~= nil) then
                v.object:SetClickable(true);
            end
        else
            v:setPosition(v.xPosition + self.p_xPos + self.p_xOffset, v.yPosition + self.p_yPos + self.p_yOffset);
            if (v:setClickable() ~= nil) then
                v:setClickable(true);
                self:draw();
            end
        end
    end
end

--called in the "fly out" state
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
        v.object:SetPos(self.p_xPos + v.x + self.p_xOffset, self.p_yPos + v.y + self.p_yOffset);
        if (v.object.SetClickable ~= nil) then
            v.object:SetClickable(false);
        end
    end
end

--- return true if the frame is on position /fly in move is finished
function Frame:checkPosition()
    if (self.p_xOffset == 0 and self.p_yOffset == 0) then
        return true;
    else
        return false;
    end
end

return Frame;
