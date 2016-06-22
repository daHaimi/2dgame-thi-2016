Class = require "lib.hump.class";
ImageButton = require "class.ImageButton";

local Pause = Class {
    init = function(self)
        self.background = love.graphics.newImage("assets/gui/StandardBG.png");
        self.imageButton = love.graphics.newImage("assets/gui/button.png");
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.offset = (_G._persTable.winDim[2] - self.background:getHeight())/2 + 30;
        self.buttonDistance = 10;
        self.name = "Pause";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--- creates the pause frame
function Pause:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        button_backToGame = ImageButton(self.imageButton, self.buttonXPosition , 
            self.offset, true);
        button_backToMenu = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - self.buttonHeight - 30, true);
        button_changeLevel = ImageButton(self.imageButton, self.buttonXPosition ,  
            self.offset + (self.buttonHeight + self.buttonDistance) * 1, true);
        button_restartLevel = ImageButton(self.imageButton, self.buttonXPosition ,  
            self.offset + (self.buttonHeight + self.buttonDistance) * 2, true);
        button_options = ImageButton(self.imageButton, self.buttonXPosition ,  
            self.offset + (self.buttonHeight + self.buttonDistance) * 3, true);
    };

    --onclick events for all buttons
    self.elementsOnFrame.button_backToGame.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'buttonPressed');
        _gui:changeFrame(_gui:getFrames().inGame);
    end

    self.elementsOnFrame.button_changeLevel.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'buttonPressed');
        _gui:changeFrame(_gui:getFrames().level);
    end

    self.elementsOnFrame.button_backToMenu.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'buttonPressed');
        self:checkAchRageQuit();
        _gui:getLevelManager():freeManagedObjects(); -- cleanup level, bait and swarmfactory
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end

    self.elementsOnFrame.button_restartLevel.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'buttonPressed');
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
    self.elementsOnFrame.button_options:setText(_G.data.languages[language].package.buttonOptions);
    self.elementsOnFrame.button_restartLevel:setText(_G.data.languages[language].package.buttonRestart);
    self.elementsOnFrame.button_backToMenu:setText(_G.data.languages[language].package.buttonBTM);
    self.elementsOnFrame.button_backToGame:setText(_G.data.languages[language].package.buttonBTG);
    self.elementsOnFrame.button_changeLevel:setText(_G.data.languages[language].package.buttonChangeLevel);
end

--- shows the frame on screen
function Pause:draw()
    local _, y = self.elementsOnFrame.button_options:getOffset();
    love.graphics.draw(self.background, (_G._persTable.winDim[1] - self.background:getWidth())/2,
        (_G._persTable.winDim[2] - self.background:getHeight())/2 + y);
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
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

function Pause:mousepressed(x, y)    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            v.gotClicked();
        end
    end
end

return Pause;
