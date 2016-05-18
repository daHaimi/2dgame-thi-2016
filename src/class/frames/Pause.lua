Loveframes = require "lib.LoveFrames";
Class = require "lib.hump.class";

local Pause = Class {
    init = function(self)
        self.name = "Pause";
        self.frame = Frame(100, 100, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--creates the achievement frame
function Pause:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        button_backToGame = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 10;
        };
        button_backToMenu = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 50;
        };
        button_options = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 90;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_backToGame.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_backToGame.object:SizeToImage()
    self.elementsOnFrame.button_backToGame.object:SetText("Back to the Game");
    
    self.elementsOnFrame.button_backToMenu.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_backToMenu.object:SizeToImage()
    self.elementsOnFrame.button_backToMenu.object:SetText("Back to Menu");
    
    self.elementsOnFrame.button_options.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_options.object:SizeToImage()
    self.elementsOnFrame.button_options.object:SetText("Options");
    
    --onclick events for all buttons
    self.elementsOnFrame.button_backToGame.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.inGame);
    end
    
    self.elementsOnFrame.button_backToMenu.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.mainMenu);
    end
    
    self.elementsOnFrame.button_options.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.options);
    end
end

function Pause:draw()
    self.frame:draw(self.elementsOnFrame);
end

--called to "delete" this frame
function Pause:clear()
    self.frame:clear(self.elementsOnFrame)
end

--called in the "fly in" state 
function Pause:appear()
    self.frame:appear(self.elementsOnFrame)
end

--called in the "fly out" state
function Pause:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function Pause:checkPosition()
    return self.frame:checkPosition();
end
return Pause;
