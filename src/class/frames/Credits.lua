Class = require "lib.hump.class";

local Credits = Class {
    init = function(self)
        self.name = "Credits";
        self.frame = Frame(100, 100, "down", "down", 50, 0, -1500);
        self:create();
        
        
    end;
    
    p_staffString = "";
    p_staff = {"Marco Egner",
        "Samson Groß",
        "Mathias Haimerl",
        "Anna Käfferlein",
        "Baris Kutlu",
        "Burak Kutlu",
        "Martin Lechner",
        "Daniel Plank",
        "Daniel Zistl"
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
            x = 10;
            y = 10;
        };
        text_credits = {
            object = Loveframes.Create("text");
            x = 15;
            y = 70;
        }
    };
    
    for i=1, #self.p_staff, 1
    do
        self.p_staffString = self.p_staffString .. self.p_staff[i] .. "\n";
    end
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_back.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_back.object:SizeToImage()
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    print(self.p_staffString);
    self.elementsOnFrame.text_credits.object:SetText(self.p_staffString);
    self.elementsOnFrame.text_credits.object:SetLinksEnabled(true);
    self.elementsOnFrame.text_credits.object:SetDetectLinks(true);
    self.elementsOnFrame.text_credits.object:SetShadowColor(150, 210, 255)

    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui:getFrames().mainMenu);
    end
    
    
end

---shows the frame on screen
function Credits:draw()
    self.frame:draw(self.elementsOnFrame);
end

---called to "delete" this frame
function Credits:clear()
    self.frame:clear(self.elementsOnFrame)
end

---called in the "fly in" state 
function Credits:appear()
    self.frame:appear(self.elementsOnFrame)
end

---called in the "fly out" state
function Credits:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function Credits:checkPosition()
    return self.frame:checkPosition();
end

return Credits;
