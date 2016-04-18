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
    --- persistens ersatz
    upgradeSpeed = 10;
    upgradeMoney = 1;
    upgradeMoreLife = 0;
    upgradeGodMode = 0;
};
--- TODO need balancing
-- a function to check wich upgrades are active for the bait
function Bait:checkUpgrades()
    self.money = self.money * 1 + 0.2 + self.upgradeMoney;
    self.life = self.life + self.upgradeMoreLife;
    self.speed = self.speed + 100 * _G._persTable.upgrades.speedUp;
end

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
