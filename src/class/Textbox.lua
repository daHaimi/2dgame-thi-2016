--Loveframes = require "lib.LoveFrames";

local Textbox = Class {
    init = function(self, width, length, imagepath)
        self.objTopic = Loveframes.Create("text");
        self.objText = Loveframes.Create("text");
        --self.objBackground = LoveFrames.Create("image"):SetImage(imagepath);
        self.width = width;
        self.length = length;
    end;
};

function Textbox:changeText(newTopic, newText)
    self.objTopic:SetText(newTopic);
    self.objText:SetText(newText);
end

function Textbox:SetVisible(visible)
    self.objTopic:SetVisible(visible):SetText("topic");
    self.objText:SetVisible(visible):SetText("text text text text text text text");
    --self.objBackground:SetVisibile(visible);
end

function Textbox:SetPos(x, y)
    self.objTopic:SetPos(x + 5, y + 5):SetMaxWidth(self.width);
    self.objText:SetPos(x + 5, y + 25):SetMaxWidth(self.width);
    --self.objBackground:SetPos(x, y):SetScale( bla bla);
end




return Textbox;