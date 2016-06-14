Class = require "lib.hump.class";

local AchievementDisplay = Class {
    init = function(self, directory)
        self.background = nil;
        self.defaultText = nil;
        self.unlockedAchievements = {};
        self.directory = directory;
        self.maxAchievements = 3;
        self:create();
    end;
};

--create the display/ just called in the constructure
function AchievementDisplay:create()
    self.background = Loveframes.Create("image");
    self.background:SetImage(self.directory .. "AchievementDisplayBG.png");

    self.defaultText = Loveframes.Create("text");
    self.defaultText:SetText("No unlocked achievements this round");
    self.defaultText:SetMaxWidth(self.background:GetWidth() - 40);
end

--sets the visible of the display
function AchievementDisplay:SetVisible(visible)
    if visible == true then
        --look for new achievements
        if _G._unlockedAchievements[1] ~= nil then
            local amountOfShownAchievements = 1;
            --new achievements
            for k, v in ipairs(_G._unlockedAchievements) do
                if amountOfShownAchievements < self.maxAchievements then
                    local image = Loveframes.Create("image");
                    image:SetImage(self.directory .. v.image_unlock);
                    self.unlockedAchievements[k] = image;
                    amountOfShownAchievements = amountOfShownAchievements + 1;
                end
            end
            _G._unlockedAchievements = {};
        else
            --no new achievements
            self.defaultText:SetVisible(visible);
        end
    else
        if self.unlockedAchievements[1] ~= nil then
            for _, v in pairs(self.unlockedAchievements) do
                v:Remove();
            end
        end
        self.defaultText:SetVisible(visible);
    end
    self.background:SetVisible(visible);
end

--set position of the display
function AchievementDisplay:SetPos(x, y)
    self.defaultText:SetPos(x + 20, y + 20);
    self.background:SetPos(x, y);
    for k, v in ipairs(self.unlockedAchievements) do
        v:SetPos(x + 20 + (k - 1) * 96, y + 20);
    end
end

return AchievementDisplay;
