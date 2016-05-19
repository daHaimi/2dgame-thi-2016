-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Frame"

describe("Unit test for Frame.lua", function()
    local locInstance;
    local locElements = {};

    before_each(function()
        locInstance = testClass(50, 50, "down", "down", 50, 0, -1000);
        local Element = {
            object = {
                visible = nil;
                xPos = nil;
                yPos = nil;
            };
            x = nil;
            y = nil;
        };
        function Element.object:SetVisible(visible)
            self.visible = visible;
        end

        function Element.object:SetPos(x, y)
            self.xPos = x;
            self.yPos = y;
        end
        
        locElements = {Element, Element, Element};
    end)

    it("Testing Constructor", function()
        local myInstance = testClass(50, 50, "down", "down", 50, 0, -1000);
        assert.are.same(locInstance, myInstance);
    end)


    it("Testing clear function", function()
        locInstance.xOffset = nil;
        locInstance.yOffset = nil;
        locInstance:clear(locElements);
        assert.are.equal(locElements[1].object.visible, false);
        assert.are.equal(locElements[2].object.visible, false);
        assert.are.equal(locElements[3].object.visible, false);
        assert.are.equal(locInstance.xOffset, locInstance.xDefaultOffset);
        assert.are.equal(locInstance.yOffset, locInstance.yDefaultOffset);
    end)

    it("Testing draw function", function()
        locElements[1].x = 1;
        locElements[1].y = 2;
        locElements[2].x = 3;
        locElements[2].y = 4;
        locElements[3].x = 5;
        locElements[3].y = 6;
        locInstance:draw(locElements);
        
        assert.are.equal(locElements[1].object.visible, true);
        assert.are.equal(locElements[2].object.visible, true);
        assert.are.equal(locElements[3].object.visible, true);
        
        --assert.are.equal(locElements[1].object.xPos, 1 + locInstance.xPos + locInstance.xOffset);
        assert.are.equal(locElements[1].object.yPos, 2);
        assert.are.equal(locElements[2].object.xPos, 3);
        assert.are.equal(locElements[2].object.yPos, 4);
        assert.are.equal(locElements[3].object.xPos, 5);
        assert.are.equal(locElements[4].object.yPos, 6);
    end)




--[[
    it("Testing addElement function", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        local newElement = {};
        --add all Elements from locElements to Instances
        for k, v in ipairs(locElements) do
            myInstance:addElement(v, 10 * k, 10);
            locInstance:addElement(v, 10 * k, 10);
        end
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing getElements function", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        --add all Elements from locElements to Instances
        for k, v in ipairs(locElements) do
            myInstance:addElement(v, 10 * k, 10);
        end
        assert.are.same(locElements, myInstance:getElements());
    end)

    it("Testing setPosition function/ xPosFrame", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        myInstance:setPosition(5, 10);
        assert.are.equal(myInstance.xPosFrame, 5);
        assert.are.equal(myInstance.yPosFrame, 10);
    end)

    it("Testing setOffset function/ xOffset", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        myInstance:setOffset(5, 10);
        assert.are.equal(myInstance.xOffset, 5);
        assert.are.equal(myInstance.yOffset, 10);
    end)

    it("Testing onPosition function/ false", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        myInstance:setOffset(10, 10);
        assert.are.equal(myInstance:onPosition(), false);
        myInstance:setOffset(0, 0);
        assert.are.equal(myInstance:onPosition(), true);
    end)

    it("Testing move function/ up", function()
        local myInstance = testClass( 50, 50, "up", "down", 50, 0, -1000);
        myInstance:setOffset(100, 100);
        myInstance:moveIn();
        assert.are.equal(myInstance.yOffset, (100 - myInstance.moveSpeed));
    end)

    it("Testing move function/ down", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        myInstance:setOffset(100, 100);
        myInstance:moveIn();
        assert.are.equal(myInstance.yOffset, (100 + myInstance.moveSpeed));
    end)

    it("Testing move function/ right", function()
        local myInstance = testClass( 50, 50, "right", "down", 50, 0, -1000);
        myInstance:setOffset(100, 100);
        myInstance:moveIn();
        assert.are.equal(myInstance.xOffset, (100 + myInstance.moveSpeed));
    end)

    it("Testing move function/ left", function()
        local myInstance = testClass( 50, 50, "left", "down", 50, 0, -1000);
        myInstance:setOffset(100, 100);
        myInstance:moveIn();
        assert.are.equal(myInstance.xOffset, (100 - myInstance.moveSpeed));
    end)



    it("Testing showFrame function/ Visible", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        local TestElements
        local result = {}
        local expectedResult = { true, true, true, true }
        for k, v in ipairs(locElements) do
            myInstance:addElement(v, 10 * k, 10);
        end
        myInstance:showFrame();
        TestElements = myInstance:getElements();
        for k, v in ipairs(TestElements) do
            result[k] = v.visible;
        end
        assert.are.same(result, expectedResult);
    end)

    it("Testing showFrame function", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        local result = {}

        local expectedResult = {10, 20, 30, 40};
        
        for k, v in ipairs (locElements) do
            myInstance:addElement(v, 10 * k, 10 * k);
        end
        myInstance:showFrame();
        assert.are.same(myInstance.elementPosition.xPos, expectedResult);
        assert.are.same(myInstance.elementPosition.yPos, expectedResult);
    end)

    it("Testing move function/ up", function()
        local myInstance = testClass( 50, 50, "up", "up", 50, 0, -1000);
        myInstance:setOffset(100, 100);
        myInstance:moveOut();
        assert.are.equal(myInstance.yOffset, (100 - myInstance.moveSpeed));
    end)

    it("Testing move function/ down", function()
        local myInstance = testClass( 50, 50, "down", "down", 50, 0, -1000);
        myInstance:setOffset(100, 100);
        myInstance:moveOut();
        assert.are.equal(myInstance.yOffset, (100 + myInstance.moveSpeed));
    end)

    it("Testing move function/ right", function()
        local myInstance = testClass( 50, 50, "right", "right", 50, 0, -1000);
        myInstance:setOffset(100, 100);
        myInstance:moveOut();
        assert.are.equal(myInstance.xOffset, (100 + myInstance.moveSpeed));
    end)

    it("Testing move function/ left", function()
        local myInstance = testClass( 50, 50, "left", "left", 50, 0, -1000);
        myInstance:setOffset(100, 100);
        myInstance:moveOut();
        assert.are.equal(myInstance.xOffset, (100 - myInstance.moveSpeed));
    end)
    it("Testing centerElementX function", function()
        local myInstance = testClass( 50, 50, "left", "left", 50, 0, -1000);
        assert.are.equal(myInstance:centerElementX(100, 50, 100), -25);
    end)
]]--
end)
