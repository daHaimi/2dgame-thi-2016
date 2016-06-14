Class = require "lib.hump.class";

local Credits = Class {
    init = function(self)
        self.startTime = 0;
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
        self.name = "Credits";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2,
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed, "down", "down", self.speed, 0, -1500);
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
        "Daniel Plank",
        "Daniel Zistl",
    };
    p_transTable = {
        "Michelle Guttenberger",
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
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 0.16 * self.width;
            y = self.height - self.buttonHeight;
        };
        text_credits = {
            object = Loveframes.Create("text");
            x = 15;
            y = 10;
        }
    };

    --build the credits
    local creditsToPrint = self:buildCreditsString();

    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .. "StandardBG.png");

    self.elementsOnFrame.button_back.object:SetImage(self.directory .. "Button.png")
    self.elementsOnFrame.button_back.object:SizeToImage()

    self.elementsOnFrame.text_credits.object:SetText(creditsToPrint);
    self.elementsOnFrame.text_credits.object:SetLinksEnabled(true);
    self.elementsOnFrame.text_credits.object:SetDetectLinks(true);
    self.elementsOnFrame.text_credits.object:SetShadowColor(150, 210, 255)

    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(_)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

--- changes the language of this frame
function Credits:setLanguage(language)
    self.elementsOnFrame.button_back.object:SetText(_G.data.languages[language].package.buttonBack);
end

function Credits:buildCreditsString()
    local creditsString = "";
    print(_G.data.languages[_G._persTable.config.language].package.credits.staff);
    print(_G.data.languages[_G._persTable.config.language].package.credits.trans)
    print(_G.data.languages[_G._persTable.config.language].package.credits.libs)
    print(_G.data.languages[_G._persTable.config.language].package.credits.noHWH)

    --staff
    creditsString = _G.data.languages[_G._persTable.config.language].package.credits.staff .. "\n";
    
    for i = 1, #self.p_staff, 1
    do
        creditsString = creditsString .. self.p_staff[i] .. "\n";
    end
    
    creditsString = creditsString .. "\n";
    
    --translation
    creditsString = creditsString .. _G.data.languages[_G._persTable.config.language].package.credits.trans .. "\n";
    for i = 1, #self.p_transTable, 1
    do
        creditsString = creditsString .. self.p_transTable[i] .. "\n";
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
    self.frame:draw(self.elementsOnFrame);
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
    if self:calcTimeSpent() >= 10 then
        if not _G._persTable.achievements.creditsRed then
            table.insert(_G._unlockedAchievements, _G.data.achievements.creditsRed);
            _gui:newNotification("assets/gui/480px/" .. _G.data.achievements.creditsRed.image_unlock,
                "creditsRed");
            _G._persTable.achievements.creditsRed = true;
        end
    end
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
