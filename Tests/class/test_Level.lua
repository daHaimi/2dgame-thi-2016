-- Lua 5.1 Hack
_G.math.inf = 1 / 0

_G.levelTestStub = function()
    _G.TEsound = {
        playLooping = function(...) end;
        stop = function(...) end;
    };

    _G._persTable = {
        upgrades = {
            godMode = 1;
            mapBreakthrough1 = 0;
            mapBreakthrough2 = 0;
        };
        phase = 1;
    };
    _G._tmpTable = {
        earnedMoney = nil;
        currentDepth = nil;
        roundFuel = nil;
    };
    _G.levMan = {
        curLevel = nil;
        curPlayer = {
            getPosXMouse = function (...) return 50 end;
        };
        curSwarmFac = nil;
        getLevelPropMapByName = function(...) return {
            direction = 1;
        }
        end;
        getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac end;
        getCurPlayer = function(...) return _G.levMan.curPlayer end;
        getCurLevel = function(...) return _G.levMan.curLevel end;
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
            };
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

        locInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1, _G.levMan);
        locInstance.levMan = _G.levMan;
        locInstance.caughtThisRound = {};
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1, _G.levMan);
        local lb = myInstance.lowerBoarder;
        local mbb1 = myInstance.mapBreakthroughBonus1;
        local mbb2 = myInstance.mapBreakthroughBonus2;
        assert.are.same(locInstance, myInstance);

        _persTable.upgrades.mapBreakthrough1 = true;
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1, _G.levMan);
        assert.are.same(lb + mbb1, myInstance.lowerBoarder);

        _persTable.upgrades.mapBreakthrough2 = true;
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1, _G.levMan);
        assert.are.same(lb + mbb1 + mbb2, myInstance.lowerBoarder);
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
        locInstance.posY = 1
        assert.are.same(1, locInstance:getYPos());
    end)

    it("Testing checkGodMode", function()
        locInstance.godModeActive = 1;
        locInstance.godModeFuel = 20;
        local sSGMF = spy.on(locInstance, "setGodModeFuel");

        for i = 10, -20, -1
        do
            locInstance.posY = i;
            locInstance:checkGodMode();
        end
        assert.spy(sSGMF).was.called(20);
        assert.are.same(locInstance.godModeActive, 0);
    end)

    it("Testing addToCaught", function()
        local name = "nemo";
        locInstance:addToCaught(name);
        assert.are.same(locInstance.caughtThisRound.nemo, 1);
    end)

    it("Testing addToCaught twice to test IF", function()
        local name = "nemo";
        locInstance:addToCaught(name);
        locInstance:addToCaught(name); --- now it is not nil
        assert.are.same(locInstance.caughtThisRound.nemo, 2);
    end)

    it("Testing addToCaught for two diffrent ", function()
        local name1 = "nemo";
        local name2 = "hans";
        locInstance:addToCaught(name1);
        locInstance:addToCaught(name2);
        assert.are.same(locInstance.caughtThisRound.nemo, 1);
        assert.are.same(locInstance.caughtThisRound.hans, 1);
    end)

    it("Testing activateGodMode", function()
        _G._persTable.upgrades.godMode = 1;
        locInstance.godModeFuel = 500;
        local sAGM = spy.on(locInstance, "activateGodMode");
        locInstance:activateGodMode();
        assert.spy(sAGM).was.called(1);
        assert.are.same(locInstance.godModeActive, 1);

        locInstance.godModeFuel = 0;
        locInstance:activateGodMode();
        assert.spy(sAGM).was.called(2);
        assert.are.same(locInstance.godModeActive, 0);

        _G._persTable.upgrades.godMode = 0;
        locInstance.godModeFuel = 1000;
        locInstance:activateGodMode();
        assert.spy(sAGM).was.called(3);
        assert.are.same(locInstance.godModeActive, 0);
    end)

    it("Testing deactivateGodMode", function()
        testClass.godModeActive = 1;
        local sDGM = spy.on(testClass, "deactivateGodMode");
        testClass:deactivateGodMode();
        assert.spy(sDGM).was.called(1);
        assert.are.same(testClass.godModeActive, 0);
    end)

    it("Testing getGodModeStat", function()
        assert.are.same(testClass:getGodModeStat(), 0);
    end)

    it("Testing setGodModeFuel and getGodModeFuel", function()
        testClass.godModeActive = 1;
        testClass:setGodModeFuel(1000);
        assert.are.same(testClass:getGodModeFuel(), 1000);
        testClass:setGodModeFuel(0);
        assert.are.same(testClass:getGodModeFuel(), 0);
        assert.are.same(testClass.godModeActive, 0);
    end)

    it("Testing resetOldPosY", function()
        testClass.oldPosY = -400;
        testClass:resetOldPosY();
        assert.are.same(testClass.oldPosY, math.inf);
    end)

    it("Testing calcFishedValue", function()
        locInstance.levMan.curSwarmFac = {
            getFishableObjects = function() return {
                ["turtle"] = { ["value"] = 10 },
                ["rat"] = { ["value"] = 20 },
                ["nemo"] = { ["value"] = 10 },
                ["deadFish"] = { ["value"] = -10 }
            };
            end;
        };

        locInstance.caughtThisRound = { ["turtle"] = 5, ["rat"] = 0, ["deadFish"] = 5, ["nemo"] = 3 };
        assert.are.same(locInstance:calcFishedValue(), 30);
    end)

    it("Testing multiplyFishedValue", function()
        assert.are.same(testClass:multiplyFishedValue(55, 2.5), 138);
        assert.are.same(testClass:multiplyFishedValue(0, 2.5), 0);
        assert.are.same(testClass:multiplyFishedValue(-55, 2.5), -137);
    end)

    it("Testing isFinished", function()
        assert.are.same(locInstance:isFinished(), 0);
        locInstance.levelFinished = 1;
        assert.are.same(locInstance:isFinished(), 1);
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
        locInstance.caughtThisRound["cat"] = 1;
        locInstance.caughtThisRound["dog"] = 2;
        locInstance.levMan.curSwarmFac = {
            getFishableObjects = function() return { ["cat"] = { ["value"] = 10 }, ["dog"] = { ["value"] = 20 } }; end;
        };
        local loveMock = mock(_G.love, true);
        locInstance:printResult();
        assert.spy(loveMock.graphics.print).was.called(4);
        assert.spy(loveMock.graphics.print).was.called_with("Caught objects in this round:", match._, match._);
        assert.spy(loveMock.graphics.print).was.called_with("cat: 1 x 10 Coins", match._, match._);
        assert.spy(loveMock.graphics.print).was.called_with("dog: 2 x 20 Coins", match._, match._);
        assert.spy(loveMock.graphics.print).was.called_with("Earned: 50 Coins", match._, match._);
    end)

    it("Testing switchToPhase2", function()
        locInstance:switchToPhase2();
        assert.are.same(-1, locInstance:getDirection());
    end)

    it("Testing Update", function()
        local dt = 4;
        local bait = {
            update = function(...) end;
            speed = 200;
        };
        locInstance.posY = -7500;
        locInstance:update(dt, bait);
        assert.are.same(-1, locInstance:getDirection());
        locInstance.posY = 1200;
        locInstance:update(dt, bait);
        assert.are.same(0, locInstance:getDirection());
    end)

    it("Testing activateShortGM", function()
        levMan.p_levelProperties = {
            sewers = {
                levelName = "sewers",
                direction = 1,
                bgPath = "assets/testbg.png";
            };
        };

        locInstance.p_levelName = "sewers";
        locInstance.direction = 1;
        locInstance.shortGMDist = 0;
        locInstance.godModeActive = 0;
        locInstance.oldPosY = 210;
        locInstance:activateShortGM(0.12, 200);

        assert.are.same(locInstance.godModeActive, 1);
        assert.are.same(locInstance.oldPosY, _G.math.inf);

        locInstance.shortGMDist = 0;
        locInstance.godModeActive = 0;
        locInstance.oldPosY = 210;
        locInstance.direction = -1;
        locInstance:activateShortGM(0.12, 200);

        assert.are.same(locInstance.godModeActive, 0);

    end)

    it("Testing reduceShortGMDist", function()
        locInstance.oldPosY = _G.math.inf;
        locInstance.godModeActive = 0;
        locInstance.godModeFuel = 250;
        locInstance:activateShortGM(0.12, 200);
        local sRSGM = spy.on(locInstance, "reduceShortGMDist");

        for i = 10, -250, -1
        do
            locInstance.posY = i;
            locInstance:checkGodMode();
        end
        assert.spy(sRSGM).was.called(161);
        assert.are.same(locInstance.godModeActive, 0);
        assert.are.same(locInstance.shortGMDist, 0);
        assert.are.same(locInstance.oldPosY, _G.math.inf);
        assert.are.same(locInstance.godModeFuel, 250);
    end)

    it("Testing getMoved()", function()
        testClass.moved = 5;
        assert.are.same(5, testClass:getMoved());
    end)

    it("Testing getTime()", function()
        _G.os.date = function(...) return "22" end;
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1);
        assert.are.same("day", myInstance:getTime());

        _G.os.date = function(...) return "35" end;
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1);
        assert.are.same("night", myInstance:getTime());
    end)

    it("Testing getLevelName", function()
        locInstance.p_levelName = "someName";
        assert.are.same("someName", locInstance:getLevelName());
    end)

    it("Testing drawEnviroment", function()
        local loveMock = mock(_G.love, true);
        locInstance:drawEnviroment();
        assert.spy(loveMock.graphics.draw).was.called(17);
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



end)
