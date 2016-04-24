local Gui = Class {
    init = function(self)
        Gui:loadValues();
        Gui:clearAll();
        Gui:draw("MainMenu");
    end;
    
    guiName = "";--Text in the left upper corner
    tempOutput = "";--Output values on the Main Menu. Will be replaced later
    state = {"", ""};--The current and last gui state

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
        start = Loveframes.Create("button"):SetText("Start game"),
        level1 = Loveframes.Create("button"):SetText("Level 1"),
        level2 = Loveframes.Create("button"):SetText("Level 2"),
        level3 = Loveframes.Create("button"):SetText("Level 3"),
        retry = Loveframes.Create("button"):SetText("Retry"),
        Pause = Loveframes.Create("button"):SetText("Pause"),
        tempEndTurn = Loveframes.Create("button"):SetText("End turn"),
        tempGo = Loveframes.Create("button"):SetText("Skip tutorial"),
        backToMenu = Loveframes.Create("button"):SetText("Back to menu"),
        backToGame = Loveframes.Create("button"):SetText("Back to game")
    };
    --Table contains all checkboxes
    checkBox = {
        tutorial = Loveframes.Create("checkbox"):SetText("enter tutorial?"),
        upgrade1 = Loveframes.Create("checkbox"):SetText("Speed Up"),
        upgrade2 = Loveframes.Create("checkbox"):SetText("Money Mult"),
        upgrade3 = Loveframes.Create("checkbox"):SetText("More Life"),
        upgrade4 = Loveframes.Create("checkbox"):SetText("God Mode"),
        upgrade5 = Loveframes.Create("checkbox"):SetText("Upgrade 5"),
        option1 = Loveframes.Create("checkbox"):SetText("Option1"),
        option2 = Loveframes.Create("checkbox"):SetText("Option2"),
    };
};

--set the visible of all elements to false
function Gui:clearAll()
    for k, v in pairs(Gui.button) do v:SetVisible(false); end
    for k, v in pairs(Gui.checkBox) do v:SetVisible(false); end
    for k, v in pairs(Gui.slider) do v:SetVisible(false); end
end

--set the visilbe and position of delivered elements
-- @param elements Table contains all elements to be displayed
-- @param xStart Start position of the first element on the x axis
-- @param yStart Start position of the first element on the y axis
-- @param dx The difference between the actual and the previous...
--...element on the x axis
-- @param dy The difference between the actual and the previous...
--...element on the y axis
function Gui:drawElements(elements, xStart, yStart, dx, dy)
    for k,v in ipairs(elements) do
        v:SetPos((xStart + dx * k), (yStart +  dy * k));
        v:SetVisible(true);
    end
end

--this function set the current state name.
--In a later version it will chance the Background picture
function Gui:drawBackground(actstate)
    Gui.guiName = actstate;
end

--print the state-name and values
function Gui:tempDrawText()
    love.graphics.print(Gui.guiName, 10, 10);
    love.graphics.print(Gui.tempOutput, 10, 300);
end

--logging the current state in a table
-- @param actGui The currenet gui state
function Gui:logState(actGui)
    Gui.state[2] = Gui.state[1];
    Gui.state[1] = actGui;
end

--convert all values into drawable text
--this function is called continuously by the love.draw function
--will be replaced in a later version
function Gui:tempTextOutput()
    if Gui.state[1] == "MainMenu" then
        Gui.tempOutput = 
            "_persTable.upgrades:" .. "\n" ..
            "Speed UP = " .. tostring(_persTable.upgrades.speedUp).. "\n" .. 
            "Money Mult = " .. tostring(_persTable.upgrades.moneyMult).. "\n" .. 
            "More Life = " .. tostring(_persTable.upgrades.moreLife).. "\n" .. 
            "GodMode = " .. tostring(_persTable.upgrades.godMode) .. "\n" .. 
            "\n" ..
            "_persTable.config" .. "\n" .. 
            "S1 =" .. tostring(_persTable.config.slider1).. "\n" ..
            "S2 =" .. tostring(_persTable.config.slider2).. "\n" ..
            "O1 =" .. tostring(_persTable.config.option1).. "\n" .. 
            "O2 =" .. tostring(_persTable.config.option2).. "\n";
    else
        Gui.tempOutput = "";
    end
end

--This function draws the gui state
function Gui:draw(state)
    local elements = {};
    
    if state == "MainMenu" then
        elements ={
            Gui.checkBox.tutorial,
            Gui.button.start,
            Gui.button.upgradeMenu, 
            Gui.button.credits, 
            Gui.button.wiki, 
            Gui.button.achievements, 
            Gui.button.options}
    elseif state == "UpgradeMenu" then
        elements ={
            Gui.checkBox.upgrade1,
            Gui.checkBox.upgrade2,
            Gui.checkBox.upgrade3, 
            Gui.checkBox.upgrade4,
            Gui.checkBox.upgrade5,
            Gui.button.back}
    elseif state == "Credits" then
        elements ={Gui.button.back}
    elseif state == "Wiki" then
        elements ={Gui.button.back}
    elseif state == "Achievements" then
        elements ={Gui.button.back}
    elseif state == "Options" then
        elements ={
            Gui.slider.slider1,
            Gui.slider.slider2,
            Gui.checkBox.option1, 
            Gui.checkBox.option2,
            Gui.button.back}
    elseif state == "Pause" then
        elements ={
            Gui.button.backToGame,
            Gui.button.backToMenu,
            Gui.button.options}
    elseif state == "InGame" then
        elements ={
            Gui.button.Pause,
            Gui.button.tempEndTurn}
    elseif state == "Level" then
        elements ={
            Gui.button.level1,
            Gui.button.level2,
            Gui.button.level3,
            Gui.button.back}
    elseif state == "Score" then
        elements ={
            Gui.button.backToMenu,
            Gui.button.retry}
    elseif state == "Tutorial" then
        elements ={Gui.button.tempGo}
    end
    
    Gui:logState(state);--logging the new state
    Gui:clearAll();--clears all elements of the old state
    Gui:drawBackground(state);
    Gui:drawElements(elements, 10, 10, 0, 30);
end

--checking the gui state and return a boolean
function Gui:drawGame()
    --returns "true" in the InGame-state
    if Gui.state[1] == "InGame" then
        return true;
    else
        return false;
    end
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
    
    Gui.checkBox.option1:SetChecked(_persTable.config.option1);
    Gui.checkBox.option2:SetChecked(_persTable.config.option2);
    Gui.slider.slider1:SetValue(_persTable.config.slider1);
    Gui.slider.slider2:SetValue(_persTable.config.slider2);
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
end

--Onclick event of the start button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.start.OnClick = function(obj, x, y)
    if Gui.checkBox.tutorial:GetChecked() then
        Gui:draw("Tutorial");
    else
        Gui:draw("Level");
    end
end

--Onclick event of the upgrade menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.upgradeMenu.OnClick = function(obj, x, y)
    Gui:draw("UpgradeMenu");
end

--Onclick event of the credits button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.credits.OnClick = function(obj, x, y)
    Gui:draw("Credits");
end

--Onclick event of the wiki button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.wiki.OnClick = function(obj, x, y)
    Gui:draw("Wiki");
end

--Onclick event of the achievements button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.achievements.OnClick = function(obj, x, y)
    Gui:draw("Achievements");
end

--Onclick event of the options button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.options.OnClick = function(obj, x, y)
    Gui:draw("Options");
end

--Onclick event of the level 1 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level1.OnClick = function(obj, x, y)
    Gui:draw("InGame");
end

--Onclick event of the level 2 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level2.OnClick = function(obj, x, y)
    Gui:draw("InGame");
end

--Onclick event of the level 3 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.level3.OnClick = function(obj, x, y)
    Gui:draw("InGame");
end

--Onclick event of the retry button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.retry.OnClick = function(obj, x, y)
    Gui:draw("InGame");
end

--Onclick event of the end turn button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
--this function will be replaced in a later version
Gui.button.tempEndTurn.OnClick = function(obj, x, y)
    Gui:draw("Score");
end

--Onclick event of the pause button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.Pause.OnClick = function(obj, x, y)
    Gui:draw("Pause");
end

--Onclick event of the skip tutorial button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
--this function will be replaced in a later version
Gui.button.tempGo.OnClick = function(obj, x, y)
    Gui:draw("InGame");
end

--Onclick event of the back to menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.backToMenu.OnClick = function(obj, x, y)
    Gui:draw("MainMenu");
end

--Onclick event of the back to game button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.backToGame.OnClick = function(obj, x, y)
    Gui:draw("InGame");
end

--Onclick event of the back button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
Gui.button.back.OnClick = function(obj, x, y)
    if Gui.state[1] == "Options" or Gui.state [1] == "UpgradeMenu" then
        Gui.updateValues();
    end
    --go back to the last gui state
    if Gui.state[2] == "MainMenu" then Gui:draw("MainMenu");
    elseif Gui.state[2] == "upgradeMenu" then Gui:draw("UpgradeMenu");
    elseif Gui.state[2] == "Credits" then Gui:draw("Credits");
    elseif Gui.state[2] == "Achievements" then Gui:draw("Achievements");
    elseif Gui.state[2] == "Wiki" then Gui:draw("Wiki");
    elseif Gui.state[2] == "Options" then Gui:draw("Options");
    elseif Gui.state[2] == "InGame" then Gui:draw("InGame");
    elseif Gui.state[2] == "Pause" then Gui:draw("Pause");
    elseif Gui.state[2] == "Score" then Gui:draw("Score");
    elseif Gui.state[2] == "Tutorial" then Gui:draw("Tutorial");
    end
end

return Gui;