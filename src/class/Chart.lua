--- Chart contains a table with clickable elements and a textfield
Class = require "lib.hump.class";
TextField = require "class.TextField";

local Chart = Class {
    init = function(self)
        self.background = love.graphics.newImage("assets/gui/StandardBG.png");
        self.backgroundPosition = {(_G._persTable.winDim[1] - self.background:getWidth()) / 2,
            (_G._persTable.winDim[2] - self.background:getHeight()) / 2};
        self.directory = "assets/gui/icons/";
        self.imageButtonUP = love.graphics.newImage("assets/gui/UpButton.png");
        self.imageButtonDOWN = love.graphics.newImage("assets/gui/DownButton.png");
        self.mark = love.graphics.newImage("assets/gui/icons/markFrame.png");
        self.textBackground = love.graphics.newImage("assets/gui/TextBG.png");
        self.buttonHeight = self.imageButtonUP:getHeight();
        self.buttonWidth = self.imageButtonUP:getWidth();
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.buttonOffset = 15;
        self.p_column = 3; --amount of the columns of the table
        self.p_row = 0; --automatically calculated value of the amount of rows in the table
        self.p_toprow = 0; --top visible row. needed to scroll up and down
        self.p_xPos = 0;
        self.p_yPos = 0;
        self.klickableSize = 96;
        self.p_elementsOnChart = {}; --elements in the table
        self.p_markedElement = nil;
        self.xOffset = 0;
        self.yOffset = 0;
        self.clickablePosition = (_G._persTable.winDim[1] - 3 * self.klickableSize) /2;
        self.markPosition = {nil, nil};
        
        self.textFieldName = "";
        self.textFieldDescription = "";
        self.textFieldPrice = "";

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
    self.button_up = ImageButton(self.imageButtonUP, self.buttonXPosition , 
        self.p_yPos + self.buttonOffset + self.backgroundPosition[2], true);
    self.button_up:setText("");
    self.button_down = ImageButton(self.imageButtonDOWN, self.buttonXPosition, 
        self.p_yPos + self.buttonOffset + 3 * 96 + self.buttonHeight + self.backgroundPosition[2], true);
    self.button_down:setText("");

    --onclick events of the buttons
    self.button_up.gotClicked = function(_)
        self:scrollUp();
    end

    self.button_down.gotClicked = function(_)
        self:scrollDown();
    end
    
end

--- called to scroll the table up
function Chart:scrollUp()
    if (self.p_toprow > 0) then
        self.p_toprow = self.p_toprow - 1;
        if self.p_markedElement ~= nil then
            self.markPosition[2] = self.markPosition[2] + self.klickableSize;
            if self.markPosition[2] > self.backgroundPosition[2] + self.buttonHeight + 3 * self.klickableSize then
                self.markPosition = {nil, nil}
                self.p_markedElement = nil;
            end
        end
    end
end

--- called to scroll the table down
function Chart:scrollDown()
    if self.p_toprow + 3 < self.p_row then
        self.p_toprow = self.p_toprow + 1;
        if self.markPosition[1] ~= nil then
            self.markPosition[2] = self.markPosition[2] - self.klickableSize;
            if self.markPosition[2] < self.backgroundPosition[2] then
                self.markPosition = {nil, nil}
                self.p_markedElement = nil;
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
    self.markPosition = {nil, nil};
    self.p_markedElement = nil;
end

--- draws the elements shown in the table
function Chart:draw()
    local _, y = self.button_up:getOffset();
    self:setPosOfKlickableElements();
    
    -- draw text
    love.graphics.draw(self.textBackground, (_G._persTable.winDim[1] - self.textBackground:getWidth())/2, 
        450 + y+ self.backgroundPosition[2]);
    
    --draw buttons
    self.button_up:draw()
    self.button_down:draw()
    
    --draw clickalbe elements
    for i = 1, #self.p_elementsOnChart, 1 do
        if self.p_elementsOnChart[i] ~= nil and
        self.p_elementsOnChart[i].sortNumber > self.p_toprow * 3 and
        self.p_elementsOnChart[i].sortNumber <= self.p_toprow * 3 + 9 then
            self.p_elementsOnChart[i]:draw();
        end
    end
    --draw mark
    if self.markPosition[1] ~= nil and self.markPosition[2] ~= nil then
        love.graphics.draw(self.mark, self.markPosition[1], self.markPosition[2]);
    end 
    
    local font = love.graphics.getFont();
    love.graphics.setColor(0, 0, 0);
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 20));
    love.graphics.printf(self.textFieldName, (_G._persTable.winDim[1] - self.textBackground:getWidth())/2 + 10, 
        450 + y+ self.backgroundPosition[2] + y, self.textBackground:getWidth(), "left")
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 17));
    love.graphics.printf(self.textFieldDescription, (_G._persTable.winDim[1] - self.textBackground:getWidth())/2 + 10, 
        480 + y+ self.backgroundPosition[2] + y, self.textBackground:getWidth() - 20, "left")
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 15));
    love.graphics.printf(self.textFieldPrice, (_G._persTable.winDim[1] - self.textBackground:getWidth())/2 + 20, 
        430 + y+ self.backgroundPosition[2] + y, self.textBackground:getWidth() - 20, "left")
    love.graphics.setFont(font);
    love.graphics.setColor(255, 255, 255);
end

--- set the position of all elements in the table
function Chart:setPosOfKlickableElements()
    local row = 0;
    for i = 1, #self.p_elementsOnChart, 1 do
        if self.p_elementsOnChart[i] ~= nil then
            local positionNumber = self.p_elementsOnChart[i].sortNumber;
            local colNumber = (positionNumber - 1)%3;
            local rowNumber = (positionNumber - colNumber-1) /3
            self.p_elementsOnChart[i]:setPos(self.clickablePosition + self.p_xPos + self.klickableSize * colNumber,
               self.klickableSize * rowNumber + self.p_yPos - (self.klickableSize * self.p_toprow)
               + self.buttonHeight + self.buttonOffset + self.backgroundPosition[2]);
        end
    end
end

--- add a new klickable element the the table
-- @parm newKlickableElement: object of the new klickable element
function Chart:addKlickableElement(newKlickableElement)
    table.insert(self.p_elementsOnChart, newKlickableElement);
    self.p_row = math.ceil(table.getn(self.p_elementsOnChart) / self.p_column);
end

--- marks the selected element
-- @parm element: selected element
function Chart:markElement(element)
    local x, y = element.object:getPosition();
    self.markPosition = {x, y};
    self.p_markedElement = element;
    if _G._gui:getCurrentState() == "Achievements" or _G._gui:getCurrentState() == "Shop" or 
    (_G._gui:getCurrentState() == "Dictionary" and _G._persTable.fish.caught[element.name] > 0 ) then
        if element.price ~= nil then
            if element.name ~= nil then
                
                self.textFieldName = _G.data.languages[_G._persTable.config.language].package[element.name].name;
                self.textFieldDescription =  _G.data.languages[_G._persTable.config.language].package[element.name].description;
                self.textFieldPrice =  element.price;
                
                
            else
                self.textFieldName = _G.data.languages[_G._persTable.config.language].package[element.nameOnPersTable].name;
                self.textFieldDescription = _G.data.languages[_G._persTable.config.language].package
                    [element.nameOnPersTable].description;
                self.textFieldPrice = element.price;
                if _G._persTable.upgrades[element.nameOnPersTable] then
                    _G._gui:getFrames().upgradeMenu.elementsOnFrame.button_buy:setImage(
                        love.graphics.newImage("assets/gui/HalfButton_disable.png"));
                else
                    _G._gui:getFrames().upgradeMenu.elementsOnFrame.button_buy:setImage(
                        love.graphics.newImage("assets/gui/HalfButton.png"));
                end
                
            end
        else
            self.textFieldName = _G.data.languages[_G._persTable.config.language].package[element.nameOnPersTable].name;
            self.textFieldDescription = _G.data.languages[_G._persTable.config.language].package[element.nameOnPersTable].description;
        end
    else
        self.textFieldName = "???";
        self.textFieldDescription = "?????";
        self.textFieldPrice = "???";
    end
end

--- retruns the offset of the button
--@return x and y offset of the button
function Chart:getOffset()
    return self.xOffset, self.yOffset;
end

function Chart:getPosition()
    return self.p_xPos, self.p_yPos + self.backgroundPosition[2];
end

function Chart:getSize()
    return _G._persTable.winDim[1], 3 * self.klickableSize + 2 * self.buttonHeight + self.buttonOffset;
end

--- sets the offset of the button 
--@param x x offset of the button
--@parma y y offset of the button
function Chart:setOffset(x,y)
    self.button_up:setOffset(x,y);
    self.button_down:setOffset(x, y);
    for _, v in pairs (self.p_elementsOnChart) do
        v.object:setOffset(x,y)
    end
end

function Chart:mousepressed(x, y)
    local xPosition, yPosition = self.button_up:getPosition();
    local width, height = self.button_up:getSize();
    
    if x > xPosition and x < xPosition + width and
    y > yPosition and y < yPosition + height then
        self.button_up.gotClicked();
    else
    
    xPosition, yPosition = self.button_down:getPosition();
    width, height = self.button_down:getSize();
    
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            self.button_down.gotClicked();
        else
        
            for _, v in pairs (self.p_elementsOnChart) do
                xPosition = v:getX();
                yPosition = v:getY();
                width, height = v:getSize();
                
                if x > xPosition and x < xPosition + width and
                y > yPosition and y < yPosition + height and v ~= nil and
                v.sortNumber > self.p_toprow * 3 and
                v.sortNumber <= self.p_toprow * 3 + 9 then
                    v:gotClicked(x, y);
                end
            end
        end
    end
end
return Chart;
