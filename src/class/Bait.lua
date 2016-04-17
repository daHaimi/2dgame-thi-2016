local Bait = Class {
    init = function(self, winDim)
        self.winDim = winDim;
        self.posX = (winDim[1] / 2) - (self.size / 2);
        self.posXact = self.posX;
    end;
    size = 10;
    speed = 100;
    posX = 0;
    posXact = 0;
    posXdt = 0;
    maxSpeedX = 8;
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
    local yPos = (self.winDim[2] / 2) - (self.size / 2)
    local xPos = self:identLimitedPosX()
    love.graphics.rectangle("fill", xPos, yPos, self.size, self.size);
end

function Bait:identLimitedPosX()
  if (self.posXdt >= 0) then 
    if (self.posXdt > self.maxSpeedX) then 
      posX = self.posXact + self.maxSpeedX;
    else
      if self.posX > self.posXact*1.08 then
        posX = self.posXact + self.maxSpeedX;
      else
        posX = self.posX;
      end
    end
  else 
    if self.posXdt < ((self.maxSpeedX)*(-1)) then 
      posX = self.posXact - self.maxSpeedX;
    else
      if self.posX < self.posXact*0.92 then
        posX = self.posXact - self.maxSpeedX;
      else
        posX = self.posX; 
      end
    end
  end
  if posX >= self.winDim[1] then
    posX = self.winDim[1] - self.size;
  elseif posX < 0 then
    posX = 0;
  end
  self.posXact = posX;
  return posX;
end

return Bait;
