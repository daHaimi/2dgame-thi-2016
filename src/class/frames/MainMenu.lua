Class = require "lib.hump.class";
Frame = require "class.Frame";
ImageButton = require "class.ImageButton";

local MainMenu = Class {
    init = function(self)
        self.background = love.graphics.newImage("assets/gui/StandardBG.png");
        self.imageButton = love.graphics.newImage("assets/gui/Button.png");
        self.imageFlag = love.graphics.newImage("assets/gui/" .. _G.data.languages[_persTable.config.language].flagImage);
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.offset = (_G._persTable.winDim[2] - self.background:getHeight())/2 + 30;
        self.buttonDistance = 10;
        self.flagWidth = 120;
        self.name = "Main Menu";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -2000);
        self:create();
    end;
};

--creates the main menu frame
function MainMenu:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        button_start = ImageButton(self.imageButton, self.buttonXPosition , 
            self.offset, true);
        button_upgradeMenu = ImageButton(self.imageButton, self.buttonXPosition , 
            self.offset + (self.buttonHeight + self.buttonDistance) * 1, true);
        button_dictionary = ImageButton(self.imageButton, self.buttonXPosition ,  
            self.offset + (self.buttonHeight + self.buttonDistance) * 2, true);
        button_achievements = ImageButton(self.imageButton, self.buttonXPosition ,  
            self.offset + (self.buttonHeight + self.buttonDistance) * 3, true);
        button_options = ImageButton(self.imageButton, self.buttonXPosition ,  
            self.offset + (self.buttonHeight + self.buttonDistance) * 4, true);
        button_credits = ImageButton(self.imageButton, self.buttonXPosition ,  
            self.offset + (self.buttonHeight + self.buttonDistance) * 5, true);
        button_flag = ImageButton(self.imageFlag, (_G._persTable.winDim[1] - self.imageFlag:getWidth())/2 ,  
            self.offset + (self.buttonHeight + self.buttonDistance) * 6, true);
        button_close = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - self.buttonHeight - 30, true);
    };

    --adjust all elements on this frame

    --onclick events for all buttons
    self.elementsOnFrame.button_start.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
       _gui:changeFrame(_gui:getFrames().level);
    end

    self.elementsOnFrame.button_upgradeMenu.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().upgradeMenu);
    end

    self.elementsOnFrame.button_dictionary.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().dictionary);
    end

    self.elementsOnFrame.button_achievements.gotClicked = function(_)
        --_gui:newTextNotification("assets/hamster.png", "testNotification");
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().achievements);
    end
    
    self.elementsOnFrame.button_options.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().options);
    end
    
    self.elementsOnFrame.button_credits.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().credits);
    end

    self.elementsOnFrame.button_close.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        love.window:close();
        love.event.quit();
    end
    
    self.elementsOnFrame.button_flag.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        if _G._persTable.config.language == "english" then
            _G._persTable.config.language = "german";
        else
            _G._persTable.config.language = "english";
        end
        self.elementsOnFrame.button_flag:setImage(love.graphics.newImage("assets/gui/" .. 
                _G.data.languages[_persTable.config.language].flagImage));
        _G._gui:setLanguage();
    end
end
--- draws the frame
function MainMenu:draw()
    local _, y = self.elementsOnFrame.button_start:getOffset();
    love.graphics.draw(self.background, (_G._persTable.winDim[1] - self.background:getWidth())/2,
        (_G._persTable.winDim[2] - self.background:getHeight())/2 + y);
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
end
--- is called when the mouse is pressed
--@param x x coordinate of the mouse 
--@param y y coordinate of the mouse
function MainMenu:mousepressed(x, y)    
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
function MainMenu:clear()
    self.frame:clear(self.elementsOnFrame)
end

--- called in the "fly in" state
function MainMenu:appear()
    self.frame:appear(self.elementsOnFrame)
end

--- called in the "fly out" state
function MainMenu:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

--- return true if the frame is on position /fly in move is finished
function MainMenu:checkPosition()
    return self.frame:checkPosition();
end

--- changes the language of this frame
--@param language language of the text and buttons
function MainMenu:setLanguage(language)
    self.elementsOnFrame.button_close:setText(_G.data.languages[language].package.buttonClose);
    self.elementsOnFrame.button_credits:setText(_G.data.languages[language].package.buttonCredits);
    self.elementsOnFrame.button_options:setText(_G.data.languages[language].package.buttonOptions);
    self.elementsOnFrame.button_achievements:setText(_G.data.languages[language].package.buttonAchievements);
    self.elementsOnFrame.button_dictionary:setText(_G.data.languages[language].package.buttonDictionary);
    self.elementsOnFrame.button_upgradeMenu:setText(_G.data.languages[language].package.buttonShop);
    self.elementsOnFrame.button_start:setText(_G.data.languages[language].package.buttonStart);
end

return MainMenu;
