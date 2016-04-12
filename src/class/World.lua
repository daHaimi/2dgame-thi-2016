-- The class World contains all informations about the 
-- @param backgroundPath The relative path to the picture
-- @param windowDimensions The dimensions of the window
local World = Class{
    init = function(self, backgroundPath, windowDimensions)
        self.background:setWrap("repeat", "repeat");
        self.backgroundPath = backgroundPath;
        self.background = love.graphics.newImage(backgroundPath);
        self.windowDimensions = windowDimensions;
        self.posY = windowDimensions[2] / 2;
        self.bgq = love.graphics.newQuad(0, 0, windowDimensions[1], 20000, background:getWidth(), background:getHeight());
    end;
    windowDimensions = {};
    lowerBoarder = 99999; -- Math.inf; -- only for the beginning! Change this to a balanced value.
    upperBoarder = 0;
    bgq = nil;
    background = nil; --love.graphics.
    posY = 0;
    direction = 1;
};

--
function World:update(dt, bait)
    if self.direction == 1 then
        self.sizeY = self.windowDimensions[2] + math.ceil(dt * bait.speed);
        self.posY = self.posY - math.ceil(dt * bait.speed);
    end
end

function World:draw(bait)
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(self.background, self.bgq, 0, self.posY);
    bait:draw();
end


-- Set a new background image for the world
-- @param backgroundPath The relative path to the picture
function World:changeImage(backgroundPath)
    self.backgroundPath = backgroundPath;
    self.background = love.graphics.newImage(backgroundPath);
end;

-- Set the value for the lower boarder
-- @param newBoarderVal The new lower boarder value
function World:setLowerBoarder(newBoarderVal)
    self.lowerBoarder = newBoarderVal;
end;

-- Returns the value of the actual lower boarder
-- @return Returns the value of the actual lower boarder
function World:getLowerBoarder()
    return self.lowerBoarder;
end;

return World;