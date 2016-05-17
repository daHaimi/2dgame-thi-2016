
Class = require "lib.hump.class";

local Pause = Class {
    init = function(self)
        self.name = "Achievements";
        self.xPos = 50;
        self.yPos = 50;
        self.xDefaultOffset = 0; 
        self.yDefaultOffset = -1500;
        self.xOffset = self.xDefaultOffset;
        self.yOffset = self.yDefaultOffset;
        self.moveSpeed = 50;
        self:create();
    end;
};

--creates the achievement frame
function Pause:create()
    --add, create and position all elements on this frame
    self.elementsOnFrame = {
        background = {
            object = Loveframes.Create("image");
        };
        button_back = {
            object = Loveframes.Create("imagebutton");
            x = 10;
            y = 10;
        };
    };
    
    --adjust all elements on this frame
    self.elementsOnFrame.background.object:SetImage("assets/gui/gui_Test_Bg.png");
    
    self.elementsOnFrame.button_back.object:SetImage("assets/gui/gui_Test_Button.png")
    self.elementsOnFrame.button_back.object:SizeToImage()
    self.elementsOnFrame.button_back.object:SetText("Back");
    
    
    --onclick events for all buttons
    self.elementsOnFrame.button_back.object.OnClick = function(object)
        _gui:changeFrame("1");
    end
end


--called to "delete" this frame
function Pause:clear()
    --visible set on false/ should only done in this function
    self.elementsOnFrame.background.object:SetVisible(false);
    self.elementsOnFrame.button_back.object:SetVisible(false);
    --set the offset on the default value
    self.xOffset = self.xDefaultOffset;
    self.yOffset = self.yDefaultOffset;
end

--called in the "fly in" state 
function Pause:appear()
    self.yOffset = self.yOffset + self.moveSpeed;
    self:setPosition();
end

--called in the "fly out" state
function Pause:disappear()
    self.yOffset = self.yOffset + self.moveSpeed;
    self:setPosition();
end

function Pause:setPosition()
    self.elementsOnFrame.background.object:SetPos(self.xPos + self.xOffset, self.yPos + self.yOffset)
    self.elementsOnFrame.button_back.object:SetPos(self.xPos + self.elementsOnFrame.button_back.x + self.xOffset, self.yPos + self.elementsOnFrame.button_back.y + self.yOffset);
    
    
end




function Pause:draw()
    for k, v in pairs(self.elementsOnFrame) do
        v.object:SetVisible(true);
    end
end


---return true if the frame is on position /fly in move is finished
function Pause:checkPosition()
    if (self.xOffset == 0 and self.yOffset == 0) then
        return true;
    else
        return false;
    end
end




return Pause;
