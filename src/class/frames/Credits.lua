Class = require "lib.hump.class";

local Credits = Class {
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
        self.name = "Credits";
        self.frame = Frame((_G._persTable.scaledDeviceDim[1] - self.width) / 2, 
            (_G._persTable.scaledDeviceDim[2] - self.height) / 2 - self.speed, "down", "down", self.speed, 0, -1500);
        self:create();
        
        
    end;
    
    p_staffString = "";
    p_staff = {"Staff:",
        "Marco Egner",
        "Samson Groß",
        "Mathias Haimerl",
        "Anna Käfferlein",
        "Baris Kutlu",
        "Burak Kutlu",
        "Martin Lechner",
        "Daniel Plank",
        "Daniel Zistl",
        " ",
        "Libs:",
        "hump, Matthias Richter",
        "light, Marcus Ihde",
        "LoveFrames, Kenny Shields",
        "table_serializer, Mathias Haimerl",
        "TEsound, Ensayia and Taehl",
        " ",
        "No hamsters were harmed!",
    };
};

---creates the credits frame
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
            y = 30;
        }
    };
    
    for i=1, #self.p_staff, 1
    do
        self.p_staffString = self.p_staffString .. self.p_staff[i] .. "\n";
    end
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage(self.directory .."StandardBG.png");
    
    self.elementsOnFrame.button_back.object:SetImage(self.directory .. "Button.png")
    self.elementsOnFrame.button_back.object:SizeToImage()
    
    self.elementsOnFrame.text_credits.object:SetText(self.p_staffString);
    self.elementsOnFrame.text_credits.object:SetLinksEnabled(true);
    self.elementsOnFrame.text_credits.object:SetDetectLinks(true);
    self.elementsOnFrame.text_credits.object:SetShadowColor(150, 210, 255)

    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
end

---changes the language of this frame
function Credits:setLanguage(language)
    self.elementsOnFrame.button_back.object:SetText(_G.data.languages[language].package.buttonBack);
end

---shows the frame on screen
function Credits:draw()
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function Credits:clear()
    self.frame:clear(self.elementsOnFrame);
end

---called in the "fly in" state 
function Credits:appear()
    love.mouse.setVisible(true);
    self.frame:appear(self.elementsOnFrame);
end

---called in the "fly out" state
function Credits:disappear()
    self.frame:disappear(self.elementsOnFrame);
end

---return true if the frame is on position /fly in move is finished
function Credits:checkPosition()
    return self.frame:checkPosition();
end

return Credits;
