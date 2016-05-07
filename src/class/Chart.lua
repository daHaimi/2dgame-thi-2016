---Chart contains a table with clickable elements and an textfield

local Chart = Class {
    init = function(self)
        self.column = 3;--amount of the columns of the table
        self.elementsOnChart = {};--elements in the table
        self.markedElement = nil;
        
        self.markFrame = Loveframes.Create("image"):SetImage("assets/gui/markFrame.png"):SetVisible(false);
        self.textField = Textbox(128);
    end;
};

---Set the column Value
-- @parm column: amount of column
function Chart:setColumn (column)
    self.column = column;
end

---add a new klickable element the the table
-- @parm newKlickableElement: object of the new klickable element
function Chart:addKlickableElement(newKlickableElement)
    --self.elementsOnChart = {};
    table.insert(self.elementsOnChart, newKlickableElement);
    if self.elementsOnChart ~= nil then
        --table.insert(self.elementsOnChart, newUpgrade);
    end

end

---Set the visible of all elements
-- @parm visible: true or false
function Chart:SetVisible(visible)
    for k, v in pairs(self.elementsOnChart) do
        v:SetVisible(visible);
    end
    self.textField:SetVisible(visible);
end

---Set the chart position
-- @parm x: x axis position
-- @parm y: y axis position
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
    self.textField:SetPos(x, y + 128);
end

---marks the selected element
-- @parm element: selected element
function Chart:markElement(element)
    local x, y = element.object:GetPos();
    self.markFrame:SetPos(x, y):SetVisible(true);
    self.markedElement = element;
    self.textField:changeText(element.name, element.description);
end

return Chart;

