---a klickableElement represents an achievement, wikielement or an upgrade

Class = require "lib.hump.class";

local KlickableElement = Class {
    init = function(self, name, imagepath, imagepath_checked, description)
        self.name = name;
        self.checked = false;
        self.imagepath = imagepath;
        self.imagepath_checked = imagepath_checked;
        self.description = description;
        self.object = Loveframes.Create("imagebutton");
        self.object:SetImage(self.imagepath);
        self.object:SizeToImage();
        self.object:SetText(self.name);
    end;
};

---Set the visible of the element
-- @parm visible: true or false
function KlickableElement:SetVisible(visible)
    self.object:SetVisible(visible);
end

---reset the Element (just the checked state and the image)
function KlickableElement:reset()
    self.checked = false;
    self.object:SetImage(self.imagepath);
end

---represents an upgrade buy
function KlickableElement:check()
    self.checked = true;
    self.object:SetImage(self.imagepath_checked);
end

---set the position of the element
-- @parm x: x axis position
-- @parm y: y axis position
function KlickableElement:SetPos(x, y)
    self.object:SetPos(x, y);
end

---setter of the checked parameter without a reset
function KlickableElement:SetChecked()
    self.check();
end

---getter of the checked parameter
function KlickableElement:GetChecked()
    return self.checked;
end

return KlickableElement;