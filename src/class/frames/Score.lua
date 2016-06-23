Class = require "lib.hump.class";
AchievementDisplay = require "class.AchievementDisplay";
ImageButton = require "class.ImageButton";

local Score = Class {
    init = function(self)
        self.background = love.graphics.newImage("assets/gui/ScoreScreen.png");
        self.backgroundPosition = {(_G._persTable.winDim[1] - self.background:getWidth()) / 2,
            (_G._persTable.winDim[2] - self.background:getHeight()) / 2};
        self.imageButton = love.graphics.newImage("assets/gui/Button.png");
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.name = "Score";
        self.scoretext = "";
        self.scoretextPosition = 0;
        self.score = "";
        self.scorePosition = 0;
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--- creates the Score frame
function Score:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        achievements = AchievementDisplay();
        button_retry = ImageButton(self.imageButton, self.buttonXPosition , 
            self.backgroundPosition[2] + self.background:getHeight() - 2 * self.buttonHeight - 45, true);
        button_backToMenu = ImageButton(self.imageButton, self.buttonXPosition , 
            self.backgroundPosition[2] + self.background:getHeight() - self.buttonHeight - 30, true);
    };

    --adjust all elements on this frame
    self.scoretext = (_G.data.languages[_G._persTable.config.language].package.textScore);
    self.scoretextPosition = 200;
    self.scorePosition = 300;
    
    self.elementsOnFrame.achievements:setPosition(self.backgroundPosition[1], 
        self.backgroundPosition[2] + self.background:getHeight() * 0.3 + 100);

    --onclick events for all buttons
    self.elementsOnFrame.button_retry.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        self.elementsOnFrame.achievements:remove();
        _gui:getLevelManager():replayLevel();
        _gui:changeFrame(_gui:getFrames().inGame);
    end

    self.elementsOnFrame.button_backToMenu.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        self.elementsOnFrame.achievements:remove();
        _gui:getLevelManager():freeManagedObjects();
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
    
    self.elementsOnFrame.achievements.gotClicked = function (_)
    end
end

--- changes the language of this frame
function Score:setLanguage(language)
    self.scoretext = (_G.data.languages[language].package.textScore);
    self.elementsOnFrame.button_retry:setText(_G.data.languages[language].package.buttonRetry);
    self.elementsOnFrame.button_backToMenu:setText(_G.data.languages[language].package.buttonBTM);
    self.elementsOnFrame.achievements:setLanguage(language);
end

--- shows the frame on screen
function Score:draw()
    self.score = (_G._tmpTable.earnedMoney);    
    local _, y = self.elementsOnFrame.button_retry:getOffset();
    
    
    love.graphics.draw(self.background, self.backgroundPosition[1], self.backgroundPosition[2] + 100 + y);
    
    
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
    
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 25));
    love.graphics.setColor(0, 0, 0);
    love.graphics.printf(self.scoretext, 0, self.backgroundPosition[2] + 120
        + y, _G._persTable.winDim[1], 'center');
    if self.score ~= nil then 
        love.graphics.printf(self.score, self.backgroundPosition[1], self.backgroundPosition[2] + 190
            + y, self.background:getWidth() - 50, 'center');
    end
    love.graphics.setColor(255, 255, 255);
end

function Score:mousepressed(x, y)    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            v.gotClicked();
        end
    end
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
