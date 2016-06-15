Class = require "lib.hump.class";

local Pause = Class {
    init = function(self)
        if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.buttonHeight = 75;
            self.buttonOffset = 15;
            self.buttonWidth = 261;
            self.speed = 50;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.width = 512;
            self.height = 888;
            self.buttonOffset = 20;
            self.buttonHeight = 96;
            self.buttonWidth = 384;
            self.speed = 60;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            self.buttonWidth = 392;
            self.speed = 75;
        end
        self.name = "Pause";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2,
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed, "down", "down", self.speed, 0, -1500);
        self:create();
    end;
};

--- creates the pause frame
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
            x = 0.16 * self.width;
            y = self.buttonOffset;
        };
        button_backToMenu = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.height - self.buttonHeight;
        };
        button_changeLevel = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + self.buttonHeight
        };
        button_restartLevel = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 2 * self.buttonHeight;
        };
        button_options = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 3 * self.buttonHeight;
        };
    };

    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "StandardBG.png");

    self.elementsOnFrame.button_backToGame.object:SetImage(self.directory .. "Button.png")
    self.elementsOnFrame.button_backToGame.object:SizeToImage();

    self.elementsOnFrame.button_changeLevel.object:SetImage(self.directory .. "Button.png")
    self.elementsOnFrame.button_changeLevel.object:SizeToImage();

    self.elementsOnFrame.button_backToMenu.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_backToMenu.object:SizeToImage();

    self.elementsOnFrame.button_restartLevel.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_restartLevel.object:SizeToImage();

    self.elementsOnFrame.button_options.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_options.object:SizeToImage();

    --onclick events for all buttons
    self.elementsOnFrame.button_backToGame.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().inGame);
    end

    self.elementsOnFrame.button_changeLevel.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().level);
    end

    self.elementsOnFrame.button_backToMenu.object.OnClick = function(_)
        self:checkAchRageQuit();
        _gui:getLevelManager():freeManagedObjects(); -- cleanup level, bait and swarmfactory
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end

    self.elementsOnFrame.button_restartLevel.object.OnClick = function(_)
        self:checkAchRageQuit();
        _gui:getLevelManager():replayLevel();
        _gui:changeFrame(_gui:getFrames().inGame);
    end

    self.elementsOnFrame.button_options.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().options);
    end
end

--- changes the language of this frame
function Pause:setLanguage(language)
    self.elementsOnFrame.button_options.object:SetText(_G.data.languages[language].package.buttonOptions);
    self.elementsOnFrame.button_restartLevel.object:SetText(_G.data.languages[language].package.buttonRestart);
    self.elementsOnFrame.button_backToMenu.object:SetText(_G.data.languages[language].package.buttonBTM);
    self.elementsOnFrame.button_backToGame.object:SetText(_G.data.languages[language].package.buttonBTG);
    self.elementsOnFrame.button_changeLevel.object:SetText(_G.data.languages[language].package.buttonChangeLevel);
end

--- shows the frame on screen
function Pause:draw()
    self.frame:draw(self.elementsOnFrame);
end

--- called to "delete" this frame
function Pause:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Pause:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function Pause:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

--- return true if the frame is on position /fly in move is finished
function Pause:checkPosition()
    return self.frame:checkPosition();
end

--- Unlocks the rage quit achievement.
function Pause:checkAchRageQuit()
    _gui:getLevelManager():getAchievmentManager():checkRageQuit(
        _gui:getLevelManager():getCurLevel():getReachedDepth());
    _gui:getLevelManager():getAchievmentManager():achBitch();
end

return Pause;
