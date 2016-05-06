local Upgrade = Class {
    init = function(self, name, imagepath, imagepath_checked, description)
        self.name = name;
        self.checked = false;
        self.imagepath = imagepath;
        self.imagepath_checked = imagepath_checked;
        self.description = description;
        self.object = Loveframes.Create("imagebutton"):SetImage(self.imagepath):SizeToImage():SetText(self.name);
    end;
};

function Upgrade:SetVisible(visible)
    self.object:SetVisible(visible);
end

function Upgrade:reset()
    self.checked = false;
    self.object:SetImage(self.imagepath);
end

function Upgrade:check()
    self.checked = true;
    self.object:SetImage(self.imagepath_checked);
end

function Upgrade:SetPos(x, y)
    self.object:SetPos(x, y);
end

function Upgrade:SetChecked()
    self.check();
end

function Upgrade:GetChecked()
    return self.checked;
end

return Upgrade;