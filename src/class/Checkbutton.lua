local Checkbutton = Class {
    init = function(self, text, checked, imagepath, imagepath_checked)
        self.checked = checked;
        self.imagepath = imagepath;
        self.imagepath_checked = imagepath_checked;
        self.object = Loveframes.Create("imagebutton"):SetImage(imagepath):SizeToImage():SetText(text);
    end;
};

function Checkbutton:SetVisible(visible)
    self.object:SetVisible(visible);
end

function Checkbutton:reset()
    self.checked = false;
    self.object:SetImage(self.imagepath);
end

function Checkbutton:check()
    self.checked = true;
    self:SetPos(100, 100);
    self.object:SetImage(self.imagepath_checked);
end

function Checkbutton:SetPos(x, y)
    self.object:SetPos(x, y);
end

return Checkbutton;