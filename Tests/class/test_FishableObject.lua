-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.FishableObject"
--self, name, imageSrc, yPosition, minSpeed, maxSpeed, value, hitpoints, spriteSize, hitbox
describe("Unit test for FishableObject.lua", function()

    before_each(function()
        _G.TEsound = {
            play = function (...) end;
        }
        
        _G.love = {
            graphics = {
                setColor = function(...) end;
                setNewFont = function(...)end;
                getFont = function(...) return "this could be your font" end;
                setFont = function(...) end;
                print = function(...) end;
                newImage = function(...) return "assets/deadFish.png" end;
                draw = function(...) end;
                scale = function(...) end;
            },
            
            filesystem = {
                exists = function(...) return false end;
            }
        }

        _G._persTable = {
            winDim = { 500; 500 };
            moved = 0;
            fish = {
                postiveFishCaught = true;
            }
        }
        
        local hitbox = {
            {
                width = 64,
                height = 25,
                deltaXPos = 0,
                deltaYPos = 20
            }
        }
        _G.levMan = {
        curLevel = {
            winDim = {500, 500};
        };
        curPlayer = {
            getPosY = function (...) return 5 end;
        };
        curSwarmFac = nil;
        getLevelPropMapByName = function(...) return {
            direction = 1;
        }
        end;
        getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac end;
        getCurPlayer = function(...) return _G.levMan.curPlayer end;
        getCurLevel = function(...) return _G.levMan.curLevel end;
    };

        _G.locInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64, hitbox, _,_,_, 0, _G.levMan);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64, hitbox, _,_,_, 0, _G.levMan);
        assert.are.equal(locInstance.yPosition, myInstance.yPosition);
        assert.are.equal(locInstance.xHitbox, myInstance.xHitbox);
        assert.are.equal(locInstance.yHitbox, myInstance.yHitbox);
        assert.are.equal(locInstance.value, myInstance.value);
        assert.are.equal(locInstance.hitpoints, myInstance.hitpoints);
    end)

    it("Testing Contructor with fallSpeed", function()
        local myInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64, hitbox, _,_,_, 5, _G.levMan);
        assert.are.equal(myInstance.fallSpeed, 5);
    end)

    it("Testing setToCaught Function", function()
        locInstance:setToCaught();
        assert.are.same(locInstance.yPosition, locInstance.caughtAt);
        assert.are.same(true, locInstance.caught);
    end)

    it("Testing setXPosition", function()
        locInstance:setXPosition(30);
        assert.are.equal(30, locInstance.xPosition);
        locInstance:setXPosition(50);
        assert.are.equal(50, locInstance.xPosition);
    end)

    it("Testing draw Function with positiv speed", function()
        local loveMock = mock(_G.love, true);
        locInstance:setXPosition(150);
        locInstance.speed = 30;
        locInstance:draw();
        assert.spy(loveMock.graphics.draw).was_called_with("assets/deadFish.png", -150, 50);
    end)

    it("Testing draw Function with negativ speed", function()
        local loveMock = mock(_G.love, true);
        locInstance:setXPosition(400);
        locInstance.speed = -300;
        locInstance:draw();
        assert.spy(loveMock.graphics.draw).was_called_with("assets/deadFish.png", 400, 50);
    end)

    it("Testing draw Function when caught", function()
        local loveMock = mock(_G.love, true);
        locInstance.xPosition = 50;
        locInstance.yPosition = 100;
        locInstance:setToCaught();
        locInstance:draw();
        assert.spy(loveMock.graphics.print).was_called_with(50, 50, 100);
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
        locInstance:setToCaught();
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
