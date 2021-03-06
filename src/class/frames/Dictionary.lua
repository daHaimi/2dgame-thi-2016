Class = require "lib.hump.class";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement";

local Dictionary = Class {
    init = function(self)
        self.imageButton = love.graphics.newImage("assets/gui/Button.png");
        self.background = love.graphics.newImage("assets/gui/StandardBG.png");
        self.backgroundPosition = {(_G._persTable.winDim[1] - self.background:getWidth()) / 2,
            (_G._persTable.winDim[2] - self.background:getHeight()) / 2};
        self.offset = (_G._persTable.winDim[2] - self.background:getHeight())/2 + 30;
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.directory = "assets/gui/icons/dic_";
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.offset = (_G._persTable.winDim[2] - self.background:getHeight())/2 + 30;
        self.buttonDistance = 10;
        self.name = "Dictionary";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
        self:create();
        
        self.xOffset = 0;
        self.yOffset = 0;
    end;
};

--- creates the dictionary frame
function Dictionary:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        chart = Chart();
        button_back = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - self.buttonHeight - 30, true);
    };

    self:addAllObjects();

    --onclick events for all buttons
    self.elementsOnFrame.button_back.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().mainMenu);
        self.elementsOnFrame.chart:resetTopRow();
        self.elementsOnFrame.chart:resetMarkedFrame();
    end
    self.elementsOnFrame.chart.gotClicked = function(x, y)
        self.elementsOnFrame.chart:mousepressed(x,y)
    end
end

--- checks if image exists
--@param name path to the file
function Dictionary:imageExists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

--add all object written in the data.lua into the chart and adds an OnClick event
function Dictionary:addAllObjects()
    for _, v in pairs(_G.data.fishableObjects) do
        if v.sortNumber ~= nil then
        local image = love.graphics.newImage(self.directory ..  v.image);
        local image_unlock = love.graphics.newImage(self.directory ..  v.image);
            local newKlickableElement = KlickableElement(v.name, image, image_unlock, v.description, v.value, 
                v.nameOnPersTable, v.sortNumber);
            
            self.elementsOnFrame.chart:addKlickableElement(newKlickableElement);
        end
    end
end

--- changes the language of this frame
function Dictionary:setLanguage(language)
    self.elementsOnFrame.button_back:setText(_G.data.languages[language].package.buttonBack);
end

--- shows the frame on screen
function Dictionary:draw()
    local _, y = self.elementsOnFrame.button_back:getOffset();
    love.graphics.draw(self.background, self.backgroundPosition[1], self.backgroundPosition[2] + y);
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
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

--- sets the offset of the frame
--@param x x offset of the frame
--@parma y y offset of the frame
function Dictionary:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end
--- is called when the mouse is pressed
--@param x x coordinate of the mouse 
--@param y y coordinate of the mouse
function Dictionary:mousepressed(x, y)    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            v.gotClicked(x, y);
        end
    end
end

return Dictionary;
