---Button on the main menu to change the language
Class = require "lib.hump.class";

local ScoreDisplay = Class {
    init = function(self)
        self.scoreValue = nil;
        self.background = nil;
        self:create();
    end;
};

function ScoreDisplay:create()
    self.background = Loveframes.Create("image");
    self.background:SetImage("assets/gui/ScoreDisplay.png");
    
    self.scoreValue = Loveframes.Create("text");
    self.scoreValue:SetText("Your Score:" .. _G.testScore);
    self.scoreValue:SetVisible(true);
    self.scoreValue:SetShadow(true);
    
    
end

function ScoreDisplay:update()
    --just testing
    _G.testScore = _G.testScore + 5;
    self.scoreValue:SetText("Your Score:" .. _G.testScore);
end

function ScoreDisplay:SetVisible(visible)
    self.scoreValue:SetVisible(visible);
    self.background:SetVisible(visible);
end

function ScoreDisplay:SetPos(x, y)
    self.scoreValue:SetPos(x, y);
    self.background:SetPos(x, y);
end

return ScoreDisplay