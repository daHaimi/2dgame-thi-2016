--- The class for an entity
-- @param speed The speed of the entity
-- @param spawnX The x coordinate of the spawn point
-- @param spawnY The y coordinate of the spawn point
-- @param direction The moving direction of the entity
-- @param healthPoints The health points of the entity
-- @param money The value of the entity
local Entity = Class {
    init = function(self, speed, spawnX, spawnY, direction, healthPoints, money)
        self.speed = speed;
        self.posX = spawnX;
        self.posY = spawnY;
        self.direction = direction;
        self.healthPoints = healthPoints;
        self.money = money;
    end;
};

--- Update the entity state. Called every frame.
-- @param dt Delta time is the amount of seconds since the 
-- last time this function was called.
function Entity:update(dt)
    posX = posX + dt * speed * direction;
end

--- Draws the entity on the screen. Called every frame.
function Entity:draw()
    love.graphics.setColor(0, 255, 255);
    love.graphics.rectangle("fill", self.posX, self.posY, 10, 10);
end

return Entity;
