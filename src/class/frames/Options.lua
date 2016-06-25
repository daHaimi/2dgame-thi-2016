Class = require "lib.hump.class";
ImageButton = require "class.ImageButton";
Slider = require "class.Slider";

local Options = Class {
    init = function(self)
        self.imageButton = love.graphics.newImage("assets/gui/Button.png");
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
        self.vibrateDefaultFunction = nil;
        self:create();
    end;
};

--- creates the options frame
function Options:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        slider_bgm = Slider(self.imageUnpressedSlider, self.imagePressedSlider, self.buttonXPosition, 220,
            _G._persTable.winDim[1] - 2* self.buttonXPosition);
        slider_music = Slider(self.imageUnpressedSlider, self.imagePressedSlider, self.buttonXPosition, 140,
            _G._persTable.winDim[1] - 2* self.buttonXPosition);
        button_vibration = ImageButton(self.imageButton, self.buttonXPosition , 300, true);
        button_reset = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - 2 * self.buttonHeight 
            - self.buttonDistance - 30, true);
        button_back = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - self.buttonHeight - 30, true);
    };
    
    self.vibrateDefaultFunction = love.system.vibrate;
    
    --load values out of persTable into the chart
    self:loadValuesFromPersTable();

    --onclick events for all buttons
    self.elementsOnFrame.button_reset.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _persistence:resetGame();
        self:loadValuesFromPersTable();
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
    
    self.elementsOnFrame.button_vibration.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        if _G._persTable.config.vibration then
            self:setVibration(false);
        else
            self:setVibration(true);
        end
    end
    
    self.elementsOnFrame.button_back.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        self:loadValuesInPersTable();
        _gui:changeFrame(_gui:getLastState());
        _G._persistence:updateSaveFile();
    end
end

function Options:setVibration(vibration)    
    if vibration then
        love.system.vibrate = self.vibrateDefaultFunction
        _G._persTable.config.vibration = true;
        self.elementsOnFrame.button_vibration:setText("Vibration: " .. _G.data.languages[_G._persTable.config.language].package.textOn);
    else
        love.system.vibrate = function(...) end;
        _G._persTable.config.vibration = false;
        self.elementsOnFrame.button_vibration:setText("Vibration: " .. _G.data.languages[_G._persTable.config.language].package.textOff);
    end
    _G._persistence:updateSaveFile();
end


--- changes the language of this frame
--@param language language of the buttons and texts
function Options:setLanguage(language)
    self.elementsOnFrame.button_back:setText(_G.data.languages[language].package.buttonBack);
    self.elementsOnFrame.button_reset:setText(_G.data.languages[language].package.buttonReset);
    self.text_bgm = (_G.data.languages[language].package.textMusic);
    self.text_music = (_G.data.languages[language].package.textBGM);
    if _G._persTable.config.vibration then
        self.elementsOnFrame.button_vibration:setText("Vibration: " .. _G.data.languages[_G._persTable.config.language].package.textOn);
    else
        self.elementsOnFrame.button_vibration:setText("Vibration: " .. _G.data.languages[_G._persTable.config.language].package.textOff);
    end
end

--- loads the value of the sliders from the persTable
function Options:loadValuesInPersTable()
    _G._persTable.config.bgm = self.elementsOnFrame.slider_bgm:getValue();
    _G._persTable.config.music = self.elementsOnFrame.slider_music:getValue();
end

--- loads the value of the sliders in the persTable
function Options:loadValuesFromPersTable()
    self.elementsOnFrame.slider_bgm:setValue(_G._persTable.config.bgm);
    self.elementsOnFrame.slider_music:setValue(_G._persTable.config.music);
    self:setVibration(_G._persTable.config.vibration);
end

--- is called once every frame options is active
function Options:update()
    self.elementsOnFrame.slider_bgm:update();
    self.elementsOnFrame.slider_music:update();
    if self.elementsOnFrame.slider_bgm:getMoveable() then
        _G._persTable.config.bgm = self.elementsOnFrame.slider_bgm:getValue();
        TEsound.volume('bgm', _G._persTable.config.bgm / 100);
    end
    
    if self.elementsOnFrame.slider_music:getMoveable() then
        _G._persTable.config.music = self.elementsOnFrame.slider_music:getValue();
        TEsound.volume('music', _G._persTable.config.music / 100);
    end
    
end

--- shows the frame on screen
function Options:draw()
    local _, y = self.elementsOnFrame.button_back:getOffset();
    
    -- draw background
    love.graphics.draw(self.background, (_G._persTable.winDim[1] - self.background:getWidth())/2,
        (_G._persTable.winDim[2] - self.background:getHeight())/2 + y);
    
        -- draw the buttons
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
    
    -- print the text
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 20));
    love.graphics.printf(self.text_bgm, (_G._persTable.winDim[1] - self.background:getWidth())/2 + 64,
        100 + y, _G._persTable.winDim[1], "left");    
    love.graphics.printf(self.text_music, (_G._persTable.winDim[1] - self.background:getWidth())/2 + 64,
        180 + y, _G._persTable.winDim[1], "left");
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
--- is called when the mouse is pressed
--@param x x coordinate of the mouse 
--@param y y coordinate of the mouse
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
--- is called when the mouse is pressed
--@param x x coordinate of the mouse 
--@param y y coordinate of the mouse
function Options:mousereleased(x, y)
    self.elementsOnFrame.slider_bgm:release();
    self.elementsOnFrame.slider_music:release();
end
return Options;
