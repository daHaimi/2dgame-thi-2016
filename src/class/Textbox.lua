Class = require "lib.hump.class";

local Textbox = Class {
    init = function(self, width, length) --imagepath)
        self.objTopic = Loveframes.Create("text");
        self.objText = Loveframes.Create("text");
        --self.objBackground = LoveFrames.Create("image"):SetImage(imagepath);
        self.width = width;
        self.length = length;
    end;
};

---change the text on the textfield
-- @parm newTopic: the new topic of the text
-- @parm newText: new text
function Textbox:changeText(newTopic, newText)
    self.objTopic:SetText(newTopic);
    self.objText:SetText(newText);
end

---set visible of the textfield
-- @parm visible: true or false
function Textbox:SetVisible(visible)
    self.objTopic:SetVisible(visible);
    self.objText:SetVisible(visible);
    --self.objBackground:SetVisibile(visible);
end

---Set position of the textfield
-- @parm x: x axis position
-- @parm y: y axis position
function Textbox:SetPos(x, y)
    self.objTopic:SetPos(x + 5, y + 5);
    self.objTopic:SetMaxWidth(self.width);
    self.objText:SetPos(x + 5, y + 25);
    self.objText:SetMaxWidth(self.width);
    --self.objBackground:SetPos(x, y):SetScale( bla bla);
end

return Textbox;