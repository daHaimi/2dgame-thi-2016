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
    
end)