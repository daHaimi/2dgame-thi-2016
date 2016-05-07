-- Lua 5.1 Hack
_G.math.inf = 1 / 0
testClass = require "src.class.KlickableElement"
fakeImagebutton = require "src.lib.fakeLoveframes.fake_Imagebutton"


describe("Unit test for Textbox.lua", function()
    local locInstance;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeImagebutton(); end
        }
        locInstance = testClass("testClass", "test/path/testImage.png", "test/path/testImage_checked.png", "test discription");
    end)
    
    it("Testing Constructor", function()
        local myInstance = testClass("testClass", "test/path/testImage.png", "test/path/testImage_checked.png", "test discription");
        assert.are.same(locInstance, myInstance);
    end)
    
    it("Testing SetVisible function", function()
        local myInstance = testClass(3, 4);
        myInstance:SetVisible(true);
        assert.are.same(myInstance.object.visible, true);
    end)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end)
