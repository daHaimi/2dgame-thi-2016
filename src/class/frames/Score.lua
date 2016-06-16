Class = require "lib.hump.class";
AchievementDisplay = require "class.AchievementDisplay";

local Score = Class {
    init = function(self)
        self.directory = "assets/gui/480px/";
        self.widthPx = 480;
        self.width = 384;
        self.height = 666;
        self.buttonHeight = 75;
        self.scoreHeight = 170;
        self.achievementsHeight = 136;
        self.Offset = 15;
        self.speed = 50;

        self.name = "Score";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2,
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed, "down", "down", self.speed, 0, -1500);
        self:create();
    end;
};

--- creates the Score frame
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
        achievements = {
            object = AchievementDisplay(self.directory);
            x = 0;
            y = self.scoreHeight + self.Offset;
        };
        button_retry = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.scoreHeight + self.achievementsHeight + 2 * self.Offset;
        };
        button_backToMenu = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.scoreHeight + self.achievementsHeight + self.buttonHeight + 3 * self.Offset;
        };
    };

    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "ScoreScreen.png");

    self.elementsOnFrame.scoretext.object:SetText(_G.data.languages[_G._persTable.config.language].package.textScore);
    self.elementsOnFrame.scoretext.x = 0.5 * self.width - 0.5 * self.elementsOnFrame.scoretext.object:GetWidth();

    self.elementsOnFrame.score.x = 0.5 * self.width - 30;

    self.elementsOnFrame.button_retry.object:SetImage(self.directory .. "Button.png")
    self.elementsOnFrame.button_retry.object:SizeToImage()

    self.elementsOnFrame.button_backToMenu.object:SetImage(self.directory .. "Button.png")
    self.elementsOnFrame.button_backToMenu.object:SizeToImage()

    --onclick events for all buttons
    self.elementsOnFrame.button_retry.object.OnClick = function(_)
        _gui:getLevelManager():replayLevel();
        _gui:changeFrame(_gui:getFrames().inGame);
    end

    self.elementsOnFrame.button_backToMenu.object.OnClick = function(_)
        _gui:getLevelManager():freeManagedObjects();
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

--- changes the language of this frame
function Score:setLanguage(language)
    self.elementsOnFrame.scoretext.object:SetText(_G.data.languages[language].package.textScore);
    self.elementsOnFrame.button_retry.object:SetText(_G.data.languages[language].package.buttonRetry);
    self.elementsOnFrame.button_backToMenu.object:SetText(_G.data.languages[language].package.buttonBTM);
    self.elementsOnFrame.achievements.object:setLanguage(language);
end

--- shows the frame on screen
function Score:draw()
    self.elementsOnFrame.score.object:SetText(_G._tmpTable.earnedMoney);
    self.frame:draw(self.elementsOnFrame);
end

--- called to "delete" this frame
function Score:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Score:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function Score:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

--- return true if the frame is on position /fly in move is finished
function Score:checkPosition()
    return self.frame:checkPosition();
end

return Score;
