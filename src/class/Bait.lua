Class = require "lib.hump.class";
CollisionDetection = require "class.CollisionDetection";
Level = require "class.Level";

--- Class for the Bait swimming for Phase 1 and 2
-- @param winDim window Size
--
local Bait = Class {
    init = function(self, winDim, level)
        self.winDim = winDim;
        self.posXBait = (winDim[1] / 2) - (self.size / 2);
        self.curLevel = level;
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
    curLevel = nil;
    deltaTime = 0;
    modifier = 0;
    goldenRuleLowerPoint = 0.32;
    goldenRuleUpperPoint = 0.68;
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
-- @param dt Delta time is the amount of seconds since the last time this function was called.
function Bait:update(dt)
    -- calculate modifier for the golden rule
    if self.curLevel:getDirection() == 1 then
       
        self.modifier = self.goldenRuleLowerPoint;
    else
      
        if self.modifier < self.goldenRuleUpperPoint then
            self.modifier = self.modifier - self.curLevel.moved /self.winDim[2];
        else
            self.modifier = self.goldenRuleUpperPoint;
        end
    end
    
    self.yPos = (self.winDim[2] * self.modifier) - (self.size / 2);
    self:setCappedPosX();
    self.xPos = self.posXBait;
    self.deltaTime = dt;
    self:checkForCollision(#self.curLevel:getSwarmFactory().createdFishables);
    
    -- decrease or deativate sleeping pill
    if self.sleepingPillDuration > 0 then
        self.sleepingPillDuration = self.sleepingPillDuration - math.abs(self.curLevel:getMoved());
    else
        self.sleepingPillDuration = 0;
        FishableObject:setSpeedMultiplicator(1);
    end
end

--- checks for collision
-- @param CollisionDetection class of the collision detection
function Bait:checkForCollision(numberOfFishables)
    for i = 1, numberOfFishables, 1 do
        if not self.curLevel:getSwarmFactory().createdFishables[i].caught then
            local fishable = self.curLevel:getSwarmFactory().createdFishables[i];
            for c = 1, #fishable.hitbox, 1 do
                CollisionDetection:setCollision();
                CollisionDetection:calculateCollision(self.xPos, self.yPos, fishable:getHitboxXPosition(c),
                    fishable:getHitboxYPosition(c), fishable:getHitboxWidth(c), fishable:getHitboxHeight(c));
                if CollisionDetection:getCollision() then
                    self:collisionDetected(fishable, i);
                end
            end
        end
    end
end

--- is called everytime the bait hits a fishable object
-- @param fishable the fishable object hitted
-- @param index index of the fishable object hitted
function Bait:collisionDetected(fishable, index)
    -- sleeping Pill hitted
    if fishable:getName() == "sleepingPill" then
        self:sleepingPillHitted(FishableObject);
        SwarmFactory.createdFishables[index]:setToCaught();
    -- other fishable object hitted and no godMode active
    elseif self.curLevel:getGodModeStat() == 0 then
        -- still lifes left
        if self.numberOfHits < _G._persTable.upgrades.moreLife then
            self.numberOfHits = self.numberOfHits + 1;
            self.curLevel:activateShortGM(self.deltaTime, self.speed);
        else
        -- no more lifes left
            self.curLevel:switchToPhase2();
        end
        -- while phase 2
        if self.curLevel:getDirection() == -1 then
            SwarmFactory.createdFishables[index]:setToCaught();
            self.curLevel:addToCaught(fishable.name);
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
    if self.curLevel:getGodModeStat() == 0 then
        love.graphics.setColor(127, 0, 255);
    else
        love.graphics.setColor(255, 0, 0);
    end
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

--- Set a new level reference
function Bait:setLevel(newLevel)
    self.curLevel = newLevel;
end

function Bait:getGoldenRule()
    return self.goldenRuleLowerPoint, self.goldenRuleUpperPoint;
end

return Bait;
