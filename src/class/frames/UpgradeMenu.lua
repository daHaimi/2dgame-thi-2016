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

--creates the achievement frame
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
    
    --add upgrades to chart
    self.upgrades = {
        upgrade1 = KlickableElement("SpeedUp", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "Text for SpeedUp. Text for SpeedUp. Text for SpeedUp. ");
        upgrade2 = KlickableElement("Money", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "Text for Money. Text for Money. Text for Money. ");
        upgrade3 = KlickableElement("Life", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "Text for Life. Text for Life. Text for Life. ");
        upgrade4 = KlickableElement("God", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "Text for God. Text for God. Text for God. ");
        upgrade5 = KlickableElement("BT1", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "Text for BT1. Text for BT1. Text for BT1. ");
        upgrade6 = KlickableElement("BT2", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "Text for BT2. Text for BT2. Text for BT2. ");
        upgrade7 = KlickableElement("Up7", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "");
        upgrade8 = KlickableElement("Up8", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "");
        upgrade9 = KlickableElement("Up9", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "");
        upgrade10 = KlickableElement("Up10", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "T");
        upgrade11 = KlickableElement("Up11", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_disable.png", "");
    };
    
    --add all upgrade to chart
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade1);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade2);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade3);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade4);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade5);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade6);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade7);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade8);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade9);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade10);
    self.elementsOnFrame.chart.object:addKlickableElement(self.upgrades.upgrade11);
    
    --load values out of persTable into the chart
    --convert 0, 1 or more in to boolean. A 2 equals multiply checkboxes
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
    
    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(object)
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
        end
        _gui:tempTextOutput();
        _gui:changeFrame(_gui.myFrames.mainMenu);
    end
    
    self.elementsOnFrame.button_buy.object.OnClick = function(object)
        if self.elementsOnFrame.chart.object.markedElement ~= nil then
            self.elementsOnFrame.chart.object.markedElement:disable();
        end
    end
    
    self.upgrades.upgrade1.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade1);
    end
    
    self.upgrades.upgrade2.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade2);
    end
    
    self.upgrades.upgrade3.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade3);
    end
    
    self.upgrades.upgrade4.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade4);
    end
    
    self.upgrades.upgrade5.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade5);
    end
    
    self.upgrades.upgrade6.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade6);
    end
    
    self.upgrades.upgrade7.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade7);
    end
    
    self.upgrades.upgrade8.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade8);
    end
    
    self.upgrades.upgrade9.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade9);
    end
    
    self.upgrades.upgrade10.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade10);
    end
    
    self.upgrades.upgrade11.object.OnClick = function(object)
        _gui.myFrames.upgradeMenu.elementsOnFrame.chart.object:markElement(self.upgrades.upgrade11);
    end
end

function UpgradeMenu:draw()
    self.frame:draw(self.elementsOnFrame);
end

--called to "delete" this frame
function UpgradeMenu:clear()
    self.frame:clear(self.elementsOnFrame)
end

--called in the "fly in" state 
function UpgradeMenu:appear()
    self.frame:appear(self.elementsOnFrame)
end

--called in the "fly out" state
function UpgradeMenu:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function UpgradeMenu:checkPosition()
    return self.frame:checkPosition();
end

return UpgradeMenu;
