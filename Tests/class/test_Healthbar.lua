-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Healthbar"
fakeElement = require "Tests.fakeLoveframes.fakeElement";


describe("Unit test for Healthbar.lua", function()
    local locInstance;

    before_each(function()
        --_persTable.upgrades.moreLife = 1;
         _G.love = {
            mouse = {
                setVisible = function(...) end;
            };
            graphics = {
                newImage = function(...) return {
                    getHeight = function (...) return 50 end;
                    getWidth = function (...) return 50 end;
                }
                end;
            }
        };
        _G._persTable = {
            winDim = {
                [1] = 480;
                [2] = 900;
            };
            upgrades = {
                moreLife = 1;
            };
        };
        locInstance = testClass();
    end)


    it("Testing Constructor", function()
        local myInstance1 = testClass();
        local myInstance2 = testClass();
        assert.are.same(myInstance1.currentHearts, myInstance2.currentHearts);
        assert.are.same(myInstance1.unlockedHearts, myInstance2.unlockedHearts);
        assert.are.same(myInstance1.xOffset, myInstance2.xOffset);
        assert.are.same(myInstance1.yOffset, myInstance2.yOffset);
        assert.are.same(myInstance1.xPosition, myInstance2.xPosition);
        assert.are.same(myInstance1.yPosition, myInstance2.yPosition);
    end)

    it("Testing SetPos function", function()
        locInstance:setPos();
        locInstance.unlockedHearts = 2;
        assert.are.equal(locInstance.xPosition, 346);
    end)

    it("Testing minus function", function()
        locInstance.currentHearts = 0;
        locInstance:minus();
        assert.are.same(locInstance.currentHearts, 0);
    end)

    it("Testing minus function", function()
        locInstance.currentHearts = 3;
        locInstance:minus();
        assert.are.same(locInstance.currentHearts, 2);
    end)

    it("Testing resetHearts function", function()
        _G._persTable.upgrades.moreLife = 2;

        locInstance.unlockedHearts = 0;
        locInstance:resetHearts();
        assert.are.equal(3, locInstance.unlockedHearts);
    end)
end)
