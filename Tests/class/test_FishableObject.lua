-- Lua 5.1 Hack
_G.math.inf = 1/0

testClass = require "src.class.FishableObject"
--self, yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints
describe("Unit test for FishableObject.lua", function()
        
    before_each(function()
        _G.love = {
            graphics = {
                setColor = function(...) end;
                rectangle = function(...) end;
            }
        }
        
        _G._persTable ={ 
            winDim = {500; 500}
        }
        
        locInstance = testClass(50, 30, 35, 100, 75, 50, 5);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass(50, 30, 35, 100, 75, 50, 5);
        assert.are.equal(locInstance.yPosition, myInstance.yPosition);
        assert.are.equal(locInstance.xHitbox, myInstance.xHitbox);
        assert.are.equal(locInstance.yHitbox, myInstance.yHitbox);
        assert.are.equal(locInstance.value, myInstance.value);
        assert.are.equal(locInstance.hitpoints, myInstance.hitpoints);
    end)

    it("Testing setXPosition", function()
        locInstance:setXPosition(30);
        assert.are.equal(30, locInstance.xPosition);
        locInstance:setXPosition(50);
        assert.are.equal(50, locInstance.xPosition);
    end)

    it("Testing draw Function", function()
        local loveMock = mock(_G.love, true);
        locInstance:setXPosition(150);
        locInstance:draw();
        
        assert.spy(loveMock.graphics.rectangle).was_called_with("fill", 150, 50, 100, 75);    
    end)

    it("Testing Update Function", function()
        myInstance1= testClass(50, 300, 300, 100, 75, 50, 5);
        myInstance1:setXPosition(250);
        myInstance1:update();
        assert.are.equal(350, myInstance1.xPosition);
        myInstance1:update();
        assert.are.equal(50, myInstance1.xPosition);
        myInstance1:update();
        assert.are.equal(250, myInstance1.xPosition);
    end)

    it("Testing getValue Function", function()
        assert.are.same(50, locInstance:getValue());
    end)

    it("Testing getHitpoints Function", function()
        assert.are.same(5, locInstance:getHitpoints());
    end)
    it("Testing getHitbox Function", function()
        xHitbox, yHitbox = locInstance:getHitbox();
        assert.are.equal(100, xHitbox);
        assert.are.equal(75, yHitbox);
    end)
    
    it("Testing getPosition Function", function()
        locInstance:setXPosition(200);
        xPosition, yPosition = locInstance:getPosition();
        assert.are.equal(200, xPosition);
        assert.are.equal(50, yPosition);
    end)
end)