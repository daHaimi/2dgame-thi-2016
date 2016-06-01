-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.TextField"
fakeElement = require "Tests.fakeLoveframes.fakeElement"


describe("Unit test for TextField.lua", function()
    local locInstance;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeElement(); end
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
        assert.are.equal(locInstance.objTopic.x, 60);
        assert.are.equal(locInstance.objTopic.y, 60);
        assert.are.equal(locInstance.objText.x, 60);
        assert.are.equal(locInstance.objText.y, 80);
        assert.are.equal(locInstance.objTopic.maxWidth, 3);
        assert.are.equal(locInstance.objText.maxWidth, 3);
    end)
end)
