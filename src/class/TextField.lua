Class = require "lib.hump.class";

--- class for a text box
-- @param width the size of the textfield
-- @param directory the current resolution directory 
local Textbox = Class {
    init = function(self, width, directory)
        self.objBackground = Loveframes.Create("image");
        self.objBackground:SetImage(directory .. "TextBG.png");
        self.objTopic = Loveframes.Create("text");
        self.objText = Loveframes.Create("text");
        self.objPrice = Loveframes.Create("text");
        self.width = width;
    end;
};

--- change the text on the textfield
-- @param newTopic the new topic of the text
-- @param newText new text
-- @param newPrice the new price or nil
function Textbox:changeText(newTopic, newText, newPrice)
    self.objTopic:SetFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 20));
    self.objTopic:SetText(newTopic);
    self.objText:SetFont(love.graphics.newFont("font/8bitOperatorPlus-Regular.ttf", 15));
    self.objText:SetText(newText);
    if newPrice ~= nil then
        self.objPrice:SetText(_G.data.languages[_G._persTable.config.language].package.textPrice .. newPrice);
    else
        self.objPrice:SetText("");
    end
end

--- Function not conform to CC/ implements an interface
--- set visible of the textfield
-- @param visible true or false
function Textbox:SetVisible(visible)
    self.objTopic:SetVisible(visible);
    self.objText:SetVisible(visible);
    self.objPrice:SetVisible(visible);
    self.objBackground:SetVisible(visible);
end

--- Function not conform to CC/ implements an interface
--- Set position of the textfield
-- @param x x axis position
-- @param y y axis position
function Textbox:SetPos(x, y)
    self.objTopic:SetPos(x + 10, y + 10);
    self.objTopic:SetMaxWidth(self.width);
    self.objText:SetPos(x + 10, y + 30);
    self.objText:SetMaxWidth(self.width);
    self.objPrice:SetPos(x, y - 25);
    self.objBackground:SetPos(x, y);
end

return Textbox;
