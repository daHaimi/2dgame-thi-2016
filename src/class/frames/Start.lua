Class = require "lib.hump.class";

local Start = Class {
    init = function(self)
        self.speed = 40;
        self.name = "start";
        self.x = 0.05 * _persTable.scaledDeviceDim[1];
        self.y = 0.2 * _persTable.scaledDeviceDim[2];
        self.blinkTimer = 50;
        self.offset = 1200;
        self:create();
    end;
};

--- creates the Start frame
function Start:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        title = Loveframes.Create("image");
        hamster = Loveframes.Create("image");
        text = Loveframes.Create("text");
    };

    --adjust all elements on this frame
    self.elementsOnFrame.title:SetImage("assets/gui/title.png");
    self.elementsOnFrame.title:SetScale(0.9 * _persTable.scaledDeviceDim[1] / 256, 0.9 * _persTable.scaledDeviceDim[1] / 256);

    self.elementsOnFrame.hamster:SetImage("assets/gui/hamster.png");
    self.elementsOnFrame.hamster:SetScale(0.9 * _persTable.scaledDeviceDim[1] / 256, 0.9 * _persTable.scaledDeviceDim[1] / 256);

    self.elementsOnFrame.text:SetFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 35));
    self.elementsOnFrame.text:SetText({ { color = { 255, 255, 255, 255 } }, _G.data.languages[_G._persTable.config.language].package.textStart })
    self.elementsOnFrame.text:SetPos(0.5 * _persTable.scaledDeviceDim[1] - 0.5 * self.elementsOnFrame.text:GetWidth(), 0.75 * _persTable.scaledDeviceDim[2]);
end

function Start:mousepressed(x, y)
    _gui:changeFrame(_gui:getFrames().mainMenu);
end

--- just called frequenzly in the start state
function Start:blink()
    self.blinkTimer = self.blinkTimer - 1;
    if self.blinkTimer <= 0 then
        self.elementsOnFrame.text:SetVisible(not self.elementsOnFrame.text:GetVisible());
        self.blinkTimer = 50;
    end
end

--- shows the frame on screen
function Start:draw()
    for _, v in pairs(self.elementsOnFrame) do
        v:SetVisible(true);
    end
end

--- called to "delete" this frame
function Start:clear()
    for _, v in pairs(self.elementsOnFrame) do
        v:SetVisible(false);
    end
end

--- called in the "fly in" state
function Start:appear()
    self.elementsOnFrame.title:SetPos(self.x - self.offset, self.y);
    self.elementsOnFrame.hamster:SetPos(self.x + self.offset + 0.6 * _persTable.scaledDeviceDim[1], self.y - 0.1 * _persTable.scaledDeviceDim[2]);
    self.offset = self.offset - self.speed;
end

--- called in the "fly out" state
function Start:disappear()
    self.elementsOnFrame.title:SetPos(self.x + self.offset, self.y);
    self.elementsOnFrame.hamster:SetPos(self.x - self.offset + 0.5 * _persTable.scaledDeviceDim[1], self.y - 0.1 * _persTable.scaledDeviceDim[2]);
    self.offset = self.offset - self.speed;
end

--- return true if the frame is on position /fly in move is finished
function Start:checkPosition()
    if self.offset <= 0 then
        return true;
    else
        return false;
    end
end

return Start;
