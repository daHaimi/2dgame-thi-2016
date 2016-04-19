-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait"
Level = require "class.Level"
Loveframes = require "lib.Loveframes"
Gui = require "class.Gui"

-- Global variables


--- globale persistance table
_G._persTable = {
    statistic = {};
    achivments = {};
    config = {};
    fishCaught = {};
    money = 0;
    lastLevel = 1;
};
--- upgrades list in persTable
_G._persTable.upgrades = {
    speedUp = 1;
    moneyMult = 1;
    moreLife = 0;
    godMode = 0;
  }

-- Local variables
local winDim = {};
local curLevel = nil;
local player = nil;

-- The bootstrap of the game. 
-- This function is called exactly once at the beginning of the game.
function love.load()
    local _, _, flags = love.window.getMode()
    love.graphics.setBackgroundColor( 30, 180, 240)
    winDim = {love.window.getDesktopDimensions(flags.display)};
    winDim[2] = winDim[2] - 50; -- Sub 50px for taskbar and window header
    winDim[1] = (winDim[2] / 16) * 9; -- Example: 16:9
    love.window.setMode(winDim[1], winDim[2], flags);
    curLevel = Level("assets/testbg.png", winDim, 1);
    player = Bait(winDim);
    player:checkUpgrades();
    Gui:loadValues();--loads option and upgrade values 
    Gui:clearAll();--set visible of all elements to false
    Gui:mainMenu();--prints all elements for the main menu
end

-- The love main draw call, which draws every frame on the screen.
-- This function is called continuously by the love.run().
function love.draw()
    Gui:tempDrawText()--[[prints the State name and output values.
    This function will be replaced in a later version]]--
    Loveframes.draw()
    if Gui.drawGame() then
        curLevel:draw(player);
    end
end

-- This function is called continuously by the love.run().
-- @param dt Delta time  is the amount of seconds since the 
-- last time this function was called.
function love.update(dt)
    Gui:checkValues();--updates the upgrade and option values
    Gui:tempTextOutput();--[[updates the text output.
    This function will be replaced in a later version]]--
    Loveframes.update(dt);
    if Gui.drawGame() then--updates the curLevel only in the InGame GUI
        curLevel:update(dt, player);
    end
end
  
-- Callback function triggered when the mouse is moved. 
-- @param x The mouse position on the x-axis.
-- @param y The mouse position on the y-axis.
function love.mousemoved(x, y)
    if player then
        if x < (player.size / 2) then
            player.posX = 0;
        else 
          if x > winDim[1] - player.size then
              player.posX = winDim[1] - player.size;
          else 
              player.posX = x - (player.size / 2);
          end
        end  
    end
end

-- Callback function triggered when the mouse is pressed. 
-- @param x The mouse position on the x-axis.
-- @param y The mouse position on the y-axis.
-- @param button The pressed mousebutton.
function love.mousepressed(x, y, button)
    --[[Loveframes needs 'l' to detect the left mousebutton.
    It's necessary to convert the received "1" value]]--
    if button == 1 then 
        button = 'l';
    end
    Loveframes.mousepressed(x, y, button);
end

-- @param x The mouse position on the x-axis.
-- @param y The mouse position on the y-axis.
-- @param button The pressed mousebutton.
function love.mousereleased(x, y, button)
    --[[Loveframes needs a 'l' to detect the left mousebutton.
    It's necessary to convert the received "1" value]]--
    if button == 1 then
        button = 'l';
    end
    Loveframes.mousereleased(x, y, button);
end

