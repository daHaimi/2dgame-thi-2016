Class = require "lib.hump.class";

local ImageButton = Class{
    init = function (self, image, xPos, yPos, clickable)
        self.xPosition = xPos;
        self.yPosition = yPos;
        self.xOffset = 0;
        self.yOffset = 0;
        if image ~= nil then
            self.image = image;
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
    end
};

function ImageButton:draw() 
    local font = love.graphics.getFont();
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 22));
    love.graphics.draw(self.image, self.xPosition + self.xOffset, self.yPosition + self.yOffset);
    love.graphics.printf(self.text, self.xPosition + self.xOffset, self.yPosition + 25 + self.yOffset, self.width, "center")
    love.graphics.setFont(font);
end

function ImageButton:setText(text)
    self.text = text
end

function ImageButton:setPosition(x, y)
    self.xPosition = x;
    self.yPosition = y;
end

function ImageButton:getPosition()
    return self.xPosition, self.yPosition;
end

function ImageButton:getSize()
    return self.width, self.height;
end

function ImageButton:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end

function ImageButton:getOffset()
    return self.xOffset, self.yOffset;
end

function ImageButton:setImage(image)
    if image ~= nil then
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