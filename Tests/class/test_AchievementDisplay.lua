-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.AchievementDisplay"
fakeElement = require "Tests.fakeLoveframes.fakeElement";


describe("Unit test for AchievementDisplay.lua", function()
    local locInstance;

    before_each(function()
        _G.Loveframes = {
            Create = function(typeName) return fakeElement(typeName); end;
        };
        _G._unlockedAchievements = {};
        _G._tmpTable = {
            unlockedAchievements = nil;
        };
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

    it("Testing SetVisible function without achievements", function()
        locInstance:SetVisible(true);
        assert.are.equal(locInstance.defaultText.visible, true);
        assert.are.equal(locInstance.background.visible, true);

        locInstance:SetVisible(false);
        assert.are.equal(locInstance.defaultText.visible, false);
        assert.are.equal(locInstance.background.visible, false);
    end)

    it("Testing SetVisible function with achievements", function()
        local testTable = {
            nameOnPersTable = "test";
            name = "testname";
            description = "testdes";
            image_lock = "testpath1";
            image_unlock = "testpath2";
        };
        _G._unlockedAchievements = {
            [1] = testTable;
        };
        locInstance:SetVisible(true);
        assert.are.same(_G._unlockedAchievements[1], nil);
        assert.are.same(locInstance.unlockedAchievements[1].imagepath, "path/" .. testTable.image_unlock);
        assert.are.equal(locInstance.defaultText.visible, nil);
        assert.are.equal(locInstance.background.visible, true);

        locInstance.unlockedAchievements = {
            fakeElement("image"),
            fakeElement("image")
        };
        locInstance:SetVisible(false);
        assert.are.equal(locInstance.unlockedAchievements[1].calledRemove, true);
        assert.are.equal(locInstance.unlockedAchievements[2].calledRemove, true);
        assert.are.equal(locInstance.defaultText.visible, false);
        assert.are.equal(locInstance.background.visible, false);
    end)

    it("Testing SetPos function", function()
        locInstance:SetPos(50, 50);
        assert.are.equal(locInstance.background.x, 50)
        assert.are.equal(locInstance.background.y, 50)
        assert.are.equal(locInstance.defaultText.x, 70)
        assert.are.equal(locInstance.defaultText.y, 70)

        locInstance.unlockedAchievements = {
            fakeElement("image"),
            fakeElement("image")
        };
        locInstance:SetPos(30, 30);
        assert.are.equal(locInstance.background.x, 30)
        assert.are.equal(locInstance.background.y, 30)
        assert.are.equal(locInstance.unlockedAchievements[1].x, 50);
        assert.are.equal(locInstance.unlockedAchievements[1].y, 50);
        assert.are.equal(locInstance.unlockedAchievements[2].x, 146);
        assert.are.equal(locInstance.unlockedAchievements[2].y, 50);
    end)
end)

