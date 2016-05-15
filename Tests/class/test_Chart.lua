-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "class.Chart";
fakeImage = require "Tests.fakeLoveframes.fakeImage";


describe("Unit test for Chart.lua", function()
    local locInstance;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeImage(); end
        }
        locInstance = testClass();
    end)
    
    it("Testing Constructor", function()
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)

end)
