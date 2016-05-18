-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait";
Level = require "class.Level";
SwarmFactory = require "class.SwarmFactory";
Loveframes = require "lib.LoveFrames";
Gui = require "class.Gui";
LevelManager = require "class.LevelManager";
Gamestate = require "lib.hump.gamestate";
_G.data = require "data";
Persistence = require"class.Persistence";

-- Global variables
_G.math.inf = 1 / 0;
_G._gui = nil;


--- Local variables
local curLevel;
local player;
local swarmFactory;
local gui;
local levMan;
local persistence;

--- The bootstrap of the game.
-- This function is called exactly once at the beginning of the game.
function love.load()
    persistence = Persistence();
    _gui = Gui();
    local _, _, flags = love.window.getMode();
    love.graphics.setBackgroundColor(30, 180, 240);
    _G._persTable.winDim = { love.window.getDesktopDimensions(flags.display) };
    _G._persTable.winDim[2] = _G._persTable.winDim[2] - 150; -- Sub 50px for taskbar and window header
    _G._persTable.winDim[1] = (_G._persTable.winDim[2] / 16) * 9; -- Example: 16:9
    love.window.setMode(_G._persTable.winDim[1], _G._persTable.winDim[2], { centered });
    levMan = LevelManager();
    levMan:newLevel("assets/testbg.png", 1, _G.data);

    _gui:tempTextOutput();
    --gui:buildFrames();
    --gui:loadValues();
    _gui:start();
end

--- The love main draw call, which draws every frame on the screen.
-- This function is called continuously by the love.run().
function love.draw()
    if _gui:drawGame() then
        levMan:getCurLevel():draw(levMan:getCurPlayer());
        levMan:getCurSwarmFactory():draw();
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
        levMan:getCurLevel():update(dt, levMan:getCurPlayer());
        levMan:getCurSwarmFactory():update();
    end
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
    levMan:getCurLevel():activateGodMode();
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
