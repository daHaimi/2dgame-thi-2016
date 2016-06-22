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
            x = 0;
            y = 0;
        };
        
        function Element:setOffset(x, y)
            self.xPos = x;
            self.yPos = y;
        end
        spy.on(Element, "setOffset");
        
        locElements = {Element, Element, Element};
    end)

    it("Testing Constructor", function()
        local myInstance = testClass(50, 50, "down", "down", 50, 0, -1000);
        assert.are.same(locInstance, myInstance);
    end)

    it("DefaultOffset has to be a multiple of moveSpeed", function()
        assert.are.equal((locInstance.p_xDefaultOffset) % (locInstance.p_moveSpeed), 0);
        assert.are.equal((locInstance.p_yDefaultOffset) % (locInstance.p_moveSpeed), 0);
    end)
    
    
    it("Testing clear function", function()
        locInstance.p_xOffset = nil;
        locInstance.p_yOffset = nil;
        locInstance:clear(locElements);
        assert.are.equal(locInstance.p_xOffset, locInstance.p_xDefaultOffset);
        assert.are.equal(locInstance.p_yOffset, locInstance.p_yDefaultOffset);
    end)

    it("Testing appear function", function()
        locInstance.p_yOffset = 100;
        locInstance.p_moveInDirection = "up";
        locInstance:appear(locElements);
        assert.are.equal(locInstance.p_yOffset, 100 - locInstance.p_moveSpeed);

        locInstance.p_yOffset = 100;
        locInstance.p_moveInDirection = "down";
        locInstance:appear(locElements);
        assert.are.equal(locInstance.p_yOffset, 100 + locInstance.p_moveSpeed);
        
        locInstance.p_xOffset = 100;
        locInstance.p_moveInDirection = "left";
        locInstance:appear(locElements);
        assert.are.equal(locInstance.p_xOffset, 100 - locInstance.p_moveSpeed);
        
        locInstance.p_xOffset = 100;
        locInstance.p_moveInDirection = "right";
        locInstance:appear(locElements);
        assert.are.equal(locInstance.p_xOffset, 100 + locInstance.p_moveSpeed);
        
    end)
    
    it("Testing disappear function", function()
        locInstance.p_yOffset = 100;
        locInstance.p_moveOutDirection = "up";
        locInstance:disappear(locElements);
        assert.are.equal(locInstance.p_yOffset, 100 - locInstance.p_moveSpeed);

        locInstance.p_yOffset = 100;
        locInstance.p_moveOutDirection = "down";
        locInstance:disappear(locElements);
        assert.are.equal(locInstance.p_yOffset, 100 + locInstance.p_moveSpeed);
        
        locInstance.p_xOffset = 100;
        locInstance.p_moveOutDirection = "left";
        locInstance:disappear(locElements);
        assert.are.equal(locInstance.p_xOffset, 100 - locInstance.p_moveSpeed);
        
        locInstance.p_xOffset = 100;
        locInstance.p_moveOutDirection = "right";
        locInstance:disappear(locElements);
        assert.are.equal(locInstance.p_xOffset, 100 + locInstance.p_moveSpeed);
        
    end)
    
    it("Testing checkPosition function", function()
        locInstance.p_xOffset = 1;
        locInstance.p_yOffset = 1;
        assert.are.equal(locInstance:checkPosition(), false);
        locInstance.p_xOffset = 0;
        locInstance.p_yOffset = 0;
        assert.are.equal(locInstance:checkPosition(), true);
    end)
end)
