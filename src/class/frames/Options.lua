Class = require "lib.hump.class";

local Options = Class {
    init = function(self)
        self.name = "Options";
        self.xPos = 50;
        self.yPos = 50;
        self.xDefaultOffset = 0; 
        self.yDefaultOffset = -1500;
        self.xOffset = self.xDefaultOffset;
        self.yOffset = self.yDefaultOffset;
        self.moveSpeed = 50;
        self:create();
    end;
};

--creates the achievement frame
function Options:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
        };
        slider_bgm = {
            object = Loveframes.Create("slider");
            x = 0;
            y = 0;
        };
        slider_music = {
            object = Loveframes.Create("slider");
            x = 0;
            y = 50;
        };
        button_reset = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 100;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 150;
        };
    };

    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.slider_bgm.object:SetText("BGM");
    self.elementsOnFrame.slider_bgm.object:SetMinMax(0, 100);
    self.elementsOnFrame.slider_bgm.object:SetWidth(128);
    
    self.elementsOnFrame.slider_music.object:SetText("Music");
    self.elementsOnFrame.slider_music.object:SetMinMax(0, 100);
    self.elementsOnFrame.slider_music.object:SetWidth(128);
    
    self.elementsOnFrame.button_reset.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_reset.object:SizeToImage();
    self.elementsOnFrame.button_reset.object:SetText("Reset");
    
    self.elementsOnFrame.button_back.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_back.object:SizeToImage();
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    --onclick events for all buttons
    self.elementsOnFrame.slider_bgm.OnValueChanged = function(object)
        _persTable.config.bgm = self.elementsOnFrame.slider_bgm.object:GetValue();
    end
    
    self.elementsOnFrame.slider_music.OnValueChanged = function(object)
        _persTable.config.music = self.elementsOnFrame.slider_music.object:GetValue();
    end
    
    self.elementsOnFrame.button_reset.object.OnClick = function(object)
        --enter reset event
    end
    
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.mainMenu);
    end
end

--called to "delete" this frame
function Options:clear()
    --visible set on false/ should only done in this function
    self.elementsOnFrame.background.object:SetVisible(false);
    self.elementsOnFrame.button_back.object:SetVisible(false);
    --set the offset on the default value
    self.xOffset = self.xDefaultOffset;
    self.yOffset = self.yDefaultOffset;
end

--called in the "fly in" state 
function Options:appear()
    self.yOffset = self.yOffset + self.moveSpeed;
    self:setPosition();
end

--called in the "fly out" state
function Options:disappear()
    self.yOffset = self.yOffset + self.moveSpeed;
    self:setPosition();
end

function Options:setPosition()
    self.elementsOnFrame.background.object:SetPos(self.xPos + self.xOffset, self.yPos + self.yOffset)
    self.elementsOnFrame.button_back.object:SetPos(self.xPos + self.elementsOnFrame.button_back.x + self.xOffset, self.yPos + self.elementsOnFrame.button_back.y + self.yOffset);
    
    
end

function Options:draw()
    for k, v in pairs(self.elementsOnFrame) do
        v.object:SetVisible(true);
    end
end

---return true if the frame is on position /fly in move is finished
function Options:checkPosition()
    if (self.xOffset == 0 and self.yOffset == 0) then
        return true;
    else
        return false;
    end
end

return Options;
