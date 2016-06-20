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
        self.pillDuration = {0,0,0};
        self.deltaTime = 0;
        self.modifier = 0.5;
        self.goldenRuleLowerPoint = 0.32;
        self.goldenRuleUpperPoint = 0.68;
        self.image = nil;
        self.imageCheeks = nil;
        self.quadCheeks = nil;
        self.timeShowMouth = 0;
        self.pullIn = false;


        self.winDim = winDim;
        self.xPos = (winDim[1] / 2) - (self.size / 2);
        self.levMan = levelManager;
        self.yPos = (self.winDim[2] / 2) - (self.size / 2); -- FIXME unused local
        local img = love.graphics.newImage("assets/sprites/sprite_hamster.png");
        self.imgUp = love.graphics.newImage("assets/sprites/sprite_hamster_up.png");
        self.imageCheeks = love.graphics.newImage("assets/sprites/sprite_cheeks.png");
        self.imageMouth = love.graphics.newImage("assets/nomnom.png");
        self.line = love.graphics.newImage("assets/line.png");
        if img == 0 then
            self.image = nil;
        else
            self.image = Animate(img, 3, 1, .08, Animate.AnimType.bounce);
        end
        self.posXMouse = (winDim[1] / 2) - (self.size / 2);
    end
};

--- Marks the member variables for the garbage collector
function Bait:destructBait()
    self.levMan = nil;
    self.size = nil;
    self.speed = nil;
    self.posXMouse = nil;
    self.xPos = nil;
    self.maxSpeedX = nil;
    self.winDim = nil;
    self.life = nil;
    self.money = nil;
    self.numberOfHits = nil;
    self.hitFishable = nil;
    self.caughtThisRound = nil;
    self.pillDuration = nil;
    self.deltaTime = nil;
    self.modifier = nil;
    self.goldenRuleLowerPoint = nil;
    self.goldenRuleUpperPoint = nil;
    self.image = nil;
    self.pullIn = nil;
    self.imageCheeks = nil;
    self.quadCheeks = nil;
end

--- a function to check wich upgrades are active for the bait
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
    local oldXPos = self.xPos;

    -- update animation
    if self.image ~= nil then
        self.image:update(dt);
    end

    -- update Bait cheeks
    if self.hitFishable ~= nil then
        local dimX, dimY = self.imageCheeks:getDimensions();
        if self.hitFishable > 20 then
            self.quadCheeks = love.graphics.newQuad(2 * dimX / 3, 0, dimX / 3, dimY, dimX, dimY);
        elseif self.hitFishable > 15 then
            self.quadCheeks = love.graphics.newQuad(dimX / 3, 0, dimX / 3, dimY, dimX, dimY);
        elseif self.hitFishable > 5 then
            self.quadCheeks = love.graphics.newQuad(0, 0, dimX / 3, dimY, dimX, dimY);
        end
    end
    
    if self.timeShowMouth > 0 then
        self.timeShowMouth = self.timeShowMouth - dt;
    end

    -- calculate modifier for the golden rule
    if self.levMan:getCurLevel():getDirection() == 1 then
        self.modifier = self:changeModifierTo(self.goldenRuleLowerPoint);
    elseif self.levMan:getCurLevel():getDirection() == -1 and
            self.levMan:getCurLevel():getYPos() < self.winDim[2] * 0.2 then
        self.modifier = self:changeModifierTo(self.goldenRuleUpperPoint);
    else
        self.modifier = self:changeModifierTo(0.5);
    end

    self.yPos = (self.winDim[2] * self.modifier) - (self.size / 2);
    self.xPos = self.xPos + self:capXMovement();
    self.xPos = self:capXPosition();
    self.deltaTime = dt;
    self:checkForCollision(self.levMan:getCurSwarmFactory().createdFishables, oldXPos);

    -- decrease or deativate pills
    for i = 1, #self.pillDuration, 1 do 
        if self.pillDuration[i] > 0 then
            self.pillDuration[i] = self.pillDuration[i] - dt;
        elseif self.pillDuration[i] < 0 then
            self.pillDuration[i] = 0;
            self:resetPill(i);
        end
    end
end

function Bait:resetPill(i)
    if i == 1 or i == 2 then
        self.levMan:getCurSwarmFactory():setSpeedMultiplicator(1);
    elseif i == 3 then
        self.levMan:getCurSwarmFactory():resetNyan();
    end
end

function Bait:capXPosition()
    local leftBound = 58;
    local rightBound = 422;
    if self.levMan:getCurLevel():getYPos() > self.winDim[2] * 0.2
            and (self.levMan:getCurLevel():getLevelName() == "sewers" or 
                self.levMan:getCurLevel():getLevelName() == "sewersEndless" or 
                self.levMan:getCurLevel():getLevelName() == "sleepingCrocos") then
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
    local yPos = self.yPos

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
    self.timeShowMouth = 0.3;
    -- sleeping Pill hit
    if fishable:getName() == "sleepingPill" then
        self:sleepingPillHit();
        self.levMan:getCurSwarmFactory().createdFishables[index]:setToCaught();
    -- coffee hit
    elseif fishable:getName() == "coffee" then
        self:coffeeHit();
        self.levMan:getCurSwarmFactory().createdFishables[index]:setToCaught();
    -- rainbowPill Hit
    elseif fishable:getName() == "rainbowPill" then
        self:rainbowPillHit();
        self.levMan:getCurSwarmFactory().createdFishables[index]:setToCaught();
    -- other fishable object hit and no godMode active
    elseif not self.levMan:getCurLevel():getGodModeStat() then
        -- still lifes left
        if self.numberOfHits <= _G._persTable.upgrades.moreLife then
            self.numberOfHits = self.numberOfHits + 1;
            self.levMan:getCurLevel():activateShortGM(self.deltaTime, self.speed);
        end
        _gui:getFrames().inGame.elementsOnFrame.healthbar:minus();
        -- no more lifes left
        if self.numberOfHits > _G._persTable.upgrades.moreLife then
            self.levMan:getCurLevel():switchToPhase2();
        end
    end
    -- removes fishable (explosion animation)
    if self.levMan:getCurLevel():getGodModeStat() then
        self.levMan:getCurSwarmFactory().createdFishables[index]:setDestroyed();
    end
    -- while phase 2
    if self.levMan:getCurLevel():getDirection() == -1 and not fishable.caught then
        self.levMan:getCurSwarmFactory().createdFishables[index]:setToCaught();
        self.levMan:getCurLevel():addToCaught(fishable.name);
        self.hitFishable = self.hitFishable + 1;
    end
end

--- is called everytime the bait hits a sleeping pill
function Bait:sleepingPillHit()
    self.levMan:getCurSwarmFactory():setSpeedMultiplicator(_G._persTable.upgrades.sleepingPillSlow);
    self.pillDuration[1] = _G._persTable.upgrades.pillDuration;
end

--- is called everytime the bait hits a coffee pill
function Bait:coffeeHit()
    self.levMan:getCurSwarmFactory():setSpeedMultiplicator(_G._persTable.upgrades.coffeeSpeedup);
    self.pillDuration[2] = _G._persTable.upgrades.pillDuration;
end

function Bait:rainbowPillHit()
    self.levMan:getCurSwarmFactory():setImageToNyan();
    self.pillDuration[3] = _G._persTable.upgrades.rainbowPillDuration;
end

--- implements drawing interface
function Bait:draw()
    local Shaders = require "class.Shaders";
    if self.levMan:getCurLevel():getGodModeStat() then
        Shaders:hueAjust(0.5);
    end
    if self.levMan:getCurLevel():getLevelName() == "sewers" or 
    self.levMan:getCurLevel():getLevelName() == "sewers" or
    self.levMan:getCurLevel():getLevelName() == "sleepingCrocos" then
        self:drawLineDiagonal();
    else
        self:drawLineStraight();
    end
    self.image:draw(self.xPos - 32, self.yPos - 39); -- FIXME magic number
    if self.timeShowMouth > 0 then
        love.graphics.draw(self.imageMouth, self.xPos - 32, self.yPos - 39);
    end
    if self.quadCheeks ~= nil then
        love.graphics.draw(self.imageCheeks, self.quadCheeks, self.xPos - 32, self.yPos - 39);
    end
    Shaders:clear();
end

--- draws the line of the Hamster in the canyon
function Bait:drawLineStraight()
    local length = self.yPos
    for i = 1, length, 1 do
        if not (i * 9 > length) then
            love.graphics.draw(self.line, self.xPos, self.yPos - 40 - 9 * i);
        end
    end
end

--- draws the line of the Hamster in the sewers
function Bait:drawLineDiagonal()
    local angle;
    local length = math.sqrt(self.xPos * self.xPos + self.yPos * self.yPos);

    angle = math.atan((self.xPos - 0.5 * self.winDim[1]) / (self.levMan:getCurLevel():getYPos() - self.winDim[2] * self.modifier - 100));
    love.graphics.translate(self.xPos, self.yPos);
    love.graphics.rotate(angle);
    love.graphics.translate(-self.xPos, -self.yPos);
    for i = 1, length, 1 do
        if not (i * 9 > length) then
            love.graphics.draw(self.line, self.xPos, self.yPos - 40 - 9 * i);
        end
    end

    love.graphics.translate(self.xPos, self.yPos);
    love.graphics.rotate(-angle);
    love.graphics.translate(-self.xPos, -self.yPos);
end

--- Determines the capped X position of the Bait (SpeedLimit)
function Bait:capXMovement()
    local result = 0;
    if not self.levMan:getCurLevel():isFinished() then
        local delta = self.posXMouse - self.xPos;
        local posX;

        if delta > self.maxSpeedX then
            result = self.maxSpeedX;
        elseif delta < self.maxSpeedX * (-1) then
            result = -self.maxSpeedX;
        elseif math.abs(delta) < self.maxSpeedX then
            result = delta;
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

--- Returns the actual Y position of the Bait
-- @return The actual Y position of the Bait
function Bait:getPosY()
    return self.yPos;
end

--- Get the size of the player.
-- @return Returns the size of the player.
function Bait:getSize()
    return self.size;
end

--- sets the x position of the mouse
-- @param XPosMouse: x position the mouse position will be set to
function Bait:setPosXMouse(XPosMouse)
    self.posXMouse = math.min(422, math.max(58, XPosMouse));
end

--- returns the x position of the mouse
function Bait:getPosXMouse()
    return self.posXMouse;
end

--- returns the upper and the lower point of the golden rule
function Bait:getGoldenRule()
    return self.goldenRuleLowerPoint, self.goldenRuleUpperPoint;
end

function Bait:getSpeed()
    return self.speed;
end

function Bait:changeSprite()
    self.image = Animate(self.imgUp, 3, 1, .08, Animate.AnimType.bounce);
end

return Bait;
