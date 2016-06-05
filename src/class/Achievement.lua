Class = require "lib.hump.class";

local Achievement = Class {
    init = function(self) end;
};

function Achievement:checkAchievements()
    self:checkCaughtOneRound();
end

function Achievement:checkCaughtOneRound()
  
    if _G._persTable.fish.caughtInOneRound > 9 then
        _G._persTable.achievements.bronzeCaughtOneRound = true;
    end
    
    if _G._persTable.fish.caughtInOneRound > 19 then
        _G._persTable.achievements.silverCaughtOneRound = true;
    end

    if _G._persTable.fish.caughtInOneRound > 29 then
        _G._persTable.achievements.goldCaughtOneRound = true;
    end
    
end

return Achievement;