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
            _G._persTable.achievements.secondStart = true;
        else
            self:createPersTable();
            self:updateSaveFile();
        end        
        
        --- creates a file or removes all contents if the file exist in order to simulate a temporary file
        -- if you want to clear the contents of the file manually use:
        -- 1) tmpfile:close();
        -- 2) tmpfile = io.open("tmp.lua", "w+");
        tmpfile = io.open("tmp.lua", "w+");
end};


--- Deletes the saveFile and crates newPersTable to reset the game
-- Returns true if deleted the saveFile
-- @return boolean
function Persistence:resetGame()
    self:createPersTable();
    local _, _, flags = love.window.getMode();
    love.graphics.setBackgroundColor(55, 80, 100);
    _G._persTable.deviceDim = {love.window.getDesktopDimensions(flags.display)};
    _G._persTable.winDim[1], _G._persTable.winDim[2], scaleFactor = getScaledDimension(_G._persTable.deviceDim);
    _G._persTable.scaledDeviceDim = {_G._persTable.winDim[1] * scaleFactor, _G._persTable.winDim[2] * scaleFactor };
    return love.filesystem.remove("saveFile");
end

function getScaledDimension(deviceDim)
    local resultDim = {};
    local scaleFactor = 1;
    if deviceDim[1] > deviceDim[2] then
        scaleFactor = (0.9 * deviceDim[2]) / (480 * 16 / 9);
        resultDim[1] = 480;
        resultDim[2] = resultDim[1] * 16 / 9;
        if deviceDim[2] < resultDim[2] then
            resultDim[2] = deviceDim[2] * 0.975
            scaleFactor = 1;
        end
    else
        scaleFactor = deviceDim[1] / 480;
        resultDim[2] = deviceDim[2] / deviceDim[1] * 480;
        resultDim[1] = 480;
    end
    return resultDim[1], resultDim[2], scaleFactor;
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
        money = 1000;
        lastLevel = 1;
        winDim = {};
        phase = 1;
        fish = {};
        enabled = {
            ring = true;
            sleepingPill = true;
        }
    };

    --- upgrades list in persTable, "0" means unbought
    _G._persTable.upgrades = {
        firstSpeedUp = true; -- more speed
        secondSpeedUp = false; -- more speed
        oneMoreLife = false; -- more life
        twoMoreLife = false; -- more life
        threeMoreLife = false; -- more life
        moneyMult = false; -- "0" means no additional money
        moreLife = 0; -- needed for calculation in a few classes
        godMode = false; -- indicates if the god mode is available or not
        mapBreakthrough1 = false; -- can you access the first map limit? 0 = no, 1 = yes
        mapBreakthrough2 = false; -- can you access the second map limit? 0 = no, 1 = yes
        moreFuel1 = false;
        moreFuel2 = false;
        sleepingPillDuration = 600; -- duration of the effect of the sleeping pill
        sleepingPillSlow = 0.25; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement
    };

    _G._persTable.achievements = {
        getFirstObject = true;
        getSecondObject = false;
        failedStart = false;
        caughtTwoBoots = false;
        secondStart = false;
        bronzeCaughtOneRound = false;
        silverCaughtOneRound = false;
        goldCaughtOneRound = false;
        shoppingQueen = false;
        bronzeCoinsOneRound = false;
        silverCoinsOneRound = false;
        goldCoinsOneRound = false;
        negativCoins = false;
        bMoneyEarnedTotal = false;
        sMoneyEarnedTotal = false;
        gMoneyEarnedTotal = false;
    };


    _G._persTable.statistic = {
        maxCoinOneRound = 0;
        minCoinOneRound = 0;
        moneyEarnedTotal = 0;
    };
    
    --- config options
    _G._persTable.config = {
        bgm = 100;
        music = 100;
        language = "english";
    };
    
    _G._persTable.fish = {
        caughtInOneRound = 0; 
        caughtTotal = 0; 
        caught = {}; -- table of caughtable fishes with amount caught
    };
    -- adds caughtable fishes to perstable
    for name in pairs(data.fishableObjects) do
        _G._persTable.fish.caught[name] = 0;
    end

  
end

return Persistence;
