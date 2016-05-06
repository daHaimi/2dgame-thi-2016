Class = require "lib.hump.class";
LevelManager = require "class.LevelManager";

_G.math.inf = 1 / 0;

--- The class Level contains all informations about the world/level
-- @param backgroundPath The relative path to the picture
-- @param winDim The dimensions of the window
-- @param direction The y direction (-1 means up and 1 means down)
-- @param swarmFactory The swarm factory
local Level = Class {
    init = function(self, backgroundPath, winDim, direction, levelManager)
        self.levMan = levelManager;
        self.bg = love.graphics.newImage(backgroundPath);
        if self.bg ~= nil then -- do not remove this if statement or busted will crash
        self.bg:setWrap("repeat", "repeat");
        end;
        self.backgroundPath = backgroundPath;
        self.winDim = winDim;
        self.posY = (winDim[2] / 2); --startpos
        --self.direction = self.direction * direction;
        if self.bg ~= nil then -- do not remove this if statement or busted will crash
        self.bgq = love.graphics.newQuad(0, 0, winDim[1], 20000, self.bg:getWidth(), self.bg:getHeight());
        end
        if _persTable.upgrades.mapBreakthrough1 == 1 then
            self.lowerBoarder = self.lowerBoarder + self.mapBreakthroughBonus1;
        end
        if _persTable.upgrades.mapBreakthrough2 == 1 then
            self.lowerBoarder = self.lowerBoarder + self.mapBreakthroughBonus2;
        end
    end,

    -- Member variables
    levMan = nil;
    levelFinished = 0; -- 0 means the round hasn´t been finished until yet
    gotPayed = 0; -- 0 means the amount of money hasn´t calculated until yet
    roundValue = 0; -- the amount of money fished in this round
    posY = 0;
    direction = 1; -- (-1) means up and 1 means down
    bg = nil;
    bgq = nil;
    winDim = {};
    lowerBoarder = -7000; -- if you want deeper you should decrease this value!
    upperBoarder = 1000; -- if you want higher you should increase this value!
    mapBreakthroughBonus1 = -1000;
    mapBreakthroughBonus2 = -1000;
    -- list for objekts caught at this round
    caughtThisRound = {};
    oldPosY = _G.math.inf;
    godModeFuel = 800;
    shortGMDist = 0;
    godModeActive = 0;
    moved = 0;
}

--- Update the game state. Called every frame.
-- @param dt Delta time is the amount of seconds since the
-- last time this function was called.
-- @param bait The bait object, which stands for the user.
function Level:update(dt, bait)
    --set the direction in relation of the yPosition
    if self.posY <= self.lowerBoarder then
        self:switchToPhase2();
    elseif self.posY >= (self.winDim[2] / 2) and self.direction == -1 then
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
end

--- when the bait hit a object or the boarder is reached, start phase 2
function Level:switchToPhase2()
    if _G._persTable.phase == 1 then
        self.direction = -1;
        _G._persTable.phase = 2;
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
        self:printResult();
    end
end

--- Pay the achieved money to the player and multiply it with the
-- bonus value (when activated) at the end of each round. Remove the money multi when it was activated.
function Level:payPlayer()
    -- check if the round has been finished
    if self.levelFinished == 1 and self.levMan:getCurSwarmFactory() ~= nil then
        if self.gotPayed == 0 then -- check if the earned money was already payed
        local fishedVal = self:calcFishedValue();
        if _G._persTable.upgrades.moneyMult == 1 then
            self.roundValue = self:multiplyFishedValue(2.5, fishedVal);
            self.gotPayed = 1;
            _G._persTable.upgrades.moneyMult = 0;
        else
            self.roundValue = fishedVal;
            self.gotPayed = 1;
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
    end
end

--- Activates the god mode after a collision.
-- @param dt Delta time is the amount of seconds since the last time 
-- the update function was called.
-- @param speed The speed of the player.
function Level:activateShortGM(dt, speed)
    local tempGMTime = 0.8;
    self.shortGMDist = math.ceil((dt * speed) * (tempGMTime / dt));
    self.oldPosY = _G.math.inf;
    self.godModeActive = 1;
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
    if _G._persTable.upgrades.godMode == 1 and self.godModeFuel > 0  and self.godModeActive == 0 then
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
        local string = "";
        for k, v in pairs(self.caughtThisRound) do
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

return Level;
