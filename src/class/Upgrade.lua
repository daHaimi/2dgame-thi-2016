local KlickableElement = Class {
    init = function(self, name, imagepath, imagepath_checked, description)
        self.name = name;
        self.checked = false;
        self.imagepath = imagepath;
        self.imagepath_checked = imagepath_checked;
        self.description = description;
        self.object = Loveframes.Create("imagebutton"):SetImage(self.imagepath):SizeToImage():SetText(self.name);
    end;
};

function KlickableElement:SetVisible(visible)
    self.object:SetVisible(visible);
end

function KlickableElement:reset()
    self.checked = false;
    self.object:SetImage(self.imagepath);
end

function KlickableElement:check()
    self.checked = true;
    self.object:SetImage(self.imagepath_checked);
end

function KlickableElement:SetPos(x, y)
    self.object:SetPos(x, y);
end

function KlickableElement:SetChecked()
    self.check();
end

function KlickableElement:GetChecked()
    return self.checked;
end

return KlickableElement;