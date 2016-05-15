---Chart contains a table with clickable elements and an textfield
Class = require "lib.hump.class";
TextField = require "class.TextField";




local Chart = Class {
    init = function(self)
        self.column = 3;--amount of the columns of the table
        self.row = 0;
        self.toprow = 0;
        self.elementsOnChart = {};--elements in the table
        self.markedElement = nil;
        self.markFrame = Loveframes.Create("image");
        self.markFrame:SetImage("assets/gui/markFrame.png");
        self.markFrame:SetVisible(false);
        self.textField = TextField(128);
        self.xPos = 0;
        self.yPos = 0;
    end;
    buttonUp = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Up_Button.png"):SizeToImage():SetText("");
    buttonDown = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Down_Button.png"):SizeToImage():SetText("");
};
function Chart.buttonUp.OnClick(obj, x, y)
    local currentFrame = Gui.getCurrentState();
    currentFrame.elementsOnFrame[1]:scrollUp();
end

function Chart.buttonDown.OnClick(obj, x, y)
    local currentFrame = Gui.getCurrentState();
    currentFrame.elementsOnFrame[1]:scrollDown();
end

function Chart:scrollUp()
    if (self.toprow > 0) then
        self.toprow = self.toprow - 1;
        self:drawChart(true);
        self:resetMarkedFrame();
    end
end

function Chart:scrollDown()
    if self.toprow + 3 < self.row then
        self.toprow = self.toprow + 1;
        self:drawChart(true);
        self:resetMarkedFrame();
    end
end

function Chart:resetTopRow()
    self.toprow = 0;
end

function Chart:resetMarkedFrame()
    self.markFrame:SetVisible(false);
end

function Chart:drawChart(visible)
    --clear
    for k, v in pairs(self.elementsOnChart) do
        v:SetVisible(false);
    end
    --draw new elements
    for var1 = 1 + (self.row * self.toprow - 1), 9 + (self.row * self.toprow) do
        if self.elementsOnChart[var1] ~= nil then
            self.elementsOnChart[var1]:SetVisible(visible);
        end
    end
    self:setPosOfKlickableElements()
end

function Chart:setPosOfKlickableElements()
    local row = 0;
    for var1 = 1, self.row do
        for var2 = 1, self.column do
            if self.elementsOnChart[var2 + row * self.column] ~= nil then
                self.elementsOnChart[var2 + row * self.column]:SetPos(self.xPos + 64 * (var2 - 1), (self.yPos + 32 + 64 * row) - 64 * self.toprow);
            end
        end
        row = row + 1;
    end
end


---Set the column Value
-- @parm column: amount of column
function Chart:setColumn (column)
    self.column = column;
end

---add a new klickable element the the table
-- @parm newKlickableElement: object of the new klickable element
function Chart:addKlickableElement(newKlickableElement)
    table.insert(self.elementsOnChart, newKlickableElement);
    self.row = math.ceil(table.getn(self.elementsOnChart) / self.column);
end

---Set the visible of all elements
-- @parm visible: true or false
function Chart:SetVisible(visible)
    self.buttonUp:SetVisible(visible):MoveToTop();
    self.buttonDown:SetVisible(visible):MoveToTop();
    self.textField:SetVisible(visible);
    if visible then
        self:drawChart(visible);
    else
        for k, v in pairs(self.elementsOnChart) do
            v:SetVisible(visible);
        end
    end
    
end

---Set the chart position
-- @parm x: x axis position
-- @parm y: y axis position
function Chart:SetPos(x, y)
    self.xPos = x;
    self.yPos = y;
    self.buttonUp:SetPos(x, y);
    self.buttonDown:SetPos(x, y + 224);
    self:setPosOfKlickableElements();
    self.textField:SetPos(x, y + 256);
    
end

---marks the selected element
-- @parm element: selected element
function Chart:markElement(element)
    local x, y = element.object:GetPos();
    self.markFrame:SetPos(x, y)
    self.markFrame:SetVisible(true);
    self.markedElement = element;
    self.textField:changeText(element.name, element.description);
end

return Chart;

