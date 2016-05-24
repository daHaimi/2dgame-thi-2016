---a klickableElement represents an achievement, wikielement or an upgrade
Class = require "lib.hump.class";

local KlickableElement = Class {
    init = function(self, name, imagepath, imagepath_disable, description, price, nameOnPersTable)
        self.name = name;
        self.enable = true;
        self.imagepath = imagepath;
        self.imagepath_disable = imagepath_disable;
        self.price = price;
        self.nameOnPersTable = nameOnPersTable;
        self.description = description;
        self.object = Loveframes.Create("imagebutton");
        self.object:SetImage(self.imagepath);
        self.object:SizeToImage();
        self.object:SetText(self.name);
    end;
};

---Function not conform to CC/ implements an interface
---Set the visible of the element
-- @parm visible: true or false
function KlickableElement:SetVisible(visible)
    self.object:SetVisible(visible);
end

---reset the Element (just the enable state and the image)
function KlickableElement:reset()
    self.enable = true;
    self.object:SetImage(self.imagepath);
end

---represents an upgrade buy
function KlickableElement:disable()
    self.enable = false;
    self.object:SetImage(self.imagepath_disable);
    if self.nameOnPersTable ~= nil then
        --_persTable.upgrades[self.nameOnPersTable] = true;
        _persTable.upgrades[self.nameOnPersTable] = 1;
    end
end

---Function not conform to CC/ implements an interface
---set the position of the element
-- @parm x: x axis position
-- @parm y: y axis position
function KlickableElement:SetPos(x, y)
    self.object:SetPos(x, y);
end

---getter of the enable parameter
function KlickableElement:getEnable()
    return self.enable;
end

return KlickableElement;