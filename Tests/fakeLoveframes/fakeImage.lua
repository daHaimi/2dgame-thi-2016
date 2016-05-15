Class = require "lib.hump.class";

local fakeImage = Class {
    init = function(self)
        self.imagepath = nil;
        self.position = {
            xPos = nil;
            yPos = nil;
        };
        self.scale = {
            xScale = 0;
            yScale = 0;
        };
        self.visible = nil;
        self.calledRemove = false;
    end;
};

function fakeImage:SetVisible(visible)
    self.visible = visible;
end

function fakeImage:SetPos(x, y)
    self.position.xPos = x;
    self.position.yPos = y;
end

function fakeImage:SetImage(path)
    self.imagepath = path;
end

function fakeImage:SetScale(x, y)
    self.scale.xScale = x;
    self.scale.yScale = y;
end

function fakeImage:Remove()
    self.calledRemove = true;
end

return fakeImage;
