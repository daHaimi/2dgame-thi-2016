Class = require "lib.hump.class";
---Image Button is a button in the size of the image used
--@param image a love image
--@param xPos x position of the button
--@param yPos y position of the button
--@param clickable true means the button is enabled
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

--- draws the ImageButton on the frame
function ImageButton:draw() 
    local font = love.graphics.getFont();
    love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 22));
    love.graphics.draw(self.image, self.xPosition + self.xOffset, self.yPosition + self.yOffset);
    love.graphics.printf(self.text, self.xPosition + self.xOffset, self.yPosition + 25 + self.yOffset, self.width, "center")
    love.graphics.setFont(font);
end

--- changes the text of the button
--@param text new text of the button
function ImageButton:setText(text)
    self.text = text
end


--- changes the position of the button
--@param x new x position of the button
--@param y new y position of the button
function ImageButton:setPosition(x, y)
    self.xPosition = x;
    self.yPosition = y;
end

--- returns the position of the button
--@return x position and y position of the button
function ImageButton:getPosition()
    return self.xPosition, self.yPosition;
end

--- return the size of the button
--@retrun width and height of the button
function ImageButton:getSize()
    return self.width, self.height;
end

--- sets the offset of the button 
--@param x x offset of the button
--@parma y y offset of the button
function ImageButton:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end

--- retruns the offset of the button
--@return x and y offset of the button
function ImageButton:getOffset()
    return self.xOffset, self.yOffset;
end


--- sets the image of the button
--@param image love image
function ImageButton:setImage(image)
    if image ~= nil then
        self.image = image;
        self.width = self.image:getWidth()
        self.height = self.image:getHeight();
    else
        self.image = nil;
        self.width = 0;
        self.height = 0;
    end
end

--- sets the clickability of the button 
--@param new clickability of the button
function ImageButton:setClickable(clickable)
    self.clickable = clickable
end;

return ImageButton;