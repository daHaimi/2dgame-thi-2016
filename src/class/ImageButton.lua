Class = require "lib.hump.class";

local ImageButton = Class{
    init = function (self, image, xPos, yPos, text, clickable)
        self.xPosition = xPos;
        self.yPosition = yPos;
        -- incase text = nil
        if text == nil then
            self.text = "";
        else
            self.text = text
        end
        if image ~= nil then
        print("picture ~= nil")
            self.image = love.graphics.newImage(image);
            self.width = self.image:getWidth()
            self.height = self.image:getHeight();
        else
            self.image = nil;
            self.width = 0;
            self.height = 0;
        end
        -- in case clickable = nil
        if clickable == nil then
            self.clickable = true;
        else
            self.clickable = clickable;
        end
        
        self.visible = true;
    print (self.xPosition)
    print (self.yPosition)
    print (self.width)
    print (self.height)
    end
};

function ImageButton:draw() 
    print ("draw it at ")
    print (self.xPosition)
    print (self.yPosition)
    love.graphics.rectangle("fill", self.xPosition, self.yPosition, self.width, self.height);
    love.graphics.draw(self.image, self.xPosition, self.yPosition);
end

function ImageButton:setText(text)
    self.text = text
end

function ImageButton:setPosition(x, y)
    --self.xPosition = x;
    --self.yPosition = y;
end

function ImageButton:setVisible(visibility)
    self.visible = visibility;
end

function ImageButton:setImage(image)
    print (image);
    if image ~= nil then
        print("picture ~= nil")
        self.image = love.graphics.newImage(image);
        self.width = self.image:getWidth()
        self.height = self.image:getHeight();
    else
        self.image = nil;
        self.width = 0;
        self.height = 0;
    end
end

function ImageButton:setClickable(clickable)
    self.clickable = clickable
end;

return ImageButton;