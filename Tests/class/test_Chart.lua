-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "class.Chart";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Data = require "data";
ImageButton = require "class.ImageButton";

describe("Unit test for Chart.lua", function()
    local locInstance;
    local Element;

    before_each(function()
        _G._persTable = {
            winDim = { 480, 833 };
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
            graphics = {
                newImage = function(...) return {
                    getHeight = function (...) return 50 end;
                    getWidth = function (...) return 50 end;
                }
                end;
            }
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
        myInstance.background = "background";
        myInstance.textBackground = "text background";
        myInstance.imageButtonUP = "button up image";
        myInstance.imageButtonDOWN = "button down image";
        myInstance.mark = "mark";
        myInstance.button_up = "button_up";
        myInstance.button_down = "button_down";
        
        locInstance.background = "background";
        locInstance.textBackground = "text background";
        locInstance.imageButtonUP = "button up image";
        locInstance.imageButtonDOWN = "button down image";
        locInstance.mark = "mark";
        locInstance.button_up = "button_up";
        locInstance.button_down = "button_down";
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
        locInstance.button_up.gotClicked();
        locInstance.button_down.gotClicked();
        assert.spy(locInstance.scrollUp).was_called(1);
        assert.spy(locInstance.scrollDown).was_called(1);
    end)

    it("Testing scroll up function", function()
        locInstance.markPosition = {100, 100};
        stub(locInstance, "drawChart");
        stub(locInstance, "resetMarkedFrame");
        stub(locInstance, "markElement");

        locInstance.toprow = 0;
        locInstance:scrollUp();
        assert.are.equal(locInstance.p_toprow, 0);
        assert.spy(locInstance.resetMarkedFrame).was_not_called();
        assert.spy(locInstance.markElement).was_not_called();

        locInstance.p_toprow = 2;
        locInstance.p_markedElement = Element;
        locInstance:scrollUp();
        assert.are.equal(locInstance.p_toprow, 1);

        locInstance.markPosition = {100, 1000};
        locInstance:scrollUp();
        assert.stub(locInstance.resetMarkedFrame).was_called();
    end)

    it("Testing scroll down function", function()
        locInstance.markPosition = {100, 100};
        stub(locInstance, "drawChart");
        stub(locInstance, "resetMarkedFrame");
        stub(locInstance, "markElement");

        locInstance.p_row = 2;
        locInstance.p_toprow = 0;
        locInstance:scrollDown();
        assert.are.equal(locInstance.p_toprow, 0);

        locInstance.p_row = 4;
        locInstance.p_toprow = 0;
        locInstance.p_markedElement = Element;
        locInstance.p_markedElement.visible = true;
        locInstance:scrollDown();
        assert.are.equal(locInstance.p_toprow, 1);

        locInstance.p_row = 4;
        locInstance.p_toprow = 0;
        locInstance:scrollDown();
        assert.stub(locInstance.resetMarkedFrame).was_called();
    end)

    it("Testing resetTopRow function", function()
        locInstance.p_toprow = 5;
        locInstance:resetTopRow();
        assert.are.equal(locInstance.p_toprow, 0);
    end)

    it("Testing resetMarkedFrame function", function()
        locInstance:resetMarkedFrame();
        assert.are.equal(locInstance.markPosition[1], nil);
        assert.are.equal(locInstance.markPosition[2], nil);
    end)

    it("Testing markElement function", function()
        _G._gui = {
            frames = {
                upgradeMenu = {
                    elementsOnFrame = {
                        button_buy = {
                            setImage = function(...) end;
                        };
                    };
                };
            };
            getFrames = function(...) return _G._gui.frames; end;
            getCurrentState = function () return "Achievements" end;
        };
        spy.on(_G._gui:getFrames().upgradeMenu.elementsOnFrame.button_buy, "setImage");
        Element.nameOnPersTable = "rageQuit";
        Element.object.getPosition = function (...) return 40, 60; end
        locInstance:markElement(Element);
        assert.are.equal(locInstance.markPosition[1], 40);
        assert.are.equal(locInstance.markPosition[2], 60);
        local element = Element;
        element.price = 10;
        element.name = nil;
        locInstance:markElement(element);
        
        _G._persTable.upgrades.something = true;
        locInstance:markElement(element);
        
        element.name = "nemo";
        locInstance:markElement(element);
        
        assert.spy(_G._gui.frames.upgradeMenu.elementsOnFrame.button_buy.setImage).was_called(2);
    end)
end)
