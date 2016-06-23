Class = require "lib.hump.class";

local Start = Class {
    init = function(self)
        self.speed = 20;
        self.name = "start";
        self.title = love.graphics.newImage("assets/gui/title.png")
        self.hamster = love.graphics.newImage("assets/gui/hamster.png")
        self.text = _G.data.languages[_G._persTable.config.language].package.textStartDesktop;
        self.blinkTimer = 10;
        self.offset = _persTable.winDim[1];
    end;
};

function Start:mousepressed(x, y)
    _gui:changeFrame(_gui:getFrames().mainMenu);
end

--- just called frequenzly in the start state
function Start:blink()
    self.blinkTimer = self.blinkTimer - 1;
    if self.blinkTimer <= 0 then
        self.blinkTimer = 25;
        if self.colorBlack then
            self.colorBlack = false;
        else
            self.colorBlack = true;
        end
    end
end

--- shows the frame on screen
function Start:draw()    
    love.graphics.draw(self.title, (_persTable.winDim[1] - self.title:getWidth()) / 2 - self.offset,
        _persTable.winDim[2]/2 - 200);
    love.graphics.draw(self.hamster, 320 + self.offset, _persTable.winDim[2]/2 - 170);
    
    if self.colorBlack then
        love.graphics.setColor(0, 0, 0);
    else
        love.graphics.setColor(255, 255, 255);
    end
    
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 35));
    love.graphics.printf(self.text, 0, 0.75 * _persTable.winDim[2] + self.offset, _persTable.winDim[1], 'center');
    love.graphics.setColor(255, 255, 255);
end

--- called to "delete" this frame
function Start:clear()
    self.offset = _persTable.winDim[1];
end

--- called in the "fly in" state
function Start:appear()
    self.offset = self.offset - self.speed;
end

--- called in the "fly out" state
function Start:disappear()
    self.offset = self.offset + self.speed;
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
