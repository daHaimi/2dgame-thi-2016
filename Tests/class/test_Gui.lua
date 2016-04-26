_G.math.inf = 1 / 0

testClass = require "src.class.Gui"
--Loveframes = require "src.lib.LoveFrames";

describe("Test Gui", function()
    
    local locInstance = nil;
    
    before_each(function()
        _G.love = {};
        _G.love = {
            graphics = {
                newFont = function (...) return 12 end;
                -- love.graphics.newFont
            };
        };
        _G.loveframes.basicfont = _G.love.graphics.newFont(12);

        
        
        locInstance = testClass();
    end)
    
    it("Testing Class", function()
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)
end)
