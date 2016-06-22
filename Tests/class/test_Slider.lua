
_G.math.inf = 1 / 0

testClass = require "src.class.Slider"

describe("Unit test for Slider.lua", function()
    
    before_each(function()
        _G.love = {
            graphics = {
                draw = function(...) end;
            };
        };
        
        image = {
            getHeight = function (...) return 50; end;
            getWidth = function (...) return 50; end;
        }
        
        locInstance = testClass(image, image, 0, 0, 100);
    end)
    
    it("Testing Constructor", function()
        local myInstance = testClass(image, image, 0, 0, 100);
        assert.are.same(myInstance, locInstance);
    end)

    it("Testing getPosition", function()
        local x, y = locInstance:getPosition();
        assert.are.same(0, x);
        assert.are.same(-25, y);
    end)

    it("Testing draw", function()
        local loveMock = mock(love.graphics, true);
        locInstance:draw();
        assert.spy(loveMock.draw).was.called(1);
    end)

    it("Testing setOffset", function()
        locInstance:setOffset(4, 5);
        assert.are.same(locInstance.xOffset, 4);
        assert.are.same(locInstance.yOffset, 5);
    end)

    it("Testing getOffset", function()
        locInstance.xOffset = 10;
        locInstance.yOffset = 15;
        local x, y = locInstance:getOffset()
        assert.are.same({10, 15}, {x, y});
    end)

    it("Testing getValue", function()
        locInstance.xPosition = 10;
        assert.are.same(10, locInstance:getValue());
    end)    

    it("Testing setValue", function()
        locInstance:setValue(10);
        assert.are.same(10, locInstance.xPosition);
    end)

    it("Testing gotClicked", function()
        locInstance.moveable = false;
        locInstance:gotClicked();
        assert.are.same(true, locInstance.moveable);
    end)

    it("Testing release", function()
        locInstance.moveable = true;
        locInstance:release();
        assert.are.same(false, locInstance.moveable);
    end)

    it("Testing getMoveable", function()
        locInstance.moveable = true;
        assert.are.same(true, locInstance:getMoveable());
    end)
end)