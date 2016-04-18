--- The class FishableObjectFactory creates the fishable objects
local FishableObjectFactory = Class {
    init = function(self)
    end;
};

--- Creates a new fishable object
-- @param entityType The type of the entity to create
-- @param speed The speed of the entity
-- @param spawnX The x coordinate of the spawn point
-- @param spawnY The y coordinate of the spawn point
-- @param direction The moving direction of the entity
-- @param healthPoints The health points of the entity
-- @param money The value of the entity
function FishableObjectFactory:create(entityType, speed, spawnX, spawnY, direction, healthPoints, money)
    if     entityType == "angler"    then print("creating angler fish");
    elseif entityType == "crocodile" then print("creating crocodile");
    else                                  error("Unknown entity type");
    end
end

return FishableObjectFactory;
