-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait"
Level = require "class.Level"

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
--- upgrades list in persTable, "0" means unbought
_G._persTable.upgrades = {
    speedUp = 0; --- "0" no Speedup
    moneyMult = 0; --- "0" means no additional money
    moreLife = 0; --- amount of additional lifes
    godMode = 0; --- 
  
  }

-- Local variables
local winDim = {};
local curLevel = nil;
local player = nil;

-- The bootstrap of the game. 
-- This function is called exactly once at the beginning of the game.
function love.load()
    local _, _, flags = love.window.getMode()
    winDim = {love.window.getDesktopDimensions(flags.display)};
    winDim[2] = winDim[2] - 50; -- Sub 50px for taskbar and window header
    winDim[1] = (winDim[2] / 16) * 9; -- Example: 16:9
    love.window.setMode(winDim[1], winDim[2], flags);
    curLevel = Level("assets/testbg.png", winDim, 1);
    player = Bait(winDim);
    player:checkUpgrades();
end

-- The love main draw call, which draws every frame on the screen.
-- This function is called continuously by the love.run().
function love.draw()
    if curLevel then
        curLevel:draw(player);
    end
end

-- This function is called continuously by the love.run().
-- @param dt Delta time  is the amount of seconds since the 
-- last time this function was called.
function love.update(dt)
    if curLevel then
        curLevel:update(dt, player);
    end
end
  
-- Callback function triggered when the mouse is moved. 
-- @param x The mouse position on the x-axis.
-- @param y The mouse position on the y-axis.
function love.mousemoved(x, y)
    if player then
        if x < (player.size / 2) then
            player.posXMouse = 0;
        else 
          if x > winDim[1] - player.size then
              player.posXMouse = winDim[1] - player.size;
          else 
              player.posXMouse = x - (player.size / 2);
          end
        end  
    end
end

