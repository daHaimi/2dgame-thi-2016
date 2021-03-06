Class = require("lib.hump.class");
require("lib.table_serializer");
data = require("data");

--- Class to save the persTable data permanent 
-- it will be saved to the devices love.filesystem save directory 
local Persistence = Class {
    init = function(self)
        -- set foldername for the game data
        love.filesystem.setIdentity("hamster");

        self.serialize = table.serialize;
        self.deserialize = table.deserialize;

        -- first load of persTable
        if love.filesystem.exists("saveFile") then
            self:loadPersTable();
            self.loaded = true;
        else
            self:createPersTable();
            self:updateSaveFile();
        end

    end
};


--- Deletes the saveFile and crates newPersTable to reset the game
-- Returns true if deleted the saveFile
-- @return boolean
function Persistence:resetGame()
    local scaleFactor;
    self:createPersTable();
    local _, _, flags = love.window.getMode();
    love.graphics.setBackgroundColor(55, 80, 100);
    _G._persTable.deviceDim = { love.window.getDesktopDimensions(flags.display) };
    _G._persTable.winDim[1], _G._persTable.winDim[2], _G._persTable.scaleFactor, 
        titleHeight = getScaledDimension(_G._persTable.deviceDim);
    _G._persTable.scaledDeviceDim = { _G._persTable.winDim[1] * _G._persTable.scaleFactor, 
        _G._persTable.winDim[2] * _G._persTable.scaleFactor };
    love.window.setMode(_G._persTable.scaledDeviceDim[1], _G._persTable.scaledDeviceDim[2], 
        {x = (_G._persTable.deviceDim[1] - _G._persTable.scaledDeviceDim[1]) / 2, y = titleHeight});
    
    --resetting gui
    _gui:getFrames().achievements = Achievements();
    _gui:getFrames().upgradeMenu = UpgradeMenu();
    _gui:getFrames().dictionary = Dictionary();
    _gui:setLanguage();
    _gui:getFrames().mainMenu.elementsOnFrame.button_flag:setImage(love.graphics.newImage("assets/gui/" .. 
                _G.data.languages[_persTable.config.language].flagImage));
    
    return love.filesystem.remove("saveFile");
end

function getScaledDimension(deviceDim)
    local resultDim = {};
    local scaleFactor;
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
    local fileData, _ = love.filesystem.read("saveFile");
    _G._persTable = self.deserialize(fileData);
end

--- Creates initial persTable 
function Persistence:createPersTable()
    --- globale persistance table
    _G._persTable = {
        statistic = {};
        achievements = {};
        config = {};
        money = 0;
        lastLevel = 1;
        winDim = {};
        playedTime = 0;
        gameStatedAmount = 0;
        phase = 1;
        fish = {};
        enabled = {
            ring = true;
            sleepingPill = true;
        };
        unlockedLevel = 1;
    };

    --- upgrades list in persTable, "0" means unbought
    _G._persTable.upgrades = {
        firstSpeedUp = false; -- more speed
        secondSpeedUp = false; -- more speed
        oneMoreLife = false; -- more life
        twoMoreLife = false; -- more life
        threeMoreLife = false; -- more life
        moreLife = 0; -- needed for calculation in a few classes
        godMode = false; -- indicates if the god mode is available or not
        mapBreakthrough1 = false; -- can you access the first map limit? 0 = no, 1 = yes
        mapBreakthrough2 = false; -- can you access the second map limit? 0 = no, 1 = yes
        moreFuel1 = false;
        moreFuel2 = false;
        pillDuration = 2; -- duration of the effect of the pills in seconds
        rainbowPillDuration = 5; -- duration of the effect of the pills in seconds
        sleepingPillSlow = 0.25; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement speed
        coffeeSpeedup = 2; -- sets the speedup factor for coffe 2 = 200% of the usual movement speed
        firstPermanentMoneyMult = false; -- false means no additional money
        secondPermanentMoneyMult = false; -- false means no additional money
    };

    _G._persTable.achievements = {
        getFirstObject = false;
        failedStart = false;
        caughtTwoBoots = false;
        secondStart = false;
        bronzeCaughtOneRound = false;
        silverCaughtOneRound = false;
        goldCaughtOneRound = false;
        firstBorderRemoved = false;
        shoppingQueen = false;
        bronzeCoinsOneRound = false;
        silverCoinsOneRound = false;
        goldCoinsOneRound = false;
        negativCoins = false;
        bMoneyEarnedTotal = false;
        sMoneyEarnedTotal = false;
        gMoneyEarnedTotal = false;
        creditsRed = false;
        onlyNegativeFishesCaught = false;
        allObjectsAtLeastOnce = false;
        allPillsAtLeastOnce = false;
        nothingCaught = false;
        playedTime = false;
        bFishCaughtTotal = false;
        sFishCaughtTotal = false;
        gFishCaughtTotal = false;
        achBitch = false;
        unreachable = false;
    };


    _G._persTable.statistic = {
        maxCoinOneRound = 0;
        minCoinOneRound = 0;
        moneyEarnedTotal = 0;
        highscoreSewers = 0;
        highscoreCanyon = 0;
        lastHighScore = 0;
    };

    --- config options
    _G._persTable.config = {
        bgm = 50;
        music = 50;
        language = "english";
        vibration = true;
    };

    _G._persTable.fish = {
        caughtInOneRound = 0;
        caughtTotal = 0;
        caught = {}; -- table of caughtable fishes with amount caught
        postiveFishCaught = false; -- no fish with positive value caught
    };
    -- adds caughtable fishes to perstable
    for name in pairs(data.fishableObjects) do
        _G._persTable.fish.caught[name] = 0;
    end
end

return Persistence;
