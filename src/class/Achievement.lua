Class = require "lib.hump.class";

--- class for achievement checks and notification
local Achievement = Class {
    init = function(self) end;
};

--- checks a few achievements
function Achievement:checkAchievements()
    self:caughtOneRound();
    self:moneyOneRound();
    self:moneyTotal();
    self:fishCaughtTotal();
    self:secondStart();
    _persistence:updateSaveFile();
end

--- Checks achievements for round based fished amount of objects.
function Achievement:caughtOneRound()
    if _G._persTable.fish.caughtInOneRound > 9 then
        self:unlockAchievement("bronzeCaughtOneRound");
    end
    if _G._persTable.fish.caughtInOneRound > 19 then
        self:unlockAchievement("silverCaughtOneRound");
    end
    if _G._persTable.fish.caughtInOneRound > 29 then
        self:unlockAchievement("goldCaughtOneRound");
    end
end
--- checks achievement for money collected in one round
function Achievement:moneyOneRound()
    if _G._persTable.statistic.maxCoinOneRound > 199 then
        self:unlockAchievement("bronzeCoinsOneRound");
    end
    if _G._persTable.statistic.maxCoinOneRound > 599 then
        self:unlockAchievement("silverCoinsOneRound");
    end
    if _G._persTable.statistic.maxCoinOneRound > 999 then
        self:unlockAchievement("goldCoinsOneRound");
    end
end

--- checks achievement for money collected total
function Achievement:moneyTotal()
    if _G._persTable.statistic.moneyEarnedTotal > 1999 then
        self:unlockAchievement("bMoneyEarnedTotal");
    end
    if _G._persTable.statistic.moneyEarnedTotal > 4999 then
        self:unlockAchievement("sMoneyEarnedTotal");
    end
    if _G._persTable.statistic.moneyEarnedTotal > 8999 then
        self:unlockAchievement("gMoneyEarnedTotal");
    end
end

--- Checks the achievements for total amount of caught fish.
function Achievement:fishCaughtTotal()
    local fishTotal = _G._persTable.fish.caughtTotal;

    if fishTotal >= 50 then
       self:unlockAchievement("bFishCaughtTotal");
    end
    if fishTotal >= 200 then
        self:unlockAchievement("sFishCaughtTotal");
    end
    if fishTotal >= 500 then
        self:unlockAchievement("gFishCaughtTotal");
    end
end

--- Checks the achievements for game started twice
function Achievement:secondStart()  
    if _G._persistence.loaded == true and not _G._persTable.achievements.secondStart then
        self:unlockAchievement("secondStart");
    end
end

--- Checks if the achievement onlyNegativeFishesCaught was unlocked.
-- @param gotPayed 0 indicates that the player haven't got any money until yet.
-- 1 means the player got his profit.
-- @param totalRoundVal The amount of coins got in the current level.
function Achievement:checkNegativCoins(gotPayed, totalRoundVal)
    if gotPayed == 1 and not _G._persTable.achievements.negativCoins and totalRoundVal <= -200 then
        self:unlockAchievement("negativCoins");
    end
end

--- Checks if the achievement onlyNegativeFishesCaught was unlocked.
-- @param levelFinished The boolean that indicate if the level has been already finished.
-- @param swarmFac The reference to the current swarmFactory.
function Achievement:onlyNegativeFishesCaught(levelFinished, swarmFac)
    if levelFinished and not _G._persTable.achievements.onlyNegativeFishesCaught then
        local negObjects = 0;
        for name, amount in pairs(_G._tmpTable.caughtThisRound) do
            if swarmFac:getFishableObjects()[name].value < 0 then
                negObjects = negObjects + amount;
            else
                return;
            end
        end
        
        if negObjects >= 2 then
            self:unlockAchievement("onlyNegativeFishesCaught");
        end
    end
end

--- checks achievement every object without pill caught at least once
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
            _G._persTable.fish.caught.squirrel > 0 and _G._persTable.fish.caught.ufo > 0 then
        self:unlockAchievement("allObjectsAtLeastOnce");
    end
end

--- checks achievement every pill caught at least once
function Achievement:allPillsAtLeastOnce()
    if _G._persTable.fish.caught.sleepingPill > 0 and _G._persTable.fish.caught.rainbowPill > 0 and
        _G._persTable.fish.caught.coffee > 0 then
        self:unlockAchievement("allPillsAtLeastOnce");
    end
end

--- Checks if the achievement achBitch was unlocked.
function Achievement:achBitch()
    if not _G._persTable.achievements.achBitch then
        local numOfUnlockedAch = 0;

        for k,v in pairs(_G._persTable.achievements)
        do
            if v == true then
                numOfUnlockedAch = numOfUnlockedAch + 1;
            end
        end

        if self:tablelength(_G.data.achievements) - 2 == numOfUnlockedAch then
            self:unlockAchievement("achBitch");
        end
    end
end

---Checks for achievement Shopping Queen
function Achievement:achShoppingQueen()
    local boughtAll = true;
    for _, v in pairs(_G._persTable.upgrades) do
        if type(v) == "boolean" then
            if not v then
                boughtAll = false;
            end
        end
    end
    if boughtAll then
        _G._persTable.achievements.shoppingQueen = true;
        _gui:newNotification("assets/gui/480px/" .. _G.data.achievements.boughtAllItems.image_unlock, "shoppingQueen");
    end
end


--- Checks and unlock the caughtTwoBoots achievement.
-- @param failedStart Indicates if the intro failed.
-- @param levelFinished The boolean that indicate if the level has been already finished.
function Achievement:checkFailStart(failedStart, levelFinished)
    if failedStart and levelFinished then
        self:unlockAchievement("failedStart");
    end
end

--- Checks and unlock the caughtTwoBoots achievement.
-- @param levelFinished The boolean that indicate if the level has been already finished.
-- @param fishedValue The total value of fished objects.
-- @param valOfTwoShoes The value of two shoe objects.
function Achievement:checkTwoShoes(levelFinished, fishedValue, valOfTwoShoes)
    if levelFinished and _G._tmpTable.caughtThisRound.shoe == 2
    and not _G._persTable.achievements.caughtTwoBoots
    and fishedValue == valOfTwoShoes then
        self:unlockAchievement("caughtTwoBoots");
    end
end

--- Checks and unlock the nothingCaught achievement.
-- @param levelFinished The boolean that indicate if the level has been already finished.
-- @param failedStart Indicates if the intro failed.
function Achievement:checkNothingCaught(levelFinished, failedStart)
    if levelFinished and next(_G._tmpTable.caughtThisRound) == nil and not failedStart
    and not _G._persTable.achievements.nothingCaught then
        self:unlockAchievement("nothingCaught");
    end
end

--- Checks and unlock the allLevelBoardersPassed achievement.
-- @param levelFinished The boolean that indicate if the level has been already finished.
-- @param reachedDepth The maximal reached depth of one round.
-- @param lowerBorder The lower border of the current level.
function Achievement:checkAllBordersPassed(levelFinished, reachedDepth, lowerBorder)
    if levelFinished and not _G._persTable.achievements.allLevelBoardersPassed
    and _persTable.upgrades.mapBreakthrough1 == true and _persTable.upgrades.mapBreakthrough2 == true
    and reachedDepth <= lowerBorder then
        self:unlockAchievement("allLevelBoardersPassed");
    end
end

--- Checks and unlock the getFirstObject achievement.
-- @param levelFinished The boolean that indicate if the level has been already finished.
function Achievement:checkFirstObject(levelFinished)
    if levelFinished and not _G._persTable.achievements.getFirstObject
    and next(_G._tmpTable.caughtThisRound) ~= nil then
        self:unlockAchievement("getFirstObject");
    end
end

--- Checks and unlock the rageQuit achievement.
-- @param reachedDepth The maximal reached depth of one round.
function Achievement:checkRageQuit(reachedDepth)
    if not _G._persTable.achievements.rageQuit and _G._persTable.phase == 2
    and math.ceil(math.abs(reachedDepth / 300)) <= 2 then
        self:unlockAchievement("rageQuit");
    end
end

--- Checks and unlock the playedTime achievement.
-- @param levelFinished The boolean that indicate if the level has been already finished.
function Achievement:checkPlayTime(levelFinished)
    if levelFinished and not _G._persTable.achievements.playedTime
    and _G._persTable.playedTime > (2 * 60 * 60) then
        self:unlockAchievement("playedTime");
    end
end

--- Checks and unlock the creditsRed achievement.
-- @param timeSpent The difference of the time of calling the credits frame and leaving it.
function Achievement:checkCreditsRed(timeSpent)
    if timeSpent >= 10 then
        if not _G._persTable.achievements.creditsRed then
            self:unlockAchievement("creditsRed");
        end
    end
end

--- Checks and unlock the onlyOne achievement.
-- @param reachedDepth The maximal reached depth of one round.
--function Achievement:checkOnlyOne(reachedDepth)
--    if math.ceil(math.abs(reachedDepth / 300)) >= 5 and _G._persTable.fish.caughtInOneRound = 1 then
--        self:unlockAchievement("onlyOne");
--    end
--end

--- Unlocks the given achievement.
-- @param achName The name of the achievement.
function Achievement:unlockAchievement(achName)
    if not _G._persTable.achievements[achName] then
        table.insert(_G._unlockedAchievements, _G.data.achievements[achName]);
        _gui:newNotification("assets/gui/480px/" .. _G.data.achievements[achName].image_unlock, achName);
        _G._persTable.achievements[achName] = true;
    end
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
