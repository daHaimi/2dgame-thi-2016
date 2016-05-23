Class = require "lib.hump.class";
CollisionDetection = require "class.CollisionDetection";
Level = require "class.Level";
LevelManager = require "class.LevelManager";

--- Class for the Bait swimming for Phase 1 and 2
-- @param winDim window Size
-- @param levelManager The reference to the level manager object
local Bait = Class {
    init = function(self, winDim, levelManager)
        self.winDim = winDim;
        self.posXBait = (winDim[1] / 2) - (self.size / 2);
        self.levMan = levelManager;
        local yPos = (self.winDim[2] / 2) - (self.size / 2); -- FIXME unused local
    end;
    levMan = nil;
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
    deltaTime = 0;
    modifier = 0.5;
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
    oldXPos = self.xPos;

    -- calculate modifier for the golden rule
    if self.levMan:getCurLevel():getDirection() == 1 then
        self.modifier = self:changeModifierTo(self.goldenRuleLowerPoint);
    elseif self.levMan:getCurLevel():getDirection() == -1 and
            self.levMan:getCurLevel():getYPos() < self.winDim[2] * self.goldenRuleLowerPoint then
        self.modifier = self:changeModifierTo(self.goldenRuleUpperPoint);
    else
        self.modifier = self:changeModifierTo(0.5);
    end

    self.yPos = (self.winDim[2] * self.modifier) - (self.size / 2);
    self:setCappedPosX();
    self.xPos = self.posXBait;
    self.deltaTime = dt;
    self:checkForCollision(self.levMan:getCurSwarmFactory().createdFishables, oldXPos);

    -- decrease or deativate sleeping pill
    if self.sleepingPillDuration > 0 then
        self.sleepingPillDuration = self.sleepingPillDuration - math.abs(self.levMan:getCurLevel():getMoved());
    else
        self.sleepingPillDuration = 0;
        for i = 1, #self.levMan:getCurSwarmFactory().createdFishables, 1 do
            self.levMan:getCurSwarmFactory().createdFishables[i]:setSpeedMultiplicator(1);
        end
    end
end

--- checks for collision with all fishable objects
-- @param createdFishables all fishables in this level
-- @param oldXPos the x position of the bait before the update
function Bait:checkForCollision(createdFishables, oldXPos)
    for i = 1, #createdFishables, 1 do
        local fishable = createdFishables[i];
        if (not fishable.caught) and math.abs(fishable:getHitboxYPosition(1) - self.yPos) < 150 then
            self:checkFishableForCollision(fishable, oldXPos, i);
        end
    end
end

--- checks collision with one fishable object
-- @param the fishable object
-- @param oldXPos the x position of the bait before the update
-- @param i the index of the fishable object
function Bait:checkFishableForCollision(fishable, oldXPos, index)
    moved = self.levMan:getCurLevel():getMoved();
    directionOfMovement = 0;
    yPos = self.yPos
    if oldXPos < self.xPos then
        directionOfMovement = 1;
    elseif oldXPos > self.xPos then
        directionOfMovement = -1;
    else
        directionOfMovement = 1;
        oldXPos = oldXPos - 1;
    end

    for i = oldXPos, self.xPos, directionOfMovement do
        for c = 1, #fishable.hitbox, 1 do
            CollisionDetection:setCollision();
            CollisionDetection:calculateCollision(oldXPos, yPos, fishable:getHitboxXPosition(c),
                fishable:getHitboxYPosition(c), fishable:getHitboxWidth(c), fishable:getHitboxHeight(c));
            if CollisionDetection:getCollision() then
                self:collisionDetected(fishable, index);
            end
        end
        yPos = yPos + moved / math.abs(oldXPos - self.xPos);
    end
end

--- is called everytime the bait hits a fishable object
-- @param fishable the fishable object hitted
-- @param index index of the fishable object hitted
function Bait:collisionDetected(fishable, index)
    -- sleeping Pill hitted
    if fishable:getName() == "sleepingPill" then
        self:sleepingPillHitted();
        self.levMan:getCurSwarmFactory().createdFishables[index]:setToCaught();
        -- other fishable object hitted and no godMode active
    elseif self.levMan:getCurLevel():getGodModeStat() == 0 then
        -- still lifes left
        if self.numberOfHits <= _G._persTable.upgrades.moreLife then
            self.numberOfHits = self.numberOfHits + 1;
            self.levMan:getCurLevel():activateShortGM(self.deltaTime, self.speed);
        end
        _gui:getFrames().inGame.elementsOnFrame.healthbar.object:minus();
        -- no more lifes left
        if self.numberOfHits > _G._persTable.upgrades.moreLife then
            self.levMan:getCurLevel():switchToPhase2();
        end
    end
    -- while phase 2
    if self.levMan:getCurLevel():getDirection() == -1 and not fishable.caught then
        self.levMan:getCurSwarmFactory().createdFishables[index]:setToCaught();
        self.levMan:getCurLevel():addToCaught(fishable.name);
    end
end

--- is called everytime the bait hits a sleeping pill
function Bait:sleepingPillHitted()
    for i = 1, #self.levMan:getCurSwarmFactory().createdFishables, 1 do
        self.levMan:getCurSwarmFactory().createdFishables[i]:setSpeedMultiplicator(_G._persTable.upgrades.sleepingPillSlow);
    end
    self.sleepingPillDuration = self.sleepingPillDuration + _G._persTable.upgrades.sleepingPillDuration;
end

--- implements drawing interface
function Bait:draw()
    if self.levMan:getCurLevel():getGodModeStat() == 0 then
        love.graphics.setColor(127, 0, 255);
    else
        love.graphics.setColor(255, 0, 0);
    end
    love.graphics.rectangle("fill", self.xPos - 0.5 * self.size, self.yPos - 0.5 * self.size, self.size, self.size);
end

--- Determines the capped X position of the Bait (SpeedLimit)
function Bait:setCappedPosX()
    if self.levMan:getCurLevel():isFinished() == 0 then
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
end

--- changes the modifier of the height of the bait in small steps
-- @param newModifier the modifier the bait is going to have
function Bait:changeModifierTo(newModifier)
    local result = newModifier;
    if self.modifier < newModifier then
        if self.modifier > newModifier + math.abs(self.levMan:getCurLevel():getMoved() / self.winDim[2]) then
            result = newModifier;
        else
            result = self.modifier + math.abs(self.levMan:getCurLevel():getMoved() / self.winDim[2]);
        end
    elseif self.modifier > newModifier then
        if self.modifier < newModifier + math.abs(self.levMan:getCurLevel():getMoved() / self.winDim[2]) then
            result = newModifier;
        else
            result = self.modifier - math.abs(self.levMan:getCurLevel():getMoved() / self.winDim[2]);
        end
    end
    return result
end

--- Returns the actual X position of the Bait
-- @return The actual X position of the Bait
function Bait:getPosX()
    return self.posXBait;
end

--- Get the size of the player.
-- @return Returns the size of the player.
function Bait:getSize()
    return self.size;
end

--- sets the x position of the mouse
-- @param XPosMouse: x position the mouse position will be set to
function Bait:setPosXMouse(XPosMouse)
    self.posXMouse = XPosMouse;
end

--- returns the x position of the mouse
function Bait:getPosXMouse()
    return self.posXMouse;
end

--- returns the upper and the lower point of the golden rule
function Bait:getGoldenRule()
    return self.goldenRuleLowerPoint, self.goldenRuleUpperPoint;
end

return Bait;
