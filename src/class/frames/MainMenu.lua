Class = require "lib.hump.class";
Frame = require "class.Frame";
FlagButton = require "class.FlagButton";
ImageButton = require "class.ImageButton";

local MainMenu = Class {
    init = function(self)
            self.imageButton = love.graphics.newImage("assets/gui/button.png");
            self.buttonHeight = self.imageButton:getHeight();
            self.buttonWidth = self.imageButton:getWidth();
            self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
            self.offset = 100;
            self.buttonDistance = 15;
            self.flagWidth = 120;
        self.name = "Main Menu";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
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
        button_close = ImageButton(self.imageButton, self.buttonXPosition , 
            _G._persTable.winDim[2] - self.offset - self.buttonHeight, true);

        --[[language = {
            object = FlagButton();
            x = (self.width - self.flagWidth) / 2;
            y = self.buttonOffset + 6 * self.buttonHeight;
        };]]
    };

    --adjust all elements on this frame

    --onclick events for all buttons
    self.elementsOnFrame.button_start.gotClicked = function(_)
        print "Level"
        --_gui:changeFrame(_gui:getFrames().level);
    end

    self.elementsOnFrame.button_upgradeMenu.gotClicked = function(_)
        print "upgradeMenu"
        --_gui:changeFrame(_gui:getFrames().upgradeMenu);
    end

    self.elementsOnFrame.button_dictionary.gotClicked = function(_)
        print "dictionary"
        --_gui:changeFrame(_gui:getFrames().dictionary);
    end

    self.elementsOnFrame.button_achievements.gotClicked = function(_)
        print "achievements"
        --_gui:changeFrame(_gui:getFrames().achievements);
    end
    
    self.elementsOnFrame.button_options.gotClicked = function(_)
        print "options"
        --_gui:changeFrame(_gui:getFrames().options);
    end
    
    self.elementsOnFrame.button_credits.gotClicked = function(_)
        _gui:changeFrame(_gui:getFrames().credits);
    end

    self.elementsOnFrame.button_close.gotClicked = function(_)
        love.window:close();
        love.event.quit();
    end
end

function MainMenu:draw()
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
end

function MainMenu:mousepressed(x, y)
    local xClick = x * _G._persTable.scaleFactor;
    local yClick = y * _G._persTable.scaleFactor;
    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if xClick > xPosition and xClick < xPosition + width and
        yClick > yPosition and yClick < yPosition + height then
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
