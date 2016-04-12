-- The class World contains all informations about the 
-- @param backgroundPath The relative path to the picture
-- @param windowDimensions The dimensions of the window
local World = Class{
    init = function(self, backgroundPath, windowDimensions)
        self.background = backgroundPath;
        self.windowDimensions = windowDimensions;
        curLevel = Level(love.graphics.newImage("backgroundPath"), windowDimensions);
    end;
    curLevel = Level(love.graphics.setBackgroundColor(255, 255, 255));
    windowDimensions = {};
    lowerBoarder = Math.inf; -- only for the beginning! Change this to a balanced value.
    upperBoarder = 0;
};

-- Set a new background image for the world
-- @param backgroundPath The relative path to the picture
function World:changeImage(backgroundPath)
    curLevel = Level(love.graphics.newImage("backgroundPath"), windowDimensions);
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