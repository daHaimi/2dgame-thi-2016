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
    if not _G._persTable.achievements.achBitch then
        local numOfUnlockedAch = 0;

        for i=1, self:tablelength(_G._persTable.achievements), 1
        do
            if _G._persTable.achievements[i] == true then
                numOfUnlockedAch = numOfUnlockedAch +1;
            end
        end

        if self:tablelength(_G.data.achievements) == numOfUnlockedAch then
            self:unlockAchievement("achBitch");
        end
    end
end

function Achievement:checkFailStart(failedStart, levelFinished)
    if failedStart and levelFinished and not _G._persTable.achievements.failedStart then
        self:unlockAchievement("failedStart");
    end
end

function Achievement:checkTwoShoes(levelFinished, fishedValue, valOfTwoShoes)
    if levelFinished and _G._tmpTable.caughtThisRound.shoe == 2
    and not _G._persTable.achievements.caughtTwoBoots
    and fishedValue == valOfTwoShoes then
        self:unlockAchievement("caughtTwoBoots");
    end
end


function Achievement:checkNothingCaught(levelFinished, failedStart)
    if levelFinished and next(_G._tmpTable.caughtThisRound) == nil and not failedStart
    and not _G._persTable.achievements.nothingCaught then
        self:unlockAchievement("nothingCaught");
    end
end


function Achievement:checkAllBordersPassed(levelFinished, reachedDepth, lowerBoarder)
    if levelFinished and not _G._persTable.achievements.allLevelBoardersPassed
    and _persTable.upgrades.mapBreakthrough1 == true and _persTable.upgrades.mapBreakthrough2 == true
    and reachedDepth <= lowerBoarder then
        self:unlockAchievement("allLevelBoardersPassed");
    end
end


function Achievement:checkFirstObject(levelFinished)
    if levelFinished and not _G._persTable.achievements.getFirstObject
    and next(_G._tmpTable.caughtThisRound) ~= nil then
        self:unlockAchievement("getFirstObject");
    end
end

function Achievement:checkRageQuit(reachedDepth)
    if not _G._persTable.achievements.rageQuit and _G._persTable.phase == 2
    and math.ceil(math.abs(reachedDepth / 300)) <= 2 then
        self:unlockAchievement("rageQuit");
    end
end

function Achievement:checkPlayTime(levelFinished)
    if levelFinished and not _G._persTable.achievements.playedTime
    and _G._persTable.playedTime > (2 * 60 * 60) then
        self:unlockAchievement("playedTime");
    end
end

function Achievement:checkCreditsRed(timeSpent)
    if timeSpent >= 10 then
        if not _G._persTable.achievements.creditsRed then
            self:unlockAchievement("creditsRed");
        end
    end
end

--- Unlocks the given achievement.
-- @param achName The name of the achievement.
function Achievement:unlockAchievement(achName)
    table.insert(_G._unlockedAchievements, _G.data.achievements[achName]);
    _gui:newNotification("assets/gui/480px/" .. _G.data.achievements[achName].image_unlock, achName);
    _G._persTable.achievements[achName] = true;
end

--- Counts the elements in a table.
-- @return Returns the number of elements in the table.
function Achievement:tablelength(T)
  local count = 0;
  for _ in pairs(T) do 
      count = count + 1;
  end
  
  return count
end

return Achievement;
