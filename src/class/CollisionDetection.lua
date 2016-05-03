Class = require "lib.hump.class";

--- Class for CollisionDetection
local CollisionDetection = Class {
    init = function(self) end;
    collision = false;
};

--- Setter for collision
function CollisionDetection:setCollision(newCollision)
    self.collision = newCollision;
end

--- Getter for collision
function CollisionDetection:getCollision()
    return self.collision;
end

--- This function checks if the bait collides with an object.
-- The border of the object counts for the collision.
-- @param xBait is the x-coordinate of the bait
-- @param yBait is the y-coordinate of the bait
-- @param xObject is the leftmost x-coordinate of the objects hitbox
-- @param yObject is the upmost y-coordinate of the objects hitbox
-- @param w is the width of the objects hitbox
-- @param h is the height of the objects hitbox
function CollisionDetection:calculateCollision(xBait, yBait, xObject, yObject, w, h)
    if xBait >= xObject and xBait <= xObject + w and yBait >= yObject and yBait <= yObject + h then
        self.collision = true;
    end
    return self.collision;
end

return CollisionDetection;
