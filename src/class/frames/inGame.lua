Class = require "lib.hump.class";
Healthbar = require "class.Healthbar";

local InGame = Class {
    init = function(self)
        self.name = "InGame";
        self.button = love.graphics.newImage("assets/gui/pause.png");
        self.fuelBarBackground = love.graphics.newImage("assets/gui/FuelBarBG.png");
        self.fuelBar = love.graphics.newImage("assets/gui/FuelBar.png");
        self.barFuel = love.graphics.newImage("assets/gui/BarFuel.png");
        self.barMiddle = love.graphics.newImage("assets/gui/BarMiddle.png");
        self.score = "";
        self.drawBar = false;
        self.fuelBarPosition = 0;
        self.frame = Frame(0, 0, "up", "up", 50, 0, 1500);
        self:create();
    end;
};

--- creates the inGame elements
function InGame:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        healthbar = Healthbar();
        pause = ImageButton(self.button, 0, 0, true);
        --[[score = {
            object = Loveframes.Create("text");
            x = 150;
            y = 10
        }]]
    };
    
    self.elementsOnFrame.healthbar:setPos();
    
    ---set position of pause button
    local _, height = self.elementsOnFrame.pause:getSize();
    self.elementsOnFrame.pause:setPosition(0, _G._persTable.scaledDeviceDim[2] - height);
   -- self.elementsOnFrame.barMiddle.object:SetScaleX(_G._persTable.scaledDeviceDim[1] / 64);

    --set image of pause button only on mobile version
    self.elementsOnFrame.pause:setText("");

    self.elementsOnFrame.pause.gotClicked = function(_)
        if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
            _gui:changeFrame(_gui:getFrames().pause);
        end
    end
end

function InGame:update()
    --update Fuelbar
    if _G._tmpTable.roundFuel >= 0 then
        self.fuelBarPosition = ((math.ceil((100 / 2400) * _G._tmpTable.roundFuel) - 90));
    else
        self.fuelBarPosition = -90;
    end
    local depth = math.ceil(_G._tmpTable.currentDepth / 300);
    if depth <= 0 then
        self.score = (_G.data.languages[_G._persTable.config.language].package.textDepth .. math.abs(depth) .. "m");
    else
        self.score = (_G.data.languages[_G._persTable.config.language].package.textDepth .. "0m");
    end
end

function InGame:activate()
    self.drawBar = true;
end

--- shows the elements on screen
function InGame:draw()
    if self.drawBar then
        love.graphics.draw(self.fuelBarBackground, 10, 10);
        love.graphics.draw(self.fuelBar, self.fuelBarPosition, 10);
        love.graphics.draw(self.barFuel, 0, 0);
        if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
            self.elementsOnFrame.pause:draw();
        end
        self.elementsOnFrame.healthbar:draw();
        local font = love.graphics.getFont();
        love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 20));
        love.graphics.printf(self.score, _G._persTable.winDim[1]/2 - 100 , 20, 200, "center")
        love.graphics.setFont(font);
    end
end

--- called to "delete" this frame
function InGame:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function InGame:appear()
    love.mouse.setGrabbed(true);
    love.mouse.setVisible(false);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function InGame:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

function InGame:mousepressed(x, y)
    local xPosition, yPosition = self.elementsOnFrame.pause:getPosition();
    local width, height = self.elementsOnFrame.pause:getSize();
    
    if x > xPosition and x < xPosition + width and
    y > yPosition and y < yPosition + height then
        self.elementsOnFrame.pause.gotClicked();
    else
        if not _gui.levMan:getCurLevel():getStartAnimationRunning() and
        not _gui.levMan:getCurLevel():getStartAnimationFinished() then
            _gui.levMan:getCurLevel():startStartAnimation();
        end
    end
end

--- return true if the frame is on position /fly in move is finished
function InGame:checkPosition()
    return self.frame:checkPosition();
end

return InGame;
