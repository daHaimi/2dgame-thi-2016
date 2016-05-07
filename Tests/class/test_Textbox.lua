-- Lua 5.1 Hack
_G.math.inf = 1 / 0
testClass = require "src.class.Textbox"
fakeText = require "src.lib.fakeLoveframes.fake_Text"


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
        local myInstance = testClass(3, 4);
        myInstance:changeText("test topic", "test text");
        assert.are.same(myInstance.objTopic.text, "test topic");
        assert.are.same(myInstance.objText.text, "test text");
    end)

    it("Testing SetVisible function", function()
        local myInstance = testClass(3, 4);
        myInstance:SetVisible(true);
        assert.are.same(myInstance.objTopic.visible, true);
        assert.are.same(myInstance.objText.visible, true);
    end)

    it("Testing SetPos function", function()
        local myInstance = testClass(3, 4);
        myInstance:SetPos(50, 50);
        assert.are.same(myInstance.objTopic.xPos, 55);
        assert.are.same(myInstance.objTopic.yPos, 55);
        assert.are.same(myInstance.objText.xPos, 55);
        assert.are.same(myInstance.objText.yPos, 75);
        assert.are.same(myInstance.objTopic.maxWidth, 3);
        assert.are.same(myInstance.objText.maxWidth, 3);
    end)

end)
