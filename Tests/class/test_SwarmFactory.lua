_G.swarmFactoryStub = function(...)
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
            print = function(...) end;
            newImage = function(...) return _G.love.graphics.Image; end;
            draw = function(...) end;
            scale = function(...) end;
            newQuad = function(...) return 0; end;
        };
        filesystem = {
            exists = function(...) return false end;
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
        window = {
            getMode = function(...) return 0, 0, {}; end;
        };
    };
    _G.love.light.world.newLight = function(...) return _G.love.light; end;
    _G.love.light.world.newImage = function(...) return _G.love.light.Image; end;
    _G.love.light.newWorld = function(...) return _G.love.light.world; end;
    _G.love.graphics.newShader = function(...) return _G.love.graphics.shader; end;
    _G.love.graphics.newCanvas = function(...) return _G.love.graphics.Canvas; end;

    _G._persTable = {
        winDim = { 500; 500 };
        moved = 0;
        enabled = {
            ring = true;
        };
    };

    _G.levMan = {
        curLevel = {
            lowerBoarder = -7000;
            winDim = { 500, 1000 };
            getLowerBoarder = function(...) return _G.levMan.curLevel.lowerBoarder end;
            getLevelName = function(...) return "sewers" end;
        };
        curPlayer = nil;
        curSwarmFac = nil;
        getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac end;
        getCurPlayer = function(...) return _G.levMan.curPlayer end;
        getCurLevel = function(...) return _G.levMan.curLevel end;
    };
end;

_G.swarmFactoryStub();

testClass = require "src.class.SwarmFactory"

describe("Unit test for SwarmFactory.lua", function()
    local locInstance;

    before_each(function()
        _G.swarmFactoryStub();

        local data = require "src.data";

        locInstance = testClass(data, levMan);
    end)

    it("Testing constructor for sewers", function()
        local myInstance = testClass(require "src.data", levMan);
        assert.are.same(myInstance.maxDepth, locInstance.maxDepth);
    end)

    it("Testing constructor for canyon", function()
        levMan.curLevel.getLevelName = function(...) return "canyon" end;
        data = require "src.data";
        local myInstance = testClass(data, levMan);
        assert.are.same(myInstance.actualSwarm, data.swarmsCanyon);
    end)

    it("Testing constructor for canyonEndless", function()
        levMan.curLevel.getLevelName = function(...) return "canyonEndless" end;
        data = require "src.data";
        local myInstance = testClass(data, levMan);
        assert.are.same(myInstance.actualSwarm, data.swarmsCanyon);
    end)

    it("Testing constructor for sewerEndless", function()
        levMan.curLevel.getLevelName = function(...) return "sewersEndless" end;
        data = require "src.data";
        local myInstance = testClass(data, levMan);
        assert.are.same(myInstance.actualSwarm, data.swarmsSewer);
    end)

    it("Testing constructor for crazySquirrels", function()
        levMan.curLevel.getLevelName = function(...) return "crazySquirrels" end;
        data = require "src.data";
        local myInstance = testClass(data, levMan);
        assert.are.same(myInstance.actualSwarm, data.crazySquirrels);
    end)

    it("Testing constructor for sleepingCrocos", function()
        levMan.curLevel.getLevelName = function(...) return "sleepingCrocos" end;
        data = require "src.data";
        local myInstance = testClass(data, levMan);
        assert.are.same(myInstance.actualSwarm, data.swarmCrocos);
    end)

    it("Testing destructSF", function()
        local testInstance = testClass(require "src.data", levMan);
        testInstance:destructSF();

        assert.are.same(testInstance.levMan, nil);
        assert.are.same(testInstance.maxDepth, nil);
        assert.are.same(testInstance.currentSwarm, nil);
        assert.are.same(testInstance.fishableObjects, nil);
        assert.are.same(testInstance.createdFishables, nil);
        assert.are.same(testInstance.swarmsSewer, nil);
    end)

    it("Testing draw method", function()
        local loveMock = mock(_G.love, true);
        locInstance:draw();
        assert.spy(loveMock.graphics.draw).was.called(#locInstance.createdFishables);
    end)

    it("Testing update method", function()
        local s = spy.on(FishableObject, "update");
        locInstance:update();
        assert.spy(s).was.called(#locInstance.createdFishables);
    end)

    it("Testing update method", function()
        levMan.curLevel.getDirection = function(...) return -1 end;
        levMan.curLevel.getYPos = function(...) return 50 end;
        local myInstance = testClass(require "src.data", levMan);
        myInstance.currentSwarm = 2;
        myInstance:update(0.004);
        assert.are.same(1, myInstance.currentSwarm);
    end)

    it("Testing createNextSwarm method", function()
        local testInstance = testClass(require "src.data", levMan);
        testInstance.currentSwarm = 1;
        testInstance.createdFishables = {};
        testInstance.currentSwarm = #testInstance.actualSwarm
        testInstance.actualSwarm[testInstance.currentSwarm].maxSwarmHeight = 10;
        testInstance:createNextSwarm(100, 0);

        local swarm = testInstance.createdFishables;

        for i = 1, #swarm, 1 do
            assert.has_no.errors(function()
                if swarm[i].yPosition < 0 or swarm[i].yPosition > 500 then
                    error("Position error");
                end
            end)
        end
    end)

    it("Testing determineFishable method", function()
        local allowedFishablesTest = { "nemo", "lollipop", "deadFish" };
        local fishablesProbabilityTest = { 100, 0, 0 };
        local fishableRes = locInstance:determineFishable(allowedFishablesTest, fishablesProbabilityTest);
        assert.same(fishableRes, locInstance.fishableObjects["nemo"]);

        allowedFishablesTest = { "deadFish", "lollipop" };
        fishablesProbabilityTest = { 0, 100 };
        fishableRes = locInstance:determineFishable(allowedFishablesTest, fishablesProbabilityTest);
        assert.are_not.same(fishableRes, locInstance.fishableObjects["deadFish"]);

        allowedFishablesTest = { "0815blafish", "lollipop" };
        fishablesProbabilityTest = { 0, 100 };
        fishableRes = locInstance:determineFishable(allowedFishablesTest, fishablesProbabilityTest);
        assert.same(fishableRes, locInstance.fishableObjects["lollipop"])
    end)

    it("Testing getCreatedFishables method", function()
        locInstance.createdFishables = { "fish1", "fish2", "fish3" };
        assert.are.same({ "fish1", "fish2", "fish3" }, locInstance:getCreatedFishables());
    end)

    it("Testing getFishableObjects method", function()
        locInstance.fishableObjects = { "fish1", "fish2", "fish3" };
        assert.are.same({ "fish1", "fish2", "fish3" }, locInstance:getFishableObjects());
    end)

    it("Testing setMovementMultiplicator Function", function()
        locInstance:setSpeedMultiplicator(0.3);
        assert.are.same(0.3, locInstance.speedMulitplicator);
    end)

    it("Testing createRandomPill", function()
        locInstance.createdFishables = {};
        locInstance.positionOfLastPill = 0;
        locInstance:createRandomPill(1000, 200, 400);
        assert.are.same(1, #locInstance.createdFishables);
    end)

    it("Testing createMoreSwarms", function()
        local locData = {
            fishableObjects = {
                balloon = {
                    name = "balloon";
                    image = "balloon.png";
                    spriteSize = 64;
                    minSpeed = 2;
                    maxSpeed = 4;
                    value = 10;
                    minAmount = 2;
                    maxAmount = 3;
                    swarmHeight = 200;
                    enabled = true;
                    description = "Let it go like your dreams";
                    hitbox = {
                        {
                            width = 20;
                            height = 40;
                            deltaXPos = 22;
                            deltaYPos = 4;
                        },
                        {
                            width = 30;
                            height = 14;
                            deltaXPos = 18;
                            deltaYPos = 14;
                        },
                        {
                            width = 6;
                            height = 20;
                            deltaXPos = 34;
                            deltaYPos = 44;
                        }
                    };
                };
            };
            swarmsSewer = {
                {
                    allowedFishables = { "balloon" };
                    fishablesProbability = { 100 };
                    maxSwarmHeight = 90000;
                }
            };
        };
        local myInstance = testClass(locData, levMan);
        myInstance.addedHeights = 0;
        myInstance:createMoreSwarms(10);
        assert.are.not_same(myInstance.addedHeights, 0);
    end)

    it("Testing creatFallingLitter", function()
        levMan.curLevel.getLevelName = function(...) return "canyon" end
        local myInstance = testClass(require "src.data", levMan);
        myInstance.positionOfLastLitter = 0;
        myInstance.actualSwarm[myInstance.currentSwarm].typ = "static";
        myInstance:createFallingLitter(1000, 200, 300);
        assert.are.same(myInstance.positionOfLastLitter, 1000);
    end)

    it("Testing creatBubbles", function()
        levMan.curLevel.getLevelName = function(...) return "sewers" end;
        levMan.curLevel.getDirection = function(...) return 1 end;
        local myInstance = testClass(require "src.data", levMan);
        myInstance.positionOfLastBubbles = 0;
        myInstance:createBubbles(0, 2, 1);
        assert.is_true(#myInstance.createdBubbles > 0);
    end)
end)
