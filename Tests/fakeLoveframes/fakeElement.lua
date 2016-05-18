Class = require "lib.hump.class";

local fakeElement = Class {
    init = function(self)
        --basics
        self.x = nil;
        self.y = nil
        self.visible = nil;
        self.text = "";
        
        --text
        self.maxWidth = nil;
        
        --imagebutton and image
        self.imagepath = nil;
        self.text = "";
        self.calledSizeToImage = false;
        self.xScale = nil;
        self.yScale = nil;
        self.calledRemove = false;
        
        --slider
        
        
    end;
};

---basic functions
function fakeElement:SetVisible(visible)
    self.visible = visible;
end

function fakeElement:SetPos (x, y)
    self.x = x;
    self.y = y;
end

function fakeElement:SetText(text)
    self.text = text;
end



---text
function fakeElement:SetMaxWidth(maxWidth)
    self.maxWidth = maxWidth;
end



---imagebutton
function fakeElement:SetImage(path)
    self.imagepath = path;
end

function fakeElement:SizeToImage()
    self.calledSizeToImage = true;
end

function fakeElement:SetText(text)
    self.text = text;
end

function fakeElement:SetScale(x, y)
    self.xScale = x;
    self.yScale = y;
end

function fakeElement:Remove()
    self.calledRemove = true;
end

return fakeElement;
