Class = require "lib.hump.class";
Frame = require "class.Frame";

local MainMenu = Class {
    init = function(self)
        self.name = "Main Menu";
        self.frame = Frame(100, 100, "down", "down", 50, 0, -1500);
        self:create();
    end;
};

--creates the achievement frame
function MainMenu:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
            x = 0;
            y = 0;
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 100;
            y = 10;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_back.object:SetImage("assets/gui/gui_Test_Button.png");
    self.elementsOnFrame.button_back.object:SizeToImage();
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    
    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame(_gui.myFrames.achievements);
    end
end


--[[



--- Call to set all Elements invisible and reset the x/y
function MainMenu:clear()
    for k, v in pairs(self.elementsOnFrame) do
        v.object:SetVisible(false);
    end
    --self.xOffset = self.xStartOffset;
    --self.yOffset = self.yStartOffset;
end

--- Call to set all Elements visible/ set all elements on position
function MainMenu:draw()
    for k, v in pairs(self.elementsOnFrame) do
        v.object:SetVisible(true);
        v.object:SetPos(v.x + self.xPos + self.xOffset, v.y + self.yPos + self.yOffset);
    end
end

--called in the "fly in" state 
function MainMenu:appear()
    self.yOffset = self.yOffset - self.moveSpeed;
    for k, v in pairs(self.elementsOnFrame) do
        v.object:SetPos(v.x + self.xPos + self.xOffset, v.y + self.yPos + self.yOffset);
    end
end

--called in the "fly out" state
function MainMenu:disappear()
    self.yOffset = self.yOffset + self.moveSpeed;
    for k, v in pairs(self.elementsOnFrame) do
        v.object:SetPos(self.xPos + v.object.x + self.xOffset, self.yPos + v.object.y + self.yOffset);
    end
end


---return true if the frame is on position /fly in move is finished
function MainMenu:checkPosition()
    if (self.xOffset == 0 and self.yOffset == 0) then
        return true;
    else
        return false;
    end
end


]]--














function MainMenu:draw()
    self.frame:draw(self.elementsOnFrame);
end

--called to "delete" this frame
function MainMenu:clear()
    self.frame:clear(self.elementsOnFrame)
end

--called in the "fly in" state 
function MainMenu:appear()
    self.frame:appear(self.elementsOnFrame)
end

--called in the "fly out" state
function MainMenu:disappear()
    self.frame:disappear(self.elementsOnFrame)
end

---return true if the frame is on position /fly in move is finished
function MainMenu:checkPosition()
    return self.frame:checkPosition();
end





return MainMenu;
