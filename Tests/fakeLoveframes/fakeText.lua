Class = require "lib.hump.class";

local fakeText = Class {
    init = function(self)
        self.position = {
            xPos = nil;
            yPos = nil;
        };
        self.visible = nil;
        self.text = "";
        self.maxWidth = nil;
    end;
};

function fakeText:SetVisible(visible)
    self.visible = visible;
end

function fakeText:SetPos (x, y)
    self.position.xPos = x;
    self.position.yPos = y;
end


function fakeText:SetText(text)
    self.text = text;
end

function fakeText:SetMaxWidth(maxWidth)
    self.maxWidth = maxWidth;
end


return fakeText;
