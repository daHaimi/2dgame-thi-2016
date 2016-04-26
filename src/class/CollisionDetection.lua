--- Class for CollisionDetection

Class = require "lib.hump.class";

local CollisionDetection = Class {
    init = function(self)
    end;
    collision = false;
};

--- Setter for collision
function CollisionDetection:setCollision(newCollision)
    self.collision = newCollision;
end

--- Getter for collision
function CollisionDetection:getCollision ()
    return self.collision;
end

--- This function checks if the bait collides with an object.
-- The border of the object counts for the collision.
-- xBait is the x-coordinate of the bait
-- xObject is the leftmost x-coordinate of the object
-- w is the width of the object
function CollisionDetection:calculateCollision ( xBait, xObject, w )
    if xBait >= xObject and xBait <= xObject + w then
        self.collision = true;
    end
    return self.collision;
end

return CollisionDetection;