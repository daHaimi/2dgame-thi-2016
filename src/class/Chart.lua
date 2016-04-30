local Chart = Class {
    init = function(self, column)
        self.column = column;
        self.elementsOnChart = {};
        self.abc = {};
    end;

};

function Chart:addCheckbutton(newCheckbutton)
    self.elementsOnChart = {"", ""};
    --self.abc[1] = newCheckbutton;
    --table.insert(self.elementsOnChart, newCheckbutton);
end

function Chart:SetVisible(visible)
    for k, v in pairs(self.elementsOnChart) do
        v:SetVisibile(visible);
    end
end

function Chart:SetPos(x, y)
    for k, v in ipairs(self.elementsOnChart) do
        for var = 0, (self.column - 1) do
            v:SetPos((x + 64 * var), (y + 64 * k));
        end
    end
end

return Chart;

