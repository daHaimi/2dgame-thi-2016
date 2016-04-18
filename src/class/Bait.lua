Class = require "lib.hump.class";

local Bait = Class {
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

function Bait:draw()
    love.graphics.setColor(127, 0, 255);
    local yPos = (self.winDim[2] / 2) - (self.size / 2)
    love.graphics.rectangle("fill", self.posX, yPos, self.size, self.size);
end


return Bait;
