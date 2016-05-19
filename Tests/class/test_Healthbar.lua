-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Healthbar"
fakeElement = require "Tests.fakeLoveframes.fakeElement";


describe("Unit test for Healthbar.lua", function()
    local locInstance;
    
    before_each(function()
        --_persTable.upgrades.moreLife = 1;
        _G.Loveframes = {
            Create = function(...) return fakeElement(); end
        }
        
        _G._persTable = {
            winDim = {
                [1] = 500;
                [2] = 900;
            };
            upgrades = {
                moreLife = 1;
            };
            
        };
        locInstance = testClass("path1", "path2", "path3");
        --locInstance:refreshAfterBuy();
    end)


    it("Testing Constructor", function()
        local myInstance = testClass("path1", "path2", "path3");
        --locInstance:refreshAfterBuy();
        assert.are.same(locInstance, myInstance);
    end)
--[[
    it("Testing buyExtraLife function", function()
        spy.on(locInstance, "refresh");
        --locInstance:buyExtraLife();
        assert.are.equal(locInstance.unlockedHearts, 2);
        assert.are.equal(locInstance.currentHearts, 2);
        --image in that table is a red heart
        assert.are.equal(locInstance.hearts[1].imagepath, "path3");
        assert.are.equal(locInstance.hearts[2].imagepath, "path3");
        assert.spy(locInstance.refresh).was_called(1);
    end)
]]--
    it("Testing scaleHearts function", function()
        --locInstance:buyExtraLife();
        locInstance:scaleHearts();
        assert.are.equal(locInstance.hearts[1].xScale, 0.5);
        assert.are.equal(locInstance.hearts[1].yScale, 0.5);
        assert.are.equal(locInstance.hearts[2].xScale, 0.5);
        assert.are.equal(locInstance.hearts[2].yScale, 0.5);
    end)
    
    it("Testing SetVisible function", function()
        --locInstance:buyExtraLife();
        locInstance:SetVisible(true);
        assert.are.equal(locInstance.basic.visible, true);
        assert.are.equal(locInstance.hearts[1].visible, true);
        assert.are.equal(locInstance.hearts[2].visible, true);
        assert.are.equal(locInstance.icon.visible, true);
    end)
    
    it("Testing SetPos function", function()
        --locInstance:buyExtraLife();
        locInstance:refresh();
        locInstance:SetPos(5, 5);
        assert.are.equal(locInstance.basic.xPos, 5);
        assert.are.equal(locInstance.basic.yPos, 5);
        assert.are.equal(locInstance.hearts[1].x, 468);
        assert.are.equal(locInstance.hearts[1].y, 16);
        assert.are.equal(locInstance.hearts[2].x, 436);
        assert.are.equal(locInstance.hearts[2].y, 16);
        assert.are.equal(locInstance.icon.x, 372);
        assert.are.equal(locInstance.icon.y, 0);
    end)

    it("Testing refresh function", function()
        spy.on(locInstance, "scaleHearts");
        spy.on(locInstance, "SetVisible");
        spy.on(locInstance, "SetPos");
        locInstance:refresh();
        assert.spy(locInstance.scaleHearts).was_called(1);
        assert.spy(locInstance.SetVisible).was_called(1);
        assert.spy(locInstance.SetPos).was_called(1);
    end)

    it("Testing minus function", function()
        spy.on(locInstance, "refresh");
        locInstance.currentHearts = 0;
        locInstance:minus();
        assert.spy(locInstance.refresh).was_not_called();
    end)

    it("Testing minus function", function()
        --locInstance:buyExtraLife();
        assert.are.equal(locInstance.currentHearts, 2);
        locInstance:minus();
        assert.are.equal(locInstance.hearts[2].imagepath, "path2");
        assert.spy(locInstance.refresh).was_called();
    end)
    
    it("Testing reset function", function()
        spy.on(locInstance, "refresh");
        
        locInstance:reset();
        assert.are.equal(locInstance.currentHearts, 2);
        --assert.are.equal(locInstance.hearts[2].imagepath, "path3");
        assert.spy(locInstance.refresh).was_called();
    end)
    
end)
