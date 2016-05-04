testClass = require "src.class.SwarmFactory"



describe("Unit test for SwarmFactory.lua", function()
    local locInstance;
    
    local level = {
        lowerBoarder = -7000;
    }

    before_each(function()
        _G.love = {
            graphics = {
                setColor = function(...) end;
                newImage = function(...) end;
                draw = function(...) end;
                scale = function(...) end;
            }
        }

        _G._persTable = {
            winDim = { 500; 500 };
            moved = 0;
            enabled = {
                ring = true;
            }
        }
        
        locInstance = testClass(level, player, "src/data.lua");
    end)

    it("Testing constructor", function()
        local myInstance = testClass(level, player, "src/data.lua");
        assert.are.same(locInstance, myInstance);
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
        local testInstance = testClass(level, player, "src/data.lua");
        testInstance.currentSwarm = 1;
        testInstance.createdFishables = {};
        
        testInstance:createNextSwarm(20);
        local testSwarmheight = 100;
        local testSwarmMaxYPos = 100 + testSwarmheight;
        local swarm = testInstance.createdFishables;

        for i = 1, #swarm, 1 do
            print (swarm[i].yPosition);
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
        assert.are_not.same(fishableRes, locInstance.fishableObjects["deadFish"])
    end)
end)
