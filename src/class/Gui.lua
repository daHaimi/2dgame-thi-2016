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
        Loveframes.config["ACTIVESKIN"] = "ShitSkin"
        --Loveframes.util.SetActiveSkin();
        self.p_myFrames = {
            achievements = Achievements();
            mainMenu = Mainmenu();
            options = Options();
            upgradeMenu = UpgradeMenu();
            dictionary = Dictionary();
            credits = Credits();
            score = Score();
            pause = Pause();
            level = ChooseLevel();
            inGame = InGame();
            start = Start();
        };
        self.p_frameChangeActiv = false;--true if a frame change is activ
        self.p_states = {
            currentState = nil;
            lastState = nil;
        };
        self.p_textOutput = "";
        self.notification = Notification();

    end;
    levMan = nil;
}

function Gui:setLanguage()
    local language = _G._persTable.config.language;
    for k, v in pairs(self.p_myFrames) do
        if (v.setLanguage ~= nil) then
            v:setLanguage(language);
        end
    end
end

---return all frames
function Gui:getFrames()
    return self.p_myFrames;
end

---creates new notification
function Gui:newNotification(image, text)
    self.notification:newNotification(image, text);
end

---called in the load function
---clears all frames and starts at the main menu
function Gui:start()
    self:clearAll();
    self:setLanguage();
    self:changeFrame(self.p_myFrames.start);    
end

---called to draw a new frame
--@parm: newFrame: the frame which should be draw
function Gui:changeFrame(newFrame)
    self:setFrameChangeActivity(true);
    self.p_states.lastState = self.p_states.currentState;
    self.p_states.currentState = newFrame;
    self.p_states.currentState:draw();
end

---updates the gui. called in the love.update function
function Gui:update()
    if self.p_frameChangeActiv then
        if (not self.p_states.currentState:checkPosition()) then
            self.p_states.currentState:appear();
            if self.p_states.lastState ~= nil then
                self.p_states.lastState:disappear();
            end
        else
            self.p_states.currentState:appear();
            self:setFrameChangeActivity(false);
            if self.p_states.lastState ~= nil then
                self.p_states.lastState:clear();
            end
        end
    end
    if self.p_states.currentState == self.p_myFrames.start then
        self.p_myFrames.start:blink();
    end
    
    if self:drawGame() then
        self.p_myFrames.inGame:update();
    end
    self.notification:update();
end

---Set to start the flyIn/Out of the frames
function Gui:setFrameChangeActivity(activity)
    self.p_frameChangeActiv = activity;
end

---returns te last state. needed for  the back button
function Gui:getLastState()
    if self.p_states.lastState ~= nil then
        return self.p_states.lastState;
    end
end

---set the visible of all frames to false
function Gui:clearAll()
    for k, v in pairs(self.p_myFrames) do
        v:clear(false);
    end
end

---checking the gui state and return a boolean
function Gui:drawGame()
    --returns "true" in the InGame-state
    if self.p_states.currentState ~= self.p_myFrames.inGame then
        return false;
    else
        return true;
    end
end

--- Returns the current game state.
-- @return Returns the current game state.
function Gui:getCurrentState()
    return self.p_states.currentState.name;
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