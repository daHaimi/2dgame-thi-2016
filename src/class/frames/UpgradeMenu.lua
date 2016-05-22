Class = require "lib.hump.class";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement"

local UpgradeMenu = Class {
    init = function(self)
        self.name = "Shop";
        self.frame = Frame(100, 100, "down", "down", 50, 0, -1500);
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
        chart = {
            object = Chart();
            x = 10;
            y = 10;
        };
        button_buy = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 350;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 390;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_buy.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_buy.object:SizeToImage()
    self.elementsOnFrame.button_buy.object:SetText("Buy Upgrade");
    
    self.elementsOnFrame.button_back.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_back.object:SizeToImage()
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    self:addAllUpgrades();
    
    --load values out of persTable into the chart
    --convert 0, 1 or more in to boolean. A 2 equals multiply checkboxes
    --[[
    if _persTable.upgrades.speedUp == 1 then
        self.upgrades.upgrade1:disable();
    end
    if _persTable.upgrades.moneyMult == 1 then
        self.upgrades.upgrade2:disable();
    end
    if _persTable.upgrades.moreLife == 1 then
        self.upgrades.upgrade3:disable();
    end
    if _persTable.upgrades.godMode == 1 then
        self.upgrades.upgrade4:disable();
    end
    if _persTable.upgrades.mapBreakthrough1 == 1 then
        self.upgrades.upgrade4:disable();
        if _persTable.upgrades.mapBreakthrough2 == 1 then
            self.upgrades.upgrade4:disable();
        end
    end
    ]]--
    
    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        --[[
        --update persTable with new bought updates
        if self.upgrades.upgrade1:getEnable() then
            _persTable.upgrades.speedUp = 0;
        else
            _persTable.upgrades.speedUp = 1;
        end
        if self.upgrades.upgrade2:getEnable() then
            _persTable.upgrades.moneyMult = 0;
        else
            _persTable.upgrades.moneyMult = 1;
        end
        if self.upgrades.upgrade3:getEnable() then
            _persTable.upgrades.moreLife = 0;
        else
            _persTable.upgrades.moreLife = 1;
        end
        if self.upgrades.upgrade4:getEnable() then
            _persTable.upgrades.godMode = 0;
        else
            _persTable.upgrades.godMode = 1;
        end
        if self.upgrades.upgrade5:getEnable() then
            _persTable.upgrades.mapBreakthrough1 = 0;
        else
            _persTable.upgrades.mapBreakthrough1 = 1;
        end
        if self.upgrades.upgrade6:getEnable() then
            _persTable.upgrades.mapBreakthrough2 = 0;
        else
            _persTable.upgrades.mapBreakthrough2 = 1;
        end]]--
        _gui:tempTextOutput();
        _gui:changeFrame(_gui.myFrames.mainMenu);
    end
    
    self.elementsOnFrame.button_buy.object.OnClick = function(object)
        if self.elementsOnFrame.chart.object.markedElement ~= nil then
            self.elementsOnFrame.chart.object.markedElement:disable();
        end
    end
    
end

--add all upgrades written in the data.lua into the chart and adds an OnClick event
function UpgradeMenu:addAllUpgrades()
    for k, v in pairs(_G.data.upgrades) do
        local newKlickableElement = KlickableElement(v.name, v.image, v.image_disable, v.description, v.price, v.nameInPersTable);
        newKlickableElement.object.OnClick = function(object)
            self.elementsOnFrame.chart.object:markElement(newKlickableElement);
        end
        self.elementsOnFrame.chart.object:addKlickableElement(newKlickableElement);
    end
end


function UpgradeMenu:loadValuesFromPersTable()
    
    
    
end

function UpgradeMenu:loadValuesInPersTable()
    
    
    
end


---shows the frame on screen
function UpgradeMenu:draw()
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function UpgradeMenu:clear()
    self.frame:clear(self.elementsOnFrame)
end

---called in the "fly in" state 
function UpgradeMenu:appear()
    self.frame:appear(self.elementsOnFrame)
end

---called in the "fly out" state
function UpgradeMenu:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function UpgradeMenu:checkPosition()
    return self.frame:checkPosition();
end

return UpgradeMenu;
