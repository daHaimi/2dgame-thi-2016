Class = require "lib.hump.class";
require "lib/light"

_G.math.inf = 1 / 0;

--- The class Level contains all informations about the world/level
-- @param backgroundPath The relative path to the picture
-- @param winDim The dimensions of the window
-- @param direction The y direction (-1 means up and 1 means down)
-- @param swarmFactory The swarm factory
local Level = Class {
    init = function(self, levelName, backgroundPath, winDim, direction, levelManager)
        -- Member variables
        self.playTime = 0;
        self.levMan = nil;
        self.p_levelName = "";
        self.levelFinished = false; -- 0 means the round hasn´t been finished until yet
        self.gotPayed = 0; -- 0 means the amount of money hasn´t calculated until yet
        self.roundValue = 0; -- the amount of money fished in this round
        self.posY = 0;
        self.direction = 1; -- (-1) means up and 1 means down
        self.bg = nil;
        self.bgq = nil;
        self.winDim = {};
        self.lowerBoarder = -7000; -- if you want deeper you should decrease this value!
        self.upperBoarder = 1000; -- if you want higher you should increase this value!
        self.mapBreakthroughBonus1 = -1000;
        self.mapBreakthroughBonus2 = -1000;
        -- list for objekts caught at this round
        self.oldPosY = _G.math.inf;
        self.godModeFuel = 0;
        self.shortGMDist = 0;
        self.godModeActive = false;
        self.moved = 0;
        self.gMMusicPlaying = false;
        self.reachedDepth = 0;
        
        self.levMan = levelManager;
        self.direction = direction;
        self.p_levelName = levelName;
        self.bg = love.graphics.newImage(backgroundPath);
        if self.bg ~= nil then -- do not remove this if statement or busted will crash
        self.bg:setWrap("repeat", "repeat");
        end;
        self.backgroundPath = backgroundPath;
        self.winDim = winDim;
        self.posY = (winDim[2] * 0.5); --startpos
        --self.direction = self.direction * direction;
        if self.bg ~= nil then -- do not remove this if statement or busted will crash
        self.bgq = love.graphics.newQuad(0, 0, winDim[1], 20000, self.bg:getWidth(), self.bg:getHeight());
        end
        if _persTable.upgrades.mapBreakthrough1 == true then
            self.lowerBoarder = self.lowerBoarder + self.mapBreakthroughBonus1;
        end
        if _persTable.upgrades.mapBreakthrough2 == true then
            self.lowerBoarder = self.lowerBoarder + self.mapBreakthroughBonus2;
        end
        if _persTable.upgrades.godMode == true then
            self.godModeFuel = 800;
            if _persTable.upgrades.moreFuel1 == true then
                self.godModeFuel = 1600;
                if _persTable.upgrades.moreFuel2 == true then
                    self.godModeFuel = 2400;
                end
            end
        end
        _G._tmpTable.roundFuel = self.godModeFuel;
        
        --Animation parameters
        self.animationStart = false;
        self.animationStartFinished = false;
        self.animationEnd = false;
        self.animationEndFinished = false;
        self.hamsterYPos = 0;
        self.animationStartPoint = self.winDim[2] / 2 - 270;
        self.hamsterYPos = self.animationStartPoint - 30;
        self.hamsterLockedXPos = 0;
        self.enviromentPosition = 0;
        self.borderHeight = 200;
        self.waitTillSwitch = 0.5;
        self.pumpCounter = 0;
        self.pumpDirection = true; -- true = down

        -- create light world
        self.lightWorld = love.light.newWorld();

        local time = tonumber(os.date("%M"));
        local minLightLevel = 81;
        local maxLightLevel = 174;
        local lightLevel = ((math.abs(30 - time)) / 30) * maxLightLevel + minLightLevel;
        
        self.lightWorld.setAmbientColor(lightLevel, lightLevel, lightLevel);

        self.baitLight = self.lightWorld.newLight(1, 1, 255, 127, 63, 500);
        self.baitLight.setSmooth(2);

        -- temp bugfix to play the game with persistence
        -- delete when non persistent table exists
        _G._persTable.phase = 1;
        
        --elements to draw
        
        if self.p_levelName == "sewers" then
            self.borderLeft = love.graphics.newImage("assets/left.png");
            self.borderRight = love.graphics.newImage("assets/right.png");
            self.background = love.graphics.newImage("assets/toilet_whole.png");
            self.background2 = love.graphics.newImage("assets/toilet_bg.png");
            self.front = love.graphics.newImage("assets/toilet_lowerHalf.png");
            self.plunger = love.graphics.newImage("assets/poempel.png");
            self.frontOffset = 180;
        elseif self.p_levelName == "canyon" then
            self.borderLeft = love.graphics.newImage("assets/canyon_left.png");
            self.borderRight = love.graphics.newImage("assets/canyon_right.png");
            self.background = love.graphics.newImage("assets/canyon_back.png");
            self.background2 = love.graphics.newImage("assets/canyon_back.png");
            self.front = love.graphics.newImage("assets/canyon_front.png");
            self.frontOffset = 375;
        end
        
        self.hamster = love.graphics.newImage("assets/hamster_noLine.png");
        self.line = love.graphics.newImage("assets/line.png");
        self.hand = love.graphics.newImage("assets/hand.png");
        self.borderBottom = love.graphics.newImage("assets/border.png");
        self.lowerBorderPosition = math.abs(self.lowerBoarder) + self.winDim[2] * 0.68 + 130;
        
        --parameters for achievements
        self.failedStart = false;
        --parameter for loading the game
        self.gameLoaded = true;

    end
}

--- Marks the member variables for the garbage collector
function Level:destructLevel()
    self.levMan = nil;
    self.p_levelName = nil;
    self.levelFinished = nil;
    self.gotPayed = nil;
    self.roundValue = nil;
    self.posY = nil;
    self.direction = nil;
    self.bg = nil;
    self.bgq = nil;
    self.winDim = nil;
    self.lowerBoarder = nil;
    self.upperBoarder = nil;
    self.mapBreakthroughBonus1 = nil;
    self.mapBreakthroughBonus2 = nil;
    self.oldPosY = nil;
    self.godModeFuel = nil;
    self.shortGMDist = nil;
    self.godModeActive = nil;
    self.moved = nil;
    self.time = nil;
    self.gMMusicPlaying = nil;
    self.enviromentPosition = nil;
    self.reachedDepth = nil;
end

--- Update the game state. Called every frame.
-- @param dt Delta time is the amount of seconds since the
-- last time this function was called.
-- @param bait The bait object, which stands for the user.
function Level:update(dt, bait)
    self.moved = 0;
    --set the direction in relation of the yPosition
    if self.posY <= self.lowerBoarder then
        self:switchToPhase2();
    elseif self.posY >= (self.winDim[2] * 0.5) and self.direction == -1 then
        self.direction = 0;
        self.levelFinished = true;
        self:payPlayer();
    end
    --dynamic creation of swarms
    self.levMan:getCurSwarmFactory():createMoreSwarms( - (self.posY - self.winDim[2] * 0.5));

    --set the movement in relation of the direction
    if not self.animationStartFinished  then
        self.moved = 0;
    elseif self.direction == 1 then
        self.moved = math.ceil(dt * bait:getSpeed());
        self.playTime = self.playTime + dt;
    elseif self.direction == -1 then
        self.moved = -math.ceil(dt * bait:getSpeed());
        self.playTime = self.playTime + dt;
    end

    --do the ingame movement
    if not (FishableObject == nil) then
        FishableObject:setYMovement(self.moved);
    end
    self.sizeY = self.winDim[2] + self.moved;
    self.posY = self.posY - self.moved;
    self.lowerBorderPosition = self.lowerBorderPosition - self.moved;

    self:checkGodMode();
    bait:update(dt);
    
    --do the animation movement
    self:doStartAnimationMovement(bait, dt);
    self:startEndAnimation();
    self:doEndAnimationMovement(bait, dt);
    if self.animationEndFinished then
        self.waitTillSwitch = self.waitTillSwitch - dt;
    end
    
    --Update music
    if self.godModeActive and not self.gMMusicPlaying then
        TEsound.playLooping({ "assets/sound/godMode.wav" }, 'godmode');
        self.gMMusicPlaying = true;
    elseif not self.godModeActive then
        TEsound.stop('godmode');
        self.gMMusicPlaying = false;
    end
    
    --Update the light
    self.baitLight.setPosition(self.posY or 0, self.posX or 0);
    self.lightWorld:update();
    
    -- update the currentDepth
    _G._tmpTable.currentDepth = self.posY;
    
    -- calc fished Value
    if self.levelFinished then
        _G._tmpTable.earnedMoney = self:calcFishedValue();
        _G._persTable.playedTime = _G._persTable.playedTime + self.playTime;
    end
    self:checkForAchievments()
end

--- checks if a new achievement is unlocked
function Level:checkForAchievments()
    if self.failedStart and self.levelFinished and not _G._persTable.achievements.failedStart then
        self:unlockAchievement("failedStart");
    end
    if self.levelFinished and _G._tmpTable.caughtThisRound.shoe == 2 
    and not _G._persTable.achievements.caughtTwoBoots 
    and self:calcFishedValue() == self.levMan:getCurSwarmFactory():getFishableObjects().shoe.value * 2 then
         self:unlockAchievement("caughtTwoBoots");
    end
    if self.levelFinished and next(_G._tmpTable.caughtThisRound) == nil and not self.failedStart
    and not _G._persTable.achievements.nothingCaught then
        self:unlockAchievement("nothingCaught");
    end
    if self.levelFinished and not _G._persTable.achievements.allLevelBoardersPassed 
    and _persTable.upgrades.mapBreakthrough1 == true and _persTable.upgrades.mapBreakthrough2 == true 
    and self.reachedDepth <= self.lowerBoarder then
        self:unlockAchievement("allLevelBoardersPassed");
    end
    if self.levelFinished and not _G._persTable.achievements.getFirtsObject 
    and next(_G._tmpTable.caughtThisRound) ~= nil then
        self:unlockAchievement("getFirtsObject");
    end
    if self.levelFinished and not _G._persTable.achievements.playedTime 
    and _G._persTable.playedTime > (2*60*60) then
        self:unlockAchievement("playedTime");
    end
end

--- Unlocks the given achievement.
-- @param achName The name of the achievement.
function Level:unlockAchievement(achName)
    table.insert(_G._unlockedAchievements, _G.data.achievements[achName]);
    _gui:newNotification("assets/gui/480px/" .. _G.data.achievements[achName].image_unlock, 
        _G.data.achievements[achName].name);
    _G._persTable.achievements[achName] = true;
end

--- calculates the momement an positioning of all elements needed for the ending animation
--@param bai curBait
--@param dt delta time
function Level:doEndAnimationMovement(bait, dt)
    if self.levelFinished and not self.failedStart then
        if self.p_levelName == "sewers" then
            if self.pumpCounter < 4 then
                if self.pumpDirection then
                    self.pumpingWay = self.pumpingWay - 5;
                    if self.pumpingWay == 0 then
                        self.pumpDirection = false;
                    end
                else
                    self.pumpingWay = self.pumpingWay + 10;
                    if self.pumpingWay == 100 then
                        self.pumpDirection = true;
                        self.pumpCounter = self.pumpCounter + 1
                    end
                end
            else
                if self.pumpingWay < 200 then
                    self.pumpingWay = self.pumpingWay + 15
                else
                    self.animationEndFinished = true;
                end
            end
        else
            if self.winDim[2] / 2 - 300 < self.hamsterYPos then
                self.hamsterYPos = self.hamsterYPos - math.ceil(dt * bait:getSpeed());
            else
                self.animationEndFinished = true;
            end
        end
    end
end

--- calculates the momement an positioning of all elements needed for the starting animation
--@param bai curBait
--@param dt delta time
function Level:doStartAnimationMovement(bait, dt)
    if self.animationStart and not self.animationStartFinished then
        if self.p_levelName == "sewers" then
            -- hamster dropped on frame of toilet
            if  self.hamsterLockedXPos < 120 and self.hamsterLockedXPos > 65 or 
                self.hamsterLockedXPos < 355 and self.hamsterLockedXPos > 300 then
                if self.hamsterYPos < self.winDim[2] * 0.5 - 230 then
                    self.hamsterYPos = self.hamsterYPos + 0.5 * math.ceil(dt * bait:getSpeed());
                    self.failedStart = true;
                else
                    self.levelFinished = true;
                end
            else
                --hamster not dropped on frame of the toilet
                if self.hamsterYPos < self.winDim[2] * 0.4 then
                    self.hamsterYPos = self.hamsterYPos + 0.5 * math.ceil(dt * bait:getSpeed());
                    -- hamster dropped next to toilet
                    if self.hamsterLockedXPos < 120 or self.hamsterLockedXPos > 300 then
                        self.failedStart = true;
                    end
                else
                    --hamster dropped in toilet
                    if self.hamsterLockedXPos > 120 and self.hamsterLockedXPos < 300 then
                        self.animationStartFinished = true;
                    else
                        self.levelFinished = true;
                    end
                end
            end
        else
            --canyon
           if self.hamsterYPos < self.winDim[2] * 0.55 then
                self.hamsterYPos = self.hamsterYPos + 0.5 * math.ceil(dt * bait:getSpeed());
            else
                self.animationStartFinished = true;
            end
        end
    end
    if not self.levelFinished then
        self.hamsterYPos = self.hamsterYPos - self:getMoved();
        self.animationStartPoint = self.animationStartPoint - self:getMoved();
        --print(self.hamsterYPos);
    end
end

--- when the bait hit a object or the boarder is reached, start phase 2
function Level:switchToPhase2()
    if _G._persTable.phase == 1 then
        self.direction = -1;
        _G._persTable.phase = 2;
        self.reachedDepth = self.posY;
        self:deactivateGodMode();
        self.levMan:getCurPlayer():changeSprite();
        
        -- for ending animation in sewers
        if self.p_levelName == "sewers" then
            self.hamsterLockedXPos = 208;
            self.pumpingWay = 100;
        end
    end
end

--- Draw on the screen. Called every frame.
-- Draws the background and the bait on the screen.
-- @param bait The bait object, which stands for the user.
function Level:draw(bait)
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(self.bg, self.bgq, 0, self.posY);
    bait:draw();
    if self.levelFinished and self.waitTillSwitch < 0 then
        _gui:changeFrame(_gui:getFrames().score);
        --self:printResult();
    end
end

--- draws the enviroment like borders
function Level:drawEnviroment()
    local xPosHamster = 0;
    self.enviromentPosition = self.enviromentPosition - self:getMoved();

    self.lightWorld.drawShadow();
    
    love.graphics.setColor(255, 255, 255);

    --border bottom
    love.graphics.draw(self.borderBottom, 0, self.lowerBorderPosition);


    if self.enviromentPosition < -self.borderHeight then
        self.enviromentPosition = self.enviromentPosition + self.borderHeight;
    elseif self.enviromentPosition > self.borderHeight then
        self.enviromentPosition = self.enviromentPosition - self.borderHeight;
    end
    for i = 0, self.winDim[2] / self.borderHeight + 2, 1 do
        love.graphics.draw(self.borderLeft, 0, (i - 1) * self.borderHeight + self.enviromentPosition);
        love.graphics.draw(self.borderRight, 454, (i - 1) * self.borderHeight + self.enviromentPosition);
    end

    love.graphics.draw(self.background2, 0, self.posY - 474);
    love.graphics.draw(self.background, 0, self.posY - 375);
    if self.failedStart then
        self.front = love.graphics.newImage("assets/toilet_bowl.png");
    end

    --animation
    if self.p_levelName == "sewers" and self.animationStart then
        xPosHamster = self.hamsterLockedXPos;
    else
        xPosHamster = self.levMan:getCurPlayer():getPosXMouse() - 32;
    end
    -- befor starting a animation
    if not self.animationStart then
        love.graphics.draw(self.hamster, self.levMan:getCurPlayer():getPosXMouse() - 32, self.hamsterYPos);
        self:drawLine(self.levMan:getCurPlayer():getPosXMouse() - 32, 100);
        love.graphics.draw(self.hand, self.levMan:getCurPlayer():getPosXMouse() - 48, self.animationStartPoint - 220);
    -- while starting animation in sewers or while playing canyon
    elseif self.direction == 1 or self.p_levelName == "canyon" then
        love.graphics.draw(self.hand, xPosHamster - 16, self.animationStartPoint - 220);
        self:drawLine(xPosHamster, 300);
        if self.hamsterYPos < self.animationStartPoint + 130 or self.failedStart 
            or self.hamsterYPos < self.animationStartPoint + 200 and self.p_levelName == "canyon" then
            love.graphics.draw(self.hamster, xPosHamster, self.hamsterYPos);
        end
        --ending animation for sewer
    elseif (self.direction == -1 or self.levelFinished) and self.p_levelName == "sewers" then
        love.graphics.draw(self.hamster, xPosHamster, self.hamsterYPos - self.pumpingWay);
        love.graphics.draw(self.plunger, xPosHamster - 32, self.hamsterYPos - 170 - self.pumpingWay);
    end
    
    love.graphics.draw(self.front, 0, self.posY - self.frontOffset);
    
end

--- Draws the line
function Level:drawLine(position, length)
    local p_dist = (self.hamsterYPos - (self.animationStartPoint - 40));
    local p_toMuch = 0;
    while p_dist > length do
        p_dist = p_dist - 9;
        p_toMuch = p_toMuch + 9
    end
    for i = 9, p_dist, 9 do
        love.graphics.draw(self.line, position + 30, self.hamsterYPos - p_toMuch - i);
    end
end
--- Pay the achieved money to the player and multiply it with the
-- bonus value (when activated) at the end of each round. Remove the money multi when it was activated.
function Level:payPlayer()
    -- check if the round has been finished
    if self.levelFinished and self.levMan:getCurSwarmFactory() ~= nil then
        if self.gotPayed == 0 then -- check if the earned money was already payed
        local fishedVal = self:calcFishedValue();
        if _G._persTable.upgrades.firstPermanentMoneyMult == true then
            self.roundValue = self:multiplyFishedValue(1.2, fishedVal);
        end
        if _G._persTable.upgrades.secondPermanentMoneyMult == true then
            self.roundValue = self:multiplyFishedValue(1.25, fishedVal);
        end
        if _G._persTable.upgrades.moneyMult == true then
            self.roundValue = self:multiplyFishedValue(2, fishedVal);
            self.gotPayed = 1;
            _G._persTable.upgrades.moneyMult = false;
        else
            self.roundValue = fishedVal;
            self.gotPayed = 1;
        end
        -- persist money from this round
        if self.roundValue >= 0 then
            _G._persTable.money = _G._persTable.money + self.roundValue;
            _G._persistence:updateSaveFile();
        end
        end
    end
end

--- Check the state of the god mode and updates the god mode fuel and shortGMDist value.
function Level:checkGodMode()
    if self.godModeActive then
        if self.shortGMDist > 0 then
            self:reduceShortGMDist();
        else
            if self.oldPosY == _G.math.inf then
                self.oldPosY = self.posY;
            else
                self.godModeFuel = self.godModeFuel - math.abs(self.moved);
                _G._tmpTable.roundFuel = self.godModeFuel;
                if self.godModeFuel < 0 then
                    self:deactivateGodMode();
                end
            end
        end
    end
end

--- Activates the god mode after a collision.
-- @param dt Delta time is the amount of seconds since the last time
-- the update function was called.
-- @param speed The speed of the player.
function Level:activateShortGM(dt, speed)
    if self.direction == self.levMan:getLevelPropMapByName(self.p_levelName).direction then
        local tempGMTime = 0.8;
        self.shortGMDist = math.ceil((dt * speed) * (tempGMTime / dt));
        self.oldPosY = _G.math.inf;
        self.godModeActive = true;
    end
end

--- Reduce the distance of the short god mode
-- and deactivate it when the distance was moved
function Level:reduceShortGMDist()
    if self.oldPosY == _G.math.inf then
        self.oldPosY = self.posY;
    else
        self.shortGMDist = self.shortGMDist - math.abs(self.posY - self.oldPosY);
        self.oldPosY = self.posY;
    end

    -- reset the oldPosY for the real god mode when the shortGM ends
    if self.shortGMDist <= 0 then
        self.oldPosY = _G.math.inf;
        self.shortGMDist = 0;
        self:deactivateGodMode();
    end
end

--- Try to activate the god Mode.
-- @return When the god mode was successfully activated it returns 1 otherwise 0.
function Level:activateGodMode()
    if _G._persTable.upgrades.godMode and not self.godModeActive and
    self.direction == self.levMan:getLevelPropMapByName(self.p_levelName).direction then
        if self.godModeFuel > 0 then
            self.godModeActive = true;
        end
    end

end

--- Deactivates the god mode.
function Level:deactivateGodMode()
    self.godModeActive = false;
end

--- Calculates the value of the fished objects and adds amount to persTable.
-- @return Returns the value of all fished objects.
function Level:calcFishedValue()
    local fishedVal = 0;
    local fishedAmount = 0;
    for name, amount in pairs(_G._tmpTable.caughtThisRound) do
        if amount > 0 then
            fishedVal = fishedVal + self.levMan:getCurSwarmFactory():getFishableObjects()[name].value * amount;
            -- for achivements
            _G._persTable.fish.caught[name] = _G._persTable.fish.caught[name] + amount;
            _G._persTable.fish.caughtTotal = _G._persTable.fish.caughtTotal + amount;
            fishedAmount = fishedAmount + amount
        end
    end
    -- for achivement x caught in one round
    if fishedVal > _G._persTable.statistic.maxCoinOneRound then
        _G._persTable.statistic.maxCoinOneRound = fishedVal;
    end
    
    if fishedVal < _G._persTable.statistic.minCoinOneRound then
        _G._persTable.statistic.minCoinOneRound = fishedVal;
    end
    
    if fishedAmount > _G._persTable.fish.caughtInOneRound then
        _G._persTable.fish.caughtInOneRound = fishedAmount;
    end
    _G._persTable.statistic.moneyEarnedTotal = _G._persTable.statistic.moneyEarnedTotal + fishedAmount;
    return (fishedVal);
end

--- Calculate the amount of money with the given multiply bonus (round up).
-- @param multy The factor of the bonus.
-- @param fishedValue The value of the fished objects for one round.
-- @return The amount of money.
function Level:multiplyFishedValue(multy, fishedValue)
    return math.ceil(fishedValue * multy);
end

--- Returns the amount of the fuel for the god mode
-- @return Returns the amount of the fuel for the god mode
function Level:getGodModeFuel()
    return self.godModeFuel;
end

--- Set the fuel for the god mode to the new value.
-- Is newFuel <= 0, the god mode will be deactivated.
function Level:setGodModeFuel(newFuel)
    self.godModeFuel = newFuel;
    if self.godModeFuel <= 0 then
        self.godModeActive = false;
    end
end

--- Returns the state of the god mode.
-- @return Returns 1 when the god mode was activated. Otherwise 0.
function Level:getGodModeStat()
    return self.godModeActive;
end

--- Set the value for the lower boarder.
-- @param newBoarderVal The new lower boarder value.
function Level:setLowerBoarder(newBoarderVal)
    self.lowerBoarder = newBoarderVal;
end

--- Returns the value of the actual lower boarder.
-- @return Returns the value of the actual lower boarder.
function Level:getLowerBoarder()
    return self.lowerBoarder;
end

--- Set the value for the upper boarder.
-- @param newBoarderVal The new upper boarder value.
function Level:setUpperBoarder(newBoarderVal)
    self.upperBoarder = newBoarderVal;
end

--- Returns the value of the actual upper boarder.
-- @return Returns the value of the actual upper boarder.
function Level:getUpperBoarder()
    return self.upperBoarder;
end

--- Set the direction of the current Level.
-- @param direction Stands for the direction. 1 means down and -1 means up
function Level:setDirection(direction)
    self.direction = direction;
end

--- Returns the direction of the current map.
-- @return 1 means down and -1 means up all and
-- other values stands for an error.
function Level:getDirection()
    return self.direction;
end

--- Returns the current y position.
-- @return Returns the current y position.
function Level:getYPos()
    return self.posY;
end

--- Return the state of the level.
-- @return Returns 1 when the level has been finished otherwise 0.
function Level:isFinished()
    return self.levelFinished;
end

--- adds the caught Objekt to the caughtThisRound table with amount
-- @param name The name of the fishable object.
function Level:addToCaught(name)
    -- add the first
    if _G._tmpTable.caughtThisRound[name] == nil then
        _G._tmpTable.caughtThisRound[name] = 0;
    end;
    _G._tmpTable.caughtThisRound[name] = _G._tmpTable.caughtThisRound[name] + 1;
end

--- Call this function to make known that the player has stopped the god mode
function Level:resetOldPosY()
    self.oldPosY = _G.math.inf;
end

--- Displays the amount and value of the caught objects
function Level:printResult()
    local xpos = 0;
    local ypos = 120;
    love.graphics.setColor(0, 0, 0, 255);
    love.graphics.print("Caught objects in this round:", xpos, ypos);
    if next(_G._tmpTable.caughtThisRound) ~= nil then
        local string;
        for k, v in pairs(_G._tmpTable.caughtThisRound) do
            ypos = ypos + 15;
            string = k .. ": " .. v .. " x " ..
                    self.levMan:getCurSwarmFactory():getFishableObjects()[k].value .. " Coins";
            love.graphics.print(string, xpos, ypos);
        end
        ypos = ypos + 15;
        love.graphics.print("Earned: " .. self:calcFishedValue() .. " Coins", xpos, ypos);
    else
        ypos = ypos + 15;
        love.graphics.print("Nothing caught", xpos, ypos);
    end
end

--- Returns the amount of pixels moved in y direction.
-- @return Returns the amount of pixels moved in y direction.
function Level:getMoved()
    return self.moved;
end

--- Returns the daytime in the game.
-- @return Returns "day" if the daytime in the game is day otherwise "night".
function Level:getTime()
    return self.time;   
end

--- Returns the name/type of the level.
-- @return Returns the name/type of the level.
function Level:getLevelName()
    return self.p_levelName;
end

--- Returns true if the start animation is running (started and not finished)
function Level:getStartAnimationRunning()
    return self.animationStart and not self.animationStartFinished;
end

--- returns true if the start animation is Finished
function Level:getStartAnimationFinished()
    return self.animationStartFinished;
end

--- starts the Start Animation
function Level:startStartAnimation()
    self.animationStart = true;
    self.hamsterLockedXPos = self.levMan:getCurPlayer():getPosXMouse() - 32;
end

function Level:startEndAnimation()
    if self.levelFinished and not self.animationEnd and not self.failedStart then
        self.animationEnd = true;
    end
    if self.levelFinished and self.failedStart then
        self.animationEnd = true;
        self.animationEndFinished = true;
    end
end

--- returns true if the level is fully loaded
function Level:isLoaded()
    if self.gameLoaded ~= nil then
        return self.gameLoaded;
    else
        return false;
    end
end

--- Returns the reached depth before phase 2 was activated.
-- @return Returns the reached depth.
function Level:getReachedDepth()
    return self.reachedDepth;
end

return Level;
