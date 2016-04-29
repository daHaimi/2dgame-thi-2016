Frame = require "class.Frame";
Loveframes = require "lib.LoveFrames";
Class = require "lib.hump.class";

local Gui = Class {
    init = function(self)
    end;
    
    tempOutput = "";--Output values on the Main Menu. Will be replaced later
    state = {};
    changeFrame = false;
    
    background = {
        mainMenu = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
        options = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
        credits = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
        wiki = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
        achievements = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
        upgradeMenu = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
        score = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
        level = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
        pause = Loveframes.Create("image"):SetImage("assets/gui_Test_Bg.png");
    };
     --frameName, moveInDirection,moveOutDirection, moveSpeed, xStartOffset, yStartOffset
    myFrame ={
        mainMenu = Frame(
            "MainMenu",--Frame name
            "down",--Move in direction
            "down",--Move out direction
            30,--Movespeed
            0,--Start offset X
            -600--Start offset Y
            ),
        options = Frame("Options", "down", "down", 30, 0, -600),
        upgradeMenu = Frame("UpgradeMenu", "down", "down", 30, 0, -600),
        wiki = Frame("Wiki", "down", "down", 30, 0, -600),
        credits = Frame("Credits", "down", "down", 30, 0, -600),
        inGame = Frame("InGame", "right", "left", 10, -300, 0),
        score = Frame("Score", "right", "left", 10, -300, 0),
        tutorial = Frame("Tutorial", "up", "up", 30, 0, 600),
        achievements = Frame("Achievements", "down", "down", 30, 0, -600),
        pause = Frame("Pause", "right", "left", 30, -600, 0),
        level = Frame("Level", "down", "down", 30, 0, -600)
    };
    

    
    --Tabel contains all sliders
    slider = { 
        slider1 = Loveframes.Create("slider"):SetText("slider1"):SetMinMax(0, 100):SetWidth(80),
        slider2 = Loveframes.Create("slider"):SetText("slider2"):SetMinMax(0, 100):SetWidth(80),
    };
    --Table contains all buttons
    button = {
        back = Loveframes.Create("button"):SetText("Back"),
        upgradeMenu = Loveframes.Create("button"):SetText("Upgrade menu"),
        credits = Loveframes.Create("button"):SetText("Credits"),
        wiki = Loveframes.Create("button"):SetText("Wiki"),
        achievements = Loveframes.Create("button"):SetText("Achievements"),
        options = Loveframes.Create("button"):SetText("Options"),
        options_mM = Loveframes.Create("button"):SetText("Options"),
        start = Loveframes.Create("button"):SetText("Start game"),
        level1 = Loveframes.Create("button"):SetText("Level 1"),
        level2 = Loveframes.Create("button"):SetText("Level 2"),
        level3 = Loveframes.Create("button"):SetText("Level 3"),
        retry = Loveframes.Create("button"):SetText("Retry"),
        pause = Loveframes.Create("button"):SetText("Pause"),
        tempEndTurn = Loveframes.Create("button"):SetText("End turn"),
        tempGo = Loveframes.Create("button"):SetText("Skip tutorial"),
        backToMenu = Loveframes.Create("button"):SetText("Back to menu"),
        backToGame = Loveframes.Create("button"):SetText("Back to game")
    };
    --Table contains all checkboxes
    checkBox = {
        tutorial = Loveframes.Create("checkbox"):SetText("enter tutorial?"),
        upgrade1 = Loveframes.Create("checkbox"):SetText("Speed Up"),--speed Up Upgrade
        upgrade2 = Loveframes.Create("checkbox"):SetText("Money Mult"),--Money multiplier upgrade
        upgrade3 = Loveframes.Create("checkbox"):SetText("More Life"),--One life added upgrade
        upgrade4 = Loveframes.Create("checkbox"):SetText("God Mode"),--God mode upgrade
        upgrade5 = Loveframes.Create("checkbox"):SetText("Breakthrough 1"),--Map breakthrough 1 upgrade
        upgrade6 = Loveframes.Create("checkbox"):SetText("Breakthrough 2"),--Map breakthrough 2 upgrade
        option1 = Loveframes.Create("checkbox"):SetText("Option1"),
        option2 = Loveframes.Create("checkbox"):SetText("Option2"),
    };
};


function Gui:startGui()
    self:clearAll();
    self:draw(self.myFrame.mainMenu);
end

--set the visible of all elements to false
function Gui:clearAll()
    for k, v in pairs(self.myFrame) do v:clearFrame(); end
end

function Gui:buildFrames()
    local x = _persTable.winDim[1];
    local y = _persTable.winDim[2];
    --Build Main Menu

    self.background.mainMenu:SetScale((x*0.5)/self.background.mainMenu:GetImageWidth(), (y*0.6)/self.background.mainMenu:GetImageHeight());
    self.myFrame.mainMenu:setPosition((x/2 - self.background.mainMenu:GetImageWidth()/2*self.background.mainMenu:GetScaleX()), (y/2 - self.background.mainMenu:GetImageHeight()/2*self.background.mainMenu:GetScaleY()));
    self.myFrame.mainMenu:addElement(self.background.mainMenu, 0, 0);
    self.myFrame.mainMenu:addElement(self.checkBox.tutorial, self.checkBox.tutorial:GetWidth(), 30);
    self.myFrame.mainMenu:addElement(self.button.start, 30, 60);
    self.myFrame.mainMenu:addElement(self.button.upgradeMenu, 30, 90);
    self.myFrame.mainMenu:addElement(self.button.credits, 30, 120);
    self.myFrame.mainMenu:addElement(self.button.wiki, 30, 150);
    self.myFrame.mainMenu:addElement(self.button.achievements, 30, 180);
    self.myFrame.mainMenu:addElement(self.button.options_mM, 30, 210);

    --Build Upgrade Menu
    self.myFrame.upgradeMenu:setPosition(x/2, y/2);
    self.myFrame.upgradeMenu:addElement(self.background.upgradeMenu, 0, 0);
    self.myFrame.upgradeMenu:addElement(self.checkBox.upgrade1, 30, 30);
    self.myFrame.upgradeMenu:addElement(self.checkBox.upgrade2, 30, 60);
    self.myFrame.upgradeMenu:addElement(self.checkBox.upgrade3, 30, 90);
    self.myFrame.upgradeMenu:addElement(self.checkBox.upgrade4, 30, 120);
    self.myFrame.upgradeMenu:addElement(self.checkBox.upgrade5, 30, 150);
    self.myFrame.upgradeMenu:addElement(self.checkBox.upgrade6, 30, 180);
    self.myFrame.upgradeMenu:addElement(self.button.back, 30, 210);
    
    --Build Credits
    self.myFrame.credits:setPosition(x, y);
    self.myFrame.credits:addElement(self.background.credits, 0, 0);
    self.myFrame.credits:addElement(self.button.back, 30, 0);
    
    --Build Wiki
    self.myFrame.wiki:setPosition(x, y);
    self.myFrame.wiki:addElement(self.background.wiki, 0, 0);
    self.myFrame.wiki:addElement(self.button.back, 30, 0);
    
    --Build Achievements
    self.myFrame.achievements:setPosition(x, y);
    self.myFrame.achievements:addElement(self.background.achievements, 0, 0);
    self.myFrame.achievements:addElement(self.button.back, 30, 0);
    
    --Build Options
    self.myFrame.options:setPosition(x, y);
    self.myFrame.options:addElement(self.background.options, 0, 0);
    self.myFrame.options:addElement(self.slider.slider1, 30, 0);
    self.myFrame.options:addElement(self.slider.slider2, 30, 30);
    self.myFrame.options:addElement(self.checkBox.option1, 30, 60);
    self.myFrame.options:addElement(self.checkBox.option2, 30, 90);
    self.myFrame.options:addElement(self.button.back, 30, 120);
    
    --Build Pause
    self.myFrame.pause:setPosition(x, y);
    self.myFrame.pause:addElement(self.background.pause, 0, 0);
    self.myFrame.pause:addElement(self.button.backToGame, 30, 0);
    self.myFrame.pause:addElement(self.button.backToMenu, 30, 30);
    self.myFrame.pause:addElement(self.button.options, 30, 60);
    
    --Build In Game
    self.myFrame.inGame:setPosition(0, 30);
    self.myFrame.inGame:addElement(self.button.pause, 30, 0);
    self.myFrame.inGame:addElement(self.button.tempEndTurn, 30, 30);
    
    --Build Level
    self.myFrame.level:setPosition(x, y);
    self.myFrame.level:addElement(self.background.level, 0, 0);
    self.myFrame.level:addElement(self.button.level1, 30, 0);
    self.myFrame.level:addElement(self.button.level2, 30, 30);
    self.myFrame.level:addElement(self.button.level3, 30, 60);
    self.myFrame.level:addElement(self.button.back, 30, 90);
    
    --Build Score
    self.myFrame.score:setPosition(x, y);
    self.myFrame.score:addElement(self.background.score, 0, 0);
    self.myFrame.score:addElement(self.button.backToMenu, 30, 0);
    self.myFrame.score:addElement(self.button.retry, 30, 30);
    
    --Build Tutorial
    self.myFrame.tutorial:setPosition(x, y);
    self.myFrame.tutorial:addElement(self.button.tempGo, 30, 0);
end

function Gui:updateGui()
    if Gui.changeFrame then
        self.state[1]:moveIn();
        if self.state[2] ~= nil then 
            self.state[2]:moveOut(); 
        end
        if self.state[1]:onPosition() then
            if self.state[2] ~= nil then self.state[2]:clearFrame(); end
            self:setChangeFrame(false);

        end
    end
end

--This function draws the gui state
function Gui:draw(newFrame)
    Gui:logState(newFrame);
    --self.state[1]:setOffset(0, -600);
    self.state[1]:showFrame()
    self:setChangeFrame(true);

end
function Gui:setChangeFrame(bool)
    Gui.changeFrame = bool;
end

--logging the current state in a table
-- @param actGui The currenet gui state
function Gui:logState(actFrame)
    Gui.state[2] = Gui.state[1];
    Gui.state[1] = actFrame;
end

--checking the gui state and return a boolean
function Gui:drawGame()
    --returns "true" in the InGame-state
    if Gui.state[1] ~= Gui.myFrame.inGame then
        return false;
    else
        return true;
    end
end

--print the state-name and values
function Gui:tempDrawText()
    love.graphics.print(Gui.state[1].name, 0, 0);
    if Gui.state[1] == Gui.myFrame.mainMenu then
        --print(Gui.tempOutput);
        love.graphics.print(Gui.tempOutput, 0, 20);
    end
end

--convert all values into drawable text
--this function is called continuously by the love.draw function
--will be replaced in a later version
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
        "S1 =" .. tostring(_persTable.config.slider1).. "\n" ..
        "S2 =" .. tostring(_persTable.config.slider2).. "\n" ..
        "O1 =" .. tostring(_persTable.config.option1).. "\n" .. 
        "O2 =" .. tostring(_persTable.config.option2).. "\n";
end
--set the state of the gui elements on the defined status
--this function is called exactly once at the beginning of the game
function Gui:loadValues()
    --convert 0, 1 or more in to boolean. A 2 equals multiply checkboxes
    if _persTable.upgrades.speedUp == 1 then
        Gui.checkBox.upgrade1:SetChecked(true);
    end
    if _persTable.upgrades.moneyMult == 1 then
        Gui.checkBox.upgrade2:SetChecked(true);
    end
    if _persTable.upgrades.moreLife == 1 then
        Gui.checkBox.upgrade3:SetChecked(true);
    end
    if _persTable.upgrades.godMode == 1 then
        Gui.checkBox.upgrade4:SetChecked(true);
    end
    if _persTable.upgrades.mapBreakthrough1 == 1 then
        Gui.checkBox.upgrade4:SetChecked(true);
        if _persTable.upgrades.mapBreakthrough2 == 1 then
            Gui.checkBox.upgrade4:SetChecked(true);
        end
    end
    
    Gui.checkBox.option1:SetChecked(_persTable.config.option1);
    Gui.checkBox.option2:SetChecked(_persTable.config.option2);
    Gui.slider.slider1:SetValue(_persTable.config.slider1);
    Gui.slider.slider2:SetValue(_persTable.config.slider2);
    Gui:tempTextOutput();
end

--updates all values which can be chanced by gui elements
--this function is called on every Back-Button clickevent
function Gui:updateValues()
    _persTable.config.option1 = Gui.checkBox.option1:GetChecked();
    _persTable.config.option2 = Gui.checkBox.option2:GetChecked();
    _persTable.config.slider1 = Gui.slider.slider1:GetValue();
    _persTable.config.slider2 = Gui.slider.slider2:GetValue();
    
    --transform the boolean to 0, 1 or more
    if Gui.checkBox.upgrade1:GetChecked() then
        _persTable.upgrades.speedUp = 1;
    else
        _persTable.upgrades.speedUp = 0;
    end
    if Gui.checkBox.upgrade2:GetChecked() then
        _persTable.upgrades.moneyMult = 1;
    else
        _persTable.upgrades.moneyMult = 0;
    end
    if Gui.checkBox.upgrade3:GetChecked() then
        _persTable.upgrades.moreLife = 1;
    else
        _persTable.upgrades.moreLife = 0;
    end
    if Gui.checkBox.upgrade4:GetChecked() then
        _persTable.upgrades.godMode = 1;
    else
        _persTable.upgrades.godMode = 0;
    end
    if Gui.checkBox.upgrade5:GetChecked() then
        _persTable.upgrades.mapBreakthrough1 = 1;
    else
        _persTable.upgrades.mapBreakthrough1 = 0;
    end
    if Gui.checkBox.upgrade6:GetChecked() then
        _persTable.upgrades.mapBreakthrough2 = 1;
    else
        _persTable.upgrades.mapBreakthrough2 = 0;
    end
    Gui:tempTextOutput();
end
--Onclick event of the start button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.start.OnClick = function(obj, x, y)
    if Gui.checkBox.tutorial:GetChecked() then
        Gui:draw(Gui.myFrame.tutorial);
    else
        Gui:draw(Gui.myFrame.level);
    end
end

--Onclick event of the upgrade menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.upgradeMenu.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.upgradeMenu);
end

--Onclick event of the credits button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.credits.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.credits);
end

--Onclick event of the wiki button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.wiki.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.wiki);
end

--Onclick event of the achievements button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.achievements.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.achievements);
end

--Onclick event of the options button
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

--Onclick event of the level 1 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level1.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--Onclick event of the level 2 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level2.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--Onclick event of the level 3 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level3.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--Onclick event of the retry button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.retry.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--Onclick event of the end turn button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
--this function will be replaced in a later version
Gui.button.tempEndTurn.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.score);
end

--Onclick event of the pause button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.pause.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.pause);
end

--Onclick event of the skip tutorial button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
--this function will be replaced in a later version
Gui.button.tempGo.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--Onclick event of the back to menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.backToMenu.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.mainMenu);
end

--Onclick event of the back to game button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.backToGame.OnClick = function(obj, x, y)
    Gui:draw(Gui.myFrame.inGame);
end

--Onclick event of the back button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.back.OnClick = function(obj, x, y)
    if Gui.state[1] == Gui.myFrame.options or Gui.state [1] == Gui.myFrame.upgradeMenu then
        Gui.updateValues();
    end
    Gui:draw(Gui.state[2]);
end

return Gui;