-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait";
Level = require "class.Level";
SwarmFactory = require "class.SwarmFactory";
Loveframes = require "lib.LoveFrames";
-- Disable cursor on android (otherwise it leads to errors)
if love.os == "android" then
    Loveframes.config["ENABLE_SYSTEM_CURSORS"] = false;
end
Gui = require "class.Gui";
LevelManager = require "class.LevelManager";
Gamestate = require "lib.hump.gamestate";
Persistence = require"class.Persistence";
require "lib.TEsound";

-- Global variables
_G.math.inf = 1 / 0;
_G._gui = nil;
_G._persistence = nil;

-- Game Title
love.window.setTitle("Simon Hamsters insane trip");

-- loads all functions from util to the global space
for k,v in pairs(require "util") do
  _G[k] = v;
end

--- Local variables
local curLevel;
local player;
local swarmFactory;
local levMan;
--local persistence;

--- The bootstrap of the game.
-- This function is called exactly once at the beginning of the game.
function love.load()
    _G.data = require "data"; -- loading cycle on android requires data to be load on love.load()
    _persistence = Persistence();
    _persistence:resetGame();
    
    local _, _, flags = love.window.getMode();
    love.graphics.setBackgroundColor(30, 180, 240);
    deviceDim = {love.window.getDesktopDimensions(flags.display)};
    --deviceDim = {480, 833};
    _G._persTable.winDim[1], _G._persTable.winDim[2], scaleFactor = getScaledDimension(deviceDim);
    
    _G._persTable.scaledDeviceDim = {_G._persTable.winDim[1] * scaleFactor, _G._persTable.winDim[2] * scaleFactor};
    love.window.setMode(_G._persTable.scaledDeviceDim[1], _G._persTable.scaledDeviceDim[2], { centered });
    levMan = LevelManager();
    levMan:newLevel("assets/testbg.png", 1, _G.data);

    _gui = Gui();
    _gui:tempTextOutput();
    _gui:start();
end

---calculates the dimension of the Level and the factor of the scaling
--@ param deviceDim dimension of the divice
function getScaledDimension(deviceDim)
    resultDim = {};
    if deviceDim[1] > deviceDim[2] then
        scaleFactor = (0.9 * deviceDim[2]) / (480 * 16 / 9);
        resultDim[1] = 480;
        resultDim[2] = resultDim[1] * 16 / 9;
    else
        scaleFactor = deviceDim[1] / 480;
        resultDim[2] = deviceDim[2] / deviceDim[1] * 480;
        resultDim[1] = 480;
    end
        return resultDim[1], resultDim[2], scaleFactor;
end

--- The love main draw call, which draws every frame on the screen.
-- This function is called continuously by the love.run().
function love.draw()
    if _gui:drawGame() then
        love.graphics.scale(scaleFactor, scaleFactor);
        levMan:getCurLevel():draw(levMan:getCurPlayer());
        levMan:getCurSwarmFactory():draw();
        love.graphics.scale(1/scaleFactor, 1/scaleFactor);
    end
    
    Loveframes.draw()
    --[[prints the State name and output values.
    This function will be replaced in a later version]] --
    _gui:tempDrawText()
end

--- This function is called continuously by the love.run().
-- @param dt Delta time  is the amount of seconds since the
-- last time this function was called.
function love.update(dt)
    _gui:update();
    Loveframes.update(dt);
    if _gui:drawGame() then
        -- updates the curLevel only in the InGame GUI
        setMouseVisibility(levMan:getCurLevel());
        levMan:getCurLevel():update(dt, levMan:getCurPlayer());
        levMan:getCurSwarmFactory():update();
    end
    TEsound.cleanup();
end

--- Callback function triggered when the mouse is moved.
-- @param x The mouse position on the x-axis.
-- @param _ The mouse position on the y-axis. unused
function love.mousemoved(x, _)
    if levMan:getCurPlayer() then
        if x < (levMan:getCurPlayer():getSize() / 2) then
            levMan:getCurPlayer():setPosXMouse(0);
        else
            if x > _G._persTable.winDim[1] - levMan:getCurPlayer():getSize() then
                levMan:getCurPlayer():setPosXMouse(_G._persTable.winDim[1] - levMan:getCurPlayer():getSize());
            else
                levMan:getCurPlayer():setPosXMouse(x - (levMan:getCurPlayer():getSize() / 2));
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

    -- activate the god mode when you press the mouse
    if love.mouse.isDown(1) then
      levMan:getCurLevel():activateGodMode();
    end
    
    -- pause game when when mouse is pressed (right button)
    if love.mouse.isDown(2) and _gui:drawGame() then
      _gui:changeFrame(_gui:getFrames().pause);
      setMouseVisibility(levMan:getCurLevel());
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
    levMan:getCurLevel():deactivateGodMode();
    levMan:getCurLevel():resetOldPosY();
end
