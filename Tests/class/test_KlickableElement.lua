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
        _G._persTable = {
            scaledDeviceDim = {480, 833};
        };
        locInstance = testClass("testClass", "test/path/testImage.png", "test/path/testImage_disable.png", "test discription", 0, "testName");
    end)
    
    it("Testing Constructor", function()
        local myInstance = testClass("testClass", "test/path/testImage.png", "test/path/testImage_disable.png", "test discription", 0, "testName");
        assert.are.same(locInstance, myInstance);
    end)
    
    it("Testing SetVisible function", function()
        locInstance:SetVisible(true);
        assert.are.same(locInstance.object.visible, true);
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

    it("Testing reset function", function()
        stub(locInstance.object, "SetImage");
        locInstance:reset();
        assert.are.equal(locInstance.enable, true);
        assert.stub(locInstance.object.SetImage).was.called();
    end)

    it("Testing disable function", function()
        stub(locInstance.object, "SetImage");
        _G._persTable = {
            upgrades = {
                [locInstance.nameOnPersTable] = 0;
            }
        }
        locInstance:disable();
        assert.are.equal(locInstance.enable, false);
        assert.stub(locInstance.object.SetImage).was.called();
        assert.are.equal(_G._persTable.upgrades[locInstance.nameOnPersTable], 1);
    end)
end)
