-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Bait"

describe("Unit test for Bait.lua", function()
    local locInstance = nil;
    --- possible Window size
    local locWinDim = {400, 800}; 
    
    
    before_each(function()
        locInstance = testClass(locWinDim);
    end)
    
     it("Testing Constructor", function()
        local myInstance = testClass(locWinDim);
        assert.are.same(locInstance, myInstance);
    end)


    
end)