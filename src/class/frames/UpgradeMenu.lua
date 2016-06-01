Class = require "lib.hump.class";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement"

local UpgradeMenu = Class {
    init = function(self)
        if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.buttonHeight = 75;
            self.buttonOffset = 15;
            self.buttonLength = 128;
            self.textFieldLength = 279;
            self.speed = 50;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.width = 512;
            self.height = 888;
            self.buttonOffset = 20;
            self.buttonHeight = 96;
            self.buttonLength = 174;
            self.textFieldLength = 384;
            self.speed = 60;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            self.buttonLength = 196;
            self.textFieldLength = 432;
            self.speed = 75;
        end
        self.name = "Shop";
       self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2, 
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2, "down", "down", self.speed, 0, -1500);
        self:create();
    end;
};

---creates the shop frame
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
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
    
    self.elementsOnFrame.button_buy.object.OnClick = function(object)
        if self.elementsOnFrame.chart.object:getMarkedElement() ~= nil and 
        _G._persTable.money >= self.elementsOnFrame.chart.object:getMarkedElement().price then
            self:buyElement();
            _G._persistence:updateSaveFile();
        end
    end
end

--updates the money on this frame
function UpgradeMenu:updateMoney()
        self.elementsOnFrame.money.object:SetText("Money: " .. _G._persTable.money);
end

---called to buy an Item
function UpgradeMenu:buyElement()
    self.elementsOnFrame.chart.object:getMarkedElement():disable();
    local price = self.elementsOnFrame.chart.object:getMarkedElement().price;
    _G._persTable.money = _G._persTable.money - price;
    self:updateMoney()
end

--add all upgrades written in the data.lua into the chart and adds an OnClick event
function UpgradeMenu:addAllUpgrades()
    for k, v in pairs(_G.data.upgrades) do
        local newKlickableElement = KlickableElement(v.name, self.directory .. v.image, 
            self. directory .. v.image_disable, v.description, v.price, v.nameOnPersTable);
        
        --add OnClick event
        newKlickableElement.object.OnClick = function(object)
            self.elementsOnFrame.chart.object:markElement(newKlickableElement);
        end
        self.elementsOnFrame.chart.object:addKlickableElement(newKlickableElement);
    end
end


function UpgradeMenu:loadValuesFromPersTable()
    for k, v in pairs(self.elementsOnFrame.chart.object:getAllElements()) do
        local elementName = v.nameOnPersTable;
        if _G._persTable.upgrades[elementName] then
            if _G._persTable.upgrades[elementName] == true then
                v:disable();
            end
        end
    end
end

---shows the frame on screen
function UpgradeMenu:draw()
    self:updateMoney();
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function UpgradeMenu:clear()
    self.frame:clear(self.elementsOnFrame);
end

---called in the "fly in" state 
function UpgradeMenu:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

---called in the "fly out" state
function UpgradeMenu:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

---return true if the frame is on position /fly in move is finished
function UpgradeMenu:checkPosition()
    return self.frame:checkPosition();
end

return UpgradeMenu;
