local Gui = {}

-- Local variables
local guiName = "";--Text in the left upper corner
local tempOutput = "";--Output values. Will be replaced later
local state = {"", ""};--The current and last gui state
--All Values you can chance over the gui
--This values need a interface to persTable!!!
local outputValues = {
    options = {slider1 = 50, slider2 = 0, option1 = true, option2 = false},
    upgrades = {upgrade1 = false, upgrade2 = true, upgrade3 = false, 
        upgrade4 = false, upgrade5 = false},
    tutorial = false
};
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
    upgrade1 = Loveframes.Create("checkbox"):SetText("upgrade 1"),
    upgrade2 = Loveframes.Create("checkbox"):SetText("upgrade 2"),
    upgrade3 = Loveframes.Create("checkbox"):SetText("upgrade 3"),
    upgrade4 = Loveframes.Create("checkbox"):SetText("upgrade 4"),
    upgrade5 = Loveframes.Create("checkbox"):SetText("upgrade 5"),
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
function Gui.logMe(actGui)
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
--this function is called continuously by the love.update function
function Gui.checkValues()
    outputValues.options.option1 = checkBox.option1:GetChecked();
    outputValues.options.option2 = checkBox.option2:GetChecked();
    outputValues.options.slider1 = slider.slider1:GetValue();
    outputValues.options.slider2 = slider.slider2:GetValue();
    
    outputValues.upgrades.upgrade1 = checkBox.upgrade1:GetChecked();
    outputValues.upgrades.upgrade2 = checkBox.upgrade2:GetChecked();
    outputValues.upgrades.upgrade3 = checkBox.upgrade3:GetChecked();
    outputValues.upgrades.upgrade4 = checkBox.upgrade4:GetChecked();
    outputValues.upgrades.upgrade5 = checkBox.upgrade5:GetChecked();
end

--convert all values on a specific state into drawable text
--this function is called continuously by the love.draw function
--will be replaced in a later version
function Gui.tempTextOutput()
    if state[1] == "upgradeMenu" then
        tempOutput = 
        "C1 =" .. tostring(outputValues.upgrades.upgrade1).. "\n" .. 
        "C2 =" .. tostring(outputValues.upgrades.upgrade2).. "\n" .. 
        "C3 =" .. tostring(outputValues.upgrades.upgrade3).. "\n" .. 
        "C4 =" .. tostring(outputValues.upgrades.upgrade4).. "\n" .. 
        "C5 =" .. tostring(outputValues.upgrades.upgrade5);
    elseif state[1] == "Options" then
        tempOutput =
        "S1 =" .. tostring(outputValues.options.slider1).. "\n" ..
        "S2 =" .. tostring(outputValues.options.slider2).. "\n" ..
        "O1 =" .. tostring(outputValues.options.option1).. "\n" .. 
        "O2 =" .. tostring(outputValues.options.option2).. "\n";
    elseif state[1] == "MainMenu" then
        outputValues.tutorial = checkBox.tutorial:GetChecked();
        tempOutput = "Tutorial =" .. tostring(checkBox.tutorial:GetChecked());
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
    checkBox.option1:SetChecked(outputValues.options.option1);
    checkBox.option2:SetChecked(outputValues.options.option2);
    slider.slider1:SetValue(outputValues.options.slider1);
    slider.slider2:SetValue(outputValues.options.slider2);
    
    checkBox.upgrade1:SetChecked(outputValues.upgrades.upgrade1);
    checkBox.upgrade2:SetChecked(outputValues.upgrades.upgrade2);
    checkBox.upgrade3:SetChecked(outputValues.upgrades.upgrade3);
    checkBox.upgrade4:SetChecked(outputValues.upgrades.upgrade4);
    checkBox.upgrade5:SetChecked(outputValues.upgrades.upgrade5);
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
--build the main menu screen
function Gui.mainMenu ()
    Gui.logMe("MainMenu");
    Gui.clearAll();
    Gui.drawBackground("MainMenu");
    Gui.drawElements(elementsOnGui.MainMenu, 10, 10, 0, 30);
end

--build the upgrade menu screen
function Gui.upgradeMenu ()
    Gui.logMe("upgradeMenu");
    Gui.clearAll();
    Gui.drawBackground("upgradeMenu");
    Gui.drawElements(elementsOnGui.upgradeMenu, 10, 10, 0, 30);
end

--build the credits screen
function Gui.credits ()
    Gui.logMe("Credits");
    Gui.clearAll();
    Gui.drawBackground("Credits");
    Gui.drawElements(elementsOnGui.credits, 10, 10, 0, 30);
end

--build the wiki screen
function Gui.wiki ()
    Gui.logMe("Wiki");
    Gui.clearAll();
    Gui.drawBackground("Wiki");
    Gui.drawElements(elementsOnGui.wiki, 10, 10, 0, 30);
end

--build the achievements screen
function Gui.achievements ()
    Gui.logMe("Achievements");
    Gui.clearAll();
    Gui.drawBackground("Achievements");
    Gui.drawElements(elementsOnGui.achievements, 10, 10, 0, 30);
end

--build the options screen
function Gui.options ()
    Gui.logMe("Options");
    Gui.clearAll();
    Gui.drawBackground("Options");
    Gui.drawElements(elementsOnGui.options, 10, 10, 0, 30);
end

--build the pause screen
function Gui.Pause ()
    Gui.logMe("Pause");
    Gui.clearAll();
    Gui.drawBackground("Pause");
    Gui.drawElements(elementsOnGui.Pause, 10, 10, 0, 30);
end

--build the InGame screen (only the name and buttons)
function Gui.InGame ()
    Gui.logMe("InGame");
    Gui.clearAll();
    Gui.drawBackground("InGame");
    Gui.drawElements(elementsOnGui.InGame, 10, 10, 0, 30);
end

--build the change level screen
function Gui.level ()
    Gui.logMe("Level");
    Gui.clearAll();
    Gui.drawBackground("Level");
    Gui.drawElements(elementsOnGui.level, 10, 10, 0, 30);
end

--build the score screen
function Gui.Score ()
    Gui.logMe("Score");
    Gui.clearAll();
    Gui.drawBackground("Score");
    Gui.drawElements(elementsOnGui.Score, 10, 10, 0, 30);
end

--build the tutorial screen
function Gui.tutorial()
    Gui.logMe("Tutorial");
    Gui.clearAll();
    Gui.drawBackground("Tutorial");
    Gui.drawElements(elementsOnGui.tutorial, 10, 10, 0, 30);
end

--Onclick event of the start button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.start.OnClick = function(obj, x, y)
    if outputValues.tutorial == true then
        Gui.tutorial();
    else
        Gui.level();
    end
end

--Onclick event of the upgrade menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.upgradeMenu.OnClick = function(obj, x, y)
    Gui.upgradeMenu();
end

--Onclick event of the credits button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.credits.OnClick = function(obj, x, y)
    Gui.credits();
end

--Onclick event of the wiki button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.wiki.OnClick = function(obj, x, y)
    Gui.wiki();
end

--Onclick event of the achievements button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.achievements.OnClick = function(obj, x, y)
    Gui.achievements();
end

--Onclick event of the options button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.options.OnClick = function(obj, x, y)
    Gui.options();
end

--Onclick event of the level 1 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.level1.OnClick = function(obj, x, y)
    Gui.InGame();
end

--Onclick event of the level 2 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.level2.OnClick = function(obj, x, y)
    Gui.InGame();
end

--Onclick event of the level 3 button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.level3.OnClick = function(obj, x, y)
    Gui.InGame();
end

--Onclick event of the retry button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.retry.OnClick = function(obj, x, y)
    Gui.InGame();
end

--Onclick event of the end turn button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
--this function will be replaced in a later version
button.tempEndTurn.OnClick = function(obj, x, y)
    Gui.Score();
end

--Onclick event of the pause button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.Pause.OnClick = function(obj, x, y)
    Gui.Pause();
end

--Onclick event of the skip tutorial button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
--this function will be replaced in a later version
button.tempGo.OnClick = function(obj, x, y)
    Gui.InGame();
end

--Onclick event of the back to menu button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.backToMenu.OnClick = function(obj, x, y)
    Gui.mainMenu();
end

--Onclick event of the back to game button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.backToGame.OnClick = function(obj, x, y)
    Gui.InGame();
end

--Onclick event of the back button
-- @param obj The clicked button object
-- @param x The mouse position on the x axis
-- @param y The mouse position on the y axis
button.back.OnClick = function(obj, x, y)
    --go back to the last gui state
    if state[2] == "MainMenu" then Gui.mainMenu();
    elseif state[2] == "upgradeMenu" then Gui.upgradeMenu();
    elseif state[2] == "Credits" then Gui.credits();
    elseif state[2] == "Achievements" then Gui.achievements();
    elseif state[2] == "Wiki" then Gui.wiki();
    elseif state[2] == "Options" then Gui.options();
    elseif state[2] == "InGame" then Gui.InGame();
    elseif state[2] == "Pause" then Gui.Pause();
    elseif state[2] == "Score" then Gui.Score();
    elseif state[2] == "Tutorial" then Gui.tutorial();
    end
end

return Gui;