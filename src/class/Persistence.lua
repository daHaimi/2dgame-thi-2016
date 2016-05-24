Class = require("lib.hump.class");
require("lib.table_serializer");

--- Class to save the persTable data permanent 
-- it will be saved to the devices love.filesystem save directory 
local Persistence = Class{

    init = function(self)
        -- set foldername for the game data
        love.filesystem.setIdentity("hamster");
        
        self.serialize = table.serialize;
        self.deserialize = table.deserialize;
        
        -- first load of persTable
        if love.filesystem.exists("saveFile") then
            self:loadPersTable();
        else
            self:createPersTable();
            self:updateSaveFile();
        end        
end};


--- Deletes the saveFile and crates newPersTable to reset the game
-- Returns true if deleted the saveFile
-- @return boolean
function Persistence:resetGame()
    self:createPersTable();
    local _, _, flags = love.window.getMode();
    _G._persTable.winDim = { love.window.getDesktopDimensions(flags.display) };
    _G._persTable.winDim[2] = _G._persTable.winDim[2] - 150; -- Sub 50px for taskbar and window header
    _G._persTable.winDim[1] = (_G._persTable.winDim[2] / 16) * 9; -- Example: 16:9
    return love.filesystem.remove("saveFile");
    
end

--- Save the persTable data at saveFile
-- Returns true if could save
-- @return boolean
function Persistence:updateSaveFile()
    local fileData = self.serialize(_G._persTable);
    return love.filesystem.write("saveFile", fileData);
end

--- Load persTable from saveFile
function Persistence:loadPersTable()
    local fileData,_ = love.filesystem.read("saveFile");
    _G._persTable = self.deserialize(fileData);
end

--- Creates initial persTable 
function Persistence:createPersTable()
    --- globale persistance table
    _G._persTable = {
        statistic = {};
        achievements = {};
        config = {};
        fishCaught = {};
        money = 0;
        lastLevel = 1;
        winDim = {};
        phase = 1;
        enabled = {
            ring = true;
            sleepingPill = true;
        }
    };

    --- upgrades list in persTable, "0" means unbought
    _G._persTable.upgrades = {
        speedUp = 0; -- "0" no Speedup for more looke bait.lua
        moneyMult = 0; -- "0" means no additional money
        moreLife = 0; -- amount of additional lifes
        godMode = 1; -- indicates if the god mode is available or not
        mapBreakthrough1 = 0; -- can you access the first map limit? 0 = no, 1 = yes
        mapBreakthrough2 = 0; -- can you access the second map limit? 0 = no, 1 = yes
        sleepingPillDuration = 600; -- duration of the effect of the sleeping pill
        sleepingPillSlow = 0.25; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement
    };
    --[[
    _G._persTable.upgrades = {
        firstSpeedUp = false;
        secondSpeedUp = false;
        moneyMulitplier = false;
        oneMoreLife = false;
        twoMoreLife = false;
        threeMoreLife = false;
        godMode = false;
        mapBreakthrough1 = false;
        mapBreakthrough2 = false;
    }
    ]]--
    _G._persTable.achievements = {
        getFirstObject = true;
        getSecondObject = false;
    };

    --- config options
    _G._persTable.config = {
        bgm = 100;
        music = 100;
        language = "english";
    };
end

return Persistence;
