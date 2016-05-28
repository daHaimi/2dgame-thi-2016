Class = require "lib.hump.class";

local Score = Class {
    init = function(self)
        self.name = "Score";
       self.frame = Frame((_G._persTable.scaledDeviceDim[1] - 256) / 2, (_G._persTable.scaledDeviceDim[2] - 512) / 2,
            "down", "down", 50, 0, -1500);
        self:create();
    end;
};

---creates the Score frame
function Score:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        score = {
            object = Loveframes.Create("text");
            x = 0;
            y = 0;
        };
        button_retry = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 30;
        };
        button_backToMenu = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 110;
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
        _gui:changeFrame(_gui:getFrames().inGame);
    end
    
    self.elementsOnFrame.button_backToMenu.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

---shows the frame on screen
function Score:draw()
    self.elementsOnFrame.score.object:SetText(_G.testScore);
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function Score:clear()
    self.frame:clear(self.elementsOnFrame)
end

---called in the "fly in" state 
function Score:appear()
    self.frame:appear(self.elementsOnFrame)
end

---called in the "fly out" state
function Score:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function Score:checkPosition()
    return self.frame:checkPosition();
end

return Score;
