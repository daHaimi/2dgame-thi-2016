-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait";
Level = require "class.Level";
SwarmFactory = require "class.SwarmFactory";
Gui = require "class.Gui";
LevelManager = require "class.LevelManager";
Gamestate = require "lib.hump.gamestate";
Persistence = require "class.Persistence";
Achievement = require "class.Achievement";
MusicManager = require "class.MusicManager";
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
    lastLevelWas = nil;
};

_G._unlockedAchievements = {};
-- Font for android debugging
_G.myfont = love.graphics.newFont(30);
_G._musicManager = MusicManager();

-- Game Title
love.window.setTitle("Simon Hamster's Insane Trip");

--- Local variables
local curLevel;
local player;
local swarmFactory;
local levMan;
local achiev;
local frameCounter = 0;

--- The bootstrap of the game.
-- This function is called exactly once at the beginning of the game.
function love.load()
    --if arg[#arg] == "-debug" then require("mobdebug").start() end -- enables the debugging
    _G.data = require "data"; -- loading cycle on android requires data to be load on love.load()
    _G._persistence = Persistence();
    _G._persTable.gameStatedAmount = _G._persTable.gameStatedAmount + 1;


    local _, _, flags = love.window.getMode();
    love.graphics.setBackgroundColor(55, 80, 100);
    _G._persTable.deviceDim = { love.window.getDesktopDimensions(flags.display) };
    --_G._persTable.deviceDim = {720, 1080};
    --_G._persTable.deviceDim = {1366,768};
    --_G._persTable.deviceDim = {1600,900};
    --_G._persTable.deviceDim = {480,853};
    _G._persTable.winDim[1], _G._persTable.winDim[2], _G._persTable.scaleFactor, 
        titleHeight = getScaledDimension(_G._persTable.deviceDim);

    _G._persTable.scaledDeviceDim = {_G._persTable.winDim[1] * _G._persTable.scaleFactor, 
        _G._persTable.winDim[2] * _G._persTable.scaleFactor };
    love.window.setMode(_G._persTable.scaledDeviceDim[1], _G._persTable.scaledDeviceDim[2], 
        {x = (_G._persTable.deviceDim[1] - _G._persTable.scaledDeviceDim[1]) / 2, y = 25});
    achiev = Achievement();
    levMan = LevelManager(achiev);

    -- Get Accelerometer if android
    if love.system.getOS() == "Android" then
        local joy = love.joystick.getJoysticks();
        for k, js in pairs(joy) do
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

    _G._gui = Gui();
    _gui:setLevelManager(levMan);
    _gui:start();
    achiev:checkAchievements();
    _musicManager:update();
    
    if _G._persTable.gameStatedAmount == 2 then
        levMan:getAchievmentManager():unlockAchievement("secondStart");
    end
end

--- calculates the dimension of the Level and the factor of the scaling
-- @param deviceDim dimension of the device
function getScaledDimension(deviceDim)
    local resultDim = {};
    local scaleFactor = 1;
    local titleHeight = 0;
    if deviceDim[1] > deviceDim[2] then
        resultDim[1] = 480;
        resultDim[2] = 853; -- 480 * 16 /9
        titleHeight = 25;
        if resultDim[2] > 0.93 * deviceDim[2] then
            resultDim[2] = 0.93 * deviceDim[2];
        else 
            scaleFactor = (deviceDim[2] * 0.93) / 853;
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
    
    love.graphics.scale(_G._persTable.scaleFactor, _G._persTable.scaleFactor);
    if _gui:drawGame() then
        levMan:getCurLevel():draw(levMan:getCurPlayer());
        levMan:getCurSwarmFactory():draw();
        levMan:getCurLevel():drawEnviroment(); 
    end
    _gui:draw();
    love.graphics.scale(1 / _G._persTable.scaleFactor, 1 / _G._persTable.scaleFactor);
   

    if levMan:getCurLevel() ~= nil then
        if levMan:getCurLevel().levelFinished == 1 and
                _gui:getCurrentState() == "InGame" then
            levMan:getCurLevel():printResult();
        end
    end
 
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
          -- shift [-30,30] to [0,60] and scale to windim[1]
          _G._androidConfig.lastPos[_G._androidConfig.rrPos] = (_G._androidConfig.joystick:getAxis(1) +
              _G._androidConfig.maxTilt) * (_G._persTable.winDim[1] / (_G._androidConfig.maxTilt * 2));
          _G._androidConfig.rrPos = (_G._androidConfig.rrPos % _G._androidConfig.rrLen) + 1;
          local joyPos = 0;
          for _,v in pairs(_G._androidConfig.lastPos) do
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

    TEsound.cleanup();
    
    -- free unused memory
    frameCounter = frameCounter + 1;
    if _gui:getCurrentState() ~= "InGame" or levMan:getCurLevel():isFinished() == 1 then
        if (frameCounter % 60) == 0 then
            collectgarbage("collect");
            frameCounter = 0;
        end
    end
    
    if levMan:getCurLevel() ~= nil then
        if levMan:getCurLevel():isFinished() then
            achiev:checkAchievements();
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
    
    if love.mouse.isDown(1) then
        _gui:mousepressed(x, y);
    end
    
    -- activate the god mode when you press the mouse
    if love.mouse.isDown(1) and _gui:getCurrentState() == "InGame" and
    levMan:getCurLevel():getStartAnimationFinished() then
        levMan:getCurLevel():activateGodMode();
    end
    
    -- pause game when when mouse is pressed (right button)
    if love.mouse.isDown(2) and _gui:drawGame() and levMan:getCurLevel():isLoaded() then
        levMan:getCurLevel():onPause();
        _gui:changeFrame(_gui:getFrames().pause);
    end
    
end

--- Callback function triggered wehen the mouse is released.
-- @param x The mouse position on the x-axis.
-- @param y The mouse position on the y-axis.
-- @param button The pressed mousebutton.
function love.mousereleased(x, y, button)

    _gui:mousereleased(x, y);
    love.system.vibrate(0.1);
    -- deactivate the god mode when you release the mouse
    if _gui:getCurrentState() == "InGame" then
        levMan:getCurLevel():deactivateGodMode();
        levMan:getCurLevel():resetOldPosY();
    end
end
