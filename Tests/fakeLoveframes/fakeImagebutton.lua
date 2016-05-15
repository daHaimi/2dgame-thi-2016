Class = require "lib.hump.class";

local fakeImagebutton = Class {
    init = function(self)
        self.imagepath = nil;
        self.position = {
            xPos = nil;
            yPos = nil;
        };
        self.visible = nil;
        self.text = "";
        self.calledSizeToImage = false;
    end;
};

function fakeImagebutton:SetVisible(visible)
    self.visible = visible;
end

function fakeImagebutton:SetPos (x, y)
    self.position.xPos = x;
    self.position.yPos = y;
end

function fakeImagebutton:SetImage(path)
    self.imagepath = path;
end

function fakeImagebutton:SizeToImage()
    self.calledSizeToImage = true;
end

function fakeImagebutton:SetText(text)
    self.text = text;
end


    
    
return fakeImagebutton;
