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
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().mainMenu);
        self.elementsOnFrame.chart:resetTopRow();
        self.elementsOnFrame.chart:resetMarkedFrame();
    end

    self.elementsOnFrame.button_buy.gotClicked = function(_)
        if self.elementsOnFrame.chart:getMarkedElement() ~= nil then
            markedElement = self.elementsOnFrame.chart:getMarkedElement();
            if _G._persTable.money >= markedElement.price and
                (markedElement.dependency == nil or _G._persTable.upgrades[markedElement.dependency]) then
                if (self:buyElement() == true) then
                    TEsound.play({ "assets/sound/buying.wav" }, 'bgm');
                    _G._persistence:updateSaveFile();
                end
            else
                if markedElement.purchaseable then
                TEsound.play({ "assets/sound/notEnoughMoney.wav" }, 'bgm');
                end
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
-- @return Returns true if the element was successfully bought, otherwise false.
function UpgradeMenu:buyElement()
    local bought = false;
    local markedElement = self.elementsOnFrame.chart:getMarkedElement();
    if not _G._persTable.upgrades[markedElement.nameOnPersTable] then
        markedElement:disable();
        local price = self.elementsOnFrame.chart:getMarkedElement().price;
        _G._persTable.money = _G._persTable.money - price;
        self.elementsOnFrame.button_buy:setImage(self.imageButtonLocked);
        self:updateMoney();
        self:loadValuesFromPersTable();
        if markedElement.nameOnPersTable == "mapBreakthrough1" then
            _gui.levMan:getAchievmentManager():unlockAchievement("firstBorderRemoved");
        end
        bought = true;
    else
        _gui:newTextNotification(self.directory .. "ach_shitcoin.png", 
            _G.data.languages[_G._persTable.config.language].package.textBought)
        bought = false;
    end
    
    return bought;
end

--- add all upgrades written in the data.lua into the chart and adds an OnClick event
function UpgradeMenu:addAllUpgrades()
    for _, v in pairs(_G.data.upgrades) do
        local image = love.graphics.newImage(self.directory ..  v.image);
        local image_unlock = love.graphics.newImage(self.directory ..  v.image_disable);
        if v.sortNumber ~= nil then
            local newKlickableElement = KlickableElement(v.name, image, image_unlock, v.description, v.price, 
                v.nameOnPersTable, v.sortNumber, v.dependency);
            if _G._persTable.upgrades[v.nameOnPersTable] then
                newKlickableElement.object:setImage(image_unlock);
            end
            self.elementsOnFrame.chart:addKlickableElement(newKlickableElement);
        end
    end
end

--- Loads the values form pers table and updates elements states based on those values
function UpgradeMenu:loadValuesFromPersTable()
    for _, v in pairs(self.elementsOnFrame.chart:getAllElements()) do
        local elementName = v.nameOnPersTable;
        local elementOnPersTable = _G._persTable.upgrades[elementName];
        
        if elementOnPersTable ~= nil and v.dependency == nil then
            if elementOnPersTable == true then
                v:disable();
            else
                v:reset();
            end
        elseif elementOnPersTable ~= nil and v.dependency ~= nil then
            if _G._persTable.upgrades[v.dependency] then
                if elementOnPersTable == true then
                    v:disable();
                else
                    v:reset();
                end
            else
                v:lock();
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
--- is called when the mouse is pressed
--@param x x coordinate of the mouse 
--@param y y coordinate of the mouse
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
