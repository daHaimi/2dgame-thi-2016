Class = require "lib.hump.class";
Healthbar = require "class.Healthbar";

local InGame = Class {
    init = function(self)if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.scaleFactor = 1;
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.speed = 50;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.scaleFactor = 1.5;
            self.width = 512;
            self.height = 888;
            self.speed = 60;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.scaleFactor = 2.25;
            self.width = 576;
            self.height = 1024;
            self.speed = 75;
        end
        self.name = "InGame";
        self.offsetY = -1000;
        self.frame = Frame(0, - self.speed, "down", "up", 50, 0, self.offsetY);
        self:create();
    end;
};

---creates the inGame elements
function InGame:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        fuelBarBackground = {
            object = Loveframes.Create("image");
            x = 10 * self.scaleFactor;
            y = 10 * self.scaleFactor;
        },
        fuelBar = {
            object = Loveframes.Create("image");
            x = 10 * self.scaleFactor;
            y = 10 * self.scaleFactor;
        },
        barFuel = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        },
        barMiddle = {
            object = Loveframes.Create("image");
            x = 256 * self.scaleFactor;
            y = 0;
        },
        healthbar = {
            object = Healthbar();
            x = 0;
            y = 0;
        },
        pause = {
            object = Loveframes.Create("imagebutton");
            x = 0;
            y = _G._persTable.scaledDeviceDim[2] - 128;
        };
        score = {
            object = Loveframes.Create("text");
            x = 150 * self.scaleFactor;
            y = 10 * self.scaleFactor;
        }
    };
    
    self.elementsOnFrame.barMiddle.object:SetImage(self.directory .. "BarMiddle.png");
    self.elementsOnFrame.barMiddle.object:SetScaleX(_G._persTable.scaledDeviceDim[1]/64);
    self.elementsOnFrame.barFuel.object:SetImage(self.directory .. "BarFuel.png");
    self.elementsOnFrame.fuelBar.object:SetImage(self.directory .. "FuelBar.png");
    self.elementsOnFrame.fuelBarBackground.object:SetImage(self.directory .. "FuelBarBG.png");
    
    self.elementsOnFrame.score.object:SetShadow(true);
    
    --set image of pause button only on mobile version
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        self.elementsOnFrame.pause.object:SetImage(self.directory .. "Pause.png");
    end
    self.elementsOnFrame.pause.object:SetText("");
    self.elementsOnFrame.pause.object:SizeToImage();
    
    self.elementsOnFrame.pause.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().pause);
    end
    
end

function InGame:update()
    --update Fuelbar
    if _G._tmpTable.roundFuel >= 0 then
        self.elementsOnFrame.fuelBar.object:SetX((math.ceil((100 / 2400)*_G._tmpTable.roundFuel) - 90) * self.scaleFactor);
    end
    local depth = math.ceil(_G._tmpTable.currentDepth / 300);
    if depth <= 0 then
        self.elementsOnFrame.score.object:SetText(_G.data.languages[_G._persTable.config.language].package.textDepth .. math.abs(depth) .. "m");
    else
        self.elementsOnFrame.score.object:SetText(_G.data.languages[_G._persTable.config.language].package.textDepth .. "0m");
    end
end

---shows the elements on screen
function InGame:draw()
    --the healthbar does not reset after the pause state
    if _gui:getLastState() ~= _gui:getFrames().pause then
        self.elementsOnFrame.healthbar.object = Healthbar();
    end
    self.elementsOnFrame.healthbar.object:SetVisible(false);
    self.elementsOnFrame.pause.object:SetVisible(false);
end

function InGame:activate()
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function InGame:clear()
    self.frame:clear(self.elementsOnFrame);
end

---called in the "fly in" state 
function InGame:appear()
    love.mouse.setGrabbed(true);
    love.mouse.setVisible(false);
    self.frame:appear(self.elementsOnFrame);
end

---called in the "fly out" state
function InGame:disappear()
    love.mouse.setGrabbed(false);
    self.elementsOnFrame.healthbar.object:SetVisible(false);
    self.elementsOnFrame.pause.object:SetVisible(false);
    self.frame:disappear(self.elementsOnFrame);
end

---return true if the frame is on position /fly in move is finished
function InGame:checkPosition()
    return self.frame:checkPosition();
end

return InGame;
