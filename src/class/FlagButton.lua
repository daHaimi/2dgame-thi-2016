---Button on the main menu to change the language
Class = require "lib.hump.class";

local FlagButton = Class {
    init = function(self)
        self.languages = _G.data.languages;
        self.object = nil;
        self:create();
    end;
};

function FlagButton:create()
    self.object = Loveframes.Create("imagebutton");
    self.object:SetText("");
    self.object:SetImage(self.languages[_persTable.config.language].flagImage);
    self.object:SetVisible(false);
    self.object.OnClick = function(object)
        self:changeLanguage();
    end
end

function FlagButton:changeLanguage()
    if _persTable.config.language == "english" then
        _persTable.config.language = "german";
    else
        _persTable.config.language = "english";
    end
    self.object:SetImage(self.languages[_persTable.config.language].flagImage);
    _G._gui:tempTextOutput();
end

function FlagButton:SetVisible(visible)
    self.object:SetVisible(visible);
end

function FlagButton:SetPos(x, y)
    self.object:SetPos(x, y);
end

return FlagButton;