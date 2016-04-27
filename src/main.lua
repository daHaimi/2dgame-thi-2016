-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait"
Level = require "class.Level"
SwarmFactory = require "class.SwarmFactory"
Loveframes = require "lib.LoveFrames"
Gui = require "class.Gui"

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
    moved = 0;
};

--- upgrades list in persTable, "0" means unbought
_G._persTable.upgrades = {
    speedUp = 0; -- "0" no Speedup for more looke bait.lua
    moneyMult = 0; -- "0" means no additional money
    moreLife = 0; -- amount of additional lifes
    godMode = 1; -- indicates if the god mode is available or not
    mapBreakthrough1 = 0; -- can you access the first map limit? 0 = no, 1 = yes
    mapBreakthrough2 = 0; -- can you access the second map limit? 0 = no, 1 = yes
};

--- config options
_G._persTable.config = {
    slider1 = 30; -- these values are only examples. Options have to be reviewed later
    slider2 = 80;
    option1 = true;
    option2 = false;
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
    gui = Gui();
    _G._persTable.winDim = { love.window.getDesktopDimensions(flags.display) };
    _G._persTable.winDim[2] = _G._persTable.winDim[2] - 150; -- Sub 50px for taskbar and window header
    _G._persTable.winDim[1] = (_G._persTable.winDim[2] / 16) * 9; -- Example: 16:9
    love.window.setMode(_G._persTable.winDim[1], _G._persTable.winDim[2], {centered});
    curLevel = Level("assets/testbg.png", _G._persTable.winDim, 1);
    player = Bait(_G._persTable.winDim);
    player:checkUpgrades();
    swarmFactory = SwarmFactory(curLevel, player, "data.lua");
end

--- The love main draw call, which draws every frame on the screen.
-- This function is called continuously by the love.run().
function love.draw()
    if gui.drawGame() then
        curLevel:draw(player);
        if swarmFactory then
            swarmFactory:draw();
        end
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
    Loveframes.update(dt);
    if gui.drawGame() then --updates the curLevel only in the InGame GUI
    curLevel:update(dt, player);
    end
    if swarmFactory then
        swarmFactory:update();
    end
end

--- Callback function triggered when the mouse is moved.
-- @param x The mouse position on the x-axis.
-- @param y The mouse position on the y-axis.
function love.mousemoved(x, y)
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
