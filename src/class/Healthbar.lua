Class = require "lib.hump.class";

local Healthbar = Class {
    init = function(self)
        self.icon = Loveframes.Create("image")
        self.icon:SetImage("assets/hamster.png");
        self.blackHeartPath = "assets/heart_grey.png";
        self.redHeartPath = "assets/heart.png";
        self.unlockedHearts = 1 + _persTable.upgrades.moreLife;
        self.currentHearts = self.unlockedHearts;
        self.hearts = {};
        for var1 = 1, self.unlockedHearts do
            self.hearts[var1] = Loveframes.Create("image");
            self.hearts[var1]:SetImage(self.redHeartPath);
        end
        self.basic = {
            xPos = nil;
            yPos = nil;
            visible = false;
        };
        self:scaleHearts();
    end;
};

--scale the heart images to an half
function Healthbar:scaleHearts()
    for k, v in pairs(self.hearts) do
        v:SetScale(0.5, 0.5);
    end
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

--- Reset the amount of lives to the start value.
function Healthbar:resetHearts()
    self.unlockedHearts = 1 + _persTable.upgrades.moreLife;
    self.currentHearts = self.unlockedHearts;
    self.hearts = {};
    for var1 = 1, self.unlockedHearts do
        self.hearts[var1] = Loveframes.Create("image");
        self.hearts[var1]:SetImage(self.redHeartPath);
    end
    self:refresh();
end

---Function not conform to CC/ implements an interface
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

---Function not conform to CC/ implements an interface
---set the position of the element
-- @parm x: x axis position
-- @parm y: y axis position
function Healthbar:SetPos(x, y)
    self.basic.xPos = x;
    self.basic.yPos = y;
    for k, v in ipairs(self.hearts) do
        v:SetPos(_persTable.scaledDeviceDim[1] - 32 * k,  16);
    end
    self.icon:SetPos(_persTable.scaledDeviceDim[1] - (32 * self.unlockedHearts + 64), 0);
end

return Healthbar;