---a klickableElement represents an achievement, wikielement or an upgrade

Class = require "lib.hump.class";
Loveframes = require "lib.LoveFrames";

local Healthbar = Class {
    init = function(self, iconPath, blackHeartPath, redHeartPath, unlockedHearts)
        self.icon = Loveframes.Create("image"):SetImage(iconPath);
        self.blackHeartPath = blackHeartPath;
        self.redHeardPath = redHeartPath;
        self.unlockedHearts = unlockedHearts;
        self.currentHearts = unlockedHearts;
        self.hearts = {};
        for var = 1, self.unlockedHearts, 1 do
            self.hearts[var] = Loveframes.Create("image"):SetImage(self.redHeardPath):SetScale(0.5, 0.5);
        end
        self.basic = {
            xPos = nil;
            yPos = nil;
            visible = false;
        };
    end;
};

function Healthbar:refresh()
    self:SetVisible(self.basic.visible);
    self:SetPos(self.basic.xPos, self.basic.yPos);
end


function Healthbar:minus()
    if self.currentHearts < 1 then
        --trigger end
    else
        self.hearts[self.currentHearts] = Loveframes.Create("image"):SetImage(self.blackHeartPath):SetScale(0.5, 0.5);
        self.currentHearts = self.currentHearts - 1;
        self:refresh();
    end
end


---Set the visible of the element
-- @parm visible: true or false
function Healthbar:SetVisible(visible)
    self.basic.visible = visible;
    if self.currentHearts ~= {} then
        for k, v in pairs(self.hearts) do
            v:SetVisible(visible);
        end
    end
    self.icon:SetVisible(visible);
end


---reset the Element (just the checked state and the image)
function Healthbar:reset()
    self.currentHearts = self.unlockedHearts;
end



---set the position of the element
-- @parm x: x axis position
-- @parm y: y axis position
function Healthbar:SetPos(x, y)
    self.basic.xPos = x;
    self.basic.yPos = y;
    for k, v in ipairs(self.hearts) do
        v:SetPos(_persTable.winDim[1] - (v:GetWidth()*v:GetScaleX()) * k, 16);
    end
    self.icon:SetPos(_persTable.winDim[1] - (32 * self.unlockedHearts + 64), 0);
end


return Healthbar;