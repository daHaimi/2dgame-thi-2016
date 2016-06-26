local MusicManager = Class {
    init = function(self)
        self.listMenu = {
            "assets/music/ChibiNinja.mp3",
            "assets/music/Jumpshot.mp3"
        };
        self.listSewer = {
            "assets/music/Searching.mp3",
            "assets/music/Underclocked.mp3"
        };
        self.listCanyon = {
            "assets/music/AllOfUs.mp3",
            "assets/music/Underclocked.mp3",
            "assets/music/Jumpshot.mp3",
            "assets/music/ANightOfDizzySpells.mp3"
        };
        self.listCrocodile = {
            "assets/music/Searching.mp3",
            "assets/music/HHavok-main.mp3"
        };
        self.listSquirrel = {
            "assets/music/AllOfUs.mp3",
            "assets/music/ChibiNinja",
            "assets/music/Jumpshot",
            "assets/music/ANightOfDizzySpells.mp3"
        };
        self.level = "";
    end;
}

function MusicManager:update(level)
    
    if level ~= self.level then
        TEsound.stop("music");
        print("update mit " .. tostring(level))
        self.level = level ;
        if level == "sewers" or level == "sewersEndless" then
            print"sewer"
            TEsound.playLooping(self.listSewer, "music");
        elseif level == "squirrel" then
            print"squirrel"
            TEsound.playLooping(self.listSquirrel, "music");
        elseif level == "crocodile" then
            print"crocodile"
            TEsound.playLooping(self.listCrocodile, "music");
        elseif level == "canyon" or level == "canyonEndless" then
            print"canyon"
            TEsound.playLooping(self.listCanyon, "music");
        else
            print"menu"
            TEsound.playLooping(self.listMenu, "music");
        end
        TEsound.volume('music', _G._persTable.config.music / 100)
    end
end

return MusicManager;