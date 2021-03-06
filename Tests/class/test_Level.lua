-- Lua 5.1 Hack
_G.math.inf = 1 / 0
_G.Animate = require "class.Animate";
_G.levelTestStub = function()
    _G.TEsound = {
        playLooping = function(...) end;
        play = function(...) end;
        stop = function(...) end;
        pause = function(...) end;
        resume = function(...) end;
    };

    _G._persTable = {
        upgrades = {
            godMode = true;
            moreFuel1 = true;
            moreFuel2 = true;
            mapBreakthrough1 = false;
            mapBreakthrough2 = false;
        };
        achievements = {};
        playedTime = 0;
        phase = 1;
        config = {
            bgm = 50;
        };
    };

    _G.Animate.init = function(...) end;
    _G.Animate.AnimType = {
        linear = 1;
        bounce = 2;
        random = 3;
    }
    _G.Animate.p_quads = {};
    _G._persistence = {};
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
        };
        caughtTotal = 0;
        caughtInOneRound = 0;
    };
    _G._persTable.statistic = {
        maxCoinOneRound = 0;
        minCoinOneRound = 0;
        moneyEarnedTotal = 0;
        highscoreSewers = 0;
        highscoreCanyon = 0;
    };
    _G._tmpTable = {
        earnedMoney = nil;
        currentDepth = nil;
        roundFuel = nil;
        caughtThisRound = {};
    };

    local fishables = {
        shoe = {
            value = -50;
        };
    };

    _G.levMan = {
        curLevel = nil;
        curPlayer = {
            getPosXMouse = function(...) return 50 end;
            getSpeed = function(...) return 200 end;
            changeSprite = function(...) end;
        };
        curSwarmFac = {
            createMoreSwarms = function(...) end;
            createRandomPill = function(...) end;
            createFallingLitter = function(...) end;
            createBubbles = function(...) end;
            getFishableObjects = function(...) return fishables end;
        };
        getLevelPropMapByName = function(...) return {
            direction = 1;
        };
        end;
        getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac; end;
        getCurPlayer = function(...) return _G.levMan.curPlayer; end;
        getCurLevel = function(...) return _G.levMan.curLevel; end;
        getAchievmentManager = function(...) return {
            checkFailStart = function(...) end;
            checkTwoShoes = function(...) end;
            checkNothingCaught = function(...) end;
            checkAllBordersPassed = function(...) end;
            checkFirstObject = function(...) end;
            checkPlayTime = function(...) end;
            onlyNegativeFishesCaught = function(...) end;
            checkNegativCoins = function(...) end;
            achBitch = function(...) end;
            allPillsAtLeastOnce = function(...) end;
            moneyTotal = function(...) end;
        } end;
    };
    
    _G._depth = {
        default = -7000;
        advanced = -9000;
        endless = -math.inf;
    };
    
    _G._gui = {
        getFrames = function(...)
            return {
                inGame = {
                    activate = function(...) end;
                    clear = function(...) end;
                };
            };
        end;
        newTextNotification = function (...) end;
    };
    _G.love = {
        graphics = {
            newImage = function(...) end;
            newQuad = function(...) end;
            setColor = function(...) end;
            shader = {
                send = function(...) end;
            };
            Canvas = {
                setWrap = function(...) end;
            };
            print = function(...) end;
            draw = function(...) end;
        };
        image = {
            CompressedImageData = {
                getWidth = function(...) return 4 end;
                getHeight = function(...) return 5 end;
            };
        };
        window = {
            getMode = function(...) return 0, 0, {}; end;
        };
        light = {
            world = {
                setAmbientColor = function(...) end;
                update = function(...) end;
                drawShadow = function(...) end;
                setRefractionStrength = function(...) end;
                drawPixelShadow = function(...) end;
                drawGlow = function(...) end;
            };
            setGlowStrength = function(...) end;
            setSmooth = function(...) end;
            setPosition = function(...) end;
        };
    };
    _G.love.light.world.newLight = function(...) return _G.love.light; end;
    _G.love.light.newWorld = function(...) return _G.love.light.world; end;
    _G.love.graphics.newShader = function(...) return _G.love.graphics.shader; end;
    _G.love.graphics.newCanvas = function(...) return _G.love.graphics.Canvas; end;
end;

_G.levelTestStub();


testClass = require "src.class.Level";
match = require 'luassert.match';

describe("Test unit test suite", function()
    local locInstance;

    before_each(function()

        _G.levelTestStub();

        locInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, _depth, "normal", _G.levMan);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, _depth, "normal", _G.levMan);
        local lb = myInstance.lowerBoarder;
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor for sleepingCrocos", function()
        local myInstance1 = testClass("sleepingCrocos", "assets/testbg.png", { 512, 256 }, _depth, "sleepingCrocos", _G.levMan);
        local myInstance2 = testClass("sleepingCrocos", "assets/testbg.png", { 512, 256 }, _depth, "sleepingCrocos", _G.levMan);
        assert.are.same(myInstance1, myInstance2);
    end)

    it("Testing Constructor for crazySquirrels", function()
        local myInstance1 = testClass("crazySquirrels", "assets/testbg.png", { 512, 256 }, _depth, "crazySquirrels", _G.levMan);
        local myInstance2 = testClass("crazySquirrels", "assets/testbg.png", { 512, 256 }, _depth, "crazySquirrels", _G.levMan);
        assert.are.same(myInstance1, myInstance2);
    end)

    it("Testing destructLevel", function()
        local testInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, _depth, "normal", _G.levMan);
        testInstance:destructLevel();

        for key, value in pairs(testInstance) do
            assert.are.same(nil, value);
        end
    end)

    it("Testing setLowerBoarder and getLowerBoarder", function()
        testClass:setLowerBoarder(100);
        assert.are.same(testClass:getLowerBoarder(), 100);
    end)

    it("Testing setUpperBoarder and get upperBoarder", function()
        testClass:setUpperBoarder(1000);
        assert.are.same(testClass:getUpperBoarder(), 1000);
    end)

    it("Testing setDirection and getDirection", function()
        testClass:setDirection(1);
        assert.are.same(testClass:getDirection(), 1);
    end)

    it("Testing getYPos", function()
        locInstance.posY = 1;
        assert.are.same(1, locInstance:getYPos());
    end)

    it("Testing checkGodMode", function()
        locInstance.godModeActive = true;
        locInstance.godModeFuel = 20;
        locInstance.moved = 2;

        for i = 1, 20, 1 do
            locInstance:checkGodMode();
        end
        assert.are.same(locInstance.godModeActive, false);
    end)

    it("Testing addToCaught", function()
        local name = "nemo";
        locInstance:addToCaught(name);
        assert.are.same(_G._tmpTable.caughtThisRound[name], 1);
    end)

    it("Testing addToCaught twice to test IF", function()
        local name = "nemo";
        locInstance:addToCaught(name);
        locInstance:addToCaught(name); --- now it is not nil
        assert.are.same(_G._tmpTable.caughtThisRound.nemo, 2);
    end)

    it("Testing addToCaught for two diffrent ", function()
        local name1 = "nemo";
        local name2 = "hans";
        locInstance:addToCaught(name1);
        locInstance:addToCaught(name2);
        assert.are.same(_G._tmpTable.caughtThisRound.nemo, 1);
        assert.are.same(_G._tmpTable.caughtThisRound.hans, 1);
    end)

    it("Testing activateGodMode", function()
        _G._persTable.upgrades.godMode = 1;
        locInstance.godModeFuel = 500;
        local sAGM = spy.on(locInstance, "activateGodMode");
        locInstance:activateGodMode();
        assert.spy(sAGM).was.called(1);
        assert.are.same(locInstance.godModeActive, true);

        locInstance.godModeFuel = 0;
        locInstance:activateGodMode();
        assert.spy(sAGM).was.called(2);
        assert.are.same(locInstance.godModeActive, true);

        _G._persTable.upgrades.godMode = 0;
        locInstance.godModeFuel = 1000;
        locInstance:activateGodMode();
        assert.spy(sAGM).was.called(3);
        assert.are.same(locInstance.godModeActive, true);
    end)

    it("Testing deactivateGodMode", function()
        testClass.godModeActive = true;
        local sDGM = spy.on(testClass, "deactivateGodMode");
        testClass:deactivateGodMode();
        assert.spy(sDGM).was.called(1);
        assert.are.same(testClass.godModeActive, false);
    end)

    it("Testing getGodModeStat", function()
        assert.are.same(testClass:getGodModeStat(), false);
    end)

    it("Testing setGodModeFuel and getGodModeFuel", function()
        testClass.godModeActive = true;
        testClass:setGodModeFuel(1000);
        assert.are.same(testClass:getGodModeFuel(), 1000);
        testClass:setGodModeFuel(0);
        assert.are.same(testClass:getGodModeFuel(), 0);
        assert.are.same(testClass.godModeActive, false);
    end)

    it("Testing resetOldPosY", function()
        testClass.oldPosY = -400;
        testClass:resetOldPosY();
        assert.are.same(testClass.oldPosY, math.inf);
    end)

    it("Testing calcFishedValue", function()
        locInstance.levMan.curSwarmFac = {
            getFishableObjects = function() return {
                ["turtle"] = { ["value"] = 10 };
                ["rat"] = { ["value"] = 20 };
                ["nemo"] = { ["value"] = 10 };
                ["deadFish"] = { ["value"] = -10 };
            };
            end;
        };

        _G._tmpTable.caughtThisRound = { ["turtle"] = 5; ["rat"] = 0; ["deadFish"] = 5; ["nemo"] = 3; };
        assert.are.same(locInstance:calcFishedValue(), 30);
    end)

    it("Testing multiplyFishedValue", function()
        assert.are.same(testClass:multiplyFishedValue(55, 2.5), 138);
        assert.are.same(testClass:multiplyFishedValue(0, 2.5), 0);
        assert.are.same(testClass:multiplyFishedValue(-55, 2.5), -137);
    end)

    it("Testing isFinished", function()
        assert.are.same(locInstance:isFinished(), false);
        locInstance.levelFinished = true;
        assert.are.same(locInstance:isFinished(), true);
    end)

    it("Testing printResult with no objects caught", function()
        local loveMock = mock(_G.love, true);
        _G._tmpTable.caughtThisRound = {};
        testClass:printResult();
        assert.spy(loveMock.graphics.print).was.called(2);
        assert.spy(loveMock.graphics.print).was.called_with("Caught objects in this round:", match._, match._);
        assert.spy(loveMock.graphics.print).was.called_with("Nothing caught", match._, match._);
    end)

    it("Testing printResult with caught objects", function()
        _G._tmpTable.caughtThisRound["turtle"] = 1;
        _G._tmpTable.caughtThisRound["nemo"] = 2;
        locInstance.levMan.curSwarmFac = {
            getFishableObjects = function()
                return { ["turtle"] = { ["value"] = 10 }; ["nemo"] = { ["value"] = 20 }; };
            end;
        };
        local loveMock = mock(_G.love, true);
        locInstance:printResult();
        assert.spy(loveMock.graphics.print).was.called(4);
        assert.spy(loveMock.graphics.print).was.called_with("Caught objects in this round:", match._, match._);
        assert.spy(loveMock.graphics.print).was.called_with("turtle: 1 x 10 Coins", match._, match._);
        assert.spy(loveMock.graphics.print).was.called_with("nemo: 2 x 20 Coins", match._, match._);
        assert.spy(loveMock.graphics.print).was.called_with("Earned: 50 Coins", match._, match._);
    end)

    it("Testing switchToPhase2", function()
        local unlockedCanyon = false;
        _G._gui = {
            newTextNotification = function(...) end;
            getFrames = function(...)return {
                level = {
                    unlockCanyon = function(...) _G._persTable.unlockedLevel = 2 end;
                };
            } end;
        };
        _G._persTable.unlockedLevel = 1;
        _G._persTable.config.language = "english";
        _G._persistence = {
            updateSaveFile = function(...) end;
        };
        locInstance.posY = -7001;
        locInstance.p_levelName = "sewers";
        stub(_G._gui, "newTextNotification");
        
        locInstance:switchToPhase2();
        assert.are.same(-1, locInstance:getDirection());
        assert.are.same(2, _G._persTable.unlockedLevel);
        assert.stub(_G._gui.newTextNotification).was.called(1);
    end)

    it("Testing Update", function()
        stub(locInstance, "checkForAchievments");
        _G._persTable.unlockedLevel = 2;
        local dt = 4;
        local bait = {
            update = function(...) end;
            getSpeed = function(...) return 200 end;
        };
        
        local perStub = stub(_G._persistence, "updateSaveFile");
        locInstance.posY = -7500;
        locInstance:update(dt, bait);
        assert.are.same(-1, locInstance:getDirection());
        locInstance.posY = 1200;
        locInstance.payPlayer = function(...) end;
        locInstance:update(dt, bait);

        assert.stub(locInstance.checkForAchievments).was_called(2);
        assert.are.same(0, locInstance:getDirection());
    end)

    it("Testing Update for animationStart", function()
        local dt = 4;
        local bait = {
            update = function(...) end;
            getSpeed = function(...) return 200 end;
        };
        locInstance.animationStartFinished = true;
        locInstance.direction = 1;
        locInstance:update(dt, bait);
        assert.are.same(800, locInstance.moved);
        locInstance.direction = -1;
        locInstance:update(dt, bait);
        assert.are.same(-800, locInstance.moved);
    end)

    it("Testing activateShortGM", function()
        levMan.p_levelProperties = {
            sewers = {
                levelName = "sewers";
                direction = 1;
                bgPath = "assets/testbg.png";
            };
        };

        locInstance.p_levelName = "sewers";
        locInstance.direction = 1;
        locInstance.shortGMDist = 0;
        locInstance.godModeActive = false;
        locInstance.oldPosY = 210;
        locInstance:activateShortGM(0.12, 200);

        assert.are.same(locInstance.godModeActive, true);
        assert.are.same(locInstance.oldPosY, _G.math.inf);

        locInstance.shortGMDist = 0;
        locInstance.godModeActive = false;
        locInstance.oldPosY = 210;
        locInstance.direction = -1;
        locInstance:activateShortGM(0.12, 200);

        assert.are.same(locInstance.godModeActive, false);
    end)

    it("Testing reduceShortGMDist", function()
        locInstance.oldPosY = _G.math.inf;
        locInstance.godModeActive = false;
        locInstance.godModeFuel = 250;
        locInstance:activateShortGM(0.12, 200);
        local sRSGM = spy.on(locInstance, "reduceShortGMDist");

        for i = 10, -250, -1 do
            locInstance.posY = i;
            locInstance:checkGodMode();
        end
        assert.spy(sRSGM).was.called(161);
        assert.are.same(locInstance.godModeActive, false);
        assert.are.same(locInstance.shortGMDist, 0);
        assert.are.same(locInstance.oldPosY, _G.math.inf);
        assert.are.same(locInstance.godModeFuel, 250);
    end)

    it("Testing getMoved()", function()
        testClass.moved = 5;
        assert.are.same(5, testClass:getMoved());
    end)

    it("Testing getLevelName", function()
        locInstance.p_levelName = "someName";
        assert.are.same("someName", locInstance:getLevelName());
    end)

    it("Testing drawEnviroment before start Animation", function()
        local loveMock = mock(_G.love, true);
        locInstance.enviromentPosition = -250;
        locInstance.animationStart = false;
        locInstance:drawEnviroment();
        assert.spy(loveMock.graphics.draw).was.called(20);
        assert.are.same(-50, locInstance.enviromentPosition);
    end)

    it("Testing drawEnviroment while start Animation", function()
        local loveMock = mock(_G.love, true);
        locInstance.animationStart = true;
        locInstance.enviromentPosition = 250;
        locInstance:drawEnviroment();
        assert.spy(loveMock.graphics.draw).was.called(20);
    end)

    it("Testing drawEnviroment: drawing Walls", function()
        local loveMock = mock(_G.love, true);
        locInstance.animationStart = true;
        locInstance.enviromentPosition = 250;
        locInstance:drawEnviroment();
        assert.are.same(50, locInstance.enviromentPosition);

        locInstance.enviromentPosition = -250;
        locInstance:drawEnviroment();
        assert.are.same(-50, locInstance.enviromentPosition);
    end)

    it("Testing drawEnviroment while failed start", function()
        local loveMock = mock(_G.love, true);
        locInstance.animationStart = true;
        locInstance.failedStart = true;
        locInstance:drawEnviroment();
        assert.spy(loveMock.graphics.draw).was.called(20);
    end)

    it("Testing drawEnviroment while ending animation sewer", function()
        local loveMock = mock(_G.love, true);
        locInstance.animationStart = true;
        locInstance.direction = -1;
        locInstance.pumpingWay = 100;
        locInstance.animationEnd = true;
        locInstance.levelFinished = true;
        locInstance:drawEnviroment();
        assert.spy(loveMock.graphics.draw).was.called(16);
    end)

    it("Testing getStartAnimationRunning", function()
        locInstance.animationStart = true;
        locInstance.animationStartFinished = false;
        assert.are.same(true, locInstance:getStartAnimationRunning());
    end)

    it("Testing getStartAnimationFinished", function()
        locInstance.animationStartFinished = true;
        assert.are.same(true, locInstance:getStartAnimationFinished());
    end)

    it("Testing startStartAnimation", function()
        locInstance.animationStart = false;
        locInstance:startStartAnimation();
        assert.are.same(true, locInstance.animationStart);
    end)

    it("Testing drawLine", function()
        local loveMock = mock(_G.love, true);
        locInstance.hamsterYPos = 400;
        locInstance.animationStartPoint = 0;
        locInstance:drawLine(0, 300);
        assert.spy(loveMock.graphics.draw).was.called(34);
    end)

    it("Testing isLoaded", function()
        assert.are.same(locInstance:isLoaded(), true);
        locInstance.gameLoaded = nil;
        assert.are.same(locInstance:isLoaded(), false);
    end)

    it("Testing onPause", function()
        local sOnPause = spy.on(locInstance, "onPause");
        locInstance:onPause();
        assert.spy(sOnPause).was.called();
    end)

    it("Testing onResume", function()
        local sOnResume = spy.on(locInstance, "onResume");
        locInstance:onResume();
        assert.spy(sOnResume).was.called();
    end)

    it("Testing doAnimation failed start 1", function()
        locInstance.hamsterLockedXPos = 70;
        locInstance.animationStart = true;
        locInstance.animationStartFinished = false;
        locInstance.winDim = { 480, 833 };
        locInstance:doStartAnimationMovement(_G.levMan.curPlayer, 5);
        assert.are.same(locInstance.failedStart, true);
    end)

    it("Testing doAnimation failed start 2", function()
        locInstance.hamsterLockedXPos = 50;
        locInstance.hamsterYPos = 0;
        locInstance.animationStart = true;
        locInstance.animationStartFinished = false;
        locInstance.winDim = { 480, 833 };
        locInstance:doStartAnimationMovement(_G.levMan.curPlayer, 5);
        assert.are.same(locInstance.failedStart, true);
    end)

    it("Testing doAnimation failed start 3", function()
        locInstance.hamsterLockedXPos = 50;
        locInstance.hamsterYPos = 1000;
        locInstance.animationStart = true;
        locInstance.animationStartFinished = false;
        locInstance.winDim = { 480, 833 };
        locInstance:doStartAnimationMovement(_G.levMan.curPlayer, 5);
        assert.are.same(locInstance.levelFinished, true);
    end)

    it("Testing doAnimation failed start 4", function()
        locInstance.hamsterLockedXPos = 150;
        locInstance.hamsterYPos = 1000;
        locInstance.animationStart = true;
        locInstance.animationStartFinished = false;
        locInstance.winDim = { 480, 833 };
        locInstance:doStartAnimationMovement(_G.levMan.curPlayer, 5);
        assert.are.same(locInstance.animationStartFinished, true);
    end)

    it("Testing doAnimation failed start 5", function()
        locInstance.hamsterLockedXPos = 75;
        locInstance.hamsterYPos = 1000;
        locInstance.animationStart = true;
        locInstance.animationStartFinished = false;
        locInstance.winDim = { 480, 833 };
        locInstance:doStartAnimationMovement(_G.levMan.curPlayer, 5);
        assert.are.same(locInstance.levelFinished, true);
    end)

    it("Testing doAnimation failed start 6", function()
        locInstance.hamsterLockedXPos = 150;
        locInstance.hamsterYPos = 1000;
        locInstance.animationStart = true;
        locInstance.animationStartFinished = false;
        locInstance.winDim = { 480, 833 };
        locInstance:doStartAnimationMovement(_G.levMan.curPlayer, 5);
        assert.are.same(locInstance.failedStart, false);
    end)

    it("testing Constructor for canyon", function()
        local loveMock = mock(_G.love.graphics, true);
        local myTestInstance = testClass("canyon", "assets/testbg.png", { 512, 256 }, _depth, "normal", _G.levMan);
        assert.spy(loveMock.newImage).was.called_with("assets/canyon_right.png");
    end)

    it("testing Update for canyon", function()
        --local mock = mock(levMan.curSwarmFac, true);
        local st = stub(levMan.curSwarmFac, "createFallingLitter");
        local myTestInstance = testClass("canyon", "assets/testbg.png", { 512, 256 }, _depth, "normal", _G.levMan);
        local bait = {
            update = function(...) end;
            getSpeed = function(...) return 200 end;
        };
        myTestInstance:update(0.05, bait);
        myTestInstance.posY = -500;
        myTestInstance.winDim[2] = 500;
        assert.spy(st).was.called(1);
    end)

    it("testing waiting time", function()
        local dt = 0.004;
        local bait = {
            update = function(...) end;
            getSpeed = function(...) return 200 end;
        };
        locInstance.animationEndFinished = true;
        locInstance:update(dt, bait);
        assert.are.same(locInstance.waitTillSwitch, .496);
    end)

    it("testing startanimation for canyon 1", function()
        local myTestInstance = testClass("canyon", "assets/testbg.png", { 512, 256 }, _depth, "normal", _G.levMan);
        myTestInstance.hamsterYPos = 0;
        myTestInstance.animationStart = true;
        myTestInstance.animationStartFinished = false;
        myTestInstance:doStartAnimationMovement(_G.levMan.getCurPlayer(), 0.05);
        assert.are.same(myTestInstance.hamsterYPos, 5);
    end)

    it("testing startanimation for canyon 2", function()
        local myTestInstance = testClass("canyon", "assets/testbg.png", { 512, 256 }, _depth, "normal", _G.levMan);
        myTestInstance.hamsterYPos = 1000;
        myTestInstance.animationStart = true;
        myTestInstance.animationStartFinished = false;
        myTestInstance:doStartAnimationMovement(_G.levMan.getCurPlayer(), 0.05);
        assert.are.same(myTestInstance.animationStartFinished, true);
    end)

    it("Testing doEndAnimationMovement for canyon", function()
        local myTestInstance = testClass("canyon", "assets/testbg.png", { 512, 256 }, _depth, "normal", _G.levMan);
        myTestInstance.hamsterYPos = 1000;
        myTestInstance.levelFinished = true;
        myTestInstance:doEndAnimationMovement(_G.levMan.getCurPlayer(), 0.05);
        assert.are.same(myTestInstance.hamsterYPos, 990);
        myTestInstance.hamsterYPos = -1000;
        myTestInstance:doEndAnimationMovement(_G.levMan.getCurPlayer(), 0.05);
        assert.are.same(myTestInstance.animationEndFinished, true);
    end)

    it("Testing doEndAnimationMovement for sewers", function()
        locInstance.levelFinished = true;
        locInstance.failedStart = false;
        locInstance.pumpCounter = 0;
        locInstance.pumpDirection = true;
        locInstance.pumpingWay = 5;
        locInstance:doEndAnimationMovement(_G.levMan.getCurPlayer(), 0.05);
        assert.are.same(locInstance.pumpDirection, false);
    end)
    it("Testing doEndAnimationMovement for sewers", function()
        locInstance.levelFinished = true;
        locInstance.failedStart = false;
        locInstance.pumpCounter = 0;
        locInstance.pumpDirection = false;
        locInstance.pumpingWay = 90;
        locInstance:doEndAnimationMovement(_G.levMan.getCurPlayer(), 0.05);
        assert.are.same(locInstance.pumpDirection, true);
        assert.are.same(locInstance.pumpCounter, 1);
    end)

    it("Testing doEndAnimationMovement for sewers", function()
        locInstance.levelFinished = true;
        locInstance.failedStart = false;
        locInstance.pumpCounter = 6;
        locInstance.pumpingWay = 100;
        locInstance:doEndAnimationMovement(_G.levMan.getCurPlayer(), 0.05);
        assert.are.same(locInstance.pumpingWay, 115);
    end)

    it("Testing doEndAnimationMovement for sewers", function()
        locInstance.levelFinished = true;
        locInstance.failedStart = false;
        locInstance.pumpCounter = 6;
        locInstance.pumpingWay = 250;
        locInstance:doEndAnimationMovement(_G.levMan.getCurPlayer(), 0.05);
        assert.are.same(locInstance.animationEndFinished, true);
    end)

    it("Testing updateStatistics function", function()
        locInstance.calcFishedValue = function(...) return 210 end;
        local perStub = stub(_G._persistence, "updateSaveFile");

        _G._tmpTable.caughtThisRound = { 
            ["turtle"] = 30; ["rat"] = 0;
            ["deadFish"] = 19;
            ["nemo"] = 1;
        };
        _G._persTable.statistic.maxCoinOneRound = 20;
        _G._persTable.statistic.minCoinOneRound = 1;
        _G._persTable.statistic.highscoreSewers = 20;
        _G._persTable.statistic.highscoreCanyon = 200;
        _G._persTable.fish = {
            caughtTotal = 10;
            caughtInOneRound = 50;
            caught = {
                ["turtle"] = 0; 
                ["rat"] = 0;
                ["deadFish"] = 0;
                ["nemo"] = 0;
            };
        };
        locInstance.levelFinished = true;
        locInstance.statUpdated = false;
        
        locInstance:updateStatistics();
        assert.are.same(60, _G._persTable.fish.caughtTotal);
        assert.stub(perStub).was.called(1);
    end)

    it("Testing getReachedDepth function", function()
        locInstance.reachedDepth = -356;

        assert.are.same(-356, locInstance:getReachedDepth());
    end)

    it("Testing update playing godMode music", function()
        locInstance.godModeActive = true;
        locInstance.godModeFuel = 1000;
        local bait = {
            update = function(...) end;
            getSpeed = function(...) return 200 end;
        };
        locInstance:update(0.05, bait);
        assert.are.same(locInstance.gMMusicPlaying, true);
    end)

    it("Testing update playTime", function()
        locInstance.unlockAchievement = function(...) end;
        locInstance.playTime = 1000;
        local perStub = stub(_G._persistence, "updateSaveFile");
        _G._persTable.playedTime = 1000;
        locInstance.pumpingWay = 0;
        locInstance.levelFinished = true;
        local bait = {
            update = function(...) end;
            getSpeed = function(...) return 200 end;
        };
        locInstance:update(1, bait);
        assert.are.same(_G._persTable.playedTime, 2000);
    end)

    it("Testing payPlayer function", function()
        _G._persistence.updateSaveFile = function(...) end;
        _G._persTable.upgrades.secondPermanentMoneyMult = false;
        _G._persTable.upgrades.firstPermanentMoneyMult = false;
        _G._persTable.money = 0;
        locInstance.levelFinished = false;
        locInstance.calcFishedValue = function(...) return 120 end;
        locInstance.gotPayed = 0;
        local persSpy = spy.on(_G._persistence, "updateSaveFile");
        
        locInstance:payPlayer();
        assert.are.same(0, locInstance.gotPayed);
        assert.are.same(0, locInstance.roundValue);
        
        locInstance.gotPayed = 0;
        locInstance.levelFinished = true;
        locInstance:payPlayer();
        assert.are.same(1, locInstance.gotPayed);
        assert.are.same(120, locInstance.roundValue);
        
        locInstance.gotPayed = 0;
        _G._persTable.upgrades.firstPermanentMoneyMult = true;
        locInstance:payPlayer();
        assert.are.same(1, locInstance.gotPayed);
        assert.are.same(144, locInstance.roundValue);
        
        locInstance.gotPayed = 0;
        _G._persTable.upgrades.secondPermanentMoneyMult = true;
        locInstance:payPlayer();
        assert.are.same(1, locInstance.gotPayed);
        assert.are.same(150, locInstance.roundValue);
        
        assert.spy(persSpy).was.called(3);
    end)
end)
