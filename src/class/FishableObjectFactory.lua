--- The class FishableObjectFactory creates the fishable objects
local FishableObjectFactory = Class {
    init = function(self)
    end;
};

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
end

return FishableObjectFactory;
