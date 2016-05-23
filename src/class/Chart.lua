---Chart contains a table with clickable elements and a textfield
Class = require "lib.hump.class";
TextField = require "class.TextField";

local Chart = Class {
    init = function(self)
        self.p_column = 3;--amount of the columns of the table
        self.p_row = 0;--automatically calculated value of the amount of rows in the table
        self.p_toprow = 0;--top visible row. needed to scroll up and down
        self.p_xPos = 0;
        self.p_yPos = 0;
        
        self.p_elementsOnChart = {};--elements in the table
        self.p_markedElement = nil;
        
        self:create();
    end;
};

---Getter of all Elements
function Chart:getAllElements()
    return self.p_elementsOnChart;
end


---Getter of the marked Element
function Chart:getMarkedElement()
    return self.p_markedElement;
end

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
    if (self.p_toprow > 0) then
        self.p_toprow = self.p_toprow - 1;
        self:drawChart(true);
        self:resetMarkedFrame();
    end
end

---called to scroll the table down
function Chart:scrollDown()
    if self.p_toprow + 3 < self.p_row then
        self.p_toprow = self.p_toprow + 1;
        self:drawChart(true);
        self:resetMarkedFrame();
    end
end

---resets the top row. called at the back button to reset the table for the next shop visit
function Chart:resetTopRow()
    self.p_toprow = 0;
end

---reset the markedFrame visible to false
function Chart:resetMarkedFrame()
    self.markFrame:SetVisible(false);
end

---draws the elements shown in the table
function Chart:drawChart(visible)
    --clear
    for k, v in pairs(self.p_elementsOnChart) do
        v:SetVisible(false);
    end
    --draw new elements
    for var1 = 1 + (self.p_row * self.p_toprow - 1), 9 + (self.p_row * self.p_toprow) do
        if self.p_elementsOnChart[var1] ~= nil then
            self.p_elementsOnChart[var1]:SetVisible(visible);
        end
    end
    self:setPosOfKlickableElements()
end

---set the position of all elements in the table
function Chart:setPosOfKlickableElements()
    local p_row = 0;
    for var1 = 1, self.p_row do
        for var2 = 1, self.p_column do
            if self.p_elementsOnChart[var2 + p_row * self.p_column] ~= nil then
                self.p_elementsOnChart[var2 + p_row * self.p_column]:SetPos(self.p_xPos + 64 * (var2 - 1), (self.p_yPos + 32 + 64 * p_row) - 64 * self.p_toprow);
            end
        end
        p_row = p_row + 1;
    end
end

---add a new klickable element the the table
-- @parm newKlickableElement: object of the new klickable element
function Chart:addKlickableElement(newKlickableElement)
    table.insert(self.p_elementsOnChart, newKlickableElement);
    self.p_row = math.ceil(table.getn(self.p_elementsOnChart) / self.p_column);
end

---Function not conform to CC/ implements an interface
---Set the visible of all elements
-- @parm visible: true or false
function Chart:SetVisible(visible)
    self.button_up:SetVisible(visible);--:MoveToTop();
    self.button_down:SetVisible(visible);--:MoveToTop();
    self.textField:SetVisible(visible);
    if visible then
        self:drawChart(visible);
    else
        for k, v in pairs(self.p_elementsOnChart) do
            v:SetVisible(visible);
        end
    end
    self.markFrame:SetVisible(false);
end

---Function not conform to CC/ implements an interface
---Set the chart position
-- @parm x: x axis position
-- @parm y: y axis position
function Chart:SetPos(x, y)
    self.p_xPos = x;
    self.p_yPos = y;
    self.button_up:SetPos(x, y);
    self.button_down:SetPos(x, y + 224);
    self:setPosOfKlickableElements();
    self.textField:SetPos(x, y + 256);
    if self.p_markedElement ~= nil then
        self.markFrame:SetPos(self.p_markedElement.object:GetX(), self.p_markedElement.object:GetY());
    end
end

---marks the selected element
-- @parm element: selected element
function Chart:markElement(element)
    local x, y = element.object:GetPos();
    self.markFrame:SetPos(x, y);
    self.markFrame:SetVisible(true);
    self.markFrame:MoveToTop();
    self.p_markedElement = element;
    self.textField:changeText(element.name, element.description);
end

return Chart;