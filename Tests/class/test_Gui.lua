_G.math.inf = 1 / 0

testClass = require "src.class.Gui"


describe("Test Gui", function()
    
    local locInstance = nil;
    
    before_each(function()
        --_G.love = {};
        Loveframes = {
            Create = function (...) end;
        };
       
        locInstance = testClass();
    end)
    
    it("Testing Class", function()
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)
end)
