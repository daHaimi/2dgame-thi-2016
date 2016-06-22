
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
end)