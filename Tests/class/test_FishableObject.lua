-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.FishableObject"
--self, name, imageSrc, yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints, deltaXHitbox, deltaYHitbox
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

        _G._persTable = {
            winDim = { 500; 500 };
            moved = 0;
        }

        _G.locInstance = testClass("assets/deadFish.png", "deadFish", 50, 30, 35, 100, 75, 50, 5, 2, 3);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("assets/deadFish.png", "deadFish", 50, 30, 35, 100, 75, 50, 5, 0, 0);
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
        locInstance.speed = 30;
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
        local myInstance1 = testClass("assets/deadFish.png", "deadFish", 50, 300, 300, 64, 25, 50, 5, 0, 0);
        myInstance1:setXPosition(250);
        myInstance1.speed = 300;
        myInstance1:update();
        assert.are.equal(550, myInstance1.xPosition);
        myInstance1:update();
        assert.are.equal(136, myInstance1.xPosition);
        myInstance1:update();
        assert.are.equal(-164, myInstance1.xPosition);
        myInstance1:update();
        assert.are.equal(364, myInstance1.xPosition);
    end)

    it("Testing getValue Function", function()
        assert.are.same(50, locInstance:getValue());
    end)

    it("Testing getHitpoints Function", function()
        assert.are.same(5, locInstance:getHitpoints());
    end)

    it("Testing getHitboxWidth Function", function()
        assert.are.same(100, locInstance:getHitboxWidth());
    end)

    it("Testing getHitboxHeight Function", function()
        assert.are.same(75, locInstance:getHitboxHeight());
    end)

    it("Testing getHitboxXPosition Function", function()
        locInstance:setXPosition(50);
        locInstance.speed = -30;
        assert.are.same(52, locInstance:getHitboxXPosition());
        locInstance:setXPosition(450);
        locInstance.speed = 30;
        assert.are.same(388, locInstance:getHitboxXPosition());
    end)

    it("Testing getHitboxYPosition Function", function()
        assert.are.same(53, locInstance:getHitboxYPosition());
    end)

    it("Testing setYMovement Function", function()
        locInstance:setYMovement(30);
        assert.are.same(30, locInstance.yMovement);
    end)
end)
