-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "class.Chart";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Data = require "data";

describe("Unit test for Chart.lua", function()
    local locInstance;
    local Element;

    before_each(function()
        _G.Loveframes = {
            Create = function(...) return fakeElement(); end,
        };
        _G._persTable = {
            scaledDeviceDim = { 480, 833 };
            config = {
                language = "english";
            };
            upgrades = {
                something = false;
            };
        };
        _G.data = Data;
        _G.love = {
            graphics = {
                newFont = function(...) return {}; end;
            };
        }
        Element = {
            object = {
                GetPos = function(...) return 40, 60; end;
                GetVisible = function(...) return Element.visible; end;
            };
            visible = nil;
            x = nil;
            y = nil;
            nameOnPersTable = "something";
            price = nil;
        };
        function Element:SetVisible(visible)
            self.visible = visible;
        end

        ;
        function Element:SetPos(x, y)
            self.x = x;
            self.y = y;
        end

        ;
        locInstance = testClass();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        myInstance.button_up.OnClick = { "onClick function" };
        myInstance.button_down.OnClick = { "onClick function" };
        locInstance.button_up.OnClick = { "onClick function" };
        locInstance.button_down.OnClick = { "onClick function" };
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor", function()
        _G._persTable = {
            scaledDeviceDim = { 640, 950 };
        };
        locInstance = testClass();
        local myInstance = testClass();
        myInstance.button_up.OnClick = { "onClick function" };
        myInstance.button_down.OnClick = { "onClick function" };
        locInstance.button_up.OnClick = { "onClick function" };
        locInstance.button_down.OnClick = { "onClick function" };
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor", function()
        _G._persTable = {
            scaledDeviceDim = { 720, 1024 };
        };
        locInstance = testClass();
        local myInstance = testClass();
        myInstance.button_up.OnClick = { "onClick function" };
        myInstance.button_down.OnClick = { "onClick function" };
        locInstance.button_up.OnClick = { "onClick function" };
        locInstance.button_down.OnClick = { "onClick function" };
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
        stub(locInstance, "drawChart");
        stub(locInstance, "resetMarkedFrame");
        stub(locInstance, "markElement");

        locInstance.toprow = 0;
        locInstance:scrollUp();
        assert.are.equal(locInstance.p_toprow, 0);
        assert.spy(locInstance.drawChart).was_not_called();
        assert.spy(locInstance.resetMarkedFrame).was_not_called();
        assert.spy(locInstance.markElement).was_not_called();

        locInstance.p_toprow = 2;
        locInstance.p_markedElement = Element;
        locInstance.p_markedElement.visible = true;
        locInstance:scrollUp();
        assert.are.equal(locInstance.p_toprow, 1);
        assert.stub(locInstance.drawChart).was_called(1);
        assert.stub(locInstance.markElement).was_called(1);

        locInstance.p_markedElement.visible = false;
        locInstance:scrollUp();
        assert.stub(locInstance.resetMarkedFrame).was_called(1);
    end)

    it("Testing scroll down function", function()
        stub(locInstance, "drawChart");
        stub(locInstance, "resetMarkedFrame");
        stub(locInstance, "markElement");

        locInstance.p_row = 2;
        locInstance.p_toprow = 0;
        locInstance:scrollDown();
        assert.are.equal(locInstance.p_toprow, 0);
        assert.stub(locInstance.drawChart).was_not_called();
        assert.stub(locInstance.resetMarkedFrame).was_not_called();

        locInstance.p_row = 4;
        locInstance.p_toprow = 0;
        locInstance.p_markedElement = Element;
        locInstance.p_markedElement.visible = true;
        locInstance:scrollDown();
        assert.are.equal(locInstance.p_toprow, 1);
        assert.stub(locInstance.drawChart).was_called(1);
        assert.stub(locInstance.markElement).was_called(1);

        locInstance.p_row = 4;
        locInstance.p_toprow = 0;
        locInstance.p_markedElement.visible = false;
        locInstance:scrollDown();
        assert.stub(locInstance.resetMarkedFrame).was_called(1);
    end)

    it("Testing resetTopRow function", function()
        locInstance.p_toprow = 5;
        locInstance:resetTopRow();
        assert.are.equal(locInstance.p_toprow, 0);
    end)

    it("Testing resetMarkedFrame function", function()
        locInstance:resetMarkedFrame();
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

        locInstance.p_elementsOnChart = { Element, Element };
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
        _G._gui = {
            frames = {
                upgradeMenu = {
                    elementsOnFrame = {
                        button_buy = {
                            object = {
                                SetImage = function(...) end;
                            };
                        };
                    };
                };
            };
            getFrames = function(...) return _G._gui.frames; end;
        };
        stub(_G._gui:getFrames().upgradeMenu.elementsOnFrame.button_buy.object, "SetImage");
        spy.on(locInstance.textField, "changeText");
        Element.nameOnPersTable = "rageQuit";
        _G._gui = {
            getCurrentState = function () return "Achievements" end;
        }; 
        locInstance:markElement(Element);
        assert.are.equal(locInstance.p_markFrame.x, 40);
        assert.are.equal(locInstance.p_markFrame.y, 60);
        assert.are.equal(locInstance.p_markFrame.visible, true);
        assert.are.equal(locInstance.p_markFrame.movedToTop, true);
        assert.are.same(locInstance.p_markedElement, Element);
        
        local element = Element;
        element.price = 10;
        element.name = nil;
        locInstance:markElement(element);
        
        _G._persTable.upgrades.something = true;
        locInstance:markElement(element);
        
        element.name = "nemo";
        locInstance:markElement(element);
        
        assert.spy(locInstance.textField.changeText).was_called(4);
        assert.stub(_G._gui.frames.upgradeMenu.elementsOnFrame.button_buy.object.SetImage).was_called(2);
    end)
end)
