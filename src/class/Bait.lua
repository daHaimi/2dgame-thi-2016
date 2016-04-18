--- Class for the Bait swimming for Phase 1 and 2
-- @param winDim window Size
--
local Bait = Class {
    init = function(self, winDim)
        self.winDim = winDim;
        self.posXBait = (winDim[1] / 2) - (self.size / 2);
        local yPos = (self.winDim[2] / 2) - (self.size / 2)
        love.mouse.setPosition(self.posXBait, yPos);
    end;
    size = 10;
    speed = 100;
    posXMouse = 0;
    posXBait = 0;
    maxSpeedX = 5;
    winDim = {};
    life = 1;
    money = 0;
};

--- TODO need balancing
-- a function to check wich upgrades are active for the bait
function Bait:checkUpgrades()
    if _G._persTable.upgrades.moreLife > 0 then
        self.life = self.life + _G._persTable.upgrades.moreLife;
    end
    --- speed up while phase 1 and 2
    if _G._persTable.upgrades.speedUp > 0 then
        self.speed = self.speed * (1 + _G._persTable.upgrades.speedUp);
    end
end

--- implements drawing interface
--
function Bait:draw()
    love.graphics.setColor(127, 0, 255);
    local yPos = (self.winDim[2] / 2) - (self.size / 2);
    local xPos = self:getCappedPosX();
    love.graphics.rectangle("fill", xPos, yPos, self.size, self.size);
end

--- Determines the capped X position of the Bait (SpeedLimit)
-- @return The actual X position of the Bait
function Bait:getCappedPosX()
  local delta = self.posXMouse - self.posXBait
  if delta > self.maxSpeedX  then
    posX = self.posXBait + self.maxSpeedX;
  elseif delta < self.maxSpeedX*(-1) then
    posX = self.posXBait - self.maxSpeedX;
  else
    posX = self.posXMouse;
  end
  self.posXBait = posX;
  return posX;
end

return Bait;
