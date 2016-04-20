local Gui = {}

-- Local variables
local guiName = "";--Text in the left upper corner
local tempOutput = "";--Output values. Will be replaced later
local state = {"", ""};--The current and last gui state

--Tabel contains all sliders
local slider = { 
    slider1 = Loveframes.Create("slider"):SetText("slider1")
    :SetMinMax(0, 100):SetWidth(80),
    slider2 = Loveframes.Create("slider"):SetText("slider2")
    :SetMinMax(0, 100):SetWidth(80),
};
--Table contains all buttons
local button = {
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
local checkBox = {
    tutorial = Loveframes.Create("checkbox"):SetText("enter tutorial?"),
    upgrade1 = Loveframes.Create("checkbox"):SetText("Speed Up"),
    upgrade2 = Loveframes.Create("checkbox"):SetText("Money Mult"),
    upgrade3 = Loveframes.Create("checkbox"):SetText("More Life"),
    upgrade4 = Loveframes.Create("checkbox"):SetText("God Mode"),
    upgrade5 = Loveframes.Create("checkbox"):SetText("Upgrade 5"),
    option1 = Loveframes.Create("checkbox"):SetText("Option1"),
    option2 = Loveframes.Create("checkbox"):SetText("Option2"),
};
--Tabel contains all gui states and dedicated elements
local elementsOnGui = {
    MainMenu = {checkBox.tutorial, button.start, button.upgradeMenu, 
        button.credits, 
        button.wiki, button.achievements, button.options},
    upgradeMenu = {checkBox.upgrade1, checkBox.upgrade2, checkBox.upgrade3, 
        checkBox.upgrade4, checkBox.upgrade5, button.back},
    credits = {button.back},
    wiki = {button.back},
    achievements = {button.back},
    options = {slider.slider1, slider.slider2, checkBox.option1, 
        checkBox.option2, button.back},
    Pause = {button.backToGame, button.backToMenu, button.options},
    InGame = {button.Pause, button.tempEndTurn},
    level = {button.level1, button.level2, button.level3, button.back},
    tutorial = {button.tempGo},
    Score = {button.backToMenu, button.retry}
};

--logging the current state in a table
-- @param actGui The currenet gui state
function Gui.logState(actGui)
    state[2] = state[1];
    state[1] = actGui;
end

--set the visible of all elements to false
function Gui.clearAll()
    for k, v in pairs(button) do
        v:SetVisible(false);
    end
    for k, v in pairs(checkBox) do
        v:SetVisible(false);
    end
    for k, v in pairs(slider) do
        v:SetVisible(false);
    end
end

--set the visilbe and position of delivered elements
-- @param elements Table contains all elements to be displayed
-- @param xStart Start position of the first element on the x axis
-- @param yStart Start position of the first element on the y axis
-- @param dx The difference between the actual and the previous...
--...element on the x axis
-- @param dy The difference between the actual and the previous...
--...element on the y axis
function Gui.drawElements(elements, xStart, yStart, dx, dy)
    for k,v in ipairs(elements) do
        v:SetPos((xStart + dx * k), (yStart + dy * k));
        v:SetVisible(true);
    end
end

--updates all values which can be chanced by gui elements
--this function is called on every Back-Button clickevent
function Gui.updateValues()
    _persTable.config.option1 = checkBox.option1:GetChecked();
    _persTable.config.option2 = checkBox.option2:GetChecked();
    _persTable.config.slider1 = slider.slider1:GetValue();
    _persTable.config.slider2 = slider.slider2:GetValue();
    
    --transform the boolean to 0, 1 or more
    if checkBox.upgrade1:GetChecked() then
        _persTable.upgrades.speedUp = 1;
    else
        _persTable.upgrades.speedUp = 0;
    end
    if checkBox.upgrade2:GetChecked() then
        _persTable.upgrades.moneyMult = 1;
    else
        _persTable.upgrades.moneyMult = 0;
    end
    if checkBox.upgrade3:GetChecked() then
        _persTable.upgrades.moreLife = 1;
    else
        _persTable.upgrades.moreLife = 0;
    end
    if checkBox.upgrade4:GetChecked() then
        _persTable.upgrades.godMode = 1;
    else
        _persTable.upgrades.godMode = 0;
    end
end

--convert all values into drawable text
--this function is called continuously by the love.draw function
--will be replaced in a later version
function Gui.tempTextOutput()
    if state[1] == "MainMenu" then
        tempOutput = 
        "Upgrades:" .. "\n" ..
        "Speed UP = " .. tostring(_persTable.upgrades.speedUp).. "\n" .. 
        "Money Mult = " .. tostring(_persTable.upgrades.moneyMult).. "\n" .. 
        "More Life = " .. tostring(_persTable.upgrades.moreLife).. "\n" .. 
        "GodMode = " .. tostring(_persTable.upgrades.godMode) .. "\n" .. 
        "\n" ..
        "Options:" .. "\n" .. 
        "S1 =" .. tostring(_persTable.config.slider1).. "\n" ..
        "S2 =" .. tostring(_persTable.config.slider2).. "\n" ..
        "O1 =" .. tostring(_persTable.config.option1).. "\n" .. 
        "O2 =" .. tostring(_persTable.config.option2).. "\n";
    else
        tempOutput = "";
    end
end

--print the state-name and values
function Gui.tempDrawText()
    love.graphics.print(guiName, 10, 10);
    love.graphics.print(tempOutput, 10, 300);
end

--this function set the current state name.
--In a later version it will chance the Background picture
function Gui.drawBackground(actstate)
    guiName = actstate;
end

--set the state of the gui elements on the defined status
--this function is called exactly once at the beginning of the game
function Gui.loadValues()
    --convert 0, 1 or more in to boolean. A 2 equals multiply checkboxes
    if _persTable.upgrades.speedUp == 1 then
        checkBox.upgrade1:SetChecked(true);
    end
    if _persTable.upgrades.moneyMult == 1 then
        checkBox.upgrade2:SetChecked(true);
    end
    if _persTable.upgrades.moreLife == 1 then
        checkBox.upgrade3:SetChecked(true);
    end
    if _persTable.upgrades.godMode == 1 then
        checkBox.upgrade4:SetChecked(true);
    end
    
    checkBox.option1:SetChecked(_persTable.config.option1);
    checkBox.option2:SetChecked(_persTable.config.option2);
    slider.slider1:SetValue(_persTable.config.slider1);
    slider.slider2:SetValue(_persTable.config.slider2);

end

--This function draws the gui state
function Gui.draw(state)
    Gui.logState(state);--logging the new state
    Gui.clearAll();--clears all elements of the old state
    Gui.drawBackground(state);
    if state == "MainMenu" then
        Gui.drawElements(elementsOnGui.MainMenu, 10, 10, 0, 30);
    elseif state == "UpgradeMenu" then
        Gui.drawElements(elementsOnGui.upgradeMenu, 10, 10, 0, 30);
    elseif state == "Credits" then
        Gui.drawElements(elementsOnGui.credits, 10, 10, 0, 30);
    elseif state == "Wiki" then
        Gui.drawElements(elementsOnGui.wiki, 10, 10, 0, 30);
    elseif state == "Achievements" then
        Gui.drawElements(elementsOnGui.achievements, 10, 10, 0, 30);
    elseif state == "Options" then
        Gui.drawElements(elementsOnGui.options, 10, 10, 0, 30);
    elseif state == "Pause" then
        Gui.drawElements(elementsOnGui.Pause, 10, 10, 0, 30);
    elseif state == "InGame" then
        Gui.drawElements(elementsOnGui.InGame, 10, 10, 0, 30);
    elseif state == "Level" then
        Gui.drawElements(elementsOnGui.level, 10, 10, 0, 30);
    elseif state == "Score" then
        Gui.drawElements(elementsOnGui.Score, 10, 10, 0, 30);
    elseif state == "Tutorial" then
        Gui.drawElements(elementsOnGui.tutorial, 10, 10, 0, 30);
    end
end


--checking the gui state and return a boolean
function Gui.drawGame()
    --returns "true" in the InGame-state
    if state[1] == "InGame" then
        return true;
    else
        return false;
    end
end


--Onclick event of the start button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.start.OnClick = function(obj, x, y)
    if checkBox.tutorial:GetChecked() then
        Gui.draw("Tutorial");
    else
        Gui.draw("Level");
    end
end

--Onclick event of the upgrade menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.upgradeMenu.OnClick = function(obj, x, y)
    Gui.draw("UpgradeMenu");
end

--Onclick event of the credits button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.credits.OnClick = function(obj, x, y)
    Gui.draw("Credits");
end

--Onclick event of the wiki button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.wiki.OnClick = function(obj, x, y)
    Gui.draw("Wiki");
end

--Onclick event of the achievements button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.achievements.OnClick = function(obj, x, y)
    Gui.draw("Achievements");
end

--Onclick event of the options button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.options.OnClick = function(obj, x, y)
    Gui.draw("Options");
end

--Onclick event of the level 1 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.level1.OnClick = function(obj, x, y)
    Gui.draw("InGame");
end

--Onclick event of the level 2 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.level2.OnClick = function(obj, x, y)
    Gui.draw("InGame");
end

--Onclick event of the level 3 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.level3.OnClick = function(obj, x, y)
    Gui.draw("InGame");
end

--Onclick event of the retry button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.retry.OnClick = function(obj, x, y)
    Gui.draw("InGame");
end

--Onclick event of the end turn button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
--this function will be replaced in a later version
button.tempEndTurn.OnClick = function(obj, x, y)
    Gui.draw("Score");
end

--Onclick event of the pause button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.Pause.OnClick = function(obj, x, y)
    Gui.draw("Pause");
end

--Onclick event of the skip tutorial button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
--this function will be replaced in a later version
button.tempGo.OnClick = function(obj, x, y)
    Gui.draw("InGame");
end

--Onclick event of the back to menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.backToMenu.OnClick = function(obj, x, y)
    Gui.draw("MainMenu");
end

--Onclick event of the back to game button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.backToGame.OnClick = function(obj, x, y)
    Gui.draw("InGame");
end

--Onclick event of the back button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.back.OnClick = function(obj, x, y)
    if state[1] == "Options" or state [1] == "UpgradeMenu" then
        Gui.updateValues();
    end
     
    --go back to the last gui state
    if state[2] == "MainMenu" then Gui.draw("MainMenu");
    elseif state[2] == "upgradeMenu" then Gui.draw("UpgradeMenu");
    elseif state[2] == "Credits" then Gui.draw("Credits");
    elseif state[2] == "Achievements" then Gui.draw("Achievements");
    elseif state[2] == "Wiki" then Gui.draw("Wiki");
    elseif state[2] == "Options" then Gui.draw("Options");
    elseif state[2] == "InGame" then Gui.draw("InGame");
    elseif state[2] == "Pause" then Gui.draw("Pause");
    elseif state[2] == "Score" then Gui.draw("Score");
    elseif state[2] == "Tutorial" then Gui.draw("Tutorial");
    end
end

return Gui;