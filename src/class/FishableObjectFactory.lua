--- The class FishableObjectFactory creates the fishable objects

FishableObject = require "FishableObject";

local FishableObjectFactory = Class {
    init = function(self)
    end;
};

-- Creates a new FishableObject
-- @param yPosition height of the object in the level
-- @param minSpeed lowest amount of speed possible
-- @param maxSpeed highest amount of speed possible
-- @param xHitbox width of the hitbox
-- @param yHitbox height of the hitbox
-- @param value amount of money earned by fishing this object
-- @param hitpoints amount of the hitpoints of the object
function FishableObjectFactory:create(yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints)
    FishableObject(yPosition, minSpeed, maxSpeed, xHitbox, yHitbox, value, hitpoints);
end

return FishableObjectFactory;
