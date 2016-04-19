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
-- x1 and y1 are the coordinates of the bait
-- x2 and y2 are the coordinates of the upper left corner of the object
-- h and w are the height and width of the object
function CollisionDetection:calculateCollision ( x1, y1, x2, y2, h, w )
    if x1 >= x2 and x1 <= x2 + w and y1 >= y2 and y1 <= y2 + h then
        self.collision = true;
    end
    return self.collision;
end