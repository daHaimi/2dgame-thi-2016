-- Lua 5.1 Hack
_G.math.inf = 1/0

testClass = require "main"

describe("Unit test for main.lua", function()
    it("Example unit test", function()
      assert.truthy("Yup.")
    end)
end)

