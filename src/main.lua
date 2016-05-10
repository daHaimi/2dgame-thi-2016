-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait";
Level = require "class.Level";
SwarmFactory = require "class.SwarmFactory";
Loveframes = require "lib.LoveFrames";
Gui = require "class.Gui";

_G.data = require "data"

-- Global variables
_G.math.inf = 1 / 0;

--- globale persistance table
_G._persTable = {
    statistic = {};
    achivments = {};
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
    moreLife = 1; -- amount of additional lifes
    godMode = 1; -- indicates if the god mode is available or not
    mapBreakthrough1 = 0; -- can you access the first map limit? 0 = no, 1 = yes
    mapBreakthrough2 = 0; -- can you access the second map limit? 0 = no, 1 = yes
    sleepingPillDuration = 600; -- duration of the effect of the sleeping pill
    sleepingPillSlow = 0.25; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement
};

--- config options
_G._persTable.config = {
    bgm = 100;
    music = 100;
}

--- Local variables
local curLevel;
local player;
local swarmFactory;
local gui;

--- The bootstrap of the game.
-- This function is called exactly once at the beginning of the game.
function love.load()
    local _, _, flags = love.window.getMode();
    love.graphics.setBackgroundColor(30, 180, 240);
    _G._persTable.winDim = { love.window.getDesktopDimensions(flags.display) };
    _G._persTable.winDim[2] = _G._persTable.winDim[2] - 150; -- Sub 50px for taskbar and window header
    _G._persTable.winDim[1] = (_G._persTable.winDim[2] / 16) * 9; -- Example: 16:9
    love.window.setMode(_G._persTable.winDim[1], _G._persTable.winDim[2], { centered });
    curLevel = Level("assets/testbg.png", _G._persTable.winDim, 1, nil);
    player = Bait(_G._persTable.winDim, curLevel);
    player:checkUpgrades();
    swarmFactory = SwarmFactory(curLevel, player, _G.data);
    curLevel:setSwarmFactory(swarmFactory);
    gui = Gui();
    gui:tempTextOutput();
    gui:buildFrames();
    gui:loadValues();
    gui:startGui();
end

--- The love main draw call, which draws every frame on the screen.
-- This function is called continuously by the love.run().
function love.draw()
    if gui.drawGame() then
        curLevel:draw(player);
        swarmFactory:draw();
    end

    Loveframes.draw()
    --[[prints the State name and output values.
    This function will be replaced in a later version]] --
    gui:tempDrawText()
end

--- This function is called continuously by the love.run().
-- @param dt Delta time  is the amount of seconds since the
-- last time this function was called.
function love.update(dt)
    gui:updateGui();
    Loveframes.update(dt);
    if gui.drawGame() then
        -- updates the curLevel only in the InGame GUI
        curLevel:update(dt, player);
        swarmFactory:update();
    end
end

--- Callback function triggered when the mouse is moved.
-- @param x The mouse position on the x-axis.
-- @param _ The mouse position on the y-axis. unused
function love.mousemoved(x, _)
    if player then
        if x < (player.size / 2) then
            player.posXMouse = 0;
        else
            if x > _G._persTable.winDim[1] - player.size then
                player.posXMouse = _G._persTable.winDim[1] - player.size;
            else
                player.posXMouse = x - (player.size / 2);
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
    curLevel:activateGodMode();
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
    curLevel:deactivateGodMode();
    curLevel:resetOldPosY();
end
