Class = require "lib.hump.class";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement"

local UpgradeMenu = Class {
    init = function(self)
        self.imageButton = love.graphics.newImage("assets/gui/HalfButton.png");
        self.imageButtonLocked = love.graphics.newImage("assets/gui/HalfButton_disable.png");
        self.background = love.graphics.newImage("assets/gui/StandardBG.png");
        self.backgroundPosition = {(_G._persTable.winDim[1] - self.background:getWidth()) / 2,
            (_G._persTable.winDim[2] - self.background:getHeight()) / 2};
        self.offset = (_G._persTable.winDim[2] - self.background:getHeight())/2 + 30;
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.directory = "assets/gui/icons/";
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.offset = (_G._persTable.winDim[2] - self.background:getHeight())/2 + 30;
        self.name = "Shop";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
        self.money = "";
        self:create();

        
        self.xOffset = 0;
        self.yOffset = 0;
    end;
};

--- creates the shop frame
function UpgradeMenu:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        chart = Chart();
        button_buy = ImageButton(self.imageButton, 0.875 * self.background:getWidth() + self.backgroundPosition[1]
            - self.buttonWidth, self.background:getHeight() + self.backgroundPosition[2] - self.buttonHeight - 30, true);
        button_back = ImageButton(self.imageButton, 0.125 * self.background:getWidth() + self.backgroundPosition[1], 
            self.background:getHeight() + self.backgroundPosition[2] - self.buttonHeight - 30, true);
    };

    self:addAllUpgrades();
    self:loadValuesFromPersTable();

    --onclick events for all buttons
    self.elementsOnFrame.button_back.gotClicked = function(_)
        _gui:changeFrame(_gui:getFrames().mainMenu);
        self.elementsOnFrame.chart:resetTopRow();
        self.elementsOnFrame.chart:resetMarkedFrame();
    end

    self.elementsOnFrame.button_buy.gotClicked = function(_)
        if self.elementsOnFrame.chart:getMarkedElement() ~= nil then
            if _G._persTable.money >= self.elementsOnFrame.chart:getMarkedElement().price then
                self:buyElement();
                _G._persistence:updateSaveFile();
            else
                _gui:newTextNotification(self.directory .. "ach_nothingCaught.png", _G.data.languages[_G._persTable.config.language].package.textMoney);
            end
            if not _G._persTable.achievements.shoppingQueen then
                _gui:getLevelManager():getAchievmentManager():achShoppingQueen();
            end
            _gui:getLevelManager():getAchievmentManager():achBitch(); -- check the achievement achBitch
        end
    end
    
    self.elementsOnFrame.chart.gotClicked = function (x, y)
        self.elementsOnFrame.chart:mousepressed(x, y);
    end
end

--updates the money on this frame
function UpgradeMenu:updateMoney()
    self.money = (_G.data.languages[_G._persTable.config.language].package.textMoney2 .. _G._persTable.money);
end

--- changes the language of this frame
function UpgradeMenu:setLanguage(language)
    self.elementsOnFrame.button_back:setText(_G.data.languages[language].package.buttonBack);
    self.elementsOnFrame.button_buy:setText(_G.data.languages[language].package.buttonBuy);
end

--- called to buy an Item
function UpgradeMenu:buyElement()
    local markedElement = self.elementsOnFrame.chart:getMarkedElement();
    if not _G._persTable.upgrades[markedElement.nameOnPersTable] then
        markedElement:disable();
        local price = self.elementsOnFrame.chart:getMarkedElement().price;
        _G._persTable.money = _G._persTable.money - price;
        self.elementsOnFrame.button_buy:setImage(self.imageButtonLocked);
        self:updateMoney()
    else
        _gui:newTextNotification(self.directory .. "ach_shitcoin.png", _G.data.languages[_G._persTable.config.language].package.textBought)
    end
end

--add all upgrades written in the data.lua into the chart and adds an OnClick event
function UpgradeMenu:addAllUpgrades()
    for _, v in pairs(_G.data.upgrades) do
        if v.sortNumber ~= nil then
            local newKlickableElement = KlickableElement(v.name, self.directory .. v.image,
                self.directory .. v.image_disable, v.description, v.price, v.nameOnPersTable, v.sortNumber);
            self.elementsOnFrame.chart:addKlickableElement(newKlickableElement);
        end
    end
end


function UpgradeMenu:loadValuesFromPersTable()
    for _, v in pairs(self.elementsOnFrame.chart:getAllElements()) do
        local elementName = v.nameOnPersTable;
        if _G._persTable.upgrades[elementName] then
            if _G._persTable.upgrades[elementName] == true then
                v:disable();
            end
        end
    end
end

--- shows the frame on screen
function UpgradeMenu:draw()  
    local _, y = self.elementsOnFrame.button_back:getOffset();
    love.graphics.draw(self.background, self.backgroundPosition[1], self.backgroundPosition[2] + y);
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
    
    -- print the text
    self:updateMoney();
    local font = love.graphics.getFont();
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 16));
    love.graphics.printf(self.money, self.backgroundPosition[1] + 50, 
        self.backgroundPosition[2] + 30 + y, 1000, "left");
    love.graphics.setFont(font);
end

--- called to "delete" this frame
function UpgradeMenu:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function UpgradeMenu:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function UpgradeMenu:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

--- return true if the frame is on position /fly in move is finished
function UpgradeMenu:checkPosition()
    return self.frame:checkPosition();
end

--- sets the offset of the frame
--@param x x offset of the frame
--@parma y y offset of the frame
function UpgradeMenu:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end

function UpgradeMenu:mousepressed(x, y)    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            v.gotClicked(x, y);
        end
    end
end

return UpgradeMenu;
