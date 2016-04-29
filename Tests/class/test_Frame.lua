-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Frame"

describe("Unit test for Frame.lua", function()
    local locInstance;
    local locElements = {};
    
    before_each(function()
        locInstance = testClass("TestFrame");
        local Element = {
            visible = true;
            xPos = 0;
            yPos = 0;
        };
        locElements = {
            Element,
            Element,
            Element,
            Element
        }
        function Element:SetVisible(bool)
            self.visible = bool;
        end
        function Element:SetPos(x, y)
            self.xPos = x;
            self.yPos = y;
        end
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("TestFrame");
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing addElement function", function()
        local myInstance = testClass("TestFrame");
        local newElement = {};
        --add all Elements from locElements to Instances
        for k, v in ipairs (locElements) do
            myInstance:addElement(v, 10 * k, 10);
            locInstance:addElement(v, 10 * k, 10);
        end
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing getElements function", function()
        local myInstance = testClass("TestFrame");
        --add all Elements from locElements to Instances
        for k, v in ipairs (locElements) do
            myInstance:addElement(v, 10 * k, 10);
        end
        assert.are.same(locElements, myInstance:getElements());
    end)

    it("Testing setPosition function/ xPosFrame", function()
        local myInstance = testClass("TestFrame");
        myInstance:setPosition(5, 10);
        assert.are.equal(myInstance.xPosFrame, 5);
    end)

    it("Testing setPosition function/ yPosFrame", function()
        local myInstance = testClass("TestFrame");
        myInstance:setPosition(5, 10);
        assert.are.equal(myInstance.yPosFrame, 10);
    end)

    it("Testing setOffset function/ xOffset", function()
        local myInstance = testClass("TestFrame");
        myInstance:setOffset(5, 10);
        assert.are.equal(myInstance.xOffset, 5);
    end)

    it("Testing setOffset function/ yOffset", function()
        local myInstance = testClass("TestFrame");
        myInstance:setOffset(5, 10);
        assert.are.equal(myInstance.yOffset, 10);
    end)

    it("Testing onPosition function/ false", function()
        local myInstance = testClass("TestFrame");
        myInstance:setOffset(10, 10);
        assert.are.equal(myInstance:onPosition(), false);
    end)

    it("Testing onPosition function/ true", function()
        local myInstance = testClass("TestFrame");
        myInstance:setOffset(0, 0);
        assert.are.equal(myInstance:onPosition(), true);
    end)
        
    it("Testing move function/ up", function()
        local myInstance = testClass("TestFrame");
        myInstance:setOffset(100, 100);
        myInstance:move("up");
        assert.are.equal(myInstance.yOffset, (100 - myInstance.moveSpeed));
    end)

    it("Testing move function/ down", function()
        local myInstance = testClass("TestFrame");
        myInstance:setOffset(100, 100);
        myInstance:move("down");
        assert.are.equal(myInstance.yOffset, (100 + myInstance.moveSpeed));
    end)

    it("Testing move function/ right", function()
        local myInstance = testClass("TestFrame");
        myInstance:setOffset(100, 100);
        myInstance:move("right");
        assert.are.equal(myInstance.xOffset, (100 + myInstance.moveSpeed));
    end)

    it("Testing move function/ left", function()
        local myInstance = testClass("TestFrame");
        myInstance:setOffset(100, 100);
        myInstance:move("left");
        assert.are.equal(myInstance.xOffset, (100 - myInstance.moveSpeed));
    end)

    it("Testing clearFrame function", function()
        local myInstance = testClass("TestFrame");
        local TestElements;
        local result = {};
        local expectedResult = {false, false, false, false};
        for k, v in ipairs (locElements) do
            myInstance:addElement(v, 10 * k, 10);
        end
        myInstance:clearFrame();
        TestElements = myInstance:getElements();
        for k, v in ipairs (TestElements) do
            result[k] = v.visible;
        end
        assert.are.same(result, expectedResult);
    end)

    it("Testing showFrame function/ Visible", function()
        local myInstance = testClass("TestFrame");
        local TestElements
        local result = {}
        local expectedResult = {true, true, true, true}
        for k, v in ipairs (locElements) do
            myInstance:addElement(v, 10 * k, 10);
        end
        myInstance:showFrame();
        TestElements = myInstance:getElements();
        for k, v in ipairs (TestElements) do
            result[k] = v.visible;
        end
        assert.are.same(result, expectedResult);
    end)
    
    it("Testing showFrame function/ xPos", function()
        local myInstance = testClass("TestFrame");
        local result = {}
        local expectedResult = {10, 20, 30, 40};
        
        for k, v in ipairs (locElements) do
            myInstance:addElement(v, 10 * k, 10);
        end
        myInstance:showFrame();
        assert.are.same(myInstance.elementPosition.xPos, expectedResult);
    end)

    it("Testing showFrame function/ yPos", function()
        local myInstance = testClass("TestFrame");
        local result = {}
        local expectedResult = {10, 20, 30, 40};

        for k, v in ipairs (locElements) do
            myInstance:addElement(v, 10, 10 * k);
        end
        myInstance:showFrame();
        assert.are.same(myInstance.elementPosition.yPos, expectedResult);
    end)

    it("Testing setBackground function", function()
        local myInstance = testClass("TestFrame");
        local Bg = {};
        myInstance:setBackground(Bg);
        assert.are.same(myInstance.background, Bg);
    end)

    
end)