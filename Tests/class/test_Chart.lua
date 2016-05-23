-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "class.Chart";
fakeElement = require "Tests.fakeLoveframes.fakeElement";

describe("Unit test for Chart.lua", function()
    local locInstance;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeElement(); end,
        }
        locInstance = testClass();
    end)
    
    it("Testing Constructor", function()
        local myInstance = testClass();
        myInstance.button_up.OnClick = {"onClick function"};
        myInstance.button_down.OnClick = {"onClick function"};
        locInstance.button_up.OnClick = {"onClick function"};
        locInstance.button_down.OnClick = {"onClick function"};
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing OnClick function of the up and down button", function()        
        spy.on(locInstance, "scrollUp");
        spy.on(locInstance, "scrollDown");
        locInstance.button_up.OnClick();
        locInstance.button_down.OnClick();
        assert.spy(locInstance.scrollUp).was_called(1);
        assert.spy(locInstance.scrollDown).was_called(1);
    end)

    it("Testing scroll up function", function()
        local a = spy.on(locInstance, "drawChart");
        local b = spy.on(locInstance, "resetMarkedFrame");
        
        locInstance.toprow = 0;
        locInstance:scrollUp();
        assert.are.equal(locInstance.toprow, 0);
        assert.spy(locInstance.drawChart).was_not_called();
        assert.spy(locInstance.resetMarkedFrame).was_not_called();
        
        locInstance.toprow = 2;
        locInstance:scrollUp();
        assert.are.equal(locInstance.toprow, 1);
        assert.spy(locInstance.drawChart).was_called(1);
        assert.spy(locInstance.resetMarkedFrame).was_called(1);
    end)

    it("Testing scroll down function", function()
        local a = spy.on(locInstance, "drawChart");
        local b = spy.on(locInstance, "resetMarkedFrame");
        
        locInstance.row = 2
        locInstance.toprow = 0;
        locInstance:scrollDown();
        assert.are.equal(locInstance.toprow, 0);
        assert.spy(locInstance.drawChart).was_not_called();
        assert.spy(locInstance.resetMarkedFrame).was_not_called();
        
        locInstance.row = 4
        locInstance.toprow = 0;
        locInstance:scrollDown();
        assert.are.equal(locInstance.toprow, 1);
        assert.spy(locInstance.drawChart).was_called(1);
        assert.spy(locInstance.resetMarkedFrame).was_called(1);
    end)
    
    it("Testing resetTopRow function", function()
        locInstance.toprow = 5;
        locInstance:resetTopRow();
        assert.are.equal(locInstance.toprow, 0);
    end)

    it("Testing resetMarkedFrame function", function()
        locInstance:resetMarkedFrame()
        assert.are.equal(locInstance.markFrame.visible, false);
    end)
--[[
    it("Testing addKlickableElement function", function()
        
        table = {
            insert = function(...) end
            --getn = function(...) return 33; end
        }
    end)

    it("Testing drawChart function", function()
        local testElement = {
            visible = nil;
        }
        function testElement:SetVisible(visible)
            self.visible = visible;
        end
        
        locInstance.elementsOnChart = {}--{testElement, testElement, testElement};
        locInstance.drawChart(true);
        assert.are.equal(locInstance.elementsOnChart[1].visible, true);
        
    end)
]]--
        
        
end)
