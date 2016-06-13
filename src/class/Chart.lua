--- Chart contains a table with clickable elements and a textfield
Class = require "lib.hump.class";
TextField = require "class.TextField";

local Chart = Class {
    init = function(self, _)
        if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.buttonHeight = 75;
            self.buttonOffset = 15;
            self.klickableSize = 96;
            self.textfieldSize = 250;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.width = 512;
            self.height = 888;
            self.buttonOffset = 20;
            self.buttonHeight = 96;
            self.klickableSize = 128;
            self.textfieldSize = 325;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            self.klickableSize = 144;
            self.textfieldSize = 400;
        end
        self.p_column = 3; --amount of the columns of the table
        self.p_row = 0; --automatically calculated value of the amount of rows in the table
        self.p_toprow = 0; --top visible row. needed to scroll up and down
        self.p_xPos = 0;
        self.p_yPos = 0;

        self.p_elementsOnChart = {}; --elements in the table
        self.p_markedElement = nil;

        self:create();
    end;
};

--- Getter of all Elements
function Chart:getAllElements()
    return self.p_elementsOnChart;
end

--- Getter of the marked Element
function Chart:getMarkedElement()
    return self.p_markedElement;
end

--- function called in the constructor of this class. creates backround and buttons
function Chart:create()
    self.button_up = Loveframes.Create("imagebutton");
    self.button_up:SetImage(self.directory .. "UpButton.png");
    self.button_up:SizeToImage();
    self.button_up:SetText("");

    self.button_down = Loveframes.Create("imagebutton");
    self.button_down:SetImage(self.directory .. "DownButton.png");
    self.button_down:SizeToImage();
    self.button_down:SetText("");

    self.p_markFrame = Loveframes.Create("image");
    self.p_markFrame:SetImage(self.directory .. "markFrame.png");
    self.p_markFrame:SetVisible(false);

    self.textField = TextField(self.textfieldSize, self.directory);

    --onclick events of the buttons
    self.button_up.OnClick = function(_)
        self:scrollUp();
    end

    self.button_down.OnClick = function(_)
        self:scrollDown();
    end
end

--- called to scroll the table up
function Chart:scrollUp()
    if (self.p_toprow > 0) then
        self.p_toprow = self.p_toprow - 1;
        self:drawChart();
        if self.p_markedElement ~= nil then
            if self.p_markedElement.object:GetVisible() == true then
                self:markElement(self.p_markedElement);
            else
                self:resetMarkedFrame();
            end
        end
    end
end

--- called to scroll the table down
function Chart:scrollDown()
    if self.p_toprow + 3 < self.p_row then
        self.p_toprow = self.p_toprow + 1;
        self:drawChart();
        if self.p_markedElement ~= nil then
            if self.p_markedElement.object:GetVisible() == true then
                self:markElement(self.p_markedElement);
            else
                self:resetMarkedFrame();
            end
        end
    end
end

--- resets the top row. called at the back button to reset the table for the next shop visit
function Chart:resetTopRow()
    self.p_toprow = 0;
end

--- reset the markedFrame visible to false
function Chart:resetMarkedFrame()
    self.p_markFrame:SetVisible(false);
end

--- draws the elements shown in the table
function Chart:drawChart()
    --clear
    for _, v in pairs(self.p_elementsOnChart) do
        v:SetVisible(false);
    end
    --draw new elements
    for var1 = 1 + (self.p_column * self.p_toprow), 9 + (self.p_column * self.p_toprow) do
        if self.p_elementsOnChart[var1] ~= nil then
            self.p_elementsOnChart[var1]:SetVisible(true);
        end
    end
    self:setPosOfKlickableElements()
end

--- set the position of all elements in the table
function Chart:setPosOfKlickableElements()
    local row = 0;
    for _ = 1, self.p_row + 1 do
        for var2 = 1, self.p_column + 1 do
            if self.p_elementsOnChart[var2 + row * self.p_column] ~= nil then
                self.p_elementsOnChart[var2 + row * self.p_column]:SetPos(self.p_xPos + self.klickableSize * (var2 - 1),
                    (self.p_yPos + self.klickableSize * row) - (self.klickableSize * self.p_toprow) + self.buttonHeight);
            end
        end
        row = row + 1;
    end
end

--- add a new klickable element the the table
-- @parm newKlickableElement: object of the new klickable element
function Chart:addKlickableElement(newKlickableElement)
    table.insert(self.p_elementsOnChart, newKlickableElement);
    self.p_row = math.ceil(table.getn(self.p_elementsOnChart) / self.p_column);
end

--- Function not conform to CC/ implements an interface
--- Set the visible of all elements
-- @parm visible: true or false
function Chart:SetVisible(visible)
    self.button_up:SetVisible(visible);
    self.button_down:SetVisible(visible);
    self.textField:SetVisible(visible);
    if visible then
        self:drawChart();
    else
        for _, v in pairs(self.p_elementsOnChart) do
            v:SetVisible(visible);
        end
    end
    self.p_markFrame:SetVisible(false);
    if not visible then
        self.textField:changeText("", "");
    end
end

--- Function not conform to CC/ implements an interface
--- Set the chart position
-- @parm x: x axis position
-- @parm y: y axis position
function Chart:SetPos(x, y)
    local buttonXPos = (_G._persTable.scaledDeviceDim[1] - self.width) / 2 + self.width * 0.16;
    self.p_xPos = (_G._persTable.scaledDeviceDim[1] - self.klickableSize * self.p_column) / 2;
    self.p_yPos = y;
    self.button_up:SetPos(buttonXPos, y);
    self.button_down:SetPos(buttonXPos, y + math.min(self.p_row, 3) * self.klickableSize + self.buttonHeight + self.buttonOffset);
    self:setPosOfKlickableElements();
    self.textField:SetPos(x, math.ceil(y + self.height * 0.68));
    if self.p_markedElement ~= nil then
        self.p_markFrame:SetPos(self.p_markedElement.object:GetX(), self.p_markedElement.object:GetY());
    end
end

--- marks the selected element
-- @parm element: selected element
function Chart:markElement(element)
    local x, y = element.object:GetPos();
    self.p_markFrame:SetPos(x, y);
    self.p_markFrame:SetVisible(true);
    self.p_markFrame:MoveToTop();
    self.p_markedElement = element;
    if element.price ~= nil then
        if element.name ~= nil then
            self.textField:changeText(_G.data.languages[_G._persTable.config.language].package[element.name].name,
                _G.data.languages[_G._persTable.config.language].package[element.name].description, element.price);
        else
            self.textField:changeText(_G.data.languages[_G._persTable.config.language].package[element.nameOnPersTable].name,
                _G.data.languages[_G._persTable.config.language].package[element.nameOnPersTable].description, element.price);
        end
    else
        self.textField:changeText(_G.data.languages[_G._persTable.config.language].package[element.nameOnPersTable].name,
            _G.data.languages[_G._persTable.config.language].package[element.nameOnPersTable].description);
    end
end

return Chart;
