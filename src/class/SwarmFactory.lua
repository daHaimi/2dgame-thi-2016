--- The class SwarmFactory creates swarms of fishable objects defined by data.lua
FishableObject = require "class.FishableObject";
LevelManager = require "class.LevelManager";
require "socket" math.randomseed(socket.gettime() * 10000);

local SwarmFactory = Class {
    --- Initializes the swarm factory
    -- @param data The path and name of the data file
    -- @param levelManager Reference to the level manager object
    init = function(self, data, levelManager)
        self.levMan = levelManager;
        
        self.maxDepth = self.levMan:getCurLevel():getLowerBoarder() - 2 * _G._persTable.winDim[2];        
        self.fishableObjects = data.fishableObjects;
        self.swarmsSewer = data.swarmsSewer;
        
        for k,v in pairs(self.fishableObjects) do
            if _G._persTable.enabled[k] == nil then
                self.fishableObjects[k].enabled = true;
            else
                self.fishableObjects[k].enabled = _G._persTable.enabled[k];
            end
        end
        
        addedHeights = 600; -- Start at 600 to create swarms for now
        while addedHeights <= -self.maxDepth do
            addedHeights = addedHeights + self:createNextSwarm(addedHeights);
        end
    end;
    
    levMan = nil;        
    maxDepth = -5000;    
    currentSwarm = 1;
    createdFishables = {};
};

--- Draws all fishables
function SwarmFactory:draw()
    for i = 1, #self.createdFishables, 1 do
        self.createdFishables[i]:draw();
    end
end

--- Updates all fishables
function SwarmFactory:update()
    for i = 1, #self.createdFishables, 1 do
        self.createdFishables[i]:update();
    end
end

--- Creates the next swarm
-- @param startPosY Start y position of the swarm
function SwarmFactory:createNextSwarm(startPosY)
    if self.swarmsSewer[self.currentSwarm].maxSwarmHeight < startPosY then
        self.currentSwarm = self.currentSwarm + 1;
    end
    
    newSwarm = self.swarmsSewer[self.currentSwarm];
    fishable = self:determineFishable(newSwarm.allowedFishables, newSwarm.fishablesProbability);
    
    amountFishables = math.random(fishable.minAmount, fishable.maxAmount);
 
    for i = 1, amountFishables, 1 do
        yPos = math.random(fishable.swarmHeight);
        
        self.createdFishables[#self.createdFishables + 1] = FishableObject(fishable.name, fishable.image, startPosY + 
            yPos, fishable.minSpeed, fishable.maxSpeed, fishable.value, fishable.hitpoints, fishable.spriteSize, fishable.hitbox);
    end
    
    return math.random (fishable.swarmHeight * 0.9 , fishable.swarmHeight); -- to enable 2 swarms to overlap
end

--- Determines the next fishable to create
-- @param allowedFishables Fishables to consider
-- @param fishablesProbability Creation probabilities for the fishables
-- @return The fishable to create
function SwarmFactory:determineFishable(allowedFishables, fishablesProbability)
    fishableDecider = math.random(100);
    
    for i = 1, #fishablesProbability, 1 do
        if fishablesProbability[i] >= fishableDecider then
            if self.fishableObjects[allowedFishables[i]].enabled then
                return self.fishableObjects[allowedFishables[i]];                
            else
                return self:determineFishable(allowedFishables, fishablesProbability);
            end
        end
    end
end

--- Returns the table of the fishable objects.
-- @return Returns the table of the fishable objects.
function SwarmFactory:getFishableObjects()
    return self.fishableObjects;
end

return SwarmFactory;
