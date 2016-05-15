-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Healthbar"
fakeImage = require "Tests.fakeLoveframes.fakeImage";


describe("Unit test for Healthbar.lua", function()
    local locInstance;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeImage(); end
        }
        
        _G._persTable = {
            winDim = {
                [1] = 500;
                [2] = 900};
        };
        
        locInstance = testClass("path1", "path2", "path3");
    end)


    it("Testing Constructor", function()
        local myInstance = testClass("path1", "path2", "path3");
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing buyExtraLife function", function()
        locInstance:buyExtraLife();
        assert.are.equal(locInstance.unlockedHearts, 2);
        assert.are.equal(locInstance.currentHearts, 2);
        --image in that table is a red heart
        assert.are.equal(locInstance.hearts[1].imagepath, "path3");
        assert.are.equal(locInstance.hearts[2].imagepath, "path3");
    end)

    it("Testing scaleHearts function", function()
        locInstance:buyExtraLife();
        locInstance:scaleHearts();
        assert.are.same(locInstance.hearts[1].scale, {xScale = 0.5, yScale = 0.5});
        assert.are.same(locInstance.hearts[2].scale, {xScale = 0.5, yScale = 0.5});
    end)
    
    it("Testing SetVisible function", function()
        locInstance:buyExtraLife();
        locInstance:SetVisible(true);
        assert.are.equal(locInstance.basic.visible, true);
        assert.are.equal(locInstance.hearts[1].visible, true);
        assert.are.equal(locInstance.hearts[2].visible, true);
        assert.are.equal(locInstance.icon.visible, true);
    end)
    
    it("Testing SetPos function", function()
        locInstance:buyExtraLife();
        locInstance:SetPos(5, 5);
        assert.are.equal(locInstance.basic.xPos, 5);
        assert.are.equal(locInstance.basic.yPos, 5);
        assert.are.same(locInstance.hearts[1].position, {xPos = 468, yPos = 16});
        assert.are.same(locInstance.hearts[2].position, {xPos = 436, yPos = 16});
        assert.are.same(locInstance.icon.position, {xPos = 372, yPos = 0});
    end)

    it("Testing minus function", function()

    end)


end)
