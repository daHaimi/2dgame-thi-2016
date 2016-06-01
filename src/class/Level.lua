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
        self.levMan = nil;
        self.p_levelName = "";
        self.levelFinished = 0; -- 0 means the round hasn´t been finished until yet
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
        self.caughtThisRound = {};
        self.oldPosY = _G.math.inf;
        self.godModeFuel = 800;
        self.shortGMDist = 0;
        self.godModeActive = 0;
        self.moved = 0;
        self.time = nil; -- day/night
        self.gMMusicPlaying = false;
        self.enviromentPosition = 0;

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

        -- create light world
        self.lightWorld = love.light.newWorld();

        if os.date("%M") < "30" then
            self.time = "day";
            self.lightWorld.setAmbientColor(255, 255, 255);
        else
            self.time = "night";
            self.lightWorld.setAmbientColor(81, 81, 81);
        end

        self.baitLight = self.lightWorld.newLight(1, 1, 255, 127, 63, 500);
        self.baitLight.setSmooth(2);

        -- temp bugfix to play the game with persistence
        -- delete when non persistent table exists
        _G._persTable.phase = 1;
    end
}

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
    self.caughtThisRound = nil;
    self.oldPosY = nil;
    self.godModeFuel = nil;
    self.shortGMDist = nil;
    self.godModeActive = nil;
    self.moved = nil;
    self.time = nil;
    self.gMMusicPlaying = nil;
    self.enviromentPosition = nil;
end

--- Update the game state. Called every frame.
-- @param dt Delta time is the amount of seconds since the
-- last time this function was called.
-- @param bait The bait object, which stands for the user.
function Level:update(dt, bait)
    --set the direction in relation of the yPosition
    if self.posY <= self.lowerBoarder then
        self:switchToPhase2();
    elseif self.posY >= (self.winDim[2] * 0.5) and self.direction == -1 then
        self.direction = 0;
        self.levelFinished = 1;
        self:payPlayer();
    end

    --set the movement in relation of the direction
    self.moved = 0;
    if self.direction == 1 then
        self.moved = math.ceil(dt * bait.speed);
    end
    if self.direction == -1 then
        self.moved = -math.ceil(dt * bait.speed);
    end

    --do the movement
    if not (FishableObject == nil) then
        FishableObject:setYMovement(self.moved);
    end
    self.sizeY = self.winDim[2] + self.moved;
    self.posY = self.posY - self.moved;

    self:checkGodMode();
    bait:update(dt);

    --Update music
    if self.godModeActive == 1 and not self.gMMusicPlaying then
        TEsound.playLooping({ "assets/sound/godMode.wav" }, 'abc');
        self.gMMusicPlaying = true;
    elseif self.godModeActive == 0 then
        TEsound.stop('abc');
        self.gMMusicPlaying = false;
    end
    self.baitLight.setPosition(self.posY or 0, self.posX or 0);
    self.lightWorld:update();
    _G._tmptable.currentDepth = self.posY;
end

--- when the bait hit a object or the boarder is reached, start phase 2
function Level:switchToPhase2()
    if _G._persTable.phase == 1 then
        self.direction = -1;
        _G._persTable.phase = 2;
        self:deactivateGodMode();
    end
end

--- Draw on the screen. Called every frame.
-- Draws the background and the bait on the screen.
-- @param bait The bait object, which stands for the user.
function Level:draw(bait)
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(self.bg, self.bgq, 0, self.posY);
    bait:draw();
    if self.levelFinished == 1 then
        _gui:changeFrame(_gui:getFrames().score);
        --self:printResult();
    end
end

--- draws the enviroment like borders
function Level:drawEnviroment()
    local topBackground = love.graphics.newImage("assets/toilet_bg.png");
    local borderLeft = love.graphics.newImage("assets/left.png");
    local borderRight = love.graphics.newImage("assets/right.png");
    local toilet = love.graphics.newImage("assets/toilet.png");

    self.enviromentPosition = self.enviromentPosition - self:getMoved();

    love.graphics.setColor(255, 255, 255);

    if self.enviromentPosition < -200 then
        self.enviromentPosition = self.enviromentPosition + 200;
    elseif self.enviromentPosition > 200 then
        self.enviromentPosition = self.enviromentPosition - 200;
    end
    for i = 0, 5, 1 do
        love.graphics.draw(borderLeft, 0, (i - 1) * 200 + self.enviromentPosition);
        love.graphics.draw(borderRight, 454, (i - 1) * 200 + self.enviromentPosition);
    end

    love.graphics.draw(topBackground, 0, self.posY - 474);
    love.graphics.draw(topBackground, 0, self.posY - 375);
    love.graphics.draw(toilet, 0, self.posY - 375);

    self.lightWorld.drawShadow();
end

--- Pay the achieved money to the player and multiply it with the
-- bonus value (when activated) at the end of each round. Remove the money multi when it was activated.
function Level:payPlayer()
    -- check if the round has been finished
    if self.levelFinished == 1 and self.levMan:getCurSwarmFactory() ~= nil then
        if self.gotPayed == 0 then -- check if the earned money was already payed
        local fishedVal = self:calcFishedValue();
        if _G._persTable.upgrades.moneyMult == true then
            self.roundValue = self:multiplyFishedValue(2.5, fishedVal);
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
    if self.godModeActive == 1 then
        if self.shortGMDist > 0 then
            self:reduceShortGMDist();
        else
            if self.oldPosY == _G.math.inf then
                self.oldPosY = self.posY;
            else
                self:setGodModeFuel(self:getGodModeFuel() - math.abs(self.posY - self.oldPosY));
                self.oldPosY = self.posY;
            end
        end
        _G._tmptable.roundFuel = self.godModeFuel;
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
        self.godModeActive = 1;
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
        self.godModeActive = 0;
    end
end

--- Try to activate the god Mode.
-- @return When the god mode was successfully activated it returns 1 otherwise 0.
function Level:activateGodMode()
    if _G._persTable.upgrades.godMode == true and self.godModeFuel > 0
            and self.godModeActive == 0 and self.direction == 1 then
        self.godModeActive = 1;
        return 1;
    else
        self.godModeActive = 0;
        self.godModeFuel = 0; -- remove negativ fuel values
        return 0;
    end
end

--- Deactivates the god mode.
function Level:deactivateGodMode()
    self.godModeActive = 0;
end

--- Calculates the value of the fished objects.
-- @return Returns the value of all fished objects.
function Level:calcFishedValue()
    local fishedVal = 0;
    for name, amount in pairs(self.caughtThisRound) do
        if amount > 0 then
            fishedVal = fishedVal + self.levMan:getCurSwarmFactory():getFishableObjects()[name].value * amount;
        end
    end
    _G._tmptable.earnedMoney = fishedVal;
    return fishedVal;
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
        self.godModeActive = 0;
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
    if self.caughtThisRound[name] == nil then
        self.caughtThisRound[name] = 0;
    end;
    self.caughtThisRound[name] = self.caughtThisRound[name] + 1;
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
    if next(self.caughtThisRound) ~= nil then
        local string;
        for k, v in pairs(self.caughtThisRound) do
            ypos = ypos + 15;
            string = k .. ": " .. v .. " x " ..
                    self.levMan:getCurSwarmFactory():getFishableObjects()[k].value .. " Coins";
            love.graphics.print(string, xpos, ypos);
        end
        ypos = ypos + 15;
        love.graphics.print("Earned: " .. self:calcFishedValue() .. " Coins", xpos, ypos);
        _G.testScore = self:calcFishedValue();
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

return Level;
