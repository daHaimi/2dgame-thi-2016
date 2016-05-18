Loveframes = require "lib.LoveFrames";
Class = require "lib.hump.class";

local Score = Class {
    init = function(self)
        self.name = "Score";
        self.frame = Frame(100, 100, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--creates the achievement frame
function Score:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        button_retry = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 10;
        };
        button_backToMenu = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 50;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_retry.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_retry.object:SizeToImage()
    self.elementsOnFrame.button_retry.object:SetText("Retry");
    
    self.elementsOnFrame.button_backToMenu.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_backToMenu.object:SizeToImage()
    self.elementsOnFrame.button_backToMenu.object:SetText("Back to Menu");
    
    
    --onclick events for all buttons
    self.elementsOnFrame.button_retry.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.inGame);
    end
    
    self.elementsOnFrame.button_backToMenu.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.mainMenu);
    end
end

function Score:draw()
    self.frame:draw(self.elementsOnFrame);
end

--called to "delete" this frame
function Score:clear()
    self.frame:clear(self.elementsOnFrame)
end

--called in the "fly in" state 
function Score:appear()
    self.frame:appear(self.elementsOnFrame)
end

--called in the "fly out" state
function Score:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function Score:checkPosition()
    return self.frame:checkPosition();
end
return Score;
