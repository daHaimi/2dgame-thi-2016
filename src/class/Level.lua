Class = require "lib.hump.class";

--- The class Level contains all informations about the world/level
-- @param backgroundPath The relative path to the picture
-- @param winDim The dimensions of the window
-- @param direction The y direction (-1 means up and 1 means down)

Class = require "lib.hump.class";

_G.math.inf = 1 / 0;

local Level = Class{
    init = function(self, backgroundPath, winDim, direction)
        self.bg = love.graphics.newImage(backgroundPath);
        if self.bg ~= nil then -- do not remove this if statement or busted will crash
        self.bg:setWrap("repeat", "repeat");
        end;
        self.backgroundPath = backgroundPath;
        self.winDim = winDim;
        self.posY = (winDim[2] / 2); --startpos
        self.direction = direction;
        if self.bg ~= nil then -- do not remove this if statement or busted will crash
        self.bgq = love.graphics.newQuad(0, 0, winDim[1], 20000, self.bg:getWidth(), self.bg:getHeight());
        end;
    end,
    posY = 0;
    direction = 1; -- (-1) means up and 1 means down
    bg = nil;
    bgq = nil;
    winDim = {};
    lowerBoarder = -2000; -- if you want deeper you should decrease this value!
    upperBoarder = 1000; -- if you want higher you should increase this value!
    mapBreakthroughBonus1 = -1000;
    mapBreakthroughBonus2 = -1000;
    -- list for objekts caught at this round
    caughtThisRound = {};
    oldPosY = _G.math.inf;
    godModeFuel = 800;  
    godModeActive = 0;
};

--- Update the game state. Called every frame.
-- @param dt Delta time is the amount of seconds since the
-- last time this function was called.
-- @param bait The bait object, which stands for the user.
function Level:update(dt, bait)
    _G._persTable.moved = 0;
    if self.direction == 1 and self.posY > self.lowerBoarder
            and self.posY < self.upperBoarder then
        _G._persTable.moved = math.ceil(dt * bait.speed);
        self.posY = self.posY - math.ceil(dt * bait.speed);
    elseif self.posY < self.upperBoarder
            and _persTable.upgrades.mapBreakthrough1 == 1 then
        self.lowerBoarder = self.lowerBoarder + self.mapBreakthroughBonus1;
        _persTable.upgrades.mapBreakthrough1 = 0;
    elseif self.posY < self.upperBoarder
            and _persTable.upgrades.mapBreakthrough1 == 0
            and _persTable.upgrades.mapBreakthrough2 == 1 then
        self.lowerBoarder = self.lowerBoarder + self.mapBreakthroughBonus2;
        _persTable.upgrades.mapBreakthrough2 = 0;
    elseif self.posY >= (self.winDim[2] / 2) and self.direction == -1 then
        bait.speed = 0;
    elseif self.posY <= self.lowerBoarder+10 or self.direction == -1 then
        _G._persTable.moved = math.ceil(dt * bait.speed * (-1));
        self.posY = self.posY - math.ceil(dt * bait.speed * (-1));
        self.direction = -1;
    end
end

--- Draw on the screen. Called every frame.
-- Draws the background and the bait on the screen.
-- @param bait The bait object, which stands for the user.
function Level:draw(bait)
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(self.bg, self.bgq, 0, self.posY);
    bait:draw();
end;

--- Check the state of the god mode and updates the god mode fuel value.
function Level:checkGodMode()
    if self.godModeActive == 1 then
        if self.oldPosY == _G.math.inf then
            self.oldPosY = self.posY;
        else
            self:setGodModeFuel(self:getGodModeFuel() - math.abs(self.posY - self.oldPosY));
            self.oldPosY = self.posY;
        end
    end
end;

--- Try to activate the god Mode.
-- @return When the god mode was successfully activated it returns 1 otherwise 0.
function Level:activateGodMode()
    if _G._persTable.upgrades.godMode == 1 and self.godModeFuel > 0 then
        self.godModeActive = 1;
        return 1;
    else
        self.godModeActive = 0;
        return 0;
    end
end

<<<<<<< HEAD
;

=======
--- Deactivates the god mode.
function Level:deactivateGodMode()
    self.godModeActive = 0;
end;

--- Returns the amount of the fuel for the god mode
-- @return Returns the amount of the fuel for the god mode
function Level:getGodModeFuel()
    return self.godModeFuel;
end;

--- Set the fuel for the god mode to the new value. 
-- Is newFuel <= 0, the god mode will be deactivated.
function Level:setGodModeFuel(newFuel)
    self.godModeFuel = newFuel;
    if self.godModeFuel <= 0 then
        self.godModeActive = 0;
    end
end;

--- Returns the state of the god mode.
-- @return Returns 1 when the god mode was activated. Otherwise 0.
function Level:getGodModeStat()
    return self.godModeActive;
end;
>>>>>>> c9257024ccd25786cddcd3c2c74f67191a2b13ee

--- Set the value for the lower boarder.
-- @param newBoarderVal The new lower boarder value.
function Level:setLowerBoarder(newBoarderVal)
    self.lowerBoarder = newBoarderVal;
end

;

--- Returns the value of the actual lower boarder.
-- @return Returns the value of the actual lower boarder.
function Level:getLowerBoarder()
    return self.lowerBoarder;
end

;

--- Set the value for the upper boarder.
-- @param newBoarderVal The new upper boarder value.
function Level:setUpperBoarder(newBoarderVal)
    self.upperBoarder = newBoarderVal;
end

;

--- Returns the value of the actual upper boarder.
-- @return Returns the value of the actual upper boarder.
function Level:getUpperBoarder()
    return self.upperBoarder;
end

;

--- Set the direction of the current Level.
-- @param direction Stands for the direction. 1 means down and -1 means up
function Level:setDirection(direction)
    self.direction = direction;
end

;

--- Returns the direction of the current map.
-- @return 1 means down and -1 means up all and
-- other values stands for an error.
function Level:getDirection()
    return self.direction;
end

;

--- Returns the current y position.
-- @return Returns the current y position.
function Level:getYPos()
    return self.posY;
end

;

--- adds the caught Objekt to the caughtThisRound table with amount
function Level:addToCaught(name)
    -- add the first
    if self.caughtThisRound[name] == nil then
        self.caughtThisRound[name] = 0;
    end;
    self.caughtThisRound[name] = self.caughtThisRound[name] + 1;
end

;

--- Call this function to make known that the player has stopped the god mode
function Level:resetOldPosY()
    self.oldPosY = _G.math.inf;
end;

return Level;