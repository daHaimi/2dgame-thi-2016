Class = require "lib.hump.class";

local Achievement = Class {
    init = function(self) end;
};

function Achievement:checkAchievements()
    self:caughtOneRound();
    self:moneyOneRound();
    self:negativCoins();
    self:moneyTotal();
    self:fishCaughtTotal();
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
    if _G._persTable.statistic.maxCoinOneRound > 199 then
        _G._persTable.achievements.bronzeCoinsOneRound = true;
    end
    if _G._persTable.statistic.maxCoinOneRound > 599 then
        _G._persTable.achievements.silverCoinsOneRound = true;
    end
    if _G._persTable.statistic.maxCoinOneRound > 999 then
        _G._persTable.achievements.goldCoinsOneRound = true;
    end  
end

function Achievement:moneyTotal()
    if _G._persTable.statistic.moneyEarnedTotal > 1999 then
        _G._persTable.achievements.bMoneyEarnedTotal = true;
    end
    if _G._persTable.statistic.moneyEarnedTotal > 4999 then
        _G._persTable.achievements.sMoneyEarnedTotal = true;
    end
    if _G._persTable.statistic.moneyEarnedTotal > 8999 then
        _G._persTable.achievements.gMoneyEarnedTotal = true;
    end  
end

function Achievement:fishCaughtTotal()
    if _G._persTable.fish.caughtTotal > 49 then
        _G._persTable.achievements.bFishCaugtTotal = true;
    end
    if _G._persTable.fish.caughtTotal > 199 then
        _G._persTable.achievements.sFishCaugtTotal = true;
    end
    if _G._persTable.fish.caughtTotal > 499 then
        _G._persTable.achievements.gFishCaugtTotal = true;
    end  
end

function Achievement:negativCoins()
    if _G._persTable.statistic.minCoinOneRound < -199 then
        _G._persTable.achievements.negativCoins = true;
    end
end
return Achievement;