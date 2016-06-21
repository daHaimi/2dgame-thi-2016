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
            self.speed = 50;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.width = 512;
            self.height = 888;
            self.buttonOffset = 20;
            self.buttonHeight = 96;
            self.speed = 60;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            self.speed = 75;
        end
        self.name = "Level";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2,
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed, "down", "down", self.speed, 0, -1500);
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
        },
        buttonHouse = {
            object = Loveframes.Create("imagebutton");
            x = 0.05 * self.width;
            y = self.buttonOffset;
        },
        buttonCanyon = {
            object = Loveframes.Create("imagebutton");
            x = 0.25 * self.width;
            y = self.height - 3.6 * self.buttonHeight;
        },
        buttonBack = {
            object = Loveframes.Create("imagebutton");
            x = 0.25 * self.width;
            y = self.height - self.buttonHeight - self.buttonOffset;
        }
    };

    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "LevelBG.png");

    self.elementsOnFrame.buttonHouse.object:SetImage(self.directory .. "HouseButton.png");
    self.elementsOnFrame.buttonHouse.object:SizeToImage();
    self.elementsOnFrame.buttonHouse.object:SetText("");

    if _G._persTable.unlockedLevel == 1 then
        self.elementsOnFrame.buttonCanyon.object:SetImage(self.directory .. "CanyonButton_locked.png");
    else
        self.elementsOnFrame.buttonCanyon.object:SetImage(self.directory .. "CanyonButton.png");
    end
    self.elementsOnFrame.buttonCanyon.object:SizeToImage();
    self.elementsOnFrame.buttonCanyon.object:SetText("");

    self.elementsOnFrame.buttonBack.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.buttonBack.object:SizeToImage();
    self.elementsOnFrame.buttonBack.object:SetText("Back");

    --onclick events for all buttons
    self.elementsOnFrame.buttonHouse.object.OnClick = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'buttonPressed');
        _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("sewers"), _G.data);
        _gui:changeFrame(_gui:getFrames().inGame);
    end

    if _G._persTable.unlockedLevel == 1 then
        self.elementsOnFrame.buttonCanyon.object.OnClick = function(_)
            _gui:newNotification(self.directory .. "ach_nothingCaught.png", "Not unlocked yet!");
        end
    else
        self.elementsOnFrame.buttonCanyon.object.OnClick = function(_)
            TEsound.play({ "assets/sound/buttonPressed.wav" }, 'buttonPressed');
            _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("crazySquirrels"), _G.data);
            _gui:changeFrame(_gui:getFrames().inGame);
        end
    end

    self.elementsOnFrame.buttonBack.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

--- changes the language of this frame
function Level:setLanguage(language)
    self.elementsOnFrame.buttonBack.object:SetText(_G.data.languages[language].package.buttonBack);
end

--- call to unlock the second level
function Level:unlockCanyon()
    _G._persTable.unlockLevel = 2;
    self.elementsOnFrame.buttonCanyon.object:SetImage(self.directory .. "CanyonButton.png");
end

--- shows the frame on screen
function Level:draw()
    self.frame:draw(self.elementsOnFrame);
end

--- called to "delete" this frame
function Level:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Level:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function Level:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

--- return true if the frame is on position /fly in move is finished
function Level:checkPosition()
    return self.frame:checkPosition();
end

return Level;
