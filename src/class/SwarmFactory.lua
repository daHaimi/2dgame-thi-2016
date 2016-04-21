--- The class SwarmFactory creates swarms of fishable objects

FishableObject = require "class.FishableObject";

local fishableObjects = {};
local currentSwarm = 0;

local swarmsSewer = {};

local createdFishables = {};

local SwarmFactory = Class {
    --- Initializes the swarm factory
    -- @param level The current level
    -- @param player The player object
    init = function(self, level, player)
        self.level = level;
        self.player = player;

        --- Takes the fishable form the data file
        -- @param fishable The fishable
        function fishableObject(fishable) 
            fishableObjects[fishable.name] = fishable;
        end
        
        --- Takes the sewer swarms from the data file
        -- @param swarms The swarms
        function sewer(swarms) 
            swarmsSewer = swarms;
        end
        
        dofile("data.lua");
        addedHeights = 800; -- Start at 800 to create swarms for now
        for i = 1, #swarmsSewer, 1 do
            self:createNextSwarm(addedHeights);
            addedHeights = addedHeights + swarmsSewer[i].swarmHeight;
        end
    end;
};

--- Draws all fishables
function SwarmFactory:draw()
    for i = 1, #createdFishables, 1 do
        createdFishables[i]:draw();
    end
end

--- Updates all fishables
function SwarmFactory:update()
    for i = 1, #createdFishables, 1 do
        createdFishables[i]:update();
    end
end

--- Creates the next swarm
-- @param startPosY Start y position of the swarm
function SwarmFactory:createNextSwarm(startPosY)
    currentSwarm = currentSwarm + 1;
    newSwarm = swarmsSewer[currentSwarm];
    amountFishables = math.random(newSwarm.minFishables, newSwarm.maxFishables);
 
    for i = 1, amountFishables, 1 do
        yPos = math.random(newSwarm.swarmHeight);
        fishable = self:determineFishable(newSwarm.allowedFishables, newSwarm.fishablesProbability);

        createdFishables[#createdFishables + 1] = FishableObject(fishable.image, startPosY + yPos,
            fishable.minSpeed, fishable.maxSpeed, fishable.xHitbox, fishable.yHitbox,
            fishable.value, fishable.hitpoints);
    end
end

--- Determines the next fishable to create
-- @param allowedFishables Fishables to consider
-- @param fishablesProbability Creation probabilities for the fishables
-- @return The fishable to create
function SwarmFactory:determineFishable(allowedFishables, fishablesProbability)
    fishableDecider = math.random(100);
    addedProbability = 0;
    for i = 1, #fishablesProbability, 1 do
        addedProbability = addedProbability + fishablesProbability[i];
        if addedProbability > fishableDecider then
            return fishableObjects[allowedFishables[i]];
        end
    end
end

return SwarmFactory;
