-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "class.Chart";
fakeElement = require "Tests.fakeLoveframes.fakeElement";

describe("Unit test for Chart.lua", function()
    local locInstance;
    local Element;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeElement(); end,
        }
        _G._persTable = {
            scaledDeviceDim = {480, 833};
        };
        
        Element = {
            object = {
                GetPos = function(...) return 40, 60; end;};
            visible = nil;
            x = nil;
            y = nil;
        };
        function Element:SetVisible(visible) 
            self.visible = visible; 
        end;
        function Element:SetPos(x, y) 
            self.x = x; 
            self.y = y; 
        end;
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

    it("Testing getAllElements function", function()
        locInstance.p_elementsOnChart = "test";
        assert.are.equal(locInstance:getAllElements(), "test");
    end)

    it("Testing getMarkedElement function", function()
        locInstance.p_markedElement = "test";
        assert.are.equal(locInstance:getMarkedElement(), "test");
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
        assert.are.equal(locInstance.p_toprow, 0);
        assert.spy(locInstance.drawChart).was_not_called();
        assert.spy(locInstance.resetMarkedFrame).was_not_called();
        
        locInstance.p_toprow = 2;
        locInstance:scrollUp();
        assert.are.equal(locInstance.p_toprow, 1);
        assert.spy(locInstance.drawChart).was_called(1);
        assert.spy(locInstance.resetMarkedFrame).was_called(1);
    end)

    it("Testing scroll down function", function()
        local a = spy.on(locInstance, "drawChart");
        local b = spy.on(locInstance, "resetMarkedFrame");
        
        locInstance.p_row = 2
        locInstance.p_toprow = 0;
        locInstance:scrollDown();
        assert.are.equal(locInstance.p_toprow, 0);
        assert.spy(locInstance.drawChart).was_not_called();
        assert.spy(locInstance.resetMarkedFrame).was_not_called();
        
        locInstance.p_row = 4
        locInstance.p_toprow = 0;
        locInstance:scrollDown();
        assert.are.equal(locInstance.p_toprow, 1);
        assert.spy(locInstance.drawChart).was_called(1);
        assert.spy(locInstance.resetMarkedFrame).was_called(1);
    end)
    
    it("Testing resetTopRow function", function()
        locInstance.p_toprow = 5;
        locInstance:resetTopRow();
        assert.are.equal(locInstance.p_toprow, 0);
    end)

    it("Testing resetMarkedFrame function", function()
        locInstance:resetMarkedFrame()
        assert.are.equal(locInstance.p_markFrame.visible, false);
    end)

    it("Testing SetVisible function", function()
        spy.on(locInstance, "drawChart");
        locInstance:SetVisible(true);
        assert.are.equal(locInstance.button_up.visible, true);
        assert.are.equal(locInstance.button_down.visible, true);
        assert.are.equal(locInstance.textField.objBackground.visible, true);
        assert.are.equal(locInstance.textField.objPrice.visible, true);
        assert.are.equal(locInstance.textField.objText.visible, true);
        assert.are.equal(locInstance.textField.objTopic.visible, true);
        assert.spy(locInstance.drawChart).was.called();
        assert.are.equal(locInstance.p_markFrame.visible, false);
        
        locInstance.p_elementsOnChart = {Element, Element};
        locInstance:SetVisible(false);
        assert.are.equal(locInstance.button_up.visible, false);
        assert.are.equal(locInstance.button_down.visible, false);
        assert.are.equal(locInstance.textField.objBackground.visible, false);
        assert.are.equal(locInstance.textField.objText.visible, false);
        assert.are.equal(locInstance.textField.objTopic.visible, false);
        assert.are.equal(locInstance.textField.objPrice.visible, false);
        assert.are.equal(locInstance.p_elementsOnChart[1].visible, false);
        assert.are.equal(locInstance.p_elementsOnChart[2].visible, false);
        assert.are.equal(locInstance.p_markFrame.visible, false);
    end)

    it("Testing SetPos function", function()
        locInstance.width = 50;
        locInstance.klickableSize = 60;
        spy.on(locInstance, "setPosOfKlickableElements");
        
        locInstance:SetPos(50, 50);
        assert.are.equal(locInstance.p_xPos, 150);
        assert.are.equal(locInstance.p_yPos, 50);
        assert.are.equal(locInstance.button_up.x, 223);
        assert.are.equal(locInstance.button_up.y, 50);
        assert.are.equal(locInstance.button_down.x, 223);
        assert.are.equal(locInstance.button_down.y, 140);
        assert.spy(locInstance.setPosOfKlickableElements).was.called();
        assert.are.equal(locInstance.textField.objBackground.x, 50);
        assert.are.equal(locInstance.textField.objBackground.y, 503);
    end)

    it("Testing markElement function", function()
        spy.on(locInstance.textField, "changeText");
        
        locInstance:markElement(Element);
        assert.are.equal(locInstance.p_markFrame.x, 40);
        assert.are.equal(locInstance.p_markFrame.y, 60);
        assert.are.equal(locInstance.p_markFrame.visible, true);
        assert.are.equal(locInstance.p_markFrame.movedToTop, true);
        assert.are.same(locInstance.p_markedElement, Element);
        
        assert.spy(locInstance.textField.changeText).was_called();
    end)

--[[
    it("Testing drawChart function", function()
        locInstance.p_column = 3;
        locInstance.p_toprow = 0;
        for var = 1, 12 do
            locInstance.p_elementsOnChart[var] = Element;
        end
        locInstance:drawChart()
        for var = 1, 12 do
            assert.are.equal(locInstance.p_elementsOnChart[var].visible, true);
        end
        assert.are.equal(locInstance.p_elementsOnChart[12].visible, false);
    end)
    

    it("Testing setPosOfKlickableElements function", function()
        for var = 1, 4 do
            locInstance.p_elementsOnChart[var] = Element;
        end
        locInstance.p_xPos = 5;
        locInstance.p_yPos = 5;
        locInstance.p_toprow = 0;
        locInstance.klickableSize = 90;
        locInstance.p_column = 3;
        locInstance.buttonHeight = 50;
        locInstance:setPosOfKlickableElements();
        --assert.are.equal(locInstance.p_elementsOnChart[1].x, 5);
        --assert.are.equal(locInstance.p_elementsOnChart[1].y, 1);
        --assert.are.equal(locInstance.p_elementsOnChart[2].x, 5);
        --assert.are.equal(locInstance.p_elementsOnChart[2].y, 1);
        --assert.are.equal(locInstance.p_elementsOnChart[3].x, 5);
        --assert.are.equal(locInstance.p_elementsOnChart[3].y, 1);
        --assert.are.equal(locInstance.p_elementsOnChart[4].x, 5);
        --assert.are.equal(locInstance.p_elementsOnChart[4].y, 1);
    end)
]]--
end)
