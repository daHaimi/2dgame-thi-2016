Class = require "lib.hump.class";
Healthbar = require "class.Healthbar";
ScoreDisplay = require "class.ScoreDisplay";

local InGame = Class {
    init = function(self)
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
