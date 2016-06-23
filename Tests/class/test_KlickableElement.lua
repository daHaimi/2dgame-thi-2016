-- Lua 5.1 Hack
_G.math.inf = 1 / 0;

testClass = require "src.class.KlickableElement";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
ImageButton = require "src.class.ImageButton";


describe("Unit test for KlickableElement.lua", function()
    local locInstance;

    before_each(function()
        _G.love = {
            graphics = {
                newFont = function(...) end;
            };
            graphics = {
                newImage = function(...) return {
                    getHeight = function (...) return 50 end;
                    getWidth = function (...) return 50 end;
                }
                end;
            }
        }
        _G._persTable = {
            scaledDeviceDim = { 480, 833 };
        };
        
        _G.image = {
            getHeight = function (...) return 50 end;
            getWidth = function (...) return 50 end;
        };

        locInstance = testClass("testClass", _G.image, _G.image, "test discription", 0, "testName");
    end)

    it("Testing Constructor", function()
        local myInstance1 = testClass("testClass", _G.image, _G.image, "test discription", 0, "testName");
        local myInstance2 = testClass("testClass", _G.image, _G.image, "test discription", 0, "testName");
        assert.are.same(myInstance1.description, myInstance2.description);
        assert.are.same(myInstance1.enable, myInstance2.enable);
        assert.are.same(myInstance1.name, myInstance2.name);
        assert.are.same(myInstance1.nameOnPersTable, myInstance2.nameOnPersTable);
        assert.are.same(myInstance1.price, myInstance2.price);
        assert.are.same(myInstance1.xOffset, myInstance2.xOffset);
        assert.are.same(myInstance1.yOffset, myInstance2.yOffset);
    end)

    it("Testing SetPos function", function()
        locInstance:setPos(5, 5);
        assert.are.equal(locInstance.object.xPosition, 5);
        assert.are.equal(locInstance.object.yPosition, 5);
    end)

    it("Testing getEnable function", function()
        locInstance.enable = false;
        assert.are.equal(locInstance:getEnable(), false);
    end)

    it("Testing reset function", function()
        locInstance:reset();
        assert.are.equal(locInstance.enable, true);
    end)

    it("Testing disable function", function()
        _G._persTable = {
            upgrades = {
                [locInstance.nameOnPersTable] = 0;
            };
        };
        locInstance:disable();
        assert.are.equal(locInstance.enable, false);
        assert.are.equal(_G._persTable.upgrades[locInstance.nameOnPersTable], true);
    end)
end)
