Class = require "lib.hump.class";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement";

local Dictionary = Class {
    init = function(self)
        if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.widthPx = 480;
            self.width = 384;
            self.height = 666;
            self.buttonHeight = 75;
            self.buttonOffset = 15;
            self.speed = 50;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.widthPx = 640;
            self.directory = "assets/gui/640px/";
            self.width = 512;
            self.height = 888;
            self.buttonOffset = 20;
            self.buttonHeight = 96;
            self.speed = 60;
        else
            self.widthPx = 720;
            self.directory = "assets/gui/720px/";
            self.width = 576;
            self.height = 1024;
            self.buttonOffset = 30;
            self.buttonHeight = 106;
            self.speed = 75;
        end
        self.name = "Dictionary";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2,
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed, "down", "down", self.speed, 0, -1500);
        self:create();
    end;
};

--- creates the dictionary frame
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
            x = 0.125 * self.width;
            y = self.buttonOffset;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.height - self.buttonHeight;
        };
    };

    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "StandardBG.png");

    self.elementsOnFrame.button_back.object:SetImage(self.directory .. "Button.png");
    self.elementsOnFrame.button_back.object:SizeToImage();

    self:addAllObjects();

    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().mainMenu);
        self.elementsOnFrame.chart.object:resetTopRow();
    end
end

function Dictionary:imageExists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

--add all object written in the data.lua into the chart and adds an OnClick event
function Dictionary:addAllObjects()
    for _, v in pairs(_G.data.fishableObjects) do
        if v.sortNumber ~= nil then
            local path = "";
            if self:imageExists(self.directory .. "dic_" .. v.image) then
                path = self.directory .. "dic_" .. v.image;
            else
                path = "assets/" .. v.image;
            end
            local newKlickableElement = KlickableElement(v.name, path, path, v.description, v.value, nil, v.sortNumber);
            newKlickableElement.object.OnClick = function(_)
                self.elementsOnFrame.chart.object:markElement(newKlickableElement);
            end
            self.elementsOnFrame.chart.object:addKlickableElement(newKlickableElement);
        end
    end
end

--- changes the language of this frame
function Dictionary:setLanguage(language)
    self.elementsOnFrame.button_back.object:SetText(_G.data.languages[language].package.buttonBack);
end

--- shows the frame on screen
function Dictionary:draw()
    self.frame:draw(self.elementsOnFrame);
end

--- called to "delete" this frame
function Dictionary:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Dictionary:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function Dictionary:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

--- return true if the frame is on position /fly in move is finished
function Dictionary:checkPosition()
    return self.frame:checkPosition();
end

return Dictionary;
