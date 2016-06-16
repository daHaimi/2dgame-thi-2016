Class = require "lib.hump.class";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement"

local UpgradeMenu = Class {
    init = function(self)
        self.directory = "assets/gui/480px/";
        self.widthPx = 480;
        self.width = 384;
        self.height = 666;
        self.buttonHeight = 75;
        self.buttonOffset = 15;
        self.buttonLength = 128;
        self.textFieldLength = 279;
        self.speed = 50;

        self.name = "Shop";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2,
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed, "down", "down", self.speed, 0, -1500);
        self:create();
    end;
};

--- creates the shop frame
function UpgradeMenu:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        money = {
            object = Loveframes.Create("text");
            x = 50;
            y = 30;
        };
        chart = {
            object = Chart();
            x = 0.125 * self.width;
            y = self.buttonOffset + 20;
        };
        button_buy = {
            object = Loveframes.Create("imagebutton");
            x = 0.125 * self.width + self.textFieldLength - self.buttonLength;
            y = self.height - self.buttonHeight;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 0.125 * self.width;
            y = self.height - self.buttonHeight;
        };
    };

    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "StandardBG.png");

    self.elementsOnFrame.button_buy.object:SetImage(self.directory .. "HalfButton.png")
    self.elementsOnFrame.button_buy.object:SizeToImage()
    self.elementsOnFrame.button_buy.object:SetText("Buy");

    self.elementsOnFrame.button_back.object:SetImage(self.directory .. "HalfButton.png")
    self.elementsOnFrame.button_back.object:SizeToImage()
    self.elementsOnFrame.button_back.object:SetText("Back");

    self:addAllUpgrades();
    self:loadValuesFromPersTable();

    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end

    self.elementsOnFrame.button_buy.object.OnClick = function(_)
        if self.elementsOnFrame.chart.object:getMarkedElement() ~= nil then
            if _G._persTable.money >= self.elementsOnFrame.chart.object:getMarkedElement().price then
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
end

--updates the money on this frame
function UpgradeMenu:updateMoney()
    self.elementsOnFrame.money.object:SetText("Money: " .. _G._persTable.money);
end

--- changes the language of this frame
function UpgradeMenu:setLanguage(language)
    self.elementsOnFrame.button_back.object:SetText(_G.data.languages[language].package.buttonBack);
    self.elementsOnFrame.button_buy.object:SetText(_G.data.languages[language].package.buttonBuy);
end

--- called to buy an Item
function UpgradeMenu:buyElement()
    local markedElement = self.elementsOnFrame.chart.object:getMarkedElement();
    if not _G._persTable.upgrades[markedElement.nameOnPersTable] then
        markedElement:disable();
        local price = self.elementsOnFrame.chart.object:getMarkedElement().price;
        _G._persTable.money = _G._persTable.money - price;
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

            --add OnClick event
            newKlickableElement.object.OnClick = function(_)
                self.elementsOnFrame.chart.object:markElement(newKlickableElement);
            end
            self.elementsOnFrame.chart.object:addKlickableElement(newKlickableElement);
        end
    end
end


function UpgradeMenu:loadValuesFromPersTable()
    for _, v in pairs(self.elementsOnFrame.chart.object:getAllElements()) do
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
    self:updateMoney();
    self.frame:draw(self.elementsOnFrame);
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

return UpgradeMenu;
