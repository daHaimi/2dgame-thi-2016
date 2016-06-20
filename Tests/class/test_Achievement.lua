-- Lua 5.1 Hack
_G.math.inf = 1 / 0
testClass = require "src.class.Achievement";
Data = require "data";

describe("Unit test for Achievement.lua", function()
    local locInstance;

    before_each(function()
        _G.data = Data;
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
        _G._gui = {
            newNotification = function(...) end;
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
            bFishCaugtTotal = false;
        }
        _G._persTable.fish = {
            caught = {
                turtle = 0;
                rat = 0;
                deadFish = 0;
                nemo = 0;
            };
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
            caughtThisRound = {};
        };
        
        local locInstance = testClass();
        
    end)


    it("Testing Constructor", function()
        locInstance = testClass();
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)

    it("Test function Achievement:caughtOneRound", function()
        _G._persTable.fish.caughtInOneRound = 30;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:caughtOneRound()
        assert.stub(myInstance.unlockAchievement).was.called(3);
    end)

    it("Testing achShoppingQueen function", function()
        stub(_G._gui, "newNotification");
        _G._persTable.upgrades = {test = false};
        locInstance:achShoppingQueen();
        assert.are.equal(_G._persTable.achievements.shoppingQueen, false);
        _G._persTable.upgrades = {test = true};
        locInstance:achShoppingQueen();
        assert.are.equal(_G._persTable.achievements.shoppingQueen, true);
        assert.stub(_G._gui.newNotification).was_called();
        assert.are.equal(true, _G._persTable.achievements.shoppingQueen);
    end)

    it("Test function Achievement:caughtOneRound", function()
        _G._persTable.fish.caughtInOneRound = 10;

        local myInstance = testClass();
        local exp = true;
        stub(myInstance, "unlockAchievement");
        myInstance:caughtOneRound()
        assert.stub(myInstance.unlockAchievement).was.called(1);
    end)

    it("Test function Achievement:caughtOneRound", function()
        _G._persTable.fish.caughtInOneRound = 20;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:caughtOneRound()
        assert.stub(myInstance.unlockAchievement).was.called(2);
    end)

    it("Test function Achievement:caughtOneRound", function()
        _G._persTable.fish.caughtInOneRound = 100;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:caughtOneRound()
        assert.stub(myInstance.unlockAchievement).was.called(3);
    end)

    it("Test function Achievement:moneyOneRound", function()
        _G._persTable.statistic.maxCoinOneRound = 100;

        local myInstance = testClass();
        local exp = false;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:moneyOneRound()
        assert.stub(myInstance.unlockAchievement).was.called(0);
    end)

    it("Test function Achievement:moneyOneRound", function()
        _G._persTable.statistic.maxCoinOneRound = 200;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:moneyOneRound()
        assert.stub(myInstance.unlockAchievement).was.called(1);
    end)

    it("Test function Achievement:moneyOneRound", function()
        _G._persTable.statistic.maxCoinOneRound = 600;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:moneyOneRound();
        assert.stub(myInstance.unlockAchievement).was.called(2);
    end)

    it("Test function Achievement:moneyOneRound", function()
        _G._persTable.statistic.maxCoinOneRound = 1000;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:moneyOneRound();
        assert.stub(myInstance.unlockAchievement).was.called(3);
    end)

    it("Test function Achievement:moneyTotal", function()
        _G._persTable.statistic.moneyEarnedTotal = 1000;

        local myInstance = testClass();
        local exp = false;
        myInstance.unlockAchievement = function (...) end;
        myInstance:moneyTotal()
        assert.are.same(_G._persTable.achievements.bMoneyEarnedTotal, exp);
    end)

    it("Test function Achievement:moneyTotal", function()
        _G._persTable.statistic.moneyEarnedTotal = 2000;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:checkAchievements();
        assert.stub(myInstance.unlockAchievement).was.called(1);
    end)

    it("Test function Achievement:moneyTotal", function()
        _G._persTable.statistic.moneyEarnedTotal = 6000;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:moneyTotal();
        assert.stub(myInstance.unlockAchievement).was.called(2);
    end)

    it("Test function Achievement:moneyTotal", function()
        _G._persTable.statistic.moneyEarnedTotal = 100000;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:moneyTotal();
        assert.stub(myInstance.unlockAchievement).was.called(3);
    end)

    it("Test function Achievement:fishCaughtTotal", function()
        _G._persTable.fish.caughtTotal = 10;

        local myInstance = testClass();
        local exp = false;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:checkAchievements();
        assert.stub(myInstance.unlockAchievement).was.called(0);
    end)

    it("Test function Achievement:fishCaughtTotal", function()
        _G._persTable.fish.caughtTotal = 100;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:checkAchievements();
        assert.stub(myInstance.unlockAchievement).was.called(1);
    end)

    it("Test function Achievement:fishCaughtTotal", function()
        _G._persTable.fish.caughtTotal = 200;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:checkAchievements();
        assert.stub(myInstance.unlockAchievement).was.called(2);
    end)

    it("Test function Achievement:fishCaughtTotal", function()
        _G._persTable.fish.caughtTotal = 500;

        local myInstance = testClass();
        local exp = true;
        myInstance.unlockAchievement = function (...) end;
        stub(myInstance, "unlockAchievement");
        myInstance:checkAchievements();
        assert.stub(myInstance.unlockAchievement).was.called(3);
    end)

    it("Test function Achievement:negativCoins", function()
        _G._gui = {
            newNotification = function(...) end;
        };
        _G._unlockedAchievements = {};
        _G.data = {
            achievements = {
                negativCoins = {
                    nameOnPersTable = "negativCoins";
                    sortNumber = 13;
                    image_lock = "ach_negativeShitcoin_locked.png";
                    image_unlock = "ach_negativeShitcoin.png";
                };
            };
        };
        
        local gotPayed = 0;
        local roundVal = -100;
        
        locInstance:checkNegativCoins(gotPayed, roundVal);
        assert.are.same(false, _G._persTable.achievements.negativCoins);
        
        gotPayed = 1;
        locInstance:checkNegativCoins(gotPayed, roundVal);
        assert.are.same(false, _G._persTable.achievements.negativCoins);
        
        roundVal = -200;
        locInstance:checkNegativCoins(gotPayed, roundVal);
        assert.are.same(true, _G._persTable.achievements.negativCoins);
    end)  

    it("Test Achievement: nothing Caught", function()
        _G._gui = {
            newNotification = function(...) end;
        };
        _G._unlockedAchievements = {};
        _G.data = {
            achievements = {
                onlyNegativeFishesCaught = {
                    nameOnPersTable = "onlyNegativeFishesCaught";
                    sortNumber = 20;
                    image_lock = "ach_negativeShitcoin_locked.png";
                    image_unlock = "ach_negativeShitcoin.png";
                };
            };
        };
        _G._tmpTable = {
            caughtThisRound = { 
                ["rat"] = 2;
            };
        };
        
        local levelFinished = true;
        local swarmFactory = {
            getFishableObjects = function(...) return {
                rat = {
                    value = -10;
                };
            } end;
        };
        
        stub(_gui, "newNotification");
        
        locInstance:onlyNegativeFishesCaught(levelFinished, swarmFactory);
        assert.are.same(true, _G._persTable.achievements.onlyNegativeFishesCaught);
        assert.stub(_gui.newNotification).was.called(1);
    end)
  
    it("Test function Achievement:allPillsAtLeastOnce", function()
        _G._persTable.fish.caught.sleepingPill  = 2;
        local myInstance = testClass();
        local exp = true;
        myInstance:allPillsAtLeastOnce()
        assert.are.same(_G._persTable.achievements.allPillsAtLeastOnce, exp);
    end)
  
      it("Test function Achievement:allObjectsAtLeastOnce", function()
        _G._persTable.fish.caught = {};
        _G._persTable.fish.caught.turtle = 1;
        _G._persTable.fish.caught.rat = 1;
        _G._persTable.fish.caught.deadFish = 1;
        _G._persTable.fish.caught.sleepingPill= 1;
        _G._persTable.fish.caught.nemo = 1;
        _G._persTable.fish.caught.lollipop = 1;
        _G._persTable.fish.caught.angler = 1;
        _G._persTable.fish.caught.ring = 1;
        _G._persTable.fish.caught.shoe = 1;
        _G._persTable.fish.caught.snake = 1;
        _G._persTable.fish.caught.crocodile = 1;
        _G._persTable.fish.caught.balloon = 1;
        _G._persTable.fish.caught.camera = 1;
        _G._persTable.fish.caught.drink = 1;
        _G._persTable.fish.caught.egg = 1;
        _G._persTable.fish.caught.cactus = 1;
        _G._persTable.fish.caught.leaf = 1;
        _G._persTable.fish.caught.canyonSnake = 1; 
        _G._persTable.fish.caught.backpack= 1;
        _G._persTable.fish.caught.bird = 1;
        _G._persTable.fish.caught.squirrel = 1;
        local myInstance = testClass();
        myInstance.unlockAchievement = function (...) end
        stub(myInstance, "unlockAchievement");
        myInstance:allObjectsAtLeastOnce();
        assert.stub(myInstance.unlockAchievement).was.called(1);
    end)
  
    it("Test function Achievement:allObjectsAtLeastOnce", function()
        _G._persTable.fish.caught.turtle = 1;
        _G._persTable.fish.caught.rat = 1;
        _G._persTable.fish.caught.deadFish = 0;
        _G._persTable.fish.caught.sleepingPill= 1;
        _G._persTable.fish.caught.nemo = 1;
        _G._persTable.fish.caught.lollipop = 1;
        _G._persTable.fish.caught.angler = 1;
        _G._persTable.fish.caught.ring = 1;
        _G._persTable.fish.caught.shoe = 1;
        _G._persTable.fish.caught.snake = 1;
        _G._persTable.fish.caught.crocodile = 1;
        _G._persTable.fish.caught.balloon = 1;
        _G._persTable.fish.caught.camera = 1;
        _G._persTable.fish.caught.drink = 1;
        _G._persTable.fish.caught.egg = 1;
        _G._persTable.fish.caught.cactus = 1;
        _G._persTable.fish.caught.leaf = 1;
        _G._persTable.fish.caught.canyonSnake = 1; 
        _G._persTable.fish.caught.backpack= 1;
        _G._persTable.fish.caught.bird = 1;
        _G._persTable.fish.caught.squirrel = 1;
        local myInstance = testClass();
        local exp = false;
        myInstance.unlockAchievement = function (...) end;
        myInstance:allObjectsAtLeastOnce ()
        assert.are.same(_G._persTable.achievements.allObjectsAtLeastOnce , exp);
    end)

    it("Testing unlock FailedStart", function()
        _G._gui = {
            newNotification = function(...) end;
        };
        _G._unlockedAchievements = {};
        _G.data = {
            achievements = {
                failedStart = {
                    nameOnPersTable = "failedStart";
                    image_lock = "ach_drop_hamster_locked.png";
                    image_unlock = "ach_drop_hamster.png";
                };
            };
        };

        stub(_gui, "newNotification");
        local failedStart = true;
        local levelFinished = true;
        _G._persTable.achievements.failedStart = false;
        locInstance:checkFailStart(failedStart, levelFinished);
        assert.are.same(true, _G._persTable.achievements.failedStart);
        assert.stub(_gui.newNotification).was.called(1);
    end)

    it("Testing unlock twoBoots", function()
        _G._gui = {
            newNotification = function(...) end;
        };
        _G._unlockedAchievements = {};
        _G.data = {
            achievements = {
                caughtTwoBoots = {
                    nameOnPersTable = "caughtTwoBoots";
                    image_lock = "ach_two_shoes_locked.png";
                    image_unlock = "ach_two_shoes.png";
                };
            };
        };

        stub(_gui, "newNotification");
        _G._tmpTable.caughtThisRound = {
            shoe = 2;
        }
        _G._persTable.fish.caught = {
            shoe = 2;
        }
        
        local shoeVal = -20;
        local fishedVal = -40;
        local levelFinished = true;
        _G._persTable.achievements.caughtTwoBoots = false;
        locInstance:checkTwoShoes(levelFinished, fishedVal, shoeVal*2);
        assert.are.same(true, _G._persTable.achievements.caughtTwoBoots);
        assert.stub(_gui.newNotification).was.called(1);
    end)

    it("Testing update playTime", function()
        _G._gui = {
            newNotification = function(...) end;
        };
        _G.data = {
            achievements = {
                playedTime = {
                    nameOnPersTable = "playedTime";
                    image_lock = "ach_playtime_locked.png";
                    image_unlock = "ach_playtime.png";
                };
            };
        };
        _G._persTable.playedTime = 7201;
        _G._persTable.achievements = {
            playedTime = false;
        };
        stub(_gui, "newNotification");
        local levelFinished = true;
        
        locInstance:checkPlayTime(levelFinished);
        assert.are.same(true, _G._persTable.achievements.playedTime);
        assert.stub(_gui.newNotification).was.called(1);
    end)

    it("Testing achievement achBitch", function()
        _G._persTable.achievements = {
            getFirstObject = false;
            failedStart = true;
            caughtTwoBoots = true;
            secondStart = true;
            bronzeCaughtOneRound = true;
            silverCaughtOneRound = true;
            goldCaughtOneRound = true;
            bronzeCoinsOneRound = true;
            silverCoinsOneRound = true;
            goldCoinsOneRound = true;
            bMoneyEarnedTotal = true;
            sMoneyEarnedTotal = true;
            gMoneyEarnedTotal = true;
            negativCoins = true;
            shoppingQueen = true;
            bFishCaugtTotal = true;
            sFishCaugtTotal = true;
            gFishCaugtTotal = true;
            firstBorderRemoved = true;
            onlyNegativeFishesCaught = true;
            allPillsAtLeastOnce = true;
            nothingCaught = true;
            allLevelBoardersPassed = true;
            creditsRed = true;
            playedTime = true;
            rageQuit = true;
            unreachable = false;
            achBitch = false;
        };
        stub(_G._gui, "newNotification");
        locInstance:achBitch();
        assert.are.same(false, _G._persTable.achievements.achBitch);
        
        _G._persTable.achievements.getFirstObject = true;
        locInstance:achBitch();
        
        assert.are.same(true, _G._persTable.achievements.playedTime);
        assert.stub(_gui.newNotification).was.called(1);
    end)

    it("Testing unlockAchievement function", function()
        _G._gui = {
            newNotification = function(...) end;
        };
        _G._unlockedAchievements = {};
        _G.data = {
            achievements = {
                getFirtsObject = {
                    nameOnPersTable = "getFirstObject";
                    image_lock = "ach_firstObject_locked.png";
                    image_unlock = "ach_firstObject.png";
                };
            };
        };

        stub(_gui, "newNotification");
        locInstance:unlockAchievement("getFirtsObject");
        assert.are.same(true, _G._persTable.achievements.getFirtsObject);
        assert.stub(_gui.newNotification).was.called(1);
    end) 

end)

