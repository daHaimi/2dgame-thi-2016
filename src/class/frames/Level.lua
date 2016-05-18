Loveframes = require "lib.LoveFrames";
Class = require "lib.hump.class";

local Level = Class {
    init = function(self)
        self.name = "Level";
        self.frame = Frame(100, 100, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--creates the achievement frame
function Level:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        button_level1 = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 10;
        };
        button_level2 = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 50;
        };
        button_level3 = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 90;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 140;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_level1.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_level1.object:SizeToImage();
    self.elementsOnFrame.button_level1.object:SetText("Sewers");
    
    self.elementsOnFrame.button_level2.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_level2.object:SizeToImage();
    self.elementsOnFrame.button_level2.object:SetText("Canyon");
    
    self.elementsOnFrame.button_level3.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_level3.object:SizeToImage();
    self.elementsOnFrame.button_level3.object:SetText("Space");
    
    self.elementsOnFrame.button_back.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_back.object:SizeToImage();
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    
    --onclick events for all buttons
    self.elementsOnFrame.button_level1.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.inGame);
    end
    
    self.elementsOnFrame.button_level2.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.inGame);
    end
    
    self.elementsOnFrame.button_level3.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.inGame);
    end
    
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.mainMenu);
    end
end



function Level:draw()
    self.frame:draw(self.elementsOnFrame);
end

--called to "delete" this frame
function Level:clear()
    self.frame:clear(self.elementsOnFrame)
end

--called in the "fly in" state 
function Level:appear()
    self.frame:appear(self.elementsOnFrame)
end

--called in the "fly out" state
function Level:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function Level:checkPosition()
    return self.frame:checkPosition();
end
return Level;
