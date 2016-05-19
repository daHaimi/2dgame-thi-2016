-- Lua 5.1 Hack
_G.math.inf = 1 / 0;

testClass = require "src.class.KlickableElement";
fakeElement = require "Tests.fakeLoveframes.fakeElement";


describe("Unit test for KlickableElement.lua", function()
    local locInstance;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeElement(); end
        }
        locInstance = testClass("testClass", "test/path/testImage.png", "test/path/testImage_disable.png", "test discription");
    end)
    
    it("Testing Constructor", function()
        local myInstance = testClass("testClass", "test/path/testImage.png", "test/path/testImage_disable.png", "test discription");
        assert.are.same(locInstance, myInstance);
    end)
    
    it("Testing SetVisible function", function()
        locInstance:SetVisible(true);
        assert.are.same(locInstance.object.visible, true);
    end)

    it("Testing check function", function()
        locInstance:disable();
        assert.are.equal(locInstance.enable, false);
        assert.are.equal(locInstance.object.imagepath, "test/path/testImage_disable.png");
    end)

    it("Testing SetPos function", function()
        locInstance:SetPos(5, 5);
        assert.are.equal(locInstance.object.x, 5);
        assert.are.equal(locInstance.object.y, 5);
    end)

    it("Testing getEnable function", function()
        locInstance.enable = false;
        assert.are.equal(locInstance:getEnable(), false);
    end)

end)
