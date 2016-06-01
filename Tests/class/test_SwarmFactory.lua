testClass = require "src.class.SwarmFactory"

describe("Unit test for SwarmFactory.lua", function()
    local locInstance;
    
    local level = {
        lowerBoarder = -7000;
        winDim = {500, 1000};
    }

    before_each(function()
        _G.love = {
            graphics = {
                setColor = function(...) end;
                newImage = function(...) end;
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
            enabled = {
                ring = true;
            }
        }
        
        _G.levMan = {
            curLevel = {
                lowerBoarder = -7000;
                winDim = {500, 1000};
                getLowerBoarder = function(...) return _G.levMan.curLevel.lowerBoarder end;
            },
            curPlayer = nil,
            curSwarmFac = nil,
            getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac end,
            getCurPlayer = function(...) return _G.levMan.curPlayer end,
            getCurLevel = function(...) return _G.levMan.curLevel end
        }
        
        local data = require "src.data";
        
        locInstance = testClass(data, levMan);
    end)

    it("Testing constructor", function()
        local myInstance = testClass(require "src.data", levMan);
        assert.are.same(myInstance.maxDepth, locInstance.maxDepth);
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

    it("Testing createNextSwarm method", function()
        local testInstance = testClass(require "src.data", levMan);
        testInstance.currentSwarm = 1;
        testInstance.createdFishables = {};
        
        testInstance:createNextSwarm(20);
        local testSwarmheight = 100;
        local testSwarmMaxYPos = 100 + testSwarmheight;
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
        locInstance.createdFishables = {"fish1", "fish2", "fish3"};
        assert.are.same({"fish1", "fish2", "fish3"}, locInstance:getCreatedFishables());
    end)

    it("Testing getFishableObjects method", function()
        locInstance.fishableObjects = {"fish1", "fish2", "fish3"};
        assert.are.same({"fish1", "fish2", "fish3"}, locInstance:getFishableObjects());
    end)
end)
