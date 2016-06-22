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
        assert.are.equal(locInstance.position[1], 50)
        assert.are.equal(locInstance.position[2], 50)
    end)
end)

