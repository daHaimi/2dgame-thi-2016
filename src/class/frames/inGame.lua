Class = require "lib.hump.class";
Healthbar = require "class.Healthbar";
ScoreDisplay = require "class.ScoreDisplay";

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
        self.frame = Frame(0, 0, "right", "left", 50, -1000, 0);
        self:create();
    end;
};

---creates the inGame elements
function InGame:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        healthbar = {
            object = Healthbar();
            x = 0;
            y = 0;
        },
        score = {
            object = ScoreDisplay();
            x = 0;
            y = 0;
        }
        
    };
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
