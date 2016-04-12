-- Includes
Class = require "lib.hump.class";
Bait = require "class.Bait"
Level = require "class.Level"

local winDim = {};
local curLevel = nil;
local player = nil;

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

-- Bootstrap
function love.load()
    local _, _, flags = love.window.getMode()
    winDim = {love.window.getDesktopDimensions(flags.display)};
    winDim[2] = winDim[2] - 50; -- Sub 50px for taskbar and window header
    winDim[1] = (winDim[2] / 16) * 9; -- Example: 16:9
    love.window.setMode(winDim[1], winDim[2], flags);
    curLevel = Level(love.graphics.newImage("assets/testbg.png"), winDim);
    player = Bait(winDim);
    player:checkUpgrades();
end


-- Main draw
function love.draw()
    if curLevel then
        curLevel:draw(player);
    end
end

function love.update(dt)
    if curLevel then
        curLevel:update(dt, player);
    end
end
  
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

