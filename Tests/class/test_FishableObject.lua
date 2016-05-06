-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.FishableObject"
--self, name, imageSrc, yPosition, minSpeed, maxSpeed, value, hitpoints, spriteSize, hitbox
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
        
        local hitbox = {
            {
                width = 64,
                height = 25,
                deltaXPos = 0,
                deltaYPos = 20
            }
        }

        _G.locInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64, hitbox);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64, hitbox);
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
        locInstance.speed = 300;
        locInstance:setXPosition(250);
        locInstance.speed = 300;
        locInstance:update();
        assert.are.equal(550, locInstance.xPosition);
        locInstance:update();
        assert.are.equal(136, locInstance.xPosition);
        locInstance:update();
        assert.are.equal(-164, locInstance.xPosition);
        locInstance:update();
        assert.are.equal(364, locInstance.xPosition);
    end)

    it("Testing getValue Function", function()
        assert.are.same(50, locInstance:getValue());
    end)

    it("Testing getHitpoints Function", function()
        assert.are.same(5, locInstance:getHitpoints());
    end)

    it("Testing getHitboxWidth Function", function()
        assert.are.same(64, locInstance:getHitboxWidth(1));
    end)

    it("Testing getHitboxHeight Function", function()
        assert.are.same(25, locInstance:getHitboxHeight(1));
    end)

    it("Testing getHitboxXPosition Function", function()
        locInstance:setXPosition(50);
        locInstance.speed = -30;
        assert.are.same(50, locInstance:getHitboxXPosition(1));
        locInstance:setXPosition(450);
        locInstance.speed = 30;
        assert.are.same(386, locInstance:getHitboxXPosition(1));
    end)

    it("Testing getHitboxYPosition Function", function()
        assert.are.same(70, locInstance:getHitboxYPosition(1));
    end)

    it("Testing setYMovement Function", function()
        locInstance:setYMovement(30);
        assert.are.same(30, locInstance.yMovement);
    end)

    it("Testing getName Function", function()        
        assert.are.same("deadFish", locInstance:getName());
    end)

    it("Testing setMovementMultiplicator Function", function()
        locInstance:setSpeedMultiplicator(0.3);
        assert.are.same(0.3, locInstance.speedMulitplicator);
    end)

    it("Testing getYMovement Function", function ()
        locInstance:setYMovement(4);
        assert.are.same(4, locInstance:getYMovement());
    end)

end)
