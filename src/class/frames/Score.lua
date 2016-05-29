Class = require "lib.hump.class";

local Score = Class {
    init = function(self)
        if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.buttonHeight = 75;
            self.buttonOffset = 15;
            speed = 50;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.width = 512;
            self.height = 888;
            self.buttonOffset = 20;
            self.buttonHeight = 96;
            speed = 67;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            speed = 75;
        end
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
        scoretext = {
            object = Loveframes.Create("text");
            x = 0;
            y = 30;
        };
        score = {
            object = Loveframes.Create("text");
            x = 110;
            y = 90;
        };
        button_retry = {
            object = Loveframes.Create("imagebutton");
            x = 0;
            y = 300;
        };
        button_backToMenu = {
            object = Loveframes.Create("imagebutton");
            x = 0;
            y = 400;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "ScoreScreen.png");
    
    self.elementsOnFrame.scoretext.object:SetText("Your Score:");
    self.elementsOnFrame.scoretext.x = 128 - 0.5 * self.elementsOnFrame.scoretext.object:GetWidth();
    
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
