Class = require "lib.hump.class";

-- Global variables
_G.math.inf = 1 / 0;

--- The class LevelManager administrate all references to the current level 
-- the current player and swarmfactory objects.
local LevelManager = Class {
    init = function(self)
    end,
    
    curLevel = nil;
    curPlayer = nil;
    curSwarmFac = nil;
    p_LevelProperties = {
        sewers = {
            levelName = "sewers",
            direction = 1,
            bgPath = "Testpfad";
        },
        canyon = {
            levelName = "canyon",
            direction = 1,
            bgPath = "Testpfad";
        },
        space = {
            levelName = "space",
            direction = -1,
            bgPath = "Testpfad";
        }
    }
}

--- Create a new level object.
-- @param backgroundPath The relative path to the picture.
-- @param direction The y direction (-1 means up and 1 means down).
-- @param swarmFactory The swarm factory of the level.
-- @return Returns a reference to the created level object.
function LevelManager:newLevel(backgroundPath, direction, swarmFactoryData)
    self.curLevel = Level(backgroundPath, _G._persTable.winDim, direction, self);
    self.curPlayer = Bait(_G._persTable.winDim, self);
    self.curPlayer:checkUpgrades();
    self.curSwarmFac = SwarmFactory(swarmFactoryData, self);

    return self.curLevel;
end

--- Get the the current level object.
-- @return Returns the reference to the current level object.
function LevelManager:getCurLevel()
    return self.curLevel;
end

--- Get the current swarmfactory object.
-- @return Returns the reference to the current swarmfactory object.
function LevelManager:getCurSwarmFactory()
    return self.curSwarmFac;
end

--- Get the current bait/player object.
-- @return Returns the reference to the current player object.
function LevelManager:getCurPlayer()
    return self.curPlayer;
end

return LevelManager;