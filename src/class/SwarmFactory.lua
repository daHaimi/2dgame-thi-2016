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

        function fishableObject(fishable) 
            fishableObjects[fishable.name] = fishable;
        end
        
        function sewer(swarms) 
            swarmsSewer = swarms;
        end
        
        dofile("data.lua");
        self:createNextSwarm();
    end;
};

function SwarmFactory:draw()
    for i = 1, #createdFishables, 1 do
        createdFishables[i]:draw();
    end
end

function SwarmFactory:update()
    for i = 1, #createdFishables, 1 do
        createdFishables[i]:update();
    end
end

--- Creates the next swarm
function SwarmFactory:createNextSwarm()
    currentSwarm = currentSwarm + 1;
    newSwarm = swarmsSewer[currentSwarm];
    amount = math.random(newSwarm.minFishables, newSwarm.maxFishables);
    allowedFishables = newSwarm.allowedFishables;
    fishablesProbability = newSwarm.fishablesProbability;
    swarmHeight = newSwarm.swarmHeight;
    for i = 0, amount, 1 do
        chosenFishable = self:determineFishable(allowedFishables, fishablesProbability);
        createdFishables[#createdFishables+1] = FishableObject(2, 
            chosenFishable.minSpeed, chosenFishable.maxSpeed, chosenFishable.xHitbox, chosenFishable.yHitbox,
            chosenFishable.value, chosenFishable.hitpoints);
    end
end

function SwarmFactory:determineFishable(allowedFishables, fishablesProbability)
    chosenProbability = math.random(100);
    addedProbability = 0;
    for j = 1, #fishablesProbability, 1 do
        addedProbability = addedProbability + fishablesProbability[j];
        if addedProbability > chosenProbability then
            return fishableObjects[allowedFishables[j]];
        end
    end
end

return SwarmFactory;
