-- Lua 5.1 Hack
_G.math.inf = 1 / 0

_G.love = {};
_G.love.filesystem = {};
_G.love.filesystem.write = function(...) return true end;
_G.love.filesystem.read = function(...) return "etwas", 5; end;
_G.love.filesystem.setIdentity = function(...) end;
_G.love.filesystem.exists = function(...) return true end;
_G.love.filesystem.remove = function(...) return true end;

testClass = require "src.class.Persistence";


describe("Unit test for Persistence.lua", function()
    local locInstance;

    before_each(function()
    --- globale persistance table
    _G._persTable = {
        statistic = {};
        achievements = {};
        config = {};
        money = 50000;
        lastLevel = 1;
        winDim = {};
        playedTime = 0;
        phase = 1;
        fish = {};
        enabled = {
            ring = true;
            sleepingPill = true;
        };
        unlockedLevel = 2;
    };

    --- upgrades list in persTable, "0" means unbought
    _G._persTable.upgrades = {
        firstSpeedUp = false; -- more speed
        secondSpeedUp = false; -- more speed
        oneMoreLife = false; -- more life
        twoMoreLife = false; -- more life
        threeMoreLife = false; -- more life
        moneyMultiplier = false; -- false means no additional money
        moreLife = 0; -- needed for calculation in a few classes
        godMode = false; -- indicates if the god mode is available or not
        mapBreakthrough1 = false; -- can you access the first map limit? 0 = no, 1 = yes
        mapBreakthrough2 = false; -- can you access the second map limit? 0 = no, 1 = yes
        moreFuel1 = false;
        moreFuel2 = false;
        pillDuration = 2; -- duration of the effect of the pills in seconds
        rainbowPillDuration = 5; -- duration of the effect of the pills in seconds
        sleepingPillSlow = 0.25; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement speed
        coffeeSpeedup = 2; -- sets the speedup factor for coffe 2 = 200% of the usual movement speed
        firstPermanentMoneyMult = false; -- false means no additional money
        secondPermanentMoneyMult = false; -- false means no additional money
    };

    _G._persTable.achievements = {
        getFirstObject = false;
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
        bFishCaughtTotal = false;
        sFishCaughtTotal = false;
        gFishCaughtTotal = false;
        achBitch = false;
        unreachable = false;
    };


    _G._persTable.statistic = {
        maxCoinOneRound = 0;
        minCoinOneRound = 0;
        moneyEarnedTotal = 0;
        highscoreSewers = 0;
        highscoreCanyon = 0;
    };

    --- config options
    _G._persTable.config = {
        bgm = 100;
        music = 100;
        language = "english";
    };

    _G._persTable.fish = {
        caughtInOneRound = 0;
        caughtTotal = 0;
        caught = {}; -- table of caughtable fishes with amount caught
        postiveFishCaught = false; -- no fish with positive value caught
    };
        
    _G._persTable.fish.caught = {
            turtle = 0;
            rat = 0;
            deadFish = 0;
            nemo = 0;
    };
                
    end)


    it("Testing Constructor", function()
        
        local serStub = stub(table, "serialize");
        local deserStub = stub(table, "deserialize");
        locInstance = testClass();
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)

end)

