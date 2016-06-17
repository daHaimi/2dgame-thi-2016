Class = require "lib.hump.class";

Mainmenu = require "class.frames.MainMenu";
Achievements = require "class.frames.Achievements";
Options = require "class.frames.Options";
UpgradeMenu = require "class.frames.UpgradeMenu";
Dictionary = require "class.frames.Dictionary";
Credits = require "class.frames.Credits";
Score = require "class.frames.Score";
Pause = require "class.frames.Pause";
ChooseLevel = require "class.frames.Level";
InGame = require "class.frames.inGame";
Start = require "class.frames.Start";
Notification = require "class.Notification";

local Gui = Class {
    init = function(self)
        Loveframes.util.SetActiveSkin("ShitSkin");--set the shit skin (custom font, custom slider)
        self.p_currentState = nil; --instance of the actuel state
        self.p_lastState = nil;
        self.p_frameChangeActive = false; --true if a frame change is active
        self.p_states = { --name of the actuel and last state
            currentState = nil;
            lastState = nil;
        };
        self.notification = Notification();
    end;
    levMan = nil;
    achMan = nil;
}

--- creates new notification
-- @param image The image of the unlocked achievement.
-- @param achName The name in the persistence table of the achivement.
function Gui:newNotification(image, achName)
    if _G._persTable.config.language == "german" then
        self.notification:newNotification(image, _G.data.languages.german.package[achName].name);
    else
        self.notification:newNotification(image, _G.data.languages.english.package[achName].name);
    end
end

--- creates new text notification
-- @param: image path of the shown image
-- @param: text string of the shown text
function Gui:newTextNotification(image, text)
    self.notification:newNotification(image, text);
end

--- called to draw a new screen
-- @parm : newState: Name of the screen which should be draw
function Gui:changeState(newState)
    self.p_frameChangeActive = true;--activates the screen moving animation
    --refresh the states table
    self.p_states.lastState = self.p_states.currentState;
    self.p_states.currentState = newState;
    --refresh the states (instances)
    self.p_lastState = self.p_currentState;
    self.p_currentState = self:getNewState(newState);
end

---creates new state 
-- @parm : newState name of the new state
function Gui:getNewState(newState)
    if newState == "Achievements" then
        return Achievements();
    elseif newState == "Credits" then
        return Credits();
    elseif newState == "Dictionary" then
        return Dictionary();
    elseif newState == "InGame" then
        return InGame();
    elseif newState == "Level" then
        return ChooseLevel();
    elseif newState == "MainMenu" then
        return Mainmenu();
    elseif newState == "Options" then
        return Options();
    elseif newState == "Pause" then
        return Pause();
    elseif newState == "Score" then
        return Score();
    elseif newState == "Start" then
        return Start();
    elseif newState == "UpgradeMenu" then
        return UpgradeMenu();
    else
        print("Error: check state name");
        return "MainMenu";
    end
end

--- updates the gui. called in the love.update function
function Gui:update()
    --controls the fly in/out animation
    if self.p_frameChangeActive then
        if (not self.p_currentState:checkPosition()) then
            self.p_currentState:appear();
            if self.p_lastState ~= nil then
                self.p_lastState:disappear();
            end
        else
            self.p_frameChangeActive = false;
            if self.p_lastState ~= nil then
                self.p_lastState:clear();
            end
        end
    end
    --blinks the "click to start" label on the start screen
    if self.p_states.currentState == "Start" then
        self.p_currentState:blink();
    end
    --controls the fuelbar and ingame score (depth)
    if self.p_states.currentState == "InGame" then
        self.p_currentState:update();
    end
    --shows the notification if needed
    self.notification:update();
end

--- returns the name of last state. needed for  the back button
function Gui:getLastStateName()
    if self.p_states.lastState ~= nil then
        return self.p_states.lastState;
    end
end

--- Returns the name of the current game state.
function Gui:getCurrentStateName()
    return self.p_states.currentState;
end

--returns the object of the current state
function Gui:getCurrentState()
    return self.p_currentState;
end

--- checking the gui state and return a boolean
function Gui:drawGame()
    --returns "true" in the InGame-state
    if self.p_states.currentState ~= "InGame" then
        return false;
    else
        return true;
    end
end



--- Returns the reference to the LevelManager object.
-- @return Returns the reference to the LevelManager object.
function Gui:getLevelManager()
    return self.levMan;
end

--- Set the reference to the LevelManager object.
-- @param levelManager The reference to the LevelManager object.
function Gui:setLevelManager(levelManager)
    self.levMan = levelManager;
end

return Gui;
