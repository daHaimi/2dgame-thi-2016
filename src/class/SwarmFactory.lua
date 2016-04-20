--- The class Swarm creates the swarms of fishable objects

FishableObjectFactory = require "FishableObjectFactory";

local Swarm = Class {
    --- Initializes the swarm class
    -- @param level The current level
    -- @param player The player object
    init = function(self, level, player)
        levelDirection = level.getDirection();
        playerSpeed = player.getSpeed();
    end;
};

--- Creates a new swarm
-- @param amount amount of fishable objects in the swarm
-- @param density density of the fishable objects
function Swarm:createSwarm(amount, density)
    for i = 0, amount, 1 do
        FishableObjectFactory.create();
    end
end

return Swarm;
