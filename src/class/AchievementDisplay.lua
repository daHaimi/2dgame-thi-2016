Class = require "lib.hump.class";

local AchievementDisplay = Class {
    init = function(self)
        self.background = love.graphics.newImage("assets/gui/AchievementDisplayBG.png");
        self.defaultText = "";
        self.unlockedAchievements = {};
        self.maxAchievements = 3;
        self.position = {0, 0};
        self.xOffset = 0;
        self.yOffset = 0;
    end;
};

---Set the Language of the Text
function AchievementDisplay:setLanguage(language)
    self.defaultText = _G.data.languages[language].package.textNoNewAchievements;
end

--sets the visible of the display
function AchievementDisplay:draw()
    self.unlockedAchievements = _G._unlockedAchievements;
    love.graphics.draw(self.background, self.position[1] + self.xOffset, self.position[2] + self.yOffset);
    local counter = 0;
    if #self.unlockedAchievements == 0 then 
        local font = love.graphics.getFont();
        love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 25));
        love.graphics.printf(self.defaultText, self.position[1] + self.xOffset + 25 , self.position[2] + 15 
            + self.yOffset , self.background:getWidth() - 50, 'center');
        love.graphics.setFont(font);
    else
        for _, v in pairs (self.unlockedAchievements) do
            if counter < 3 then
                local image = love.graphics.newImage("assets/gui/icons/" .. v.image_unlock)
                love.graphics.draw(image, self.position[1] + counter * (image:getWidth() + 5) + 20 + self.xOffset, 
                    self.position[2]+ (self.background:getHeight() - image:getHeight())/2 + self.yOffset);
            end
            counter = counter + 1;
        end
    end
end

function AchievementDisplay:remove()
    self.unlockedAchievements = {};
    for _, v in pairs (self.unlockedAchievements) do
        print (v.name)
    end
    print("end of text")
end

--- sets the offset of the button 
--@param x x offset of the button
--@parma y y offset of the button
function AchievementDisplay:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end

--- returns the postition of the object
--@retrun x position, y position 
function AchievementDisplay:getPosition()
    return self.position[1], self.position[2];
end

--- returns the size of the object
--@return width of the object height of the object
function AchievementDisplay:getSize()
    return self.background:getWidth(), self.background:getHeight();
end

--set position of the display
function AchievementDisplay:setPosition(x, y)
    self.position = {x, y};
end

return AchievementDisplay;
