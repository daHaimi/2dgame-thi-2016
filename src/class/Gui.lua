Frame = require "class.Frame";
Loveframes = require "lib.LoveFrames";
Class = require "lib.hump.class";
Chart = require "class.Chart";
KlickableElement = require "class.KlickableElement";
Textbox = require "class.Textbox";
Healthbar = require "class.Healthbar";


local Gui = Class {
    init = function(self)
    end;
    tempOutput = "";--Output values on the Main Menu. Will be replaced later
    state = {};--contains the current and last gui state
    changeFrame = false;--true if a frame change is activ
    
    --table contains all backgrounds
    background = {
        mainMenu = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
        options = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
        credits = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
        wiki = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
        achievements = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
        upgradeMenu = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
        score = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
        level = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
        pause = Loveframes.Create("image"):SetImage("assets/gui/gui_Test_Bg.png");
    };
    
           --Table contains all buttons
    button = {
        back = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Back");
        upgradeMenu = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Upgrade Menu");
        credits = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Credits");
        wiki = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Wiki");
        achievements = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Achievements");
        options = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Options");
        options_mM = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Options");
        start = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Start game");
        level1 = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Level 1");
        level2 = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Level 2");
        level3 = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Level 3");
        retry = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Retry");
        pause = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Pause");
        tempEndTurn = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("End turn");
        backToMenu = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Back to menu");
        backToGame = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Back to game");
        buy = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Buy Upgrade");
        reset = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("Reset");
        minusLife = Loveframes.Create("imagebutton"):SetImage("assets/gui/gui_Test_Button.png"):SizeToImage():SetText("-1 Life");
    };

    --table contains all elements like upgradebutton, achievementbuttons and wikibuttons
    klickableElement = {
        upgrade1 = KlickableElement("SpeedUp", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_checked.png", "Text for SpeedUp. Text for SpeedUp. Text for SpeedUp. ");
        upgrade2 = KlickableElement("Money", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_checked.png", "Text for Money. Text for Money. Text for Money. ");
        upgrade3 = KlickableElement("Life", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_checked.png", "Text for Life. Text for Life. Text for Life. ");
        upgrade4 = KlickableElement("God", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_checked.png", "Text for God. Text for God. Text for God. ");
        upgrade5 = KlickableElement("BT1", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_checked.png", "Text for BT1. Text for BT1. Text for BT1. ");
        upgrade6 = KlickableElement("BT2", "assets/gui/gui_Test_klickableElement.png", "assets/gui/gui_Test_klickableElement_checked.png", "Text for BT2. Text for BT2. Text for BT2. ");
        wiki1 = KlickableElement("Angler", "assets/angler.png", nil, "Text for Angler. Text for Angler. Text for Angler.");
        wiki2 = KlickableElement("Dead Fish", "assets/deadFish.png", nil, "Text for dead Fish. Text for dead Fish. Text for dead Fish.");
        wiki3 = KlickableElement("Lolli", "assets/lolli.png", nil, "Text for Lolli. Text for Lolli. Text for Lolli.");
        wiki4 = KlickableElement("Nemo", "assets/nemo.png", nil, "Text for Nemo. Text for Nemo. Text for Nemo.");
        wiki5 = KlickableElement("Ratte", "assets/ratte.png", nil, "Text for Ratte. Text for Ratte. Text for Ratte.");
        wiki6 = KlickableElement("Ring", "assets/ring.png", nil, "Text for Ring. Text for Ring. Text for Ring.");
    };
    
    --table contains all charts
    chart = {
        upgrades = Chart();
        wiki = Chart();
    };
    
    --table contains all frames of the gui
    myFrame ={
        --create a new frame for every gui state
        mainMenu = Frame(
            "MainMenu",--Frame name
            "down",--Move in direction
            "down",--Move out direction
            50,--Movespeed              !!has to be a multiply of x/yOffset!!
            0,--Start offset X
            -1500--Start offset Y 
            );
        options = Frame("Options", "down", "down", 50, 0, -1500);
        upgradeMenu = Frame("UpgradeMenu", "down", "down", 50, 0, -1500);
        wiki = Frame("Wiki", "down", "down", 50, 0, -1500);
        credits = Frame("Credits", "down", "down", 50, 0, -1500);
        inGame = Frame("InGame", "right", "left", 10, -300, 0);
        score = Frame("Score", "right", "left", 50, -300, 0);
        achievements = Frame("Achievements", "down", "down", 50, 0, -1500);
        pause = Frame("Pause", "right", "left", 50, -1000, 0);
        level = Frame("Level", "down", "down", 50, 0, -1500)
    };
    
    --Tabel contains all sliders
    slider = { 
        bgm = Loveframes.Create("slider"):SetText("BGM"):SetMinMax(0, 100):SetWidth(128);
        music = Loveframes.Create("slider"):SetText("Music"):SetMinMax(0, 100):SetWidth(128)
    };
    
    inGameElements ={
        healthbar = Healthbar("assets/hamster.png", "assets/heart_grey.png", "assets/heart.png", 3);
        };
};

---returns a scaled value in pixel for elements positions
-- @parm axis: x or y axis
-- @parm percent: Length in percent
function Gui:getScaledPixel(axis, percent)
    if axis == "x" then
        return (_persTable.winDim[1] / 100 * percent);
    elseif axis == "y" then
        return (_persTable.winDim[2] / 100 * percent);
    end
end

---Called at the beginning
---clears all frames and starts at the main menu
function Gui:startGui()
    self:clearAll();
    self:draw(self.myFrame.mainMenu);
end

---set the visible of all frames to false
function Gui:clearAll()
    for k, v in pairs(self.myFrame) do v:clearFrame(); end
end

---add, scale and postion all elements on main menu
function Gui:buildMainMenu(x, y)
    --adjust the background
    self.background.mainMenu:SetScale(
        (x*0.5)/self.background.mainMenu:GetImageWidth(),
        (y*0.6)/self.background.mainMenu:GetImageHeight());
    --set the position of the frame in the center of the screen
    self.myFrame.mainMenu:setPosition(        
        (x/2 - self.background.mainMenu:GetImageWidth()/2*self.background.mainMenu:GetScaleX()),
        (y/2 - self.background.mainMenu:GetImageHeight()/2*self.background.mainMenu:GetScaleY()));
    --add all needed elements
    self.myFrame.mainMenu:addElement(self.background.mainMenu, 0, 0);
    
    self.myFrame.mainMenu:addElement(
        Gui.button.start, 
        self.myFrame.mainMenu:centerElementX(x, self.background.mainMenu:GetImageWidth(), 128), 
        self:getScaledPixel("y", 5));
    self.myFrame.mainMenu:addElement(
        Gui.button.upgradeMenu, 
        self.myFrame.mainMenu:centerElementX(x, self.background.mainMenu:GetImageWidth(), 128), 
        32 + self:getScaledPixel("y", 7));
    self.myFrame.mainMenu:addElement(
        Gui.button.credits,
        self.myFrame.mainMenu:centerElementX(x, self.background.mainMenu:GetImageWidth(), 128),
        64 + self:getScaledPixel("y", 9));
    self.myFrame.mainMenu:addElement(Gui.button.wiki,
        self.myFrame.mainMenu:centerElementX(x, self.background.mainMenu:GetImageWidth(), 128),
        96 + self:getScaledPixel("y", 11));
    self.myFrame.mainMenu:addElement(
        Gui.button.achievements,
        self.myFrame.mainMenu:centerElementX(x, self.background.mainMenu:GetImageWidth(), 128),
        128 + self:getScaledPixel("y", 13));
    self.myFrame.mainMenu:addElement(
        Gui.button.options_mM,
        self.myFrame.mainMenu:centerElementX(x, self.background.mainMenu:GetImageWidth(), 128),
        160 + self:getScaledPixel("y", 15));
    
end

---add, scale and postion all elements on upgrade menu
function Gui:buildUpgradeMenu(x, y)
    self.background.upgradeMenu:SetScale(
        (x*0.5)/self.background.upgradeMenu:GetImageWidth(),
        (y*0.6)/self.background.upgradeMenu:GetImageHeight());
    self.myFrame.upgradeMenu:setPosition(
        (x/2 - self.background.upgradeMenu:GetImageWidth()/2*self.background.upgradeMenu:GetScaleX()),
        (y/2 - self.background.upgradeMenu:GetImageHeight()/2*self.background.upgradeMenu:GetScaleY()));
    
    self.chart.upgrades:addKlickableElement(self.klickableElement.upgrade1);
    self.chart.upgrades:addKlickableElement(self.klickableElement.upgrade2);
    self.chart.upgrades:addKlickableElement(self.klickableElement.upgrade3);
    self.chart.upgrades:addKlickableElement(self.klickableElement.upgrade4);
    self.chart.upgrades:addKlickableElement(self.klickableElement.upgrade5);
    self.chart.upgrades:addKlickableElement(self.klickableElement.upgrade6);
    self.myFrame.upgradeMenu:addElement(self.chart.upgrades,
        self.myFrame.upgradeMenu:centerElementX(x, self.background.upgradeMenu:GetImageWidth(), 192), 
        self:getScaledPixel("y", 5));
    
    self.myFrame.upgradeMenu:addElement(self.background.upgradeMenu, 0, 0);
    self.myFrame.upgradeMenu:addElement(Gui.button.buy, self.myFrame.upgradeMenu:centerElementX(x, self.background.upgradeMenu:GetImageWidth(), 128), self:getScaledPixel("y", 7) + 200);
    self.myFrame.upgradeMenu:addElement(Gui.button.back, self.myFrame.upgradeMenu:centerElementX(x, self.background.upgradeMenu:GetImageWidth(), 128), self:getScaledPixel("y", 9) + 232);
end

---add, scale and postion all elements on credits
function Gui:buildCredits(x, y)
    self.background.credits:SetScale(
        (x*0.5)/self.background.credits:GetImageWidth(),
        (y*0.6)/self.background.credits:GetImageHeight());
        self.myFrame.credits:setPosition(
        (x/2 - self.background.credits:GetImageWidth()/2*self.background.credits:GetScaleX()),
        (y/2 - self.background.credits:GetImageHeight()/2*self.background.credits:GetScaleY()));
    self.myFrame.credits:setPosition((x/2 - self.background.credits:GetImageWidth()/2*self.background.credits:GetScaleX()),
        (y/2 - self.background.credits:GetImageHeight()/2*self.background.credits:GetScaleY()));
    self.myFrame.credits:addElement(self.background.credits, 0, 0);
    self.myFrame.credits:addElement(Gui.button.back, self.myFrame.credits:centerElementX(x, self.background.credits:GetImageWidth(), 128), 50);
end

---add, scale and postion all elements on wiki
function Gui:buildWiki(x, y)
    self.background.wiki:SetScale(
        (x*0.5)/self.background.wiki:GetImageWidth(),
        (y*0.6)/self.background.wiki:GetImageHeight());
    self.myFrame.wiki:setPosition(
        (x/2 - self.background.wiki:GetImageWidth()/2*self.background.wiki:GetScaleX()),
        (y/2 - self.background.wiki:GetImageHeight()/2*self.background.wiki:GetScaleY()));
    
    self.chart.wiki:addKlickableElement(self.klickableElement.wiki1);
    self.chart.wiki:addKlickableElement(self.klickableElement.wiki2);
    self.chart.wiki:addKlickableElement(self.klickableElement.wiki3);
    self.chart.wiki:addKlickableElement(self.klickableElement.wiki4);
    self.chart.wiki:addKlickableElement(self.klickableElement.wiki5);
    self.chart.wiki:addKlickableElement(self.klickableElement.wiki6);
    self.myFrame.wiki:addElement(self.chart.wiki,
        self.myFrame.upgradeMenu:centerElementX(x, self.background.upgradeMenu:GetImageWidth(), 192), 
        self:getScaledPixel("y", 5));

    self.myFrame.wiki:addElement(self.background.wiki, 0, 0);
    self.myFrame.wiki:addElement(Gui.button.back, self.myFrame.upgradeMenu:centerElementX(x, self.background.upgradeMenu:GetImageWidth(), 128), self:getScaledPixel("y", 7) + 200);
end

---add, scale and postion all elements on achievements
function Gui:buildAchievements(x, y)
        self.background.achievements:SetScale(
        (x*0.5)/self.background.achievements:GetImageWidth(),
        (y*0.6)/self.background.achievements:GetImageHeight());
    self.myFrame.achievements:setPosition(
        (x/2 - self.background.achievements:GetImageWidth()/2*self.background.achievements:GetScaleX()),
        (y/2 - self.background.achievements:GetImageHeight()/2*self.background.achievements:GetScaleY()));
    
    self.myFrame.achievements:addElement(self.background.achievements, 0, 0);
    self.myFrame.achievements:addElement(Gui.button.back,
        self.myFrame.mainMenu:centerElementX(x, self.background.mainMenu:GetImageWidth(), 128), 
        self:getScaledPixel("y", 5));
end

function Gui:buildOptions(x, y)
    self.background.options:SetScale((x*0.5)/self.background.options:GetImageWidth(), (y*0.6)/self.background.options:GetImageHeight());
    self.myFrame.options:setPosition((x/2 - self.background.options:GetImageWidth()/2*self.background.options:GetScaleX()),
        (y/2 - self.background.options:GetImageHeight()/2*self.background.options:GetScaleY()));
    self.myFrame.options:addElement(self.background.options, 0, 0);
    self.myFrame.options:addElement(self.slider.bgm,
        self.myFrame.options:centerElementX(x, self.background.options:GetImageWidth(), 128), 
        self:getScaledPixel("y", 5));
    self.myFrame.options:addElement(self.slider.music,
        self.myFrame.options:centerElementX(x, self.background.options:GetImageWidth(), 128), 
        self:getScaledPixel("y", 7) + 32);
    self.myFrame.options:addElement(Gui.button.reset,
        self.myFrame.options:centerElementX(x, self.background.options:GetImageWidth(), 128), 
        self:getScaledPixel("y", 9) + 64);
    self.myFrame.options:addElement(Gui.button.back,
        self.myFrame.options:centerElementX(x, self.background.options:GetImageWidth(), 128), 
        self:getScaledPixel("y", 11) + 96);
end

---add, scale and postion all elements on pause
function Gui:buildPause(x, y)
    self.background.pause:SetScale(
        (x*0.5)/self.background.pause:GetImageWidth(),
        (y*0.6)/self.background.pause:GetImageHeight());
    self.myFrame.pause:setPosition(
        (x/2 - self.background.pause:GetImageWidth()/2*self.background.pause:GetScaleX()),
        (y/2 - self.background.pause:GetImageHeight()/2*self.background.pause:GetScaleY()));
    self.myFrame.pause:addElement(self.background.pause, 0, 0);
    self.myFrame.pause:addElement(Gui.button.backToGame, self.myFrame.pause:centerElementX(x, self.background.pause:GetImageWidth(), 128), 50);
    self.myFrame.pause:addElement(Gui.button.backToMenu, self.myFrame.pause:centerElementX(x, self.background.pause:GetImageWidth(), 128), 100);
    self.myFrame.pause:addElement(Gui.button.options, self.myFrame.pause:centerElementX(x, self.background.pause:GetImageWidth(), 128), 150);
end

---add, scale and postion all elements on ingame
function Gui:buildInGame(x, y)
    self.myFrame.inGame:setPosition(0, 30);
    self.myFrame.inGame:addElement(Gui.button.pause, 0, 0);
    self.myFrame.inGame:addElement(Gui.button.tempEndTurn, 0, 30);
    self.myFrame.inGame:addElement(Gui.button.minusLife, 0, 60); 
    self.myFrame.inGame:addElement(Gui.inGameElements.healthbar, 0, 0);
    
end

---add, scale and postion all elements on level
function Gui:buildLevel(x, y)
    self.background.level:SetScale(
        (x*0.5)/self.background.level:GetImageWidth(),
        (y*0.6)/self.background.level:GetImageHeight());
    self.myFrame.level:setPosition(
        (x/2 - self.background.level:GetImageWidth()/2*self.background.level:GetScaleX()),
        (y/2 - self.background.level:GetImageHeight()/2*self.background.level:GetScaleY()));
    self.myFrame.level:addElement(self.background.level, 0, 0);
    self.myFrame.level:addElement(Gui.button.level1, self.myFrame.level:centerElementX(x, self.background.level:GetImageWidth(), 128), 50);
    self.myFrame.level:addElement(Gui.button.level2, self.myFrame.level:centerElementX(x, self.background.level:GetImageWidth(), 128), 100);
    self.myFrame.level:addElement(Gui.button.level3, self.myFrame.level:centerElementX(x, self.background.level:GetImageWidth(), 128), 150);
    self.myFrame.level:addElement(Gui.button.back, self.myFrame.level:centerElementX(x, self.background.level:GetImageWidth(), 128), 200);
end

---add, scale and postion all elements on score
function Gui:buildScore(x, y)
    self.background.score:SetScale((x*0.5)/self.background.score:GetImageWidth(), (y*0.6)/self.background.score:GetImageHeight());
    self.myFrame.score:setPosition((x/2 - self.background.score:GetImageWidth()/2*self.background.score:GetScaleX()),
        (y/2 - self.background.score:GetImageHeight()/2*self.background.score:GetScaleY()));
    self.myFrame.score:addElement(self.background.score, 0, 0);
    self.myFrame.score:addElement(Gui.button.backToMenu, self.myFrame.score:centerElementX(x, self.background.score:GetImageWidth(), 128), 50);
    self.myFrame.score:addElement(Gui.button.retry, self.myFrame.score:centerElementX(x, self.background.score:GetImageWidth(), 128), 100);
end

    
---Called in the love.load function to add all needed elements to the frames
function Gui:buildFrames()
    local x = _persTable.winDim[1];
    local y = _persTable.winDim[2];
    Gui:buildMainMenu(x, y);
    Gui:buildUpgradeMenu(x, y);
    Gui:buildCredits(x, y);
    Gui:buildWiki(x, y);
    Gui:buildAchievements(x, y);
    Gui:buildOptions(x, y);
    Gui:buildPause(x, y);
    Gui:buildInGame(x, y);
    Gui:buildLevel(x, y);
    Gui:buildScore(x, y);
end

---Called each "love.update". Used to move the frames
function Gui:updateGui()
    if Gui.changeFrame then --frame change is activ
        self.state[1]:moveIn();--new frame is moving in
        if self.state[2] ~= nil then --nil only at the beginning
            self.state[2]:moveOut(); --old frame is moving out
        end
        if self.state[1]:onPosition() then
            --new frame is on position
            if self.state[2] ~= nil then --nil only at the beginning
                self.state[2]:clearFrame(); --clear old frame
            end
            self:setChangeFrame(false);--"close" the frame change
        end
    end

end

---This function draws the gui state
-- @param newFrame: object of the new frame
function Gui:draw(newFrame)
    Gui:logState(newFrame);
    self.state[1]:showFrame()
    self:setChangeFrame(true);

end

---Set the changeFrame true or false
-- @param bool: new value
function Gui:setChangeFrame(bool)
    Gui.changeFrame = bool;
end

---logging the current state in a table
-- @param actGui The currenet gui state
function Gui:logState(actFrame)
    Gui.state[2] = Gui.state[1];
    Gui.state[1] = actFrame;
end

---checking the gui state and return a boolean
function Gui:drawGame()
    --returns "true" in the InGame-state
    if Gui.state[1] ~= Gui.myFrame.inGame then
        return false;
    else
        return true;
    end
end

---print the state-name and values
function Gui:tempDrawText()
    love.graphics.print(Gui.state[1].name, 0, 0);
    if Gui.state[1] == Gui.myFrame.mainMenu then
        love.graphics.print(Gui.tempOutput, 0, 20);
    end
end

---convert all values into drawable text
---this function is called continuously by the love.draw function
---will be replaced in a later version
function Gui:tempTextOutput()
    Gui.tempOutput = 
        "_persTable.upgrades:" .. "\n" ..
        "Speed UP = " .. tostring(_persTable.upgrades.speedUp).. "\n" .. 
        "Money Mult = " .. tostring(_persTable.upgrades.moneyMult).. "\n" .. 
        "More Life = " .. tostring(_persTable.upgrades.moreLife).. "\n" .. 
        "GodMode = " .. tostring(_persTable.upgrades.godMode) .. "\n" ..
        "Breakthrough 1 = " .. tostring(_persTable.upgrades.mapBreakthrough1) .. "\n" ..
        "Breakthrough 2 = " .. tostring(_persTable.upgrades.mapBreakthrough2) .. "\n" ..
        "\n" ..
        "_persTable.config" .. "\n" .. 
        "BGM =" .. tostring(_persTable.config.bgm).. "\n" ..
        "Music =" .. tostring(_persTable.config.music).. "\n" ..
        "\n" ..
        "Money =" .. tostring(_persTable.money);
end


---set the state of the gui elements on the defined status
---this function is called exactly once at the beginning of the game
function Gui:loadValues()
    --convert 0, 1 or more in to boolean. A 2 equals multiply checkboxes
    if _persTable.upgrades.speedUp == 1 then
        Gui.klickableElement.upgrade1:check();
    end
    if _persTable.upgrades.moneyMult == 1 then
        Gui.klickableElement.upgrade2:check();
    end
    if _persTable.upgrades.moreLife == 1 then
        Gui.klickableElement.upgrade3:check();
    end
    if _persTable.upgrades.godMode == 1 then
        Gui.klickableElement.upgrade4:check();
    end
    if _persTable.upgrades.mapBreakthrough1 == 1 then
        Gui.klickableElement.upgrade4:check();
        if _persTable.upgrades.mapBreakthrough2 == 1 then
            Gui.klickableElement.upgrade4:check();
        end
    end
    --Gui.checkBox.option1:SetChecked(_persTable.config.option1);
    --Gui.checkBox.option2:SetChecked(_persTable.config.option2);
    Gui.slider.bgm:SetValue(_persTable.config.bgm);
    Gui.slider.music:SetValue(_persTable.config.music);
    Gui:tempTextOutput();
end


---updates all values which can be chanced by gui elements
---this function is called on every Back-Button clickevent
function Gui:updateValues()
    --_persTable.config.option1 = Gui.checkBox.option1:GetChecked();
    --_persTable.config.option2 = Gui.checkBox.option2:GetChecked();
    _persTable.config.bgm = Gui.slider.bgm:GetValue();
    _persTable.config.music = Gui.slider.music:GetValue();
    --transform the boolean to 0, 1 or more
    if Gui.klickableElement.upgrade1:GetChecked() then
        _persTable.upgrades.speedUp = 1;
    else
        _persTable.upgrades.speedUp = 0;
    end
    if Gui.klickableElement.upgrade2:GetChecked() then
        _persTable.upgrades.moneyMult = 1;
    else
        _persTable.upgrades.moneyMult = 0;
    end
    if Gui.klickableElement.upgrade3:GetChecked() then
        _persTable.upgrades.moreLife = 1;
    else
        _persTable.upgrades.moreLife = 0;
    end
    if Gui.klickableElement.upgrade4:GetChecked() then
        _persTable.upgrades.godMode = 1;
    else
        _persTable.upgrades.godMode = 0;
    end
    if Gui.klickableElement.upgrade5:GetChecked() then
        _persTable.upgrades.mapBreakthrough1 = 1;
    else
        _persTable.upgrades.mapBreakthrough1 = 0;
    end
    if Gui.klickableElement.upgrade6:GetChecked() then
        _persTable.upgrades.mapBreakthrough2 = 1;
    else
        _persTable.upgrades.mapBreakthrough2 = 0;
    end
    Gui:tempTextOutput();
end

--- Onclick event of the start button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.start.OnClick = function(obj, x, y)
        Gui:draw(Gui.myFrame.level);
end

--- Onclick event of the upgrade menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.upgradeMenu.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.upgradeMenu);
end

--- Onclick event of the credits button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.credits.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.credits);
end

--- Onclick event of the wiki button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.wiki.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.wiki);
end

--- Onclick event of the achievements button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.achievements.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.achievements);
end

--- Onclick event of the options button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.options.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.options);
end

--Onclick event of the options button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.options_mM.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.options);
end

--- Onclick event of the level 1 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level1.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--- Onclick event of the level 2 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level2.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--- Onclick event of the level 3 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level3.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--- Onclick event of the retry button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.retry.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--- Onclick event of the end turn button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
-- this function will be replaced in a later version
Gui.button.tempEndTurn.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.score);
end

--- Onclick event of the pause button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.pause.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.pause);
end

--Onclick event of the back to menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.backToMenu.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.mainMenu);
end

--- Onclick event of the back to game button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.backToGame.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--- Onclick event of the back to game button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.minusLife.OnClick = function(obj, x, y)
    Gui.inGameElements.healthbar:minus();
end

--- Onclick event of the back to game button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.reset.OnClick = function(obj, x, y)
    
end

--- Onclick event of the back button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.back.OnClick = function(obj, x, y)
    if Gui.state[1] == Gui.myFrame.options or Gui.state [1] == Gui.myFrame.upgradeMenu then
        Gui.updateValues();
    end
    Gui:draw(Gui.state[2]);
    Gui.chart.upgrades.markFrame:SetVisible(false);
    Gui.chart.wiki.markFrame:SetVisible(false);
end

--Onclick event of  the buy button
Gui.button.buy.OnClick = function(obj, x, y)
    if Gui.chart.upgrades.markedElement ~= nil then
        Gui.chart.upgrades.markedElement:check();
    end
end



Gui.klickableElement.upgrade1.object.OnClick = function (obj, x, y)
    Gui.chart.upgrades:markElement(Gui.klickableElement.upgrade1);
end

Gui.klickableElement.upgrade2.object.OnClick = function (obj, x, y)
    --Gui.klickableElement.upgrade2:check();
    Gui.chart.upgrades:markElement(Gui.klickableElement.upgrade2);
end
Gui.klickableElement.upgrade3.object.OnClick = function (obj, x, y)
    Gui.chart.upgrades:markElement(Gui.klickableElement.upgrade3);
end
Gui.klickableElement.upgrade4.object.OnClick = function (obj, x, y)
    Gui.chart.upgrades:markElement(Gui.klickableElement.upgrade4);
end
Gui.klickableElement.upgrade5.object.OnClick = function (obj, x, y)
    Gui.chart.upgrades:markElement(Gui.klickableElement.upgrade5);
end
Gui.klickableElement.upgrade6.object.OnClick = function (obj, x, y)
    Gui.chart.upgrades:markElement(Gui.klickableElement.upgrade6);
end


Gui.klickableElement.wiki1.object.OnClick = function (obj, x, y)
    Gui.chart.wiki:markElement(Gui.klickableElement.wiki1);
end

Gui.klickableElement.wiki2.object.OnClick = function (obj, x, y)
    --Gui.klickableElement.upgrade2:check();
    Gui.chart.wiki:markElement(Gui.klickableElement.wiki2);
end
Gui.klickableElement.wiki3.object.OnClick = function (obj, x, y)
    Gui.chart.wiki:markElement(Gui.klickableElement.wiki3);
end
Gui.klickableElement.wiki4.object.OnClick = function (obj, x, y)
    Gui.chart.wiki:markElement(Gui.klickableElement.wiki4);
end
Gui.klickableElement.wiki5.object.OnClick = function (obj, x, y)
    Gui.chart.wiki:markElement(Gui.klickableElement.wiki5);
end
Gui.klickableElement.wiki6.object.OnClick = function (obj, x, y)
    Gui.chart.wiki:markElement(Gui.klickableElement.wiki6);
end

return Gui;
