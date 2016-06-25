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
    if _gui:drawGame() then
        --ingame
        self.level = level ;
        if level == "sewer" then
            print"a"
            TEsound.playLooping(self.listSewer, "bgm");
        elseif level == "squirrel" then
            TEsound.playLooping(self.listSquirrel, "bgm");
        elseif level == "crocodile" then
            TEsound.playLooping(self.listCrocodile, "bgm");
        elseif level == "canyon" then
            TEsound.playLooping(self.listCanyon, "bgm");
        end
    else
        --menu
        TEsound.playLooping(self.listMenu, "bgm");
    end
    TEsound.volume('bgm', _G._persTable.config.bgm / 100);
end

return MusicManager;