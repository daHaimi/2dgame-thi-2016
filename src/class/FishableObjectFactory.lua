--- The class FishableObjectFactory creates the fishable objects

FishableObject = require "FishableObject";

local FishableObjectFactory = Class {
    init = function(self)
    end;
};

<<<<<<< HEAD
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
=======
--- Create a new FishableObject of type fObjectType
-- @param fObjectType The type of the object
-- @param yPosition Height of the object in the level
function FishableObjectFactory:create(fObjectType, yPosition)
    if fObjectType == "nemo"    
        then print("creating nemo");
    elseif fObjectType == "turtle"  
        then print("creating turtle");
    elseif fObjectType == "rat"     
        then print("creating rat");
    elseif fObjectType == "deadFish" 
        then print("creating deadFish");
    else                                  
        error("Unknown fishable object type");
    end
>>>>>>> d8dea96dd5bf869d4236e866dc9795f746abaf47
end

return FishableObjectFactory;
