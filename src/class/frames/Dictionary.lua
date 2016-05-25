Class = require "lib.hump.class";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement";

local Dictionary = Class {
    init = function(self)
        self.name = "Dictionary";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - 256) / 2, (_G._persTable.scaledDeviceDim[2] - 512) / 2,
            "down", "down", 50, 0, -1500);
        self:create();
    end;
};

---creates the dictionary frame
function Dictionary:create()
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
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 400;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_back.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_back.object:SizeToImage()
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    self:addAllObjects();
    
    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

--add all object written in the data.lua into the chart and adds an OnClick event
function Dictionary:addAllObjects()
    for k, v in pairs(_G.data.fishableObjects) do
        local newKlickableElement = KlickableElement(v.name, "assets/" .. v.image, "assets/" .. v.image, v.description, v.value, nil);
        newKlickableElement.object.OnClick = function(object)
            self.elementsOnFrame.chart.object:markElement(newKlickableElement);
        end
        self.elementsOnFrame.chart.object:addKlickableElement(newKlickableElement);
    end
end

---shows the frame on screen
function Dictionary:draw()
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function Dictionary:clear()
    self.frame:clear(self.elementsOnFrame)
end

---called in the "fly in" state 
function Dictionary:appear()
    self.frame:appear(self.elementsOnFrame)
end

---called in the "fly out" state
function Dictionary:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function Dictionary:checkPosition()
    return self.frame:checkPosition();
end

return Dictionary;
