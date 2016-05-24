-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Level";
match = require 'luassert.match';

describe("Test unit test suite", function()
    local locInstance;

    before_each(function()
            
        _G.TEsound = {
            playLooping = function (...) end;
            stop = function (...) end;
        }

        _G.love = {
            graphics = {
                newImage = function(...) end,
                newQuad = function(...) end,
                setColor = function(...) end,
                print = function(...) end,
                Canvas = {
                    setWrap = function(...) end
                }
            },
            image = {
                CompressedImageData = {
                    getWidth = function(...) return 4 end,
                    getHeight = function(...) return 5 end
                }
            }
        }
        _G._persTable = {
            upgrades = {
                godMode = 1,
                mapBreakthrough1 = 0,
                mapBreakthrough2 = 0;
            },
            phase = 1;
        }
        
        _G.levMan = {
            curLevel = nil,
            curPlayer = nil,
            curSwarmFac = nil,
            getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac end,
            getCurPlayer = function(...) return _G.levMan.curPlayer end,
            getCurLevel = function(...) return _G.levMan.curLevel end
        }

        _G.loveMock = mock(_G.love, true);
        locInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1);

        testClass.caughtThisRound = {};
        testClass.levMan = _G.levMan;
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1);
        local lb = myInstance.lowerBoarder;
        local mbb1 = myInstance.mapBreakthroughBonus1;
        local mbb2 = myInstance.mapBreakthroughBonus2;
        assert.are.same(locInstance, myInstance);
        assert.spy(loveMock.graphics.newImage).was.called_with("assets/testbg.png");
        
        _persTable.upgrades.mapBreakthrough1 = 1;
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1);
        assert.are.same( lb + mbb1, myInstance.lowerBoarder);
        
        _persTable.upgrades.mapBreakthrough2 = 1;
        local myInstance = testClass("sewers", "assets/testbg.png", { 512, 256 }, 1);
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
        assert.are.same(testClass:getYPos(), 0);
    end)

    it("Testing checkGodMode", function()
        testClass.godModeActive = 1;
        testClass.godModeFuel = 20;
        local sSGMF = spy.on(testClass, "setGodModeFuel");

        for i = 10, -20, -1
        do
            testClass.posY = i;
            testClass:checkGodMode();
        end
        assert.spy(sSGMF).was.called(20);
        assert.are.same(testClass.godModeActive, 0);
    end)

    it("Testing addToCaught", function()
        local name = "nemo";
        testClass:addToCaught(name);
        assert.are.same(testClass.caughtThisRound.nemo, 1);
    end)

    it("Testing addToCaught twice to test IF", function()
        local name = "nemo";
        testClass:addToCaught(name);
        testClass:addToCaught(name); --- now it is not nil
        assert.are.same(testClass.caughtThisRound.nemo, 2);
    end)

    it("Testing addToCaught for two diffrent ", function()
        local name1 = "nemo";
        local name2 = "hans";
        testClass:addToCaught(name1);
        testClass:addToCaught(name2);
        assert.are.same(testClass.caughtThisRound.nemo, 1);
        assert.are.same(testClass.caughtThisRound.hans, 1);
    end)

    it("Testing activateGodMode", function()
        _G._persTable.upgrades.godMode = 1;
        testClass.godModeFuel = 500;
        local sAGM = spy.on(testClass, "activateGodMode");
        testClass:activateGodMode();
        assert.spy(sAGM).was.called(1);
        assert.are.same(testClass.godModeActive, 1);

        testClass.godModeFuel = 0;
        testClass:activateGodMode();
        assert.spy(sAGM).was.called(2);
        assert.are.same(testClass.godModeActive, 0);

        _G._persTable.upgrades.godMode = 0;
        testClass.godModeFuel = 1000;
        testClass:activateGodMode();
        assert.spy(sAGM).was.called(3);
        assert.are.same(testClass.godModeActive, 0);
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
        testClass.levMan.curSwarmFac = {
            getFishableObjects = function() return {
                ["turtle"] = { ["value"] = 10 },
                ["rat"] = { ["value"] = 20 },
                ["nemo"] = { ["value"] = 10 },
                ["deadFish"] = { ["value"] = -10 }
            }
            end;
        };
        testClass.caughtThisRound = { ["turtle"] = 5, ["rat"] = 0, ["deadFish"] = 5, ["nemo"] = 3 };
        assert.are.same(testClass:calcFishedValue(), 30);
    end)

    it("Testing multiplyFishedValue", function()
        assert.are.same(testClass:multiplyFishedValue(55, 2.5), 138);
        assert.are.same(testClass:multiplyFishedValue(0, 2.5), 0);
        assert.are.same(testClass:multiplyFishedValue(-55, 2.5), -137);
    end)

    it("Testing isFinished", function()
        assert.are.same(testClass:isFinished(), 0);
        testClass.levelFinished = 1;
        assert.are.same(testClass:isFinished(), 1);
    end)

    it("Testing printResult with no objects caught", function()
        testClass.caughtThisRound = {};
        testClass:printResult();
        assert.spy(loveMock.graphics.print).was.called(2);
        assert.spy(loveMock.graphics.print).was.called_with("Caught objects in this round:", match._, match._);
        assert.spy(loveMock.graphics.print).was.called_with("Nothing caught", match._, match._);
    end)

    it("Testing printResult with caught objects", function()
        testClass.caughtThisRound["cat"] = 1;
        testClass.caughtThisRound["dog"] = 2;
        testClass.levMan.curSwarmFac = {
            getFishableObjects = function() return { ["cat"] = { ["value"] = 10 }, ["dog"] = { ["value"] = 20 } } end;
        };
        testClass:printResult();
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
        testClass.shortGMDist = 0;
        testClass.godModeActive = 0;
        testClass.oldPosY = 210;
        testClass:activateShortGM(0.12, 200);
        
        assert.are.same(testClass.godModeActive, 1);
        assert.are.same(testClass.oldPosY, _G.math.inf);
    end)

    it("Testing reduceShortGMDist", function()
        testClass.godModeActive = 0;
        testClass.godModeFuel = 250;
        testClass:activateShortGM(0.12, 200);
        local sRSGM = spy.on(testClass, "reduceShortGMDist");

        for i = 10, -250, -1
        do
            testClass.posY = i;
            testClass:checkGodMode();
        end
        assert.spy(sRSGM).was.called(161);
        assert.are.same(testClass.godModeActive, 0);
        assert.are.same(testClass.shortGMDist, 0);
        assert.are.same(testClass.oldPosY, _G.math.inf);
        assert.are.same(testClass.godModeFuel, 250);
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
end)
