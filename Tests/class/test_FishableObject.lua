-- Lua 5.1 Hack
_G.math.inf = 1 / 0
_G.fishableObjectStub = function()
    _G.TEsound = {
        play = function(...) end;
    };

    _G.love = {
        graphics = {
            Image = {
                getWidth = function(...) return 64; end;
                getHeight = function(...) return 64; end;
                getDimensions = function(...) return 64, 64; end;
            };
            shader = {
                send = function(...) end;
            };
            newShader = function(...) end;
            setColor = function(...) end;
            setNewFont = function(...) end;
            getFont = function(...) return "this could be your font"; end;
            setFont = function(...) end;
            print = function(...) end;
            newImage = function(...) return _G.love.graphics.Image; end;
            draw = function(...) end;
            scale = function(...) end;
            newQuad = function(...) return 0; end;
        };
        window = {
            getMode = function(...) return 0, 0, {}; end;
        };
        filesystem = {
            exists = function(...) return false; end;
        };
        light = {
            world = {
                setAmbientColor = function(...) end;
                update = function(...) end;
                drawShadow = function(...) end;
                setRefractionStrength = function(...) end;
                drawPixelShadow = function(...) end;
                drawGlow = function(...) end;
                newBody = function(...) end;
            };
            Image = {
                setGlowMap = function(...) end;
                setNormalMap = function(...) end;
                setPosition = function(...) end;
            };
            setGlowStrength = function(...) end;
            setSmooth = function(...) end;
            setPosition = function(...) end;
        };
    };

    _G._persTable = {
        winDim = { 500; 500 };
        moved = 0;
        fish = {
            postiveFishCaught = true;
        };
    };
    _G.love.light.world.newLight = function(...) return _G.love.light; end;
    _G.love.light.world.newImage = function(...) return _G.love.light.Image; end;
    _G.love.light.newWorld = function(...) return _G.love.light.world; end;
    _G.love.graphics.newShader = function(...) return _G.love.graphics.shader; end;
    _G.love.graphics.newCanvas = function(...) return _G.love.graphics.Canvas; end;

    _G.levMan = {
        curLevel = {
            winDim = { 500, 500 };
            getMoved = function(...) return 4; end;
            getLightWorld = function(...) return _G.love.light.world; end;
        };
        curPlayer = {
            getPosY = function(...) return 5; end;
        };
        curSwarmFac = nil;
        getLevelPropMapByName = function(...)
            return {
                direction = 1;
            };
        end;
        getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac; end;
        getCurPlayer = function(...) return _G.levMan.curPlayer; end;
        getCurLevel = function(...) return _G.levMan.curLevel; end;
    };
end;

_G.fishableObjectStub();

testClass = require "src.class.FishableObject"
--self, name, imageSrc, yPosition, minSpeed, maxSpeed, value, hitpoints, spriteSize, hitbox
describe("Unit test for FishableObject.lua", function()

    before_each(function()
        local hitbox = {
            {
                width = 64;
                height = 25;
                deltaXPos = 0;
                deltaYPos = 20;
            }
        };
        _G.fishableObjectStub();

        _G.locInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64, hitbox, _, _, _, 0, _G.levMan);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64, hitbox, _, _, _, 0, _G.levMan);
        assert.are.equal(locInstance.yPosition, myInstance.yPosition);
        assert.are.equal(locInstance.xHitbox, myInstance.xHitbox);
        assert.are.equal(locInstance.yHitbox, myInstance.yHitbox);
        assert.are.equal(locInstance.value, myInstance.value);
        assert.are.equal(locInstance.hitpoints, myInstance.hitpoints);
    end)

    it("Testing Contructor with fallSpeed", function()
        local myInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64, hitbox, _, _, _, 5, _G.levMan);
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
        locInstance.image = locInstance.defaultImage;
        locInstance:draw();
        assert.spy(loveMock.graphics.draw).was_called_with(_G.love.graphics.Image, -150, 50);
    end)

    it("Testing draw Function with negativ speed", function()
        local loveMock = mock(_G.love, true);
        locInstance:setXPosition(400);
        locInstance.speed = -300;        
        locInstance.image = locInstance.defaultImage;
        locInstance:draw();
        assert.spy(loveMock.graphics.draw).was_called_with(_G.love.graphics.Image, 400, 50);
    end)

    it("Testing draw Function when caught", function()
        local loveMock = mock(_G.love, true);
        locInstance.xPosition = 50;
        locInstance.yPosition = 100;
        locInstance:setToCaught();
        locInstance:draw();
        assert.spy(loveMock.graphics.print).was_called_with(50, 50, 100);
    end)

    it("Testing draw Function when caught", function()
        local loveMock = mock(_G.love, true);
        locInstance.xPosition = 50;
        locInstance.yPosition = 100;
        locInstance.value = -50;
        locInstance:setToCaught();
        locInstance:draw();
        assert.spy(loveMock.graphics.print).was_called_with(50, 50, 100);
    end)

    it("Testing Update Function", function()
        locInstance.speed = 300;
        locInstance:setXPosition(250);
        locInstance.speed = 300;
        locInstance:update(0.04, 1);
        assert.are.equal(550, locInstance.xPosition);
        locInstance:update(0.04, 1);
        assert.are.equal(136, locInstance.xPosition);
        locInstance:update(0.04, 1);
        assert.are.equal(-164, locInstance.xPosition);
        locInstance:update(0.04, 1);
        assert.are.equal(364, locInstance.xPosition);
        locInstance:setToCaught();
        locInstance:update(0.04, 1);
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
        locInstance.speed = 0;
        assert.are.same(386, locInstance:getHitboxXPosition(1));
    end)

    it("Testing getHitboxYPosition Function", function()
        assert.are.same(70, locInstance:getHitboxYPosition(1));
    end)

    it("Testing getName Function", function()
        assert.are.same("deadFish", locInstance:getName());
    end)

    it("Testing outOfArea", function()
        locInstance.yPosition = 10000;
        locInstance:update();
        assert.are.same(true, locInstance.outOfArea);
    end)

    it("Testing falling Objekt", function()
        locInstance.yPosition = 100;
        locInstance.fallSpeed = 1;
        locInstance.levMan.getCurLevel = function(...) return
        {
            getDirection = function(...) return 1; end;
            winDim = { 480, 833 };
            getMoved = function(...) return 4; end;
        };
        end;
        locInstance:update(1, 1);
        assert.are.same(101, locInstance.yPosition);
    end)

    it("Testing falling Objekt", function()
        locInstance.yPosition = 100;
        locInstance.fallSpeed = 1;
        locInstance.yMovement = 10;
        locInstance.levMan.getCurLevel = function(...) return
        {
            getDirection = function(...) return -1; end;
            winDim = { 480, 833 };
            getMoved = function(...) return 10; end;
        };
        end;
        locInstance:update(1, 1);
        assert.are.same(91, locInstance.yPosition);
    end)

    it("Testing setYPosition", function()
        locInstance:setYPosition(5);
        assert.are.same(5, locInstance.yPosition);
    end)

    it("Testing Animation", function()
        local spyShiftImage = spy.on(Animate, "shiftImage");
        local spyDraw = spy.on(Animate, "draw");

        love.filesystem.exists = function(...) return true; end;
        local localHitbox = {
            {
                width = 64;
                height = 25;
                deltaXPos = 0;
                deltaYPos = 20;
            }
        };

        local myInstance = testClass("deadFish", "assets/deadFish.png", 50, 30, 35, 50, 5, 64,
            localHitbox, 0.1, 0.2, 1, 0, _G.levMan);

        myInstance:draw();
        myInstance.xPosition = 100;
        myInstance.speed = 1;
        assert.spy(spyDraw).was.called(1);
        myInstance:update(0.05, 1);
        assert.spy(spyShiftImage).was_called();

        myInstance.speed = 1;
        myInstance:draw();
        assert.spy(spyDraw).was.called_with(myInstance.animation, -myInstance.xPosition, myInstance.yPosition);
    end)
end)
