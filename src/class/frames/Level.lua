Class = require "lib.hump.class";

local Level = Class {
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
            speed = 60;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            speed = 75;
        end
        self.name = "Level";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2, 
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2, "down", "down", speed, 0, -1500);
        self:create();
    end;
};

--creates the level frame
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
            x = 0.16 * self.width;
            y = self.buttonOffset;
        };
        button_level2 = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 1 * self.buttonHeight;
        };
        button_level3 = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 2 * self.buttonHeight;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.height - self.buttonHeight;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "gui_Test_Bg.png");
    
    self.elementsOnFrame.button_level1.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_level1.object:SizeToImage();
    self.elementsOnFrame.button_level1.object:SetText("Sewers");
    
    self.elementsOnFrame.button_level2.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_level2.object:SizeToImage();
    self.elementsOnFrame.button_level2.object:SetText("Canyon");
    
    self.elementsOnFrame.button_level3.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_level3.object:SizeToImage();
    self.elementsOnFrame.button_level3.object:SetText("Space");
    
    self.elementsOnFrame.button_back.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_back.object:SizeToImage();
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    --onclick events for all buttons
    self.elementsOnFrame.button_level1.object.OnClick = function(object)
        _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("sewers"), _G.data);
        _gui:changeFrame(_gui:getFrames().inGame);
    end
    
    self.elementsOnFrame.button_level2.object.OnClick = function(object)
        _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("canyon"), _G.data);
        _gui:changeFrame(_gui:getFrames().inGame);
    end
    
    self.elementsOnFrame.button_level3.object.OnClick = function(object)
        _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("space"), _G.data);
        _gui:changeFrame(_gui:getFrames().inGame);
    end
    
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

---shows the frame on screen
function Level:draw()
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function Level:clear()
    self.frame:clear(self.elementsOnFrame);
end

---called in the "fly in" state 
function Level:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

---called in the "fly out" state
function Level:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

---return true if the frame is on position /fly in move is finished
function Level:checkPosition()
    return self.frame:checkPosition();
end

return Level;
