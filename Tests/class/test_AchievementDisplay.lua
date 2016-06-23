-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.AchievementDisplay"
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Data = require "data";

describe("Unit test for AchievementDisplay.lua", function()
    local locInstance;

    before_each(function()
         _G.love = {
            mouse = {
                setVisible = function(...) end;
            };
            graphics = {
                draw = function (...) end;
                printf = function(...) end;
                newFont = function(...) end;
                setFont = function (...) end;
                newImage = function(...) return {
                    getHeight = function (...) return 50 end;
                    getWidth = function (...) return 50 end;
                }
                end;
            }
        };
        _G.data = Data;
        _G._unlockedAchievements = {};
        _G._tmpTable = {
            unlockedAchievements = nil;
        };
        locInstance = testClass();
    end)


    it("Testing Constructor", function()
        local myInstance = testClass();
        
        locInstance.background = "background";
        
        myInstance.background = "background";
        
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing setPosition function", function()
        locInstance:setPosition(50, 50);
        assert.are.equal(locInstance.position[1], 50);
        assert.are.equal(locInstance.position[2], 50);
    end)

    it("Testing getPosition function", function()
        locInstance.position = {50, 50};
        local x, y =locInstance:getPosition();
        assert.are.same(50, x);
        assert.are.same(50, y);
    end)

    it("Testing setOffset function", function()
        locInstance:setOffset(50, 50);
        assert.are.equal(locInstance.xOffset, 50);
        assert.are.equal(locInstance.yOffset, 50);
    end)

    it("Testing draw", function()
        local loveMock = mock(love.graphics, true);
        _G._unlockedAchievements = {};
        locInstance:draw();
        assert.spy(loveMock.printf).was_called(1);
    end)

    it("Testing draw", function()
        local loveMock = mock(love.graphics.printf, true);
        local testAchievement = {image = "test", image_unlock = "test"};
        _G._unlockedAchievements = {testAchievement, testAchievement};
        locInstance:draw();
        assert.spy(loveMock).was_called(0);
    end);
end)

