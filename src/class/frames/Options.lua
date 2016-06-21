Class = require "lib.hump.class";
ImageButton = require "class.ImageButton";
Slider = require "class.Slider";

local Options = Class {
    init = function(self)
        self.imageButton = love.graphics.newImage("assets/gui/button.png");
        self.background = love.graphics.newImage("assets/gui/StandardBG.png");
        self.imageUnpressedSlider = love.graphics.newImage("assets/hamster.png");
        self.imagePressedSlider = love.graphics.newImage("assets/hamsterOpenMouth.png");
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.offset = 100;
        self.buttonDistance = 15;
        self.flagWidth = 120;
        self.name = "Options";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--- creates the options frame
function Options:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        slider_bgm = Slider(self.imageUnpressedSlider, self.imagePressedSlider, self.buttonXPosition, 140,
            _G._persTable.winDim[1] - 2* self.buttonXPosition);
        slider_music = Slider(self.imageUnpressedSlider, self.imagePressedSlider, self.buttonXPosition, 220,
            _G._persTable.winDim[1] - 2* self.buttonXPosition);
        button_reset = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - 2 * self.buttonHeight 
            - self.buttonDistance - 30, true);
        button_back = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - self.buttonHeight - 30, true);
    };

    --load values out of persTable into the chart
    self:loadValuesFromPersTable();

    --onclick events for all buttons
    self.elementsOnFrame.button_reset.gotClicked = function(_)
        _persistence:resetGame();
        self:loadValuesFromPersTable();
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end

    self.elementsOnFrame.button_back.gotClicked = function(_)
        self:loadValuesInPersTable();
        _gui:changeFrame(_gui:getLastState());
    end
end

--- changes the language of this frame
function Options:setLanguage(language)
    self.elementsOnFrame.button_back:setText(_G.data.languages[language].package.buttonBack);
    self.elementsOnFrame.button_reset:setText(_G.data.languages[language].package.buttonReset);

    self.text_bgm = (_G.data.languages[language].package.textMusic);
    self.text_music = (_G.data.languages[language].package.textBGM);
end

function Options:loadValuesInPersTable()
    _G._persTable.config.bgm = self.elementsOnFrame.slider_bgm:getValue();
    _G._persTable.config.music = self.elementsOnFrame.slider_music:getValue();
end


function Options:loadValuesFromPersTable()
    self.elementsOnFrame.slider_bgm:setValue(_G._persTable.config.bgm);
    self.elementsOnFrame.slider_music:setValue(_G._persTable.config.music);
end

function Options:update()
    self.elementsOnFrame.slider_bgm:update();
    self.elementsOnFrame.slider_music:update();
    if self.elementsOnFrame.slider_bgm:getMoveable() then
        _G._persTable.config.bgm = self.elementsOnFrame.slider_bgm:getValue();
    end
    
    if self.elementsOnFrame.slider_music:getMoveable() then
        _G._persTable.config.music = self.elementsOnFrame.slider_music:getValue();
    end
end

--- shows the frame on screen
function Options:draw()
    local _, y = self.elementsOnFrame.button_back:getOffset();
    local font = love.graphics.getFont();
    
    -- draw background
    love.graphics.draw(self.background, (_G._persTable.winDim[1] - self.background:getWidth())/2,
        (_G._persTable.winDim[2] - self.background:getHeight())/2 + y);
    
    -- draw line for slider
    love.graphics.setColor(0,0,0);
    love.graphics.rectangle("fill", self.buttonXPosition, 140 + y , 
        _G._persTable.winDim[1] - 2 * self.buttonXPosition, 10); 
    love.graphics.rectangle("fill", self.buttonXPosition, 220 + y , 
        _G._persTable.winDim[1] - 2 * self.buttonXPosition, 10);
    love.graphics.setColor(255,255,255);
    -- print the text
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 20));
    love.graphics.printf(self.text_bgm, (_G._persTable.winDim[1] - self.background:getWidth())/2 + 64,
        100 + y, _G._persTable.winDim[1], "left");    
    love.graphics.printf(self.text_music, (_G._persTable.winDim[1] - self.background:getWidth())/2 + 64,
        180 + y, _G._persTable.winDim[1], "left");
    love.graphics.setFont(font);
    
    -- draw the buttons
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
end

--- called to "delete" this frame
function Options:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Options:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function Options:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

--- return true if the frame is on position /fly in move is finished
function Options:checkPosition()
    return self.frame:checkPosition();
end

function Options:mousepressed(x, y)    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            v:gotClicked(x, y);
        end
    end
end

function Options:mousereleased(x, y)
    self.elementsOnFrame.slider_bgm:release();
    self.elementsOnFrame.slider_music:release();
end
return Options;
