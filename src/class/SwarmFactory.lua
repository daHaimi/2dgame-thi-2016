--- The class SwarmFactory creates swarms of fishable objects defined by data.lua
FishableObject = require "class.FishableObject";
require "socket" math.randomseed(socket.gettime() * 10000);

local SwarmFactory = Class {
    --- Initializes the swarm factory
    -- @param data The path and name of the data file
    -- @param levelManager Reference to the level manager object
    init = function(self, data, levelManager)
        --initializing of the member variables. Please add all new variables in the destructor!
        self.levMan = nil;
        self.maxDepth = -5000;
        self.currentSwarm = 1;
        self.fishableObjects = {};
        self.createdFishables = {};
        self.actualSwarm = {};
        
        self.levMan = levelManager;
        
        self.maxDepth = self.levMan:getCurLevel():getLowerBoarder() - 2 * _G._persTable.winDim[2];        
        self.fishableObjects = data.fishableObjects;
        if self.levMan:getCurLevel():getLevelName() == "sewers" then
            self.actualSwarm = data.swarmsSewer;
        elseif self.levMan:getCurLevel():getLevelName() == "canyon" then
            self.actualSwarm = data.swarmsCanyon;
        end
        
        for k,v in pairs(self.fishableObjects) do
            if _G._persTable.enabled[k] == nil then
                self.fishableObjects[k].enabled = true;
            else
                self.fishableObjects[k].enabled = _G._persTable.enabled[k];
            end
        end
        
        -- Start at the lower 75% of the screen to create swarms
        local addedHeights = 0.0;
        addedHeights = self.levMan:getCurLevel().winDim[2] *0.75;
        while addedHeights <= -self.maxDepth do
            addedHeights = addedHeights + self:createNextSwarm(addedHeights);
        end
    end;
};

--- Marks the member variables for the garbage collector
function SwarmFactory:destructSF()
    self.levMan = nil;
    self.maxDepth = nil;
    self.currentSwarm = nil;
    self.fishableObjects = nil;
    self.createdFishables = nil;
    self.actualSwarm = nil;
end

--- Draws all fishables
function SwarmFactory:draw()
    for i = 1, #self.createdFishables, 1 do
        self.createdFishables[i]:draw();
    end
end

--- Updates all fishables
-- @param dt Delta time since last update in seconds
function SwarmFactory:update(dt)
    for i = 1, #self.createdFishables, 1 do
        self.createdFishables[i]:update(dt);
    end
end

--- Creates the next swarm
-- @param startPosY Start y position of the swarm
-- @return Returns a random value.
function SwarmFactory:createNextSwarm(startPosY)
    if self.actualSwarm[self.currentSwarm].maxSwarmHeight < startPosY then
        self.currentSwarm = self.currentSwarm + 1;
    end
    
    local newSwarm = self.actualSwarm[self.currentSwarm];
    local fishable = self:determineFishable(newSwarm.allowedFishables, newSwarm.fishablesProbability);
    
    local amountFishables = math.random(fishable.minAmount, fishable.maxAmount);
 
    for i = 1, amountFishables, 1 do
        local yPos = math.random(fishable.swarmHeight);
        
        self.createdFishables[#self.createdFishables + 1] = FishableObject(fishable.name, fishable.image, startPosY + 
            yPos, fishable.minSpeed, fishable.maxSpeed, fishable.value, fishable.hitpoints, fishable.spriteSize,            fishable.hitbox, fishable.animTimeoutMin, fishable.animTimeoutMax, fishable.animType);
    end
    
    return math.random(fishable.swarmHeight * 0.9 , fishable.swarmHeight); -- to enable 2 swarms to overlap
end

--- Determines the next fishable to create
-- @param allowedFishables Fishables to consider
-- @param fishablesProbability Creation probabilities for the fishables
-- @return The fishable to create
function SwarmFactory:determineFishable(allowedFishables, fishablesProbability)
    local fishableDecider = math.random(100);
    
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

--- Returns the created fishable objects.
-- @return Returns the table of created fishable objects.
function SwarmFactory:getCreatedFishables()
    return self.createdFishables;
end

return SwarmFactory;