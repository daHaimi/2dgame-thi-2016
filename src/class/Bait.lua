Class = require "lib.hump.class";
CollisionDetection = require "class.CollisionDetection";
Level = require "class.Level";

--- Class for the Bait swimming for Phase 1 and 2
-- @param winDim window Size
--
local Bait = Class {
    init = function(self, winDim)
        self.winDim = winDim;
        self.posXBait = (winDim[1] / 2) - (self.size / 2);
        local yPos = (self.winDim[2] / 2) - (self.size / 2); -- FIXME unused local
    end;
    size = 10;
    speed = 200;
    posXMouse = 0;
    posXBait = 0;
    maxSpeedX = 20;
    winDim = {};
    life = 1;
    money = 0;
    numberOfHits = 0;
    hittedFishable = 0;
    caughtThisRound = {};
    sleepingPillDuration = 0;
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
end

--- updates the bait and checks for collisions
function Bait:update()
    self.yPos = (self.winDim[2] / 2) - (self.size / 2);
    self:setCappedPosX();
    self.xPos = self.posXBait;
    self:checkForCollision();
    
    if self.sleepingPillDuration > 0 then
        self.sleepingPillDuration = self.sleepingPillDuration - math.abs(FishableObject:getYMovement());
    else
        self.sleepingPillDuration = 0;
        FishableObject:setSpeedMultiplicator(1);
    end
end

--- checks for collision
function Bait:checkForCollision()
    for i = 1, #SwarmFactory.createdFishables, 1 do
        if SwarmFactory.createdFishables[i].drawIt then
            local fishable = SwarmFactory.createdFishables[i];
            CollisionDetection:setCollision();
            CollisionDetection:calculateCollision(self.xPos, self.yPos, fishable:getHitboxXPosition(),
                fishable:getHitboxYPosition(), fishable:getHitboxWidth(), fishable:getHitboxHeight());
            if CollisionDetection:getCollision() then
                self:collisionDetected(fishable, i);
            end
        end
    end
end

--- is called everytime the bait hits a fishable object
-- @param fishable the fishable object hitted
-- @param index index of the fishable object hitted
function Bait:collisionDetected(fishable, index)
    if not (self.hittedFishable == index) then

        self.hittedFishable = index;
        if fishable:getName() == "sleepingPill" then
            self:sleepingPillHitted(FishableObject);
            SwarmFactory.createdFishables[index].drawIt = false;
        else
            if self.numberOfHits >= _G._persTable.upgrades.moreLife or _G._persTable.phase == 2 then
                SwarmFactory.createdFishables[index].drawIt = false;
                Level:switchToPhase2();
                Level:addToCaught(fishable.name);
            end
            self.numberOfHits = self.numberOfHits + 1;
        end
    end
end

--- is called everytime the bait hits a sleeping pill
function Bait:sleepingPillHitted(FishableObject)
    FishableObject:setSpeedMultiplicator(_G._persTable.upgrades.sleepingPillSlow);
    self.sleepingPillDuration = self.sleepingPillDuration + _G._persTable.upgrades.sleepingPillDuration;
end

--- implements drawing interface
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
