Class = require "lib.hump.class";

local Textbox = Class {
    init = function(self, width, directory)
        self.objBackground = Loveframes.Create("image");
        self.objBackground:SetImage(directory .. "TextBG.png");
        self.objTopic = Loveframes.Create("text");
        self.objTopic:SetFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 20));
        self.objText = Loveframes.Create("text");
        self.objText:SetFont(love.graphics.newFont("font/8bitOperatorPlus-Regular.ttf", 15));
        self.objPrice = Loveframes.Create("text");
        self.objPrice:SetFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 15));
        self.width = width;
    end;
};

---change the text on the textfield
-- @parm newTopic: the new topic of the text
-- @parm newText: new text
function Textbox:changeText(newTopic, newText, newPrice)
    self.objTopic:SetText(newTopic);
    self.objText:SetText(newText);
    if newPrice ~= nil then
        self.objPrice:SetText("Price: " .. newPrice);
    else
        self.objPrice:SetText("");
    end
end

---Function not conform to CC/ implements an interface
---set visible of the textfield
-- @parm visible: true or false
function Textbox:SetVisible(visible)
    self.objTopic:SetVisible(visible);
    self.objText:SetVisible(visible);
    self.objPrice:SetVisible(visible);
    self.objBackground:SetVisible(visible);
end

---Function not conform to CC/ implements an interface
---Set position of the textfield
-- @parm x: x axis position
-- @parm y: y axis position
function Textbox:SetPos(x, y)
    self.objTopic:SetPos(x + 10, y + 10);
    self.objTopic:SetMaxWidth(self.width);
    self.objText:SetPos(x + 10, y + 30);
    self.objText:SetMaxWidth(self.width);
    self.objPrice:SetPos(x + 200, y + 10);
    self.objBackground:SetPos(x, y);
end

return Textbox;