Class = require "lib.hump.class";
CollisionDetection = require "class.CollisionDetection";

--- Class for the Bait swimming for Phase 1 and 2
-- @param winDim window Size
--
local Bait = Class {
    init = function(self, winDim)
        self.winDim = winDim;
        self.posXBait = (winDim[1] / 2) - (self.size / 2);
        local yPos = (self.winDim[2] / 2) - (self.size / 2);
    end;
    size = 10;
    speed = 200;
    posXMouse = 0;
    posXBait = 0;
    maxSpeedX = 20;
    winDim = {};
    life = 1;
    money = 0;
};

--- TODO need balancing
-- a function to check wich upgrades are active for the bait
function Bait:checkUpgrades()
    if _G._persTable.upgrades.moreLife > 0 then
        self.life = self.life + _G._persTable.upgrades.moreLife;
    end
    --- speed up while phase 1 and 2
    if _G._persTable.upgrades.speedUp > 0 then
        self.speed = self.speed * (1 + _G._persTable.upgrades.speedUp);
    end
end;

---updates the bait and checks for collisions
function Bait:update()
    self.yPos = (self.winDim[2] / 2) - (self.size / 2);
    self:setCappedPosX();
    self.xPos = self.posXBait;
    self:checkForCollision();
end

---checks for collision
function Bait:checkForCollision()
    for i = 1, #SwarmFactory.createdFishables, 1 do
        fishable = SwarmFactory.createdFishables[i];
        CollisionDetection:setCollision();
        CollisionDetection:calculateCollision(self.xPos, self.yPos, fishable.xPosition, fishable.yPosition, fishable.xHitbox, fishable.yHitbox);
        if CollisionDetection:getCollision() then
            self:collisionDetected();
        end
    end
end

---is called every time the bait hits a fishable object
function Bait:collisionDetected()
    print "collision"
end

---implements drawing interface
function Bait:draw()
    love.graphics.setColor(127, 0, 255);
    self:update();
    love.graphics.rectangle("fill", self.xPos, self.yPos, self.size, self.size);
end

--- Determines the capped X position of the Bait (SpeedLimit)
function Bait:setCappedPosX()
    local delta = self.posXMouse - self.posXBait;
    local posX;
    if delta > self.maxSpeedX then
        posX = self.posXBait + self.maxSpeedX;
    elseif delta < self.maxSpeedX * (-1) then
        posX = self.posXBait - self.maxSpeedX;
    else
        posX = self.posXMouse;
    end
    self.posXBait = posX;
end

--- Returns the actual X position of the Bait
-- @return The actual X position of the Bait
function Bait:getPosX()
  return self.posXBait;
end

return Bait;
