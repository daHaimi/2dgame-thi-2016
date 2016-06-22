Class = require "lib.hump.class";
Frame = require "class.Frame";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement";
ImageButton = require "class.ImageButton";

local Achievements = Class {
    init = function(self)
        self.imageButton = love.graphics.newImage("assets/gui/button.png");
        self.background = love.graphics.newImage("assets/gui/StandardBG.png");
        self.backgroundPosition = {(_G._persTable.winDim[1] - self.background:getWidth()) / 2,
            (_G._persTable.winDim[2] - self.background:getHeight()) / 2};
        self.offset = (_G._persTable.winDim[2] - self.background:getHeight())/2 + 30;
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.directory = "assets/gui/icons/";
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.offset = (_G._persTable.winDim[2] - self.background:getHeight())/2 + 30;
        self.buttonDistance = 10;
        self.name = "Achievements";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
        self:create();
        
        self.xOffset = 0;
        self.yOffset = 0;
    end;
};

--- creates the achievement frame
function Achievements:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        chart = Chart();
        button_back = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - self.buttonHeight - 30, true);
    };

    --adjust all elements on this frame
    self:addAllAchievements();
    self:loadValuesFromPersTable();

    --onclick events for all buttons
    self.elementsOnFrame.button_back.gotClicked = function(_)
        _gui:changeFrame(_gui:getFrames().mainMenu);
        self.elementsOnFrame.chart:resetTopRow();
        self.elementsOnFrame.chart:resetMarkedFrame();
    end
    self.elementsOnFrame.chart.gotClicked = function(x, y)
        self.elementsOnFrame.chart:mousepressed(x,y)
    end
end

--- changes the language of this frame
function Achievements:setLanguage(language)
    self.elementsOnFrame.button_back:setText(_G.data.languages[language].package.buttonBack);
end

--add all achievements written in the data.lua into the chart and adds an OnClick event
function Achievements:addAllAchievements()
    for _, v in pairs(_G.data.achievements) do
        if v.sortNumber ~= nil then
            local imageDirectory = self.directory .. v.image_lock;
            local newKlickableElement = KlickableElement(v.name, imageDirectory, self.directory .. v.image_unlock,
                v.description, nil, v.nameOnPersTable, v.sortNumber);
            
            self.elementsOnFrame.chart:addKlickableElement(newKlickableElement);
        end
    end
end

function Achievements:loadValuesFromPersTable()
    for _, v in pairs(self.elementsOnFrame.chart:getAllElements()) do
        local elementName = v.nameOnPersTable;
        if _G._persTable.achievements[elementName] then
            if _G._persTable.achievements[elementName] == true then
                v:disable();
            end
        end
    end
end

function Achievements:mousepressed(x, y)    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            v.gotClicked(x, y);
        end
    end
end

--- shows the frame on screen
function Achievements:draw()
    local _, y = self.elementsOnFrame.button_back:getOffset();
    love.graphics.draw(self.background, self.backgroundPosition[1], self.backgroundPosition[2] + y);
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
    self:loadValuesFromPersTable();
end

--- called to "delete" this frame
function Achievements:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Achievements:appear()
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

--- sets the offset of the frame
--@param x x offset of the frame
--@parma y y offset of the frame
function Achievements:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end

return Achievements;
