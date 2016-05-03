
local Chart = Class {
    init = function(self, column)
        self.column = column;
        self.elementsOnChart = {};
        self.markedElement = nil;
        self.markFrame = Loveframes.Create("image"):SetImage("assets/gui/markFrame.png"):SetVisible(false);
    end;
};

function Chart:addCheckbutton(newCheckbutton)
    --self.elementsOnChart = {};
    table.insert(self.elementsOnChart, newCheckbutton);
    if self.elementsOnChart ~= nil then
        --table.insert(self.elementsOnChart, newCheckbutton);
    end

end

function Chart:SetVisible(visible)
    for k, v in pairs(self.elementsOnChart) do
        v:SetVisible(visible);
    end
end

function Chart:SetPos(x, y)
    local row = 0;
    for var1 = 1, table.getn(self.elementsOnChart) do
        for var2 = 1, self.column, 1 do
            if self.elementsOnChart[var2 + row * self.column] ~= nil then
                self.elementsOnChart[var2 + row * self.column]:SetPos(x + 64 * (var2 - 1), y + 64 * row);
            end
        end
        row = row + 1;
    end
end

function Chart:markElement(element)
    local x, y = element.object:GetPos();
    self.markFrame:SetPos(x, y):SetVisible(true);
    self.markedElement = element;
end

return Chart;

