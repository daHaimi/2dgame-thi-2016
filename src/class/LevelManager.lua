Class = require "lib.hump.class";
Level = require "class.Level";
Bait = require "class.Bait";
SwarmFactory = require "class.SwarmFactory";

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
    p_curDataRef = nil;
    p_levelProperties = {
        sewers = {
            levelName = "sewers",
            direction = 1,
            bgPath = "assets/testbg.png";
        },
        canyon = {
            levelName = "canyon",
            direction = 1,
            bgPath = "assets/testbg.png";
        },
        space = {
            levelName = "space",
            direction = -1,
            bgPath = "assets/testbg.png";
        }
    };
}

--- Create a new level object.
-- @param backgroundPath The relative path to the picture.
-- @param direction The y direction (-1 means up and 1 means down).
-- @param swarmFactory The swarm factory of the level.
-- @return Returns a reference to the created level object.
function LevelManager:newLevel(levelPropMap, swarmFactoryData)
    for k, v in pairs(_G._tmpTable) do
        _G._tmpTable[k] = nil
    end;

    self:freeManagedObjects();
    
    self.p_curDataRef = swarmFactoryData;
    self.curLevel = Level(levelPropMap.levelName, levelPropMap.bgPath, _G._persTable.winDim, levelPropMap.direction, self);
    self.curPlayer = Bait(_G._persTable.winDim, self);
    self.curPlayer:checkUpgrades();
    self.curSwarmFac = SwarmFactory(swarmFactoryData, self);
    _gui:getFrames().inGame.elementsOnFrame.healthbar.object:resetHearts();
        
    return self.curLevel;
end

--- Creates a new level with the same leveltype as the current level.
-- @return Returns a reference to the created level object.
function LevelManager:replayLevel()
    local currentLevelType = self.curLevel:getLevelName();
    
    return self:newLevel(self:getLevelPropMapByName(currentLevelType), self.p_curDataRef);
end

--- Destroys all form the level manager managed objects.
function LevelManager:freeManagedObjects()
    if self.curSwarmFac ~= nil then
        self.curSwarmFac:destructSF();
        self.curSwarmFac = nil;
    end

    if self.curPlayer ~= nil then
        self.curPlayer:destructBait();
        self.curPlayer = nil;
    end

    if self.curLevel ~= nil then
        self.curLevel:destructLevel();
        self.curLevel = nil;
    end
    
    collectgarbage("collect");
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

--- Returns the properties table for the given level.
-- @return Returns the properties table for the given level.
function LevelManager:getLevelPropMapByName(levName)
    return self.p_levelProperties[levName];
end

return LevelManager;
