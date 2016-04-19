--- The class Level contains all informations about the world/level
-- @param backgroundPath The relative path to the picture
-- @param winDim The dimensions of the window
-- @param direction The y direction (-1 means up and 1 means down)

Class = require "lib.hump.class";

local Level = Class{
    init = function(self, backgroundPath, winDim, direction)
        self.bg = love.graphics.newImage(backgroundPath);
        if self.bg ~= nil then
            self.bg:setWrap("repeat", "repeat");
        end;
        self.backgroundPath = backgroundPath;
        self.winDim = winDim;
        self.posY = (winDim[2] / 2);  --startpos
        self.direction = direction;
        if self.bgq ~= nil then 
            self.bgq = love.graphics.newQuad(0, 0, winDim[1], 20000, 
                self.bg:getWidth(), self.bg:getHeight());
        end;
    end,
    posY = 0;
    direction = 1;          -- (-1) means up and 1 means down
    bg = nil;
    bgq = nil;
    winDim = {};
    lowerBoarder = -2000;   -- if you want deeper you should decrease this value!
    upperBoarder = 1000;    -- if you want higher you should increase this value!
    mapBreakthroughBonus1 = -1000;
    mapBreakthroughBonus2 = -1000;
};

--- Update the game state. Called every frame.
-- @param dt Delta time is the amount of seconds since the 
-- last time this function was called.
-- @param bait The bait object, which stands for the user.
function Level:update(dt, bait)
    if self.direction == 1 and self.posY > self.lowerBoarder 
    and self.posY < self.upperBoarder then
        self.sizeY = self.winDim[2] + math.ceil(dt * bait.speed);
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
    end
end

--- Draw on the screen. Called every frame.
-- Draws the background and the bait on the screen.
-- @param bait The bait object, which stands for the user.
function Level:draw(bait)
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(self.bg, self.bgq, 0, self.posY);
    bait:draw();
end

--- Set the value for the lower boarder.
-- @param newBoarderVal The new lower boarder value.
function Level:setLowerBoarder(newBoarderVal)
    self.lowerBoarder = newBoarderVal;
end;

--- Returns the value of the actual lower boarder.
-- @return Returns the value of the actual lower boarder.
function Level:getLowerBoarder()
    return self.lowerBoarder;
end;

--- Set the value for the upper boarder.
-- @param newBoarderVal The new upper boarder value.
function Level:setUpperBoarder(newBoarderVal)
    self.upperBoarder = newBoarderVal;
end;

--- Returns the value of the actual upper boarder.
-- @return Returns the value of the actual upper boarder.
function Level:getUpperBoarder()
    return self.upperBoarder;
end;

--- Set the direction of the current Level.
-- @param direction Stands for the direction. 1 means down and -1 means up
function Level:setDirection(direction)
    self.direction = direction;
end;

--- Returns the direction of the current map.
-- @return 1 means down and -1 means up all and 
-- other values stands for an error.
function Level:getDirection()
    return self.direction;
end;

--- Returns the current y position.
-- @return Returns the current y position.
function Level:getYPos()
    return self.posY;
end;

return Level;
