local Bait = Class{
    init = function(self, winDim)
        self.winDim = winDim;
        self.posX = (winDim[1] / 2) - (self.size / 2);

    end;
    size = 10;
    speed = 100;
    posX = 0;
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
--- a function to check wich upgrades are active for the bait 
function Bait:checkUpgrades()
    self.money = self.money * 1 + 0.2 + self.upgradeMoney;
    self.life = self.life + self.upgradeMoreLife;
    self.speed = self.speed + 100 * _G._persTable.upgrades.speedUp;
end

function Bait:draw()
    love.graphics.setColor(127, 0, 255);
    love.graphics.rectangle("fill", self.posX, (self.winDim[2] / 2) - (self.size / 2) , self.size, self.size);
end


return Bait;