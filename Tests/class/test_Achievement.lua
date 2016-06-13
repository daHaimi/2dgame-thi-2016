-- Lua 5.1 Hack
_G.math.inf = 1 / 0
testClass = require "src.class.Achievement"

describe("Unit test for Achievement.lua", function()
    local locInstance;
    
    before_each(function()
  
      _G._persTable = {
        upgrades = {
            godMode = true;
            moreFuel1 = true;
            moreFuel2 = true;
            mapBreakthrough1 = 0;
            mapBreakthrough2 = 0;
        };
        achievements = {};
        playedTime = 0;
        phase = 1;
      };    
    
      _G._persTable.achievements = {
           getFirstObject = true;
          getSecondObject = false;
          failedStart = false;
          caughtTwoBoots = false;
          secondStart = false;
          bronzeCaughtOneRound = false;
          silverCaughtOneRound = false;
          goldCaughtOneRound = false;
          shoppingQueen = false;
          bronzeCoinsOneRound = false;
          silverCoinsOneRound = false;
          goldCoinsOneRound = false;
          negativCoins = false;
          bMoneyEarnedTotal = false;
          sMoneyEarnedTotal = false;
          gMoneyEarnedTotal = false;
          onlyOneCaught = false;
          onlyNegativeFishesCaught = false;
          allObjectsAtLeastOnce = false;
          allPillsAtLeastOnce = false;
          nothingCaught = false;
          playedTime = false;
      }
      _G._persTable.fish = {
            caught = {
              turtle = 0;
              rat = 0;
              deadFish = 0;
              nemo = 0;
            },
            caughtTotal = 0;
            caughtInOneRound = 0;
      };
      _G._persTable.statistic = {
            maxCoinOneRound = 0;
            minCoinOneRound = 0;
            moneyEarnedTotal = 0;
      };
      _G._tmpTable = {
          earnedMoney = nil;
          currentDepth = nil;
          roundFuel = nil;
          caughtThisRound  = {};
      };
      
    end)

    
    it("Testing Constructor", function()
        locInstance = testClass();
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)
  
    it("Test function Achievement:caughtOneRound", function()
        _G._persTable.fish.caughtInOneRound = 1;

        local myInstance = testClass();
        local exp = true;
        myInstance:caughtOneRound()
        assert.are.same(_G._persTable.achievements.onlyOneCaught, exp);
    end)
  
    it("Test function Achievement:caughtOneRound", function()
        _G._persTable.fish.caughtInOneRound = 10;

        local myInstance = testClass();
        local exp = true;
        myInstance:caughtOneRound()
        assert.are.same(_G._persTable.achievements.bronzeCaughtOneRound, exp);
        assert.are_not.same(_G._persTable.achievements.silverCaughtOneRound , exp);
        assert.are_not.same(_G._persTable.achievements.goldCaughtOneRound , exp);
    end)

    it("Test function Achievement:caughtOneRound", function()
        _G._persTable.fish.caughtInOneRound = 20;

        local myInstance = testClass();
        local exp = true;
        myInstance:caughtOneRound()
        assert.are.same(_G._persTable.achievements.silverCaughtOneRound , exp);
        assert.are_not.same(_G._persTable.achievements.goldCaughtOneRound , exp);
    end)
  
    it("Test function Achievement:caughtOneRound", function()
        _G._persTable.fish.caughtInOneRound = 100;

        local myInstance = testClass();
        local exp = true;
        myInstance:caughtOneRound()
        assert.are.same(_G._persTable.achievements.goldCaughtOneRound , exp);
    end)
    
    
  end)