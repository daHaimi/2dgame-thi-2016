Class = require "lib.hump.class";

local fakeSlider = Class {
    init = function(self)
        self.position = {
            xPos = nil;
            yPos = nil;
        };
        self.visible = nil;
    end;
};

function fakeSlider:SetVisible(visible)
    self.visible = visible;
end

function fakeSlider:SetPos (x, y)
    self.position.xPos = x;
    self.position.yPos = y;
end

return fakeSlider;
