Class = require "lib.hump.class";

local Achievement = Class {
    init = function(self) end;
};

function Achievement:checkAchievements()
    self:caughtOneRound();
    self:moneyOneRound();
end

function Achievement:caughtOneRound()
  
    if _G._persTable.fish.caughtInOneRound > 9 then
        _G._persTable.achievements.bronzeCaughtOneRound = true;
    end
    if _G._persTable.fish.caughtInOneRound > 19 then
        _G._persTable.achievements.silverCaughtOneRound = true;
    end
    if _G._persTable.fish.caughtInOneRound > 29 then
        _G._persTable.achievements.goldCaughtOneRound = true;
    end    
end

function Achievement:moneyOneRound()
    if _G._persTable.statistic.maxCoinOneRound > 200 then
        _G._persTable.achievements.bronzeCoinsOneRound = true;
    end
    if _G._persTable.statistic.maxCoinOneRound > 600 then
        _G._persTable.achievements.silverCoinsOneRound = true;
    end
    if _G._persTable.statistic.maxCoinOneRound > 1000 then
        _G._persTable.achievements.goldCoinsOneRound = true;
    end  
end
return Achievement;