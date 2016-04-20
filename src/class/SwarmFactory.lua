--- The class SwarmFactory creates swarms of fishable objects

FishableObject = require "class.FishableObject";

local fishableObjects = {};

local SwarmFactory = Class {
    --- Initializes the SwarmFactory class
    -- @param level The current level
    -- @param player The player object
    init = function(self, level, player)
        self.level = level;
        self.player = player;

        function fishableObject(fishable) 
            fishableObjects[fishable.name] = fishable;
        end
        
        dofile("data.lua");
    end;
};

--- Creates a new swarm
-- @param amount amount of fishable objects in the swarm
function SwarmFactory:createSwarm(amount)
    for i = 0, amount, 1 do
        FishableObjectFactory.create();
    end
end

-- Creates a new FishableObject
-- @param yPosition height of the object in the level
-- @param minSpeed lowest amount of speed possible
-- @param maxSpeed highest amount of speed possible
-- @param xHitbox width of the hitbox
-- @param yHitbox height of the hitbox
-- @param value amount of money earned by fishing this object
-- @param hitpoints amount of the hitpoints of the object
function SwarmFactory:create(yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints)
    FishableObject(yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints);
end

return SwarmFactory;
