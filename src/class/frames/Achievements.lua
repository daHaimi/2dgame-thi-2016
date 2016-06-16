Class = require "lib.hump.class";
Frame = require "class.Frame";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement";

local Achievements = Class {
    init = function(self)
        self.directory = "assets/gui/480px/";
        self.widthPx = 480;
        self.width = 384;
        self.height = 666;
        self.buttonHeight = 75;
        self.buttonOffset = 15;
        self.speed = 50;

        self.name = "Achievements";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2,
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed, "down", "down", self.speed, 0, -1500);
        self:create();
    end;
};

--- creates the achievement frame
function Achievements:create()
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

    self.elementsOnFrame.button_back.object:SetImage(self.directory .. "Button.png")
    self.elementsOnFrame.button_back.object:SizeToImage()
    self.elementsOnFrame.button_back.object:SetText("Back");

    self:addAllAchievements();
    self:loadValuesFromPersTable();

    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

--add all achievements written in the data.lua into the chart and adds an OnClick event
function Achievements:addAllAchievements()
    for _, v in pairs(_G.data.achievements) do
        if v.sortNumber ~= nil then
            local imageDirectory = self.directory .. v.image_lock;
            local newKlickableElement = KlickableElement(v.name, imageDirectory, self.directory .. v.image_unlock,
                v.description, nil, v.nameOnPersTable, v.sortNumber);
            newKlickableElement.object.OnClick = function(_)
                self.elementsOnFrame.chart.object:markElement(newKlickableElement);
            end
            self.elementsOnFrame.chart.object:addKlickableElement(newKlickableElement);
        end
    end
end

function Achievements:loadValuesFromPersTable()
    for _, v in pairs(self.elementsOnFrame.chart.object:getAllElements()) do
        local elementName = v.nameOnPersTable;
        if _G._persTable.achievements[elementName] then
            if _G._persTable.achievements[elementName] == true then
                v:disable();
            end
        end
    end
end

--- shows the frame on screen
function Achievements:draw()
    self.frame:draw(self.elementsOnFrame);
    self:loadValuesFromPersTable();
end

--- called to "delete" this frame
function Achievements:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Achievements:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function Achievements:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

--- return true if the frame is on position /fly in move is finished
function Achievements:checkPosition()
    return self.frame:checkPosition();
end

return Achievements;
