
Class = require "lib.hump.class";

local Dictionary = Class {
    init = function(self)
        self.name = "Dictionary";
        self.frame = Frame(100, 100, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--creates the achievement frame
function Dictionary:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        chart = {
            object = Chart();
            x = 10;
            y = 10;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 300;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_back.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_back.object:SizeToImage()
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    
    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.mainMenu);
    end
end


function Dictionary:draw()
    self.frame:draw(self.elementsOnFrame);
end

--called to "delete" this frame
function Dictionary:clear()
    self.frame:clear(self.elementsOnFrame)
end

--called in the "fly in" state 
function Dictionary:appear()
    self.frame:appear(self.elementsOnFrame)
end

--called in the "fly out" state
function Dictionary:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function Dictionary:checkPosition()
    return self.frame:checkPosition();
end
return Dictionary;
