-- Lua 5.1 Hack
_G.math.inf = 1/0

testClass = require "src.class.FishableObject"
--self, imageSrc, yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints
describe("Unit test for FishableObject.lua", function()
        
    before_each(function()
        _G.love = {
            graphics = {
                setColor = function(...) end;
                newImage = function(...) return "assets/deadFish.png" end;
                draw = function(...) end;
                scale = function(...) end;
            }
        }
        
        _G._persTable ={ 
            winDim = {500; 500};
            moved = 0;
        }
        
        locInstance = testClass("assets/deadFish.png", 50, 30, 35, 100, 75, 50, 5);
        
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("assets/deadFish.png", 50, 30, 35, 100, 75, 50, 5);
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

    it("Testing draw Function 1", function()
        local loveMock = mock(_G.love, true);
        locInstance:setXPosition(150);
        locInstance:draw();
        assert.spy(loveMock.graphics.draw).was_called_with("assets/deadFish.png", -150, 50);  
    end)

    it("Testing draw Function 2", function()
          local loveMock = mock(_G.love, true);    
        locInstance:setXPosition(400);
        locInstance.speed = -300;
        locInstance:draw();
        assert.spy(loveMock.graphics.draw).was_called_with("assets/deadFish.png", 400, 50);  
    end)

    it("Testing Update Function", function()
        myInstance1= testClass("assets/deadFish.png", 50, 300, 300, 100, 75, 50, 5);
        myInstance1:setXPosition(250);
        myInstance1:update();
        assert.are.equal(400, myInstance1.xPosition);
        myInstance1:update();
        assert.are.equal(100, myInstance1.xPosition);
        myInstance1:update();
        assert.are.equal(200, myInstance1.xPosition);
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
    
    it("Testing getPosition Function 1", function()
        locInstance:setXPosition(200);
        xPosition, yPosition = locInstance:getPosition();
        assert.are.equal(200, xPosition);
        assert.are.equal(50, yPosition);
    end)

end)