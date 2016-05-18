---Chart contains a table with clickable elements and a textfield
Class = require "lib.hump.class";
TextField = require "class.TextField";
Loveframes = require "lib.LoveFrames";

local Chart = Class {
    init = function(self)
        self.column = 3;--amount of the columns of the table
        self.row = 0;--automatically calculated value of the amount of rows in the table
        self.toprow = 0;--top visible row. needed to scroll up and down
        self.xPos = 0;
        self.yPos = 0;
        
        self.elementsOnChart = {};--elements in the table
        self.markedElement = nil;
        
        self:create();
    end;
};

---function called in the constructor of this class. creates backround and buttons
function Chart:create()
    self.button_up = Loveframes.Create("imagebutton");
    self.button_up:SetImage("assets/gui/gui_Up_Button.png");
    self.button_up:SizeToImage();
    self.button_up:SetText("");
    
    self.button_down = Loveframes.Create("imagebutton");
    self.button_down:SetImage("assets/gui/gui_Down_Button.png");
    self.button_down:SizeToImage();
    self.button_down:SetText("");
    
    self.markFrame = Loveframes.Create("image");
    self.markFrame:SetImage("assets/gui/markFrame.png");
    self.markFrame:SetVisible(false);
    
    self.textField = TextField(128);
    
    --onclick events of the buttons
    self.button_up.OnClick = function(object)
        self:scrollUp();
    end
    
    self.button_down.OnClick = function(object)
        self:scrollDown();
    end
end

---called to scroll the table up
function Chart:scrollUp()
    if (self.toprow > 0) then
        self.toprow = self.toprow - 1;
        self:drawChart(true);
        self:resetMarkedFrame();
    end
end

---called to scroll the table down
function Chart:scrollDown()
    if self.toprow + 3 < self.row then
        self.toprow = self.toprow + 1;
        self:drawChart(true);
        self:resetMarkedFrame();
    end
end

---resets the top row. called at the back button to reset the table for the next shop visit
function Chart:resetTopRow()
    self.toprow = 0;
end

---reset the markedFrame visible to false
function Chart:resetMarkedFrame()
    self.markFrame:SetVisible(false);
end

---draws the elements shown in the table
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

---set the position of all elements in the table
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

---add a new klickable element the the table
-- @parm newKlickableElement: object of the new klickable element
function Chart:addKlickableElement(newKlickableElement)
    table.insert(self.elementsOnChart, newKlickableElement);
    self.row = math.ceil(table.getn(self.elementsOnChart) / self.column);
end

---Set the visible of all elements
-- @parm visible: true or false
function Chart:SetVisible(visible)
    self.button_up:SetVisible(visible);--:MoveToTop();
    self.button_down:SetVisible(visible);--:MoveToTop();
    self.textField:SetVisible(visible);
    if visible then
        self:drawChart(visible);
    else
        for k, v in pairs(self.elementsOnChart) do
            v:SetVisible(visible);
        end
    end
    self.markFrame:SetVisible(false);
end

---Set the chart position
-- @parm x: x axis position
-- @parm y: y axis position
function Chart:SetPos(x, y)
    self.xPos = x;
    self.yPos = y;
    self.button_up:SetPos(x, y);
    self.button_down:SetPos(x, y + 224);
    self:setPosOfKlickableElements();
    self.textField:SetPos(x, y + 256);
    if self.markFrame:GetX() ~= nil then
        self.markFrame:SetPos(self.markFrame:GetX() + x, self.markFrame:GetY() + y);
    end
end

---marks the selected element
-- @parm element: selected element
function Chart:markElement(element)
    local x, y = element.object:GetPos();
    self.markFrame:SetPos(x, y);
    self.markFrame:SetVisible(true);
    self.markFrame:MoveToTop();
    self.markedElement = element;
    self.textField:changeText(element.name, element.description);
end

return Chart;

