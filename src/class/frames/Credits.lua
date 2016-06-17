Class = require "lib.hump.class";

local Credits = Class {
        init = function(self)
            self.imageButton = love.graphics.newImage("assets/gui/button.png");
            self.buttonHeight = self.imageButton:getHeight();
            self.buttonWidth = self.imageButton:getWidth();
            self.buttonXPosition = (_G._persTable.winDim[1] - self.buttonWidth) / 2;
            self.background = love.graphics.newImage("assets/gui/StandardBG.png");
            self.offset = 100;
            self.buttonDistance = 15;
            self.flagWidth = 120;
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
        "LoveFrames, Kenny Shields",
        "LÖVE 2D",
        "table_serializer, Mathias Haimerl",
        "TEsound, Ensayia and Taehl",
    };
};

--- creates the credits frame
function Credits:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        button_back = ImageButton(self.imageButton, self.buttonXPosition , 
            _G._persTable.winDim[2] - self.offset - self.buttonHeight, true);
    };

    --build the credits
    local creditsToPrint = self:buildCreditsString();

    --onclick events for all buttons
    self.elementsOnFrame.button_back.gotClicked = function(_)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

--- changes the language of this frame
function Credits:setLanguage(language)
    self.elementsOnFrame.button_back:setText(_G.data.languages[language].package.buttonBack);
end

function Credits:mousepressed(x, y)
    local xClick = x * _G._persTable.scaleFactor;
    local yClick = y * _G._persTable.scaleFactor;
    
    for _, v in pairs (self.elementsOnFrame) do
        local xPosition, yPosition = v:getPosition();
        local width, height = v:getSize();
        
        if xClick > xPosition and xClick < xPosition + width and
        yClick > yPosition and yClick < yPosition + height then
            v.gotClicked();
        end
    end
end

--- Bild the credits string.
-- @return Returns the formatted credits string.
function Credits:buildCreditsString()
    local creditsString = "";
    
    --staff
    creditsString = _G.data.languages[_G._persTable.config.language].package.credits.staff .. "\n";
    
    for i = 1, #self.p_staff, 1
    do
        creditsString = creditsString .. self.p_staff[i] .. "\n";
    end
    creditsString = creditsString .. "\n";
    
    --libs
    creditsString = creditsString .. _G.data.languages[_G._persTable.config.language].package.credits.libs .. "\n";
    for i = 1, #self.p_libsTable, 1
    do
        creditsString = creditsString .. self.p_libsTable[i] .. "\n";
    end
    creditsString = creditsString .. "\n";
    
    --no hamsters were harmed
    creditsString = creditsString .. _G.data.languages[_G._persTable.config.language].package.credits.noHWH;
    
    return creditsString;
end

--- shows the frame on screen
function Credits:draw()
    local _, y = self.elementsOnFrame.button_back:getOffset();
    local font = love.graphics.getFont();
    love.graphics.draw(self.background, (_G._persTable.winDim[1] - self.background:getWidth())/2,
        (_G._persTable.winDim[2] - self.background:getHeight())/2 + y);
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 16));
    love.graphics.printf(self:buildCreditsString(),_G._persTable.winDim[1]*0.25,
        100 + y, _G._persTable.winDim[1], "left");
    love.graphics.setFont(font);
    for _, v in pairs (self.elementsOnFrame) do
        v:draw();
    end
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

function Credits:createStartTime()
    self.startTime = os.clock();
end

function Credits:calcTimeSpent()
    local now = os.clock();
    return now - self.startTime;
end

return Credits;
