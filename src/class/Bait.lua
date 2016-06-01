Class = require "lib.hump.class";
CollisionDetection = require "class.CollisionDetection";
Level = require "class.Level";
Animate = require "class.Animate";

--- Class for the Bait swimming for Phase 1 and 2
-- @param winDim window Size
-- @param levelManager The reference to the level manager object
local Bait = Class {
    init = function(self, winDim, levelManager)
        
        -- Initialize the member variables
        self.levMan = nil;
        self.size = 10;
        self.speed = 200;
        self.posXMouse = 0;
        self.xPos = 0;
        self.maxSpeedX = 20;
        self.winDim = {};
        self.life = 1;
        self.money = 0;
        self.numberOfHits = 0;
        self.hitFishable = 0;
        _G._tmpTable.caughtThisRound = {};
        self.sleepingPillDuration = 0;
        self.deltaTime = 0;
        self.modifier = 0.5;
        self.goldenRuleLowerPoint = 0.32;
        self.goldenRuleUpperPoint = 0.68;
        self.image = nil;
        self.pullIn = false;
        
        
        self.winDim = winDim;
        self.xPos = (winDim[1] / 2) - (self.size / 2);
        self.levMan = levelManager;
        --local yPos = (self.winDim[2] / 2) - (self.size / 2); -- FIXME unused local
        local img = love.graphics.newImage("assets/sprites/sprite_hamster.png");
        if img == 0 then
            self.image = nil;
        else 
            self.image = Animate(img, 3, 1, .08, Animate.AnimType.bounce);
        end
        self.posXMouse = (winDim[1] / 2) - (self.size / 2);
    end
};
--- 
-- a function to check wich upgrades are active for the bait
function Bait:checkUpgrades()
    -- Checks if more life upgrade is availible
    -- doesnt work if oneMoreLife isnt bought before twoMoreLife
    if _G._persTable.upgrades.oneMoreLife then
        _G._persTable.upgrades.moreLife = 1;
        if _G._persTable.upgrades.twoMoreLife then
            _G._persTable.upgrades.moreLife = 2;
            if _G._persTable.upgrades.threeMoreLife then
                _G._persTable.upgrades.moreLife = 3;
            end
        end
    end
    --- speed up while phase 1 and 2
    if _G._persTable.upgrades.firstSpeedUp then
        self.speed = self.speed + 200;
    end
    
    if _G._persTable.upgrades.secondSpeedUp then
        self.speed = self.speed + 200;
    end
    
end

--- updates the bait and checks for collisions
-- @param dt Delta time is the amount of seconds since the last time this function was called.
function Bait:update(dt)
    oldXPos = self.xPos;

    -- update animation
    if self.image ~= nil then
        self.image:update(dt);
    end

    -- calculate modifier for the golden rule
    if self.levMan:getCurLevel():getDirection() == 1 then
        self.modifier = self:changeModifierTo(self.goldenRuleLowerPoint);
    elseif self.levMan:getCurLevel():getDirection() == -1 and
            self.levMan:getCurLevel():getYPos() < self.winDim[2] * 0.2 then
        self.modifier = self:changeModifierTo(self.goldenRuleUpperPoint);
    elseif self.levMan:getCurLevel():getDirection() == -1 and
            self.levMan:getCurLevel():getYPos() > self.winDim[2] * 0.2 then
        self.pullIn = true;
        self.modifier = self:changeModifierTo(0.5);
    else
        self.modifier = self:changeModifierTo(0.5);
    end

    self.yPos = (self.winDim[2] * self.modifier) - (self.size / 2);
    self.xPos = self.xPos + self:capXMovement();
    self.xPos = self:capXPosition();
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

function Bait:capXPosition()
    local leftBound = 58;
    local rightBound = 422;
    if self.pullIn then
        local m = 142 / (self.winDim[2] * 0.2);
        leftBound = 58 + m * (self.levMan:getCurLevel():getYPos() - self.winDim[2] * 0.23);
        rightBound = 422 - m * (self.levMan:getCurLevel():getYPos() - self.winDim[2] * 0.23);
    end
    if leftBound > rightBound then
        return self.winDim[2] / 2;
    elseif self.xPos > rightBound then
        return rightBound;
    elseif self.xPos < leftBound then
        return leftBound;
    else
        return self.xPos;
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
    local moved = self.levMan:getCurLevel():getMoved();
    local directionOfMovement = 0;
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
-- @param fishable the fishable object hit
-- @param index index of the fishable object hit
function Bait:collisionDetected(fishable, index)
    -- sleeping Pill hit
    if fishable:getName() == "sleepingPill" then
        self:sleepingPillHit();
        self.levMan:getCurSwarmFactory().createdFishables[index]:setToCaught();
        -- other fishable object hit and no godMode active
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
function Bait:sleepingPillHit()
    for i = 1, #self.levMan:getCurSwarmFactory().createdFishables, 1 do
        self.levMan:getCurSwarmFactory().createdFishables[i]:setSpeedMultiplicator(_G._persTable.upgrades.sleepingPillSlow);
    end
    self.sleepingPillDuration = self.sleepingPillDuration + _G._persTable.upgrades.sleepingPillDuration;
end

--- implements drawing interface
function Bait:draw()
    local Shaders = require "class.Shaders";
    if self.levMan:getCurLevel():getGodModeStat() ~= 0 then
        Shaders:hueAjust(0.5);
    end
    self:drawLine();
    self.image:draw(self.xPos - 32, self.yPos - 39); -- FIXME magic number
    Shaders:clear();
end

--- draws the line of the Hamster
function Bait:drawLine()
    local image = love.graphics.newImage("assets/Line.png");
    local angle = 0;
    local length = math.sqrt (self.xPos * self.xPos + self.yPos * self.yPos);
    
    angle = math.atan((self.xPos - 0.5 * self.winDim[1]) / (self.levMan:getCurLevel():getYPos() - self.winDim[2] * self.modifier - 100));
    love.graphics.translate(self.xPos, self.yPos);
    love.graphics.rotate(angle);
    love.graphics.translate(- self.xPos, - self.yPos);
    for i = 1, length, 1 do
        if not (i * 9 > length) then
            love.graphics.draw(image, self.xPos, self.yPos - 40 - 9 * i);
        end
    end

    love.graphics.translate(self.xPos, self.yPos);
    love.graphics.rotate(-angle);
    love.graphics.translate(-self.xPos, -self.yPos);
end

--- Determines the capped X position of the Bait (SpeedLimit)
function Bait:capXMovement()
    local result = 0;
    if self.levMan:getCurLevel():isFinished() == 0 then
        local delta = self.posXMouse - self.xPos;
        local posX;
        
        if delta > self.maxSpeedX then
            result = self.maxSpeedX;
        elseif delta < self.maxSpeedX * (-1) then
            result =  - self.maxSpeedX;
        elseif math.abs(delta) < self.maxSpeedX then
            result =  delta;
        end
    end
    return result;
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
    return self.xPos;
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
