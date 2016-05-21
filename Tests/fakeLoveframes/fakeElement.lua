Class = require "lib.hump.class";

local fakeElement = Class {
    init = function(self, typeName)
        --basics
        self.type = typeName;
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
        self.min = nil;
        self.max = nil;
        self.width = nil;
        self.value = 123;
        
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

---slider
function fakeElement:SetValue(value)
    self.value = value;
end

function fakeElement:GetValue()
    return self.value;
end

function fakeElement:SetMinMax(min, max)
    self.min = min;
    self.max = max;
end

function fakeElement:SetWidth(width)
    self.width = width;
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