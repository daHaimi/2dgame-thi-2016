---a klickableElement represents an achievement, wikielement or an upgrade

Class = require "lib.hump.class";

local Healthbar = Class {
    init = function(self, iconPath, blackHeartPath, redHeartPath)
        self.icon = Loveframes.Create("image")
        self.icon:SetImage(iconPath);
        self.blackHeartPath = blackHeartPath;
        self.redHeartPath = redHeartPath;
        self.unlockedHearts = 1 + _persTable.upgrades.moreLife;
        self.currentHearts = self.unlockedHearts;
        self.hearts = {
            Loveframes.Create("image");
        };
        self.hearts[1]:SetImage(self.redHeartPath);
        self.basic = {
            xPos = nil;
            yPos = nil;
            visible = false;
        };
        self:scaleHearts();
    end;
};

function Healthbar:scaleHearts()
    for k, v in pairs(self.hearts) do
        v:SetScale(0.5, 0.5);
    end
end


function Healthbar:refreshAfterBuy()
    self.unlockedHearts = 1 + _persTable.upgrades.moreLife;
    self.currentHearts = self.unlockedHearts;
    self.hearts[self.unlockedHearts] = Loveframes.Create("image");
    self.hearts[self.unlockedHearts]:SetImage(self.redHeartPath);
    self:refresh();
end

---Refresh the position and visible of the Healtbarh
function Healthbar:refresh()
    self:scaleHearts();
    self:SetVisible(self.basic.visible);
    self:SetPos(self.basic.xPos, self.basic.yPos);
end

---triggerd if the hamster hit an object
function Healthbar:minus()
    if self.currentHearts < 1 then
        --trigger turn end
    else
        --trigger short time in godmode
        self.hearts[self.currentHearts]:Remove();
        self.hearts[self.currentHearts] = Loveframes.Create("image");
        self.hearts[self.currentHearts]:SetImage(self.blackHeartPath);
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
---has to be called at the end of a turn
function Healthbar:reset()
    self.currentHearts = self.unlockedHearts;
    for var1 = 1, self.currentHearts do
        self.hearts[var1]:Remove();
        self.hearts[var1] = Loveframes.Create("image");
        self.hearts[var1]:SetImage(self.redHeartPath);
    end
    self:refresh();
end

---set the position of the element
-- @parm x: x axis position
-- @parm y: y axis position
function Healthbar:SetPos(x, y)
    self.basic.xPos = x;
    self.basic.yPos = y;
    for k, v in ipairs(self.hearts) do
        v:SetPos(_persTable.winDim[1] - 32 * k, 16);
    end
    self.icon:SetPos(_persTable.winDim[1] - (32 * self.unlockedHearts + 64), 0);
end

return Healthbar;