-- The class Level contains all informations about the world/level
-- @param backgroundPath The relative path to the picture
-- @param winDim The dimensions of the window
local Level = Class{
    init = function(self, backgroundPath, winDim, direction)
        self.bg = love.graphics.newImage(backgroundPath);
        self.bg:setWrap("repeat", "repeat");
        self.backgroundPath = backgroundPath;
        self.winDim = winDim;
        self.posY = (winDim[2] / 2);  --startpos
        self.direction = direction;
        self.bgq = love.graphics.newQuad(0, 0, winDim[1], 20000, 
            self.bg:getWidth(), self.bg:getHeight());
    end,
    posY = 0;
    direction = 1; -- -1 means up and 1 means down
    bg = nil;
    bgq = nil;
    winDim = {};
    lowerBoarder = -1000;   -- if you want deeper you should decrease this value!
    upperBoarder = 1000;    -- if you want higher you should increase this value!
};

-- Update the game state. Called every frame.
-- @param dt Delta time  is the amount of seconds since the 
-- last time this function was called.
-- @param bait The bait object, which stands for the user.
function Level:update(dt, bait)
    if self.direction == 1 and self.posY > self.lowerBoarder 
    and self.posY < self.upperBoarder then
        self.sizeY = self.winDim[2] + math.ceil(dt * bait.speed);
        self.posY = self.posY - math.ceil(dt * bait.speed);
    end
end

-- Draw on the screen. Called every frame.
-- @param bait The bait object, which stands for the user.
function Level:draw(bait)
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(self.bg, self.bgq, 0, self.posY);
    bait:draw();
end

-- Set a new background image for the world
-- @param backgroundPath The relative path to the picture
function Level:changeImage(backgroundPath)
    self.backgroundPath = backgroundPath;
    self.background = love.graphics.newImage(backgroundPath);
end;

-- Set the value for the lower boarder
-- @param newBoarderVal The new lower boarder value
function Level:setLowerBoarder(newBoarderVal)
    self.lowerBoarder = newBoarderVal;
end;

-- Returns the value of the actual lower boarder
-- @return Returns the value of the actual lower boarder
function Level:getLowerBoarder()
    return self.lowerBoarder;
end;

-- Set the direction of the current Level.
-- @param direction Stands for the direction. 1 means down and -1 means up
function Level:setDirection(direction)
    self.direction = direction;
end;

-- Returns the direction of the current map.
-- @return 1 means down and -1 means up all and 
-- other values stands for an error.
function Level:getDirection()
    return self.direction;
end;

return Level;