-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait";
Level = require "class.Level";
SwarmFactory = require "class.SwarmFactory";
Loveframes = require "lib.LoveFrames";
-- Disable cursor on android (otherwise it leads to errors)
if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
    Loveframes.config["ENABLE_SYSTEM_CURSORS"] = false;
end
Gui = require "class.Gui";
LevelManager = require "class.LevelManager";
Gamestate = require "lib.hump.gamestate";
Persistence = require "class.Persistence";
Achievement = require "class.Achievement";
require "lib.TEsound";

-- Global variables
_G.math.inf = 1 / 0;
_G._gui = nil;
_G._persistence = nil;
_G._androidConfig = {
    lastPos = {};
    rrLen = 15;
    rrPos = 1;
};
_G._tmpTable = {
    caughtThisRound = {};
    earnedMoney = nil;
    currentDepth = nil;
    roundFuel = nil;
};
_G._unlockedAchievements = {};
-- Font for android debugging
_G.myfont = love.graphics.newFont(30);

-- Game Title
love.window.setTitle("Simon Hamster's Insane Trip");

--- Local variables
local curLevel;
local player;
local swarmFactory;
local levMan;
local p_scaleFactor;
local achiev;
local frameCounter = 0;

--- The bootstrap of the game.
-- This function is called exactly once at the beginning of the game.
function love.load()
    --if arg[#arg] == "-debug" then require("mobdebug").start() end -- enables the debugging
    _G.data = require "data"; -- loading cycle on android requires data to be load on love.load()
    _G._persistence = Persistence();
    _G._persistence:resetGame();

    local _, _, flags = love.window.getMode();
    love.graphics.setBackgroundColor(55, 80, 100);
    _G._persTable.deviceDim = { love.window.getDesktopDimensions(flags.display) };
    --_G._persTable.deviceDim = {720, 1080};
    --_G._persTable.deviceDim = {1366,768};
    --_G._persTable.deviceDim = {1600,900};
    _G._persTable.winDim[1], _G._persTable.winDim[2], _, titleHeight = getScaledDimension(_G._persTable.deviceDim);
    p_scaleFactor = 1;

    _G._persTable.scaledDeviceDim = { _G._persTable.winDim[1] * p_scaleFactor, _G._persTable.winDim[2] * p_scaleFactor };
    love.window.setMode(_G._persTable.scaledDeviceDim[1], _G._persTable.scaledDeviceDim[2],
        { x = (_G._persTable.deviceDim[1] - _G._persTable.scaledDeviceDim[1]) / 2, y = titleHeight });
    achiev = Achievement();
    levMan = LevelManager(achiev);

    -- Get Accelerometer if android
    if love.system.getOS() == "Android" then
        local joy = love.joystick.getJoysticks();
        for _, js in pairs(joy) do
            if js:getName() == "Android Accelerometer" then
                _G._androidConfig.joystick = js;
            end
        end
        if _G._data and _G._data.android then
            _G._androidConfig.maxTilt = _G._data.android.maxTilt;
        else
            _G._androidConfig.maxTilt = .3;
        end
    end

    Loveframes.basicfont = love.graphics.newFont("font/8bitOperatorPlus-Regular.ttf", 18);

    _G._gui = Gui();
    _gui:setLevelManager(levMan);
    _gui:start();
    achiev:checkAchievements();
end

--- calculates the dimension of the Level and the factor of the scaling
-- @ param deviceDim dimension of the divice
function getScaledDimension(deviceDim)
    local resultDim = {};
    local scaleFactor = 1;
    local titleHeight = 0;
    if deviceDim[1] > deviceDim[2] then
        resultDim[1] = 480;
        resultDim[2] = 853; -- 480 * 16 /9
        titleHeight = 25
        if resultDim[2] > 0.93 * deviceDim[2] then
            resultDim[2] = 0.93 * deviceDim[2]
        else
            scaleFactor = (deviceDim[2] * 0.93) / 853
        end
    else
        scaleFactor = deviceDim[1] / 480;
        resultDim[2] = deviceDim[2] / deviceDim[1] * 480;
        resultDim[1] = 480;
    end
    return resultDim[1], resultDim[2], scaleFactor, titleHeight;
end

--- The love main draw call, which draws every frame on the screen.
-- This function is called continuously by the love.run().
function love.draw()
    if _gui:drawGame() then
        levMan:getCurLevel():draw(levMan:getCurPlayer());
        levMan:getCurSwarmFactory():draw();
        levMan:getCurLevel():drawEnviroment();
    end

    if levMan:getCurLevel() ~= nil then
        if levMan:getCurLevel().levelFinished == 1 and
                _gui:getCurrentState() == "InGame" then
            levMan:getCurLevel():printResult();
        end
    end

    if _G._androidConfig.joyPos then
        love.graphics.push();
        love.graphics.setFont(_G.myfont);
        love.graphics.print(_G._androidConfig.joyPos, 100, 100);
        love.graphics.pop();
    end
    Loveframes.draw();
    -- debug info for memory usage do not remove!
    love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 200, 60);
    love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS()), 200, 75);
    --[[
    love.graphics.print(
        "1speedUp " .. tostring(_G._persTable.upgrades.firstSpeedUp) .. "\n" ..
        "2speedUp " .. tostring(_G._persTable.upgrades.secondSpeedUp) .. "\n" ..
        "1moreLife " .. tostring(_G._persTable.upgrades.oneMoreLife) .. "\n" ..
        "2moreLife " .. tostring(_G._persTable.upgrades.twoMoreLife) .. "\n" ..
        "3moreLife " .. tostring(_G._persTable.upgrades.threeMoreLife) .. "\n" ..
        "moneyMult " .. tostring(_G._persTable.upgrades.moneyMult) .. "\n" ..
        "godMode " .. tostring(_G._persTable.upgrades.godMode) .. "\n" ..
        "MB1 " .. tostring(_G._persTable.upgrades.mapBreakthrough1) .. "\n" ..
        "MB2 " .. tostring(_G._persTable.upgrades.mapBreakthrough2),
        0, 0)]] --
end

--- This function is called continuously by the love.run().
-- @param dt Delta time  is the amount of seconds since the
-- last time this function was called.
function love.update(dt)
    if _gui:drawGame() then
        -- updates the curLevel only in the InGame GUI
        levMan:getCurLevel():update(dt, levMan:getCurPlayer());
        levMan:getCurSwarmFactory():update(dt);

        -- if love.load had been executed and on android
        if love.system.getOS() == "Android" then
            _G._androidConfig.lastPos[_G._androidConfig.rrPos] = (_G._androidConfig.joystick:getAxis(1) + _G._androidConfig.maxTilt) * (_G._persTable.winDim[1] / (_G._androidConfig.maxTilt * 2));
            _G._androidConfig.rrPos = (_G._androidConfig.rrPos % _G._androidConfig.rrLen) + 1;
            local joyPos = 0;
            for _, v in pairs(_G._androidConfig.lastPos) do
                joyPos = joyPos + v;
            end
            joyPos = joyPos / #_G._androidConfig.lastPos;
            _G._androidConfig.joyPos = joyPos;
            if joyPos < (levMan:getCurPlayer():getSize() / 2) then
                levMan:getCurPlayer():setPosXMouse(0);
            else
                if joyPos > _G._persTable.winDim[1] - levMan:getCurPlayer():getSize() then
                    levMan:getCurPlayer():setPosXMouse(_G._persTable.winDim[1] - levMan:getCurPlayer():getSize());
                else
                    levMan:getCurPlayer():setPosXMouse(joyPos - (levMan:getCurPlayer():getSize() / 2));
                end
            end
        end
    end
    _gui:update();
    Loveframes.update(dt);
    TEsound.cleanup();

    -- free unused memory
    frameCounter = frameCounter + 1;
    if _gui:getCurrentState() ~= "InGame" or levMan:getCurLevel():isFinished() == 1 then
        if (frameCounter % 60) == 0 then
            collectgarbage("collect");
            frameCounter = 0;
        end
    end
end

--- Callback function triggered when the mouse is moved.
-- @param x The mouse position on the x-axis.
-- @param _ The mouse position on the y-axis. unused
function love.mousemoved(x, _)
    if levMan:getCurPlayer() and love.system.getOS() ~= "Android" then
        if x < (levMan:getCurPlayer():getSize() / 2) then
            levMan:getCurPlayer():setPosXMouse(0);
        else
            if x > _G._persTable.winDim[1] - levMan:getCurPlayer():getSize() then
                levMan:getCurPlayer():setPosXMouse(_G._persTable.winDim[1] - levMan:getCurPlayer():getSize());
            else
                levMan:getCurPlayer():setPosXMouse(x);
            end
        end
    end
end

--- Callback function triggered when the mouse is pressed.
-- @param x The mouse position on the x-axis.
-- @param y The mouse position on the y-axis.
-- @param button The pressed mousebutton.
function love.mousepressed(x, y, button)
    --[[Loveframes needs 'l' to detect the left mousebutton.
    It's necessary to convert the received "1" value]] --
    if button == 1 then
        button = 'l';
    end
    Loveframes.mousepressed(x, y, button);

    if _gui:getCurrentState() == "start" then
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end

    -- activate the god mode when you press the mouse
    if love.mouse.isDown(1) and _gui:getCurrentState() == "InGame" and
            levMan:getCurLevel():getStartAnimationFinished() then
        levMan:getCurLevel():activateGodMode();
    end

    -- starts the starting sequence of the game
    if love.mouse.isDown(1) and _gui:getCurrentState() == "InGame" and
            not levMan:getCurLevel():getStartAnimationRunning() and
            not levMan:getCurLevel():getStartAnimationFinished() then
        levMan:getCurLevel():startStartAnimation();
    end

    -- pause game when when mouse is pressed (right button)
    if love.mouse.isDown(2) and _gui:drawGame() and levMan:getCurLevel():isLoaded() then
        _gui:changeFrame(_gui:getFrames().pause);
    end
end

--- Callback function triggered wehen the mouse is released.
-- @param x The mouse position on the x-axis.
-- @param y The mouse position on the y-axis.
-- @param button The pressed mousebutton.
function love.mousereleased(x, y, button)
    --[[Loveframes needs a 'l' to detect the left mousebutton.
    It's necessary to convert the received "1" value]] --
    if button == 1 then
        button = 'l';
    end
    Loveframes.mousereleased(x, y, button);

    -- deactivate the god mode when you release the mouse
    if _gui:getCurrentState() == "InGame" then
        levMan:getCurLevel():deactivateGodMode();
        levMan:getCurLevel():resetOldPosY();
    end
end
