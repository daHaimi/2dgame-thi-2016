Class = require "lib.hump.class";
Frame = require "class.Frame";

local MainMenu = Class {
    init = function(self)
        self.name = "Main Menu";
        self.frame = Frame(100, 100, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--creates the main menu frame
function MainMenu:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        button_start = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 10;
        };
        button_upgradeMenu = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 50;
        };
        button_dictionary = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 90;
        };
        button_achievements = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 130;
        };
        button_options = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 170;
        };
        button_credits = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 210;
        };
        
        button_close = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 250;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_start.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_start.object:SizeToImage();
    self.elementsOnFrame.button_start.object:SetText("Start");
    
    self.elementsOnFrame.button_upgradeMenu.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_upgradeMenu.object:SizeToImage();
    self.elementsOnFrame.button_upgradeMenu.object:SetText("Shop");
    
    self.elementsOnFrame.button_dictionary.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_dictionary.object:SizeToImage();
    self.elementsOnFrame.button_dictionary.object:SetText("Dictionary");
    
    self.elementsOnFrame.button_achievements.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_achievements.object:SizeToImage();
    self.elementsOnFrame.button_achievements.object:SetText("Achievements");
    
    self.elementsOnFrame.button_options.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_options.object:SizeToImage();
    self.elementsOnFrame.button_options.object:SetText("Options");
    
    self.elementsOnFrame.button_credits.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_credits.object:SizeToImage();
    self.elementsOnFrame.button_credits.object:SetText("Credits");
    
    self.elementsOnFrame.button_close.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_close.object:SizeToImage();
    self.elementsOnFrame.button_close.object:SetText("Close Game");
    
    --onclick events for all buttons
    self.elementsOnFrame.button_start.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().level);
    end
    
    self.elementsOnFrame.button_upgradeMenu.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().upgradeMenu);
    end
    
    self.elementsOnFrame.button_dictionary.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().dictionary);
    end
    
    self.elementsOnFrame.button_achievements.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().achievements);
    end
    
    self.elementsOnFrame.button_options.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().options);
    end
    
    self.elementsOnFrame.button_credits.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().credits);
    end
    
    self.elementsOnFrame.button_close.object.OnClick = function(object)
        love.window:close();
    end
end

---shows the frame on screen
function MainMenu:draw()
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function MainMenu:clear()
    self.frame:clear(self.elementsOnFrame)
end

---called in the "fly in" state 
function MainMenu:appear()
    self.frame:appear(self.elementsOnFrame)
end

---called in the "fly out" state
function MainMenu:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function MainMenu:checkPosition()
    return self.frame:checkPosition();
end

return MainMenu;