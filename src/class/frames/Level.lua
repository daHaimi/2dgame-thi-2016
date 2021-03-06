Class = require "lib.hump.class";
ImageButton = require "class.ImageButton";

local Level = Class {
    init = function(self)
        self.background = love.graphics.newImage("assets/gui/LevelBG.png");
        self.backgroundPosition = {(_G._persTable.winDim[1] - self.background:getWidth()) / 2,
            (_G._persTable.winDim[2] - self.background:getHeight()) / 2};
        self.imageButton = love.graphics.newImage("assets/gui/Button.png");
        self.imageHouse = love.graphics.newImage("assets/gui/HouseButton.png");
        self.imageCanyonUnlocked = love.graphics.newImage("assets/gui/CanyonButton.png");
        self.imageCanyonLocked = love.graphics.newImage("assets/gui/CanyonButton_locked.png");
        self.imageSquirrel = love.graphics.newImage("assets/squirrel.png");
        self.imageCrocodile = love.graphics.newImage("assets/crocodile.png");
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.offset = 30;
        self.buttonDistance = 10;
        self.name = "Level";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--creates the level frame
function Level:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        buttonHouse = ImageButton(self.imageHouse, self.backgroundPosition[1] + 50,
            self.backgroundPosition[2] + self.offset, true);
        buttonCanyon = ImageButton(self.imageCanyon, self.backgroundPosition[1] + 70,
            self.backgroundPosition[2] + 425, true);
        button_back = ImageButton(self.imageButton, self.backgroundPosition[1] + 100,
            self.backgroundPosition[2] + 590, true);
        buttonSquirrel = ImageButton(self.imageSquirrel, self.backgroundPosition[1] + 180,
            self.backgroundPosition[2] + 200, true);
        buttonCrocodile = ImageButton(self.imageCrocodile, self.backgroundPosition[1] + 230,
            self.backgroundPosition[2] + 370, true);
    };

    --adjust all elements on this frame
    self.elementsOnFrame.buttonHouse:setText("");
    self.elementsOnFrame.buttonCanyon:setText("");
    self.elementsOnFrame.buttonSquirrel:setText("");
    self.elementsOnFrame.buttonCrocodile:setText("");

    if _G._persTable.unlockedLevel == 1 then
        self.elementsOnFrame.buttonCanyon:setImage(self.imageCanyonLocked);
    else
        self.elementsOnFrame.buttonCanyon:setImage(self.imageCanyonUnlocked);
    end
    
    --onclick events for all buttons
    self.elementsOnFrame.buttonHouse.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("sewers"), _G.data);
        _gui:changeFrame(_gui:getFrames().inGame);
    end

   
    self.elementsOnFrame.buttonCanyon.gotClicked = function(_)
         if _G._persTable.unlockedLevel == 1 then
            local canyonUnlockMess = "";
            if(_G._persTable.config.language == "english") then
                canyonUnlockMess = "Not unlocked yet!";
            elseif (_G._persTable.config.language == "german") then
                canyonUnlockMess = "Nicht entdeckt!";
            end
            _gui:newTextNotification("assets/gui/icons/" .. "ach_nothingCaught.png", canyonUnlockMess);
        else
            _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("canyon"), _G.data);
            _gui:changeFrame(_gui:getFrames().inGame);
        end
    end

    self.elementsOnFrame.button_back.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
    
    self.elementsOnFrame.buttonSquirrel.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("crazySquirrels"), _G.data);
        _gui:changeFrame(_gui:getFrames().inGame);
    end
    
    self.elementsOnFrame.buttonCrocodile.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:getLevelManager():newLevel(_gui:getLevelManager():getLevelPropMapByName("sleepingCrocos"), _G.data);
        _gui:changeFrame(_gui:getFrames().inGame);
    end
end

--- changes the language of this frame
--@param language language of the buttons
function Level:setLanguage(language)
    self.elementsOnFrame.button_back:setText(_G.data.languages[language].package.buttonBack);
end

--- call to unlock the second level
function Level:unlockCanyon()
    _G._persTable.unlockedLevel = 2;
    self.elementsOnFrame.buttonCanyon:setImage(self.imageCanyonUnlocked);
end

--- shows the frame on screen
function Level:draw()
    local _, y = self.elementsOnFrame.button_back:getOffset();
    love.graphics.draw(self.background, self.backgroundPosition[1], self.backgroundPosition[2] + y);
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
end

--- called to "delete" this frame
function Level:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Level:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

--- called in the "fly out" state
function Level:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

--- return true if the frame is on position /fly in move is finished
function Level:checkPosition()
    return self.frame:checkPosition();
end
--- is called when the mouse is pressed
--@param x x coordinate of the mouse 
--@param y y coordinate of the mouse
function Level:mousepressed(x, y)    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            v.gotClicked();
        end
    end
end

return Level;
