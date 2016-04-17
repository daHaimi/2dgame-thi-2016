-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "main"

describe("Test unit test suite", function()
    local locInstance;
    local defaultDim;

    before_each(function()
        defaultDim = { 160, 90 }
        locInstance = testClass(defaultDim);
    end)

    after_each(function()
    end)

    it("Testing Constructor", function()
        local myInstance = testClass({ 160, 90 });
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass({ 200, 100 });
        assert.are_not.same(locInstance, myInstance);
    end)
end)
