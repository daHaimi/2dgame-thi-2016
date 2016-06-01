Class = require "lib.hump.class";
Healthbar = require "class.Healthbar";

local InGame = Class {
    init = function(self)if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.buttonHeight = 75;
            self.buttonOffset = 15;
            self.flagWidth = 120;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.width = 512;
            self.height = 888;
            self.buttonOffset = 20;
            self.buttonHeight = 96;
            self.flagWidth = 165;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            self.flagWidth = 180;
        end
        self.name = "InGame";
        self.frame = Frame(0, 0, "down", "up", 50, 0, -1000);
        self:create();
    end;
};

---creates the inGame elements
function InGame:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        fuelBarBackground = {
            object = Loveframes.Create("image");
            x = 10;
            y = 10;
        },
        fuelBar = {
            object = Loveframes.Create("image");
            x = 10;
            y = 10;
        },
        barFuel = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        },
        barLife = {
            object = Loveframes.Create("image");
            x = _G._persTable.scaledDeviceDim[1] - 256;
            y = 0;
        },
        barMiddle = {
            object = Loveframes.Create("image");
            x = 256;
            y = 0;
        },
        healthbar = {
            object = Healthbar();
            x = 0;
            y = 0;
        },
        score = {
            object = Loveframes.Create("text");
            x = 220;
            y = 20;
        }
    };
    
    self.elementsOnFrame.barMiddle.object:SetImage(self.directory .. "BarMiddle.png");
    self.elementsOnFrame.barMiddle.object:SetScaleX((_G._persTable.scaledDeviceDim[1] - 512)/64);
    self.elementsOnFrame.barLife.object:SetImage(self.directory .. "BarLife.png");
    self.elementsOnFrame.barFuel.object:SetImage(self.directory .. "BarFuel.png");
    self.elementsOnFrame.fuelBar.object:SetImage(self.directory .. "FuelBar.png");
    self.elementsOnFrame.fuelBarBackground.object:SetImage(self.directory .. "FuelBarBG.png");
    
    self.elementsOnFrame.score.object:SetShadow(true);
end

function InGame:update()
    --update Fuelbar
    if self.frame:checkPosition() then
        if _G._tmpTable.roundFuel >= 0 then
            self.elementsOnFrame.fuelBar.object:SetX(math.ceil((180 / 2400)*_G._tmpTable.roundFuel) - 170);
        end
        self.elementsOnFrame.score.object:SetText("Depth: " .. math.ceil(_G._tmpTable.currentDepth) .. "Px");
    end
end

---shows the elements on screen
function InGame:draw()
    --the healthbar does not reset after the pause state
    if _gui:getLastState() ~= _gui:getFrames().pause then
        self.elementsOnFrame.healthbar.object = Healthbar();
    end
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function InGame:clear()
    self.frame:clear(self.elementsOnFrame)
end

---called in the "fly in" state 
function InGame:appear()
    self.frame:appear(self.elementsOnFrame)
end

---called in the "fly out" state
function InGame:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function InGame:checkPosition()
    return self.frame:checkPosition();
end

return InGame;
