-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.AchievementDisplay"
fakeElement = require "Tests.fakeLoveframes.fakeElement";


describe("Unit test for AchievementDisplay.lua", function()
    local locInstance;
    
    before_each(function()
        --_persTable.upgrades.moreLife = 1;
        _G.Loveframes = {
            Create = function(typeName) return fakeElement(typeName); end
        }
        _G.testUnlockedAchievements = {};
        _G._tmptable = {
            unlockedAchievements = {};
        }
        
        locInstance = testClass("path/");
    end)


    it("Testing Constructor", function()
        local myInstance = testClass("path/");
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing create function", function()
        locInstance:create();
        assert.are.equal(locInstance.background.type, "image");
        assert.are.equal(locInstance.background.imagepath, "path/AchievementDisplayBG.png");
        assert.are.equal(locInstance.defaultText.type, "text");
        assert.are.equal(locInstance.defaultText.text, "No unlocked achievements this round");
    end)
--[[
    it("Testing SetVisible function", function()
        locInstance:SetVisible(true);
        assert.are.same(locInstance.unlockedAchievements, {});
        assert.are.equal(locInstance.defaultText.visible, true);
        assert.are.equal(locInstance.background.visible, true);
        
        locInstance:SetVisible(false);
        assert.are.equal(locInstance.defaultText.visible, false);
        assert.are.equal(locInstance.background.visible, false);
    end)


_G.testUnlockedAchievements = {
                testAchievement = {
                    nameOnPersTable = "test";
                    name = "testname";
                    description = "testdes";
                    image_lock = "testpath1";
                    image_unlock = "testpath2";
                }
        };
]]---

    it("Testing SetPos function", function()
        locInstance:SetPos(50, 50);
        assert.are.equal(locInstance.background.x, 50)
        assert.are.equal(locInstance.background.y, 50)
        assert.are.equal(locInstance.defaultText.x, 70)
        assert.are.equal(locInstance.defaultText.y, 70)
        end)
    
end)

