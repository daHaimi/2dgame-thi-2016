Class = require "lib.hump.class";

local Options = Class {
    init = function(self)
        if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.buttonHeight = 75;
            self.buttonOffset = 15;
            self.buttonWidth = 261;
            speed = 50;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.width = 512;
            self.height = 888;
            self.buttonOffset = 20;
            self.buttonHeight = 96;
            self.buttonWidth = 384;
            speed = 67;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            self.buttonWidth = 392;
            speed = 75;
        end
        self.name = "Options";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2, 
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2, "down", "down", speed, 0, -1500);
        self:create();
    end;
};

---creates the options frame
function Options:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        slider_bgm = {
            object = Loveframes.Create("slider");
            x = 64;
            y = 0;
        };
        slider_music = {
            object = Loveframes.Create("slider");
            x = 64;
            y = 50;
        };
        button_reset = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.height - 2 * self.buttonHeight;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.height - self.buttonHeight;
        };
    };

    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "StandardBG.png");
    
    self.elementsOnFrame.slider_bgm.object:SetText("BGM");
    self.elementsOnFrame.slider_bgm.object:SetMinMax(0, 100);
    self.elementsOnFrame.slider_bgm.object:SetWidth(self.buttonWidth);
    
    self.elementsOnFrame.slider_music.object:SetText("Music");
    self.elementsOnFrame.slider_music.object:SetMinMax(0, 100);
    self.elementsOnFrame.slider_music.object:SetWidth(self.buttonWidth);
    
    self.elementsOnFrame.button_reset.object:SetImage(self.directory .. "gui_Test_Button.png");
    self.elementsOnFrame.button_reset.object:SizeToImage();
    self.elementsOnFrame.button_reset.object:SetText("Reset");
    
    self.elementsOnFrame.button_back.object:SetImage(self.directory .. "gui_Test_Button.png");
    self.elementsOnFrame.button_back.object:SizeToImage();
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    --load values out of persTable into the chart
    self:loadValuesFromPersTable();
        
    --onclick events for all buttons
    self.elementsOnFrame.slider_bgm.OnValueChanged = function(object)
        _persTable.config.bgm = self.elementsOnFrame.slider_bgm.object:GetValue();
    end
    
    self.elementsOnFrame.slider_music.OnValueChanged = function(object)
        _persTable.config.music = self.elementsOnFrame.slider_music.object:GetValue();
    end
    
    self.elementsOnFrame.button_reset.object.OnClick = function(object)
        _persistence:resetGame();
        self:loadValuesFromPersTable();
        _gui:tempTextOutput();
    end
    
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        self:loadValuesInPersTable();
        _gui:tempTextOutput();
        _gui:changeFrame(_gui:getLastState());
    end
end

function Options:loadValuesInPersTable()
    _persTable.config.bgm = self.elementsOnFrame.slider_bgm.object:GetValue();
    _persTable.config.music = self.elementsOnFrame.slider_music.object:GetValue();
end


function Options:loadValuesFromPersTable()
    self.elementsOnFrame.slider_bgm.object:SetValue(_persTable.config.bgm);
    self.elementsOnFrame.slider_music.object:SetValue(_persTable.config.music);
end

---shows the frame on screen
function Options:draw()
    self:loadValuesFromPersTable();
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function Options:clear()
    self.frame:clear(self.elementsOnFrame)
end

---called in the "fly in" state 
function Options:appear()
    self.frame:appear(self.elementsOnFrame)
end

---called in the "fly out" state
function Options:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function Options:checkPosition()
    return self.frame:checkPosition();
end

return Options;
