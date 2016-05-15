-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Textbox"
fakeText = require "Tests.fakeLoveframes.fakeText"


describe("Unit test for Textbox.lua", function()
    local locInstance;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeText(); end
        }
        locInstance = testClass(3, 4);
    end)
    
    
    it("Testing Constructor", function()
        local myInstance = testClass(3, 4);
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing changeText function", function()
        locInstance:changeText("test topic", "test text");
        assert.are.equal(locInstance.objTopic.text, "test topic");
        assert.are.equal(locInstance.objText.text, "test text");
    end)

    it("Testing SetVisible function", function()
        locInstance:SetVisible(true);
        assert.are.equal(locInstance.objTopic.visible, true);
        assert.are.equal(locInstance.objText.visible, true);
    end)

    it("Testing SetPos function", function()
        locInstance:SetPos(50, 50);
        assert.are.same(locInstance.objTopic.position, {xPos = 55, yPos = 55});
        assert.are.same(locInstance.objText.position, {xPos = 55, yPos = 75});
        assert.are.equal(locInstance.objTopic.maxWidth, 3);
        assert.are.equal(locInstance.objText.maxWidth, 3);
    end)
end)
