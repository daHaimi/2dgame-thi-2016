Loveframes = require "lib.LoveFrames";
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

local Gui = Class {
    init = function(self)
        self.myFrames = {
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
        };
        
        self.p_frameChangeActiv = false;--true if a frame change is activ
        self.p_states = {
            currentState = nil;
            lastState = nil;
        };
        self.p_textOutput = "";
    end;
};

---called in the load function
---clears all frames and starts at the main menu
function Gui:start()
    self:clearAll();
    self:changeFrame(self.myFrames.mainMenu);
end

function Gui:changeFrame(newFrame)
    self:setFrameChangeActivity(true);
    self.p_states.lastState = self.p_states.currentState;
    self.p_states.currentState = newFrame;
    self.p_states.currentState:draw()
end





function Gui:update()
    if self.p_frameChangeActiv then
        if (not self.p_states.currentState:checkPosition()) then
            self.p_states.currentState:appear();
            if self.p_states.lastState ~= nil then
                self.p_states.lastState:disappear();
            end
        else
            if self.p_states.lastState ~= nil then
                self.p_states.lastState:clear();
                self:setFrameChangeActivity(false);
            end
        end
    end
end

function Gui:setFrameChangeActivity(activity)
    self.p_frameChangeActiv = activity;
end

function Gui:getLastState()
    if self.p_states.lastState ~= nil then
        return self.p_states.lastState;
    end
end


---set the visible of all frames to false
function Gui:clearAll()
    for k, v in pairs(self.myFrames) do
        v:clear(false);
    end
end

---checking the gui state and return a boolean
function Gui:drawGame()
    --returns "true" in the InGame-state
    if self.p_states.currentState ~= self.myFrames.inGame then
        return false;
    else
        return true;
    end
end

---print the state-name and values
function Gui:tempDrawText()
    love.graphics.print(self.p_states.currentState.name, 0, 0);
    if self.p_states.currentState == self.myFrames.mainMenu then
        self:tempTextOutput();
        love.graphics.print(self.p_textOutput, 0, 20);
    end
end

---convert all values into drawable text
---this function is called continuously by the love.draw function
---will be replaced in a later version
function Gui:tempTextOutput()
    self.p_textOutput = 
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
--[[

---set the state of the gui elements on the defined status
---this function is called exactly once at the beginning of the game
function Gui:loadValues()

    Gui.slider.bgm:SetValue(_persTable.config.bgm);
    Gui.slider.music:SetValue(_persTable.config.music);
    Gui:tempTextOutput();
end


---updates all values which can be chanced by gui elements
---this function is called on every Back-Button clickevent
function Gui:updateValues()
    _persTable.config.bgm = Gui.slider.bgm:GetValue();
    _persTable.config.music = Gui.slider.music:GetValue();
    --transform the boolean to 0, 1 or more
    
end

function Gui:getCurrentState()
    return Gui.state[1];
end
]]--
return Gui;
