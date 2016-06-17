Class = require "lib.hump.class";
Frame = require "class.Frame";
FlagButton = require "class.FlagButton";
ImageButton = require "class.ImageButton";

local MainMenu = Class {
    init = function(self)
            self.directory = "assets/gui/480px/";
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.buttonHeight = 75;
            self.buttonOffset = 15;
            self.flagWidth = 120;
            self.speed = 50;
        self.name = "Main Menu";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2, (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed,
            "down", "down", self.speed, 0, -1500);
        self:create();
    end;
};

--creates the main menu frame
function MainMenu:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        button_start = ImageButton(self.directory .. "Button.png", 100, 100, "", true);
        
        --[[button_upgradeMenu = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 1 * self.buttonHeight;
        };
        button_dictionary = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 2 * self.buttonHeight;
        };
        button_achievements = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 3 * self.buttonHeight;
        };
        button_options = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 4 * self.buttonHeight;
        };
        button_credits = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.buttonOffset + 5 * self.buttonHeight;
        };

        button_close = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.height - self.buttonHeight;
        };

        language = {
            object = FlagButton();
            x = (self.width - self.flagWidth) / 2;
            y = self.buttonOffset + 6 * self.buttonHeight;
        };]]
    };

    --adjust all elements on this frame

    --self.elementsOnFrame.background.object:SetImage(self.directory .. "gui_Test_Bg.png");

    self.elementsOnFrame.button_start:setImage(self.directory .. "Button.png");


    --[[self.elementsOnFrame.button_upgradeMenu.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_upgradeMenu.object:SizeToImage();

    self.elementsOnFrame.button_dictionary.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_dictionary.object:SizeToImage();

    self.elementsOnFrame.button_achievements.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_achievements.object:SizeToImage();

    self.elementsOnFrame.button_options.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_options.object:SizeToImage();

    self.elementsOnFrame.button_credits.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_credits.object:SizeToImage();

    self.elementsOnFrame.button_close.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_close.object:SizeToImage();]]

    --onclick events for all buttons
    --self.elementsOnFrame.button_start.object.OnClick = function(_)
    --    _gui:changeFrame(_gui:getFrames().level);
    --end

    --[[self.elementsOnFrame.button_upgradeMenu.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().upgradeMenu);
    end

    self.elementsOnFrame.button_dictionary.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().dictionary);
    end

    self.elementsOnFrame.button_achievements.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().achievements);
    end

    self.elementsOnFrame.button_options.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().options);
    end

    self.elementsOnFrame.button_credits.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().credits);
    end

    self.elementsOnFrame.button_close.object.OnClick = function(_)
        love.window:close(); -- close the window
        love.event.quit(); -- exit the game
    end]]
end

--- shows the frame on screen
function MainMenu:draw()
    self.frame:draw(self.elementsOnFrame);
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
    --[[self.elementsOnFrame.button_close.object:SetText(_G.data.languages[language].package.buttonClose);
    self.elementsOnFrame.button_credits.object:SetText(_G.data.languages[language].package.buttonCredits);
    self.elementsOnFrame.button_options.object:SetText(_G.data.languages[language].package.buttonOptions);
    self.elementsOnFrame.button_achievements.object:SetText(_G.data.languages[language].package.buttonAchievements);
    self.elementsOnFrame.button_dictionary.object:SetText(_G.data.languages[language].package.buttonDictionary);
    self.elementsOnFrame.button_upgradeMenu.object:SetText(_G.data.languages[language].package.buttonShop);]]
    self.elementsOnFrame.button_start:setText(_G.data.languages[language].package.buttonStart);
end

return MainMenu;
