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

    if _G._persTable.fish.caughtInOneRound == 1 then
        _G._persTable.achievements.onlyOneCaught = true;
    end
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

function Achievement:onlyNegativeFishesCaught()
    if _G._persTable.fish.postiveFishCaught == false and _G._persTable.fish.caughtInOneRound > 2 then
        _G._persTable.achievements.onlyNegativeFishesCaught = true;
    end
end

function Achievement:allObjectsAtLeastOnce()
    if _G._persTable.fish.caught.turtle > 0 and _G._persTable.fish.caught.rat > 0 and
            _G._persTable.fish.caught.deadFish > 0 and _G._persTable.fish.caught.sleepingPill > 0 and
            _G._persTable.fish.caught.nemo > 0 and _G._persTable.fish.caught.lollipop > 0 and
            _G._persTable.fish.caught.angler > 0 and _G._persTable.fish.caught.ring > 0 and
            _G._persTable.fish.caught.shoe > 0 and _G._persTable.fish.caught.snake > 0 and
            _G._persTable.fish.caught.crocodile > 0 and _G._persTable.fish.caught.balloon > 0 and
            _G._persTable.fish.caught.camera > 0 and _G._persTable.fish.caught.drink > 0 and
            _G._persTable.fish.caught.egg > 0 and _G._persTable.fish.caught.cactus > 0 and
            _G._persTable.fish.caught.leaf > 0 and _G._persTable.fish.caught.canyonSnake > 0 and
            _G._persTable.fish.caught.backpack > 0 and _G._persTable.fish.caught.bird > 0 and
            _G._persTable.fish.caught.squirrel > 0 then
        _G._persTable.achievements.allObjectsAtLeastOnce = true;
    end
end

function Achievement:allPillsAtLeastOnce()
    if _G._persTable.fish.caught.sleepingPill > 0 then
        _G._persTable.achievements.allPillsAtLeastOnce = true;
    end
end

--- Checks if the achievement achBitch was unlocked
function Achievement:achBitch()
    local numOfUnlockedAch = 0;
    
    for i=1, #_G._persTable.achievements, 1
    do
        if _G._persTable.achievements[i] == true then
            numOfUnlockedAch = numOfUnlockedAch +1;
        end
    end
    
    if #_G.data.achievements == numOfUnlockedAch then
        self:unlockAchievement("achBitch");
    end
end

--- Unlocks the given achievement.
-- @param achName The name of the achievement.
function Achievement:unlockAchievement(achName)
    table.insert(_G._unlockedAchievements, _G.data.achievements[achName]);
    _gui:newNotification("assets/gui/480px/" .. _G.data.achievements[achName].image_unlock,
        achName);
    _G._persTable.achievements[achName] = true;
end

return Achievement;
