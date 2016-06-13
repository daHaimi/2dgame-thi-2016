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
        self.currentSwarm = 1;
        self.fishableObjects = {};
        self.createdFishables = {};
        self.createdBubbles ={};
        self.actualSwarm = {};
        self.speedMulitplicator = 1;
        self.addedDepth = 0;
        self.positionOfLastPill = 0;
        self.positionOfLastLitter = 0;
        self.positionOfLastBubbles = 0;
        self.levMan = levelManager;
        -- Start at the lower 75% of the screen to create swarms
        self.addedHeights = self.levMan:getCurLevel().winDim[2] * 0.75;

        self.fishableObjects = data.fishableObjects;
        if self.levMan:getCurLevel():getLevelName() == "sewers" then
            self.actualSwarm = data.swarmsSewer;
        elseif self.levMan:getCurLevel():getLevelName() == "canyon" then
            self.actualSwarm = data.swarmsCanyon;
        end

        for k, _ in pairs(self.fishableObjects) do
            if _G._persTable.enabled[k] == nil then
                self.fishableObjects[k].enabled = true;
            else
                self.fishableObjects[k].enabled = _G._persTable.enabled[k];
            end
        end
    end;
};

--- creates more Swarms
-- @param depth depth where the swarm should spawned
function SwarmFactory:createMoreSwarms(depth)
    while self.addedHeights <= depth + self.levMan:getCurLevel().winDim[2] do
        self.addedHeights = self.addedHeights + self:createNextSwarm(self.addedHeights, depth);
    end
end

--- creats a sleepingpill
-- @param depth depth where the pill should be spawned
-- @param minDistance minimal distance between two pills
-- @param maxDistance maximal distance between two pills
function SwarmFactory:createSleepingpill(depth, minDistance, maxDistance)
    if depth > self.positionOfLastPill + math.random(maxDistance - minDistance) + minDistance then
        local fishable = self.fishableObjects["sleepingPill"];
        self.createdFishables[#self.createdFishables + 1] = FishableObject(fishable.name, fishable.image,
            depth + self.levMan:getCurLevel().winDim[2], fishable.minSpeed, fishable.maxSpeed, fishable.value,
            fishable.hitpoints, fishable.spriteSize, fishable.hitbox, fishable.animTimeoutMin, fishable.animTimeoutMax,
            fishable.animType, 0, self.levMan);
        self.positionOfLastPill = depth;
    end
end

--- creats some bubbles
--@param depth depth where the bubble should be spawned
--@param minDistance minimal distance between two "swarms" of bubbles
--@param maxDistance maximal distance between two "swarms" of bubbles
function SwarmFactory:createBubbles(depth, dt, time)
    self.positionOfLastBubbles = self.positionOfLastBubbles + dt;
    if self.positionOfLastBubbles > time then
        local fishable = self.fishableObjects["bubble"];
        local amount = math.random(fishable.minAmount, fishable.maxAmount);
        local xPosition = math.random(fishable.spriteSize + 26,
            self.levMan:getCurLevel().winDim[1] - 58 - fishable.spriteSize);
        for i = 1, amount, 1 do
            self.createdBubbles[#self.createdBubbles + 1] = FishableObject(fishable.name, fishable.image,
                depth + self.levMan:getCurLevel().winDim[2], fishable.minSpeed, fishable.maxSpeed, fishable.value,
                fishable.hitpoints, fishable.spriteSize, fishable.hitbox, fishable.animTimeoutMin,
                fishable.animTimeoutMax, fishable.animType, fishable.downSpeed, self.levMan);
            self.createdBubbles[#self.createdBubbles]:setYPosition(self.levMan:getCurLevel().winDim[2]
                - math.random(100));
            self.createdBubbles[#self.createdBubbles]:setXPosition(xPosition + math.random(-50, 50));
        end
        self.positionOfLastBubbles = self.positionOfLastBubbles - time;
    end
end

--- creats falling litter
-- @param depth depth where the pill should be spawned
-- @param minDistance minimal distance between two peaces of litter
-- @param maxDistance maximal distance between two peaces of litter
function SwarmFactory:createFallingLitter(depth, minDistance, maxDistance)
    if math.abs(depth - self.positionOfLastLitter) > math.random(maxDistance - minDistance) + minDistance
            and self.actualSwarm[self.currentSwarm].typ == "static" then
        self.positionOfLastLitter = depth;
        local fishable = self:determineFishable({ "camera", "backpack", "drink" }, { 33, 67, 100 });
        self.createdFishables[#self.createdFishables + 1] = FishableObject(fishable.name, fishable.image,
            depth, fishable.minSpeed, fishable.maxSpeed, fishable.value,
            fishable.hitpoints, fishable.spriteSize, fishable.hitbox, fishable.animTimeoutMin, fishable.animTimeoutMax,
            fishable.animType, fishable.downSpeed, self.levMan);
    end
end

--- Marks the member variables for the garbage collector
function SwarmFactory:destructSF()
    self.levMan = nil;
    self.currentSwarm = nil;
    self.fishableObjects = nil;
    self.createdFishables = nil;
    self.actualSwarm = nil;
end

--- Draws all fishables
function SwarmFactory:draw()
    for i = 1, #self.createdBubbles, 1 do
        self.createdBubbles[i]:draw();
    end
    for i = 1, #self.createdFishables, 1 do
        self.createdFishables[i]:draw();
    end
end

--- Updates all fishables
-- @param dt Delta time since last update in seconds
function SwarmFactory:update(dt)
    for i = 1, #self.createdFishables, 1 do
        self.createdFishables[i]:update(dt, self.speedMulitplicator, depth);
    end

    for i = 1, #self.createdBubbles, 1 do
        self.createdBubbles[i]:update(dt, 1, depth);
    end

    if self.currentSwarm > 1 and self.levMan:getCurLevel():getDirection() == -1 then
        if -self.levMan:getCurLevel():getYPos() - self.actualSwarm[self.currentSwarm - 1].maxSwarmHeight
                + self.levMan:getCurLevel().winDim[2] * 0.5 < 0 then
            self.currentSwarm = self.currentSwarm - 1;
        end
    end
end

--- Creates the next swarm
-- @param startPosY Start y position of the swarm
-- @return Returns a random value.
function SwarmFactory:createNextSwarm(startPosY, depth)
    if self.actualSwarm[self.currentSwarm].maxSwarmHeight < startPosY - self.addedDepth then
        self.currentSwarm = self.currentSwarm + 1;
        if self.currentSwarm > #self.actualSwarm then
            self.currentSwarm = 1;
            self.addedDepth = self.actualSwarm[#self.actualSwarm].maxSwarmHeight + self.addedDepth;
        end
    end

    local newSwarm = self.actualSwarm[self.currentSwarm];
    local fishable = self:determineFishable(newSwarm.allowedFishables, newSwarm.fishablesProbability);

    local amountFishables = math.random(fishable.minAmount, fishable.maxAmount);

    for i = 1, amountFishables, 1 do
        local yPos = math.random(fishable.swarmHeight) + startPosY - depth;
        local downSpeed;
        if fishable.downSpeed ~= nil then
            downSpeed = fishable.downSpeed;
        else
            downSpeed = 0;
        end

        self.createdFishables[#self.createdFishables + 1] = FishableObject(fishable.name, fishable.image, yPos,
            fishable.minSpeed, fishable.maxSpeed, fishable.value, fishable.hitpoints, fishable.spriteSize,
            fishable.hitbox, fishable.animTimeoutMin, fishable.animTimeoutMax, fishable.animType, downSpeed, self.levMan);
    end

    return math.random(fishable.swarmHeight * 0.9, fishable.swarmHeight); -- to enable 2 swarms to overlap
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

--- sets the speed multiplicator to a certain amount
-- @param amount prozentage of the slow. 0.25 for slow to 25%
function SwarmFactory:setSpeedMultiplicator(amount)
    self.speedMulitplicator = amount;
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
