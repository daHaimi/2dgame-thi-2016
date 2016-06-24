Class = require "lib.hump.class";
ImageButton = require "class.ImageButton";

local Credits = Class {
    init = function(self)
        self.imageButton = love.graphics.newImage("assets/gui/Button.png");
        self.background = love.graphics.newImage("assets/gui/StandardBG.png");
        self.buttonHeight = self.imageButton:getHeight();
        self.buttonWidth = self.imageButton:getWidth();
        self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
        self.offset = 30;
        self.buttonDistance = 15;
        self.blinkTimer = 0;
        self.name = "Credits";
        self.frame = Frame(0, 0, "down", "down", 50, 0, -1500);
        self:create();
    end;

    p_staff = {
        staff = "",
        "Marco Egner",
        "Samson Groß",
        "Mathias Haimerl",
        "Anna Käfferlein",
        "Baris Kutlu",
        "Burak Kutlu",
        "Martin Lechner",
        "Manfred Möderl",
        "Daniel Plank",
        "Daniel Zistl",
    };
    
    p_libsTable = {
        "hump, Matthias Richter",
        "light, Marcus Ihde",
        "LÖVE 2D",
        "table_serializer, Mathias Haimerl",
        "TEsound, Ensayia and Taehl",
    };
};

--- just called frequenzly in the credits state
function Credits:update()
    self.blinkTimer = self.blinkTimer - 1;
    if self.blinkTimer <= 0 then
        self.blinkTimer = 25;
        if self.colorRed then
            self.colorRed = false;
        else
            self.colorRed = true;
        end
    end
end

--- creates the credits frame
function Credits:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        button_back = ImageButton(self.imageButton, self.buttonXPosition , 
            (_G._persTable.winDim[2] + self.background:getHeight())/2 - self.buttonHeight - self.offset, true);
    };

    --onclick events for all buttons
    self.elementsOnFrame.button_back.gotClicked = function(_)
        TEsound.play({ "assets/sound/buttonPressed.wav" }, 'bgm');
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

--- changes the language of this frame
function Credits:setLanguage(language)
    self.elementsOnFrame.button_back:setText(_G.data.languages[language].package.buttonBack);
end

function Credits:mousepressed(x, y)
    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if x > xPosition and x < xPosition + width and
        y > yPosition and y < yPosition + height then
            v.gotClicked();
        end
    end
end

--- Bild the credits string.
-- @return Returns the formatted credits string.
function Credits:buildCreditsString()
    local creditsStrings = {"","",""};
    
    for i = 1, #self.p_staff, 1
    do
        creditsStrings[1] = creditsStrings[1] .. self.p_staff[i] .. "\n";
    end
    
    --libs
    for i = 1, #self.p_libsTable, 1
    do
        creditsStrings[2] = creditsStrings[2] .. self.p_libsTable[i] .. "\n";
    end
    
    --no hamsters were harmed
    creditsStrings[3] = _G.data.languages[_G._persTable.config.language].package.credits.noHWH;
    
    return creditsStrings;
end

--- shows the frame on screen
function Credits:draw() 
    local _, y = self.elementsOnFrame.button_back:getOffset();
    -- draw background
    love.graphics.draw(self.background, (_G._persTable.winDim[1] - self.background:getWidth())/2,
        (_G._persTable.winDim[2] - self.background:getHeight())/2 + y);
        -- draw the buttons
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
    
    local strings = self:buildCreditsString();
    
    -- print the text
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Regular.ttf", 16));
    love.graphics.printf(strings[1],(_G._persTable.winDim[1] - self.background:getWidth())/2 + 30,
        (_G._persTable.winDim[2] - self.background:getHeight())/2  + 40 + y, self.background:getWidth() - 60, "left");
    love.graphics.printf(strings[2],(_G._persTable.winDim[1] - self.background:getWidth())/2 + 30,
        (_G._persTable.winDim[2] - self.background:getHeight())/2  + 310 + y, self.background:getWidth() - 60, "left");
    
    -- print titles
    love.graphics.setColor(0, 0, 0);
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 20));
    love.graphics.printf(_G.data.languages[_G._persTable.config.language].package.credits.staff, 
        (_G._persTable.winDim[1] - self.background:getWidth())/2 + 30,
        (_G._persTable.winDim[2] - self.background:getHeight())/2  + 10 + y, self.background:getWidth() - 60, "left");
    love.graphics.printf(_G.data.languages[_G._persTable.config.language].package.credits.libs, 
        (_G._persTable.winDim[1] - self.background:getWidth())/2 + 30,
        (_G._persTable.winDim[2] - self.background:getHeight())/2  + 280 + y, self.background:getWidth() - 60, "left");
    
    -- print no hamster were harmed
    if self.colorRed then
        love.graphics.setColor(255, 0, 0);
    end
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 22));
    love.graphics.printf(strings[3], (_G._persTable.winDim[1] - self.background:getWidth())/2,
        (_G._persTable.winDim[2] - self.background:getHeight())/2  + 480 + y, self.background:getWidth(), "center");
    
    love.graphics.setColor(255, 255, 255);
end

--- called to "delete" this frame
function Credits:clear()
    self.frame:clear(self.elementsOnFrame);
end

--- called in the "fly in" state
function Credits:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
    self:createStartTime();
end

--- called in the "fly out" state
function Credits:disappear()
    self.frame:disappear(self.elementsOnFrame);
    _gui:getLevelManager():getAchievmentManager():checkCreditsRed(self:calcTimeSpent());
    _gui:getLevelManager():getAchievmentManager():achBitch(); -- must be the last ach checkup!
end

--- return true if the frame is on position /fly in move is finished
function Credits:checkPosition()
    return self.frame:checkPosition();
end

--- start tracking time
function Credits:createStartTime()
    self.startTime = os.clock();
end

--- calculate spent time
function Credits:calcTimeSpent()
    local now = os.clock();
    return now - self.startTime;
end

return Credits;
