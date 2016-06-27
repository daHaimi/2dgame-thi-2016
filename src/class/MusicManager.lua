local MusicManager = Class {
    init = function(self)
        self.listMenu = {
            "assets/music/ChibiNinja.mp3"
        };
        self.listSewer = {
            "assets/music/Searching.mp3",
            "assets/music/Underclocked.mp3"
        };
        self.listCanyon = {
            "assets/music/AllOfUs.mp3",
            "assets/music/ANightOfDizzySpells.mp3"
        };
        self.listCrocodile = {
            "assets/music/HHavok-main.mp3",
            "assets/music/Underclocked.mp3"
        };
        self.listSquirrel = {
            "assets/music/Jumpshot.mp3",
            "assets/music/ANightOfDizzySpells.mp3"
        };
        self.nyanCat = "assets/music/NyanCat.ogg";
        self.level = "";
    end;
}

function MusicManager:activateNyanCat()
    TEsound.pause("music");
    TEsound.playLooping(self.nyanCat, "nyan",  _G._persTable.config.music / 100)
end

function MusicManager:deactivateNyanCat()
    TEsound.stop("nyan", false);
    TEsound.resume("music");
end

function MusicManager:update(level)
    if level ~= self.level then
        TEsound.stop("music");
        self.level = level;
        if level == "sewers" or level == "sewersEndless" then
            TEsound.playLooping(self.listSewer, "music");
        elseif level == "crazySquirrels" then
            TEsound.playLooping(self.listSquirrel, "music");
        elseif level == "sleepingCrocos" then
            TEsound.playLooping(self.listCrocodile, "music");
        elseif level == "canyon" or level == "canyonEndless" then
            TEsound.playLooping(self.listCanyon, "music");
        else
            TEsound.playLooping(self.listMenu, "music");
        end
        TEsound.volume("music", _G._persTable.config.music / 100)
    end
end

return MusicManager;
