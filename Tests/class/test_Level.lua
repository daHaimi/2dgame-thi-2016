-- Lua 5.1 Hack
_G.math.inf = 1/0

testClass = require "src.class.Level"

describe("Test unit test suite", function()
    local locInstance;
    
    before_each(function()
        _G.love = {
            graphics = {
                newImage = function(...) end,
                newQuad = function(...) end,
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
                godMode = 1
            }
        }
        
        loveMock = mock(_G.love, true);
        locInstance = testClass("assets/testbg.png", {512, 256}, 1);
    end)
        
    it("Testing Constructor", function()
        local myInstance = testClass("assets/testbg.png", {512, 256}, 1);
        assert.are.same(locInstance, myInstance);
        assert.spy(loveMock.graphics.newImage).was.called_with("assets/testbg.png");
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
end)