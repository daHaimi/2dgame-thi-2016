Class = require "lib.hump.class";
Healthbar = require "class.Healthbar";

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
        button_pause = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 10;
        };
        healthbar = {
            object = Healthbar();
            x = 0;
            y = 0;
        }
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.button_pause.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_pause.object:SizeToImage()
    self.elementsOnFrame.button_pause.object:SetText("Pause");
    
    --onclick events for all buttons
    self.elementsOnFrame.button_pause.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.pause);
    end
end

---shows the elements on screen
function InGame:draw()
    --the healthbar does not reset after the pause state
    if _gui:getLastState() ~= _gui.myFrames.pause then
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
