_G.math.inf = 1 / 0

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
Notification = require "class.Notification";

FakeElement = require "Tests.fakeLoveframes.fakeElement";



testClass = require "class.Gui";
describe("Test Gui", function()
    local locInstance;

    before_each(function()
        _G._persTable = {
            winDim = { 480, 900 };
            scaledDeviceDim = { 480, 900 };
            config = {
                bgm = 50;
                music = 50;
                language = "english";
            };
            achievements = {
                test = false;
            };
            upgrades = {
                moreLife = 1;
            };
        };
        _G.data = {
            fishableObjects = {};
            achievements = {
                testAch = {
                    nameOnPersTable = "test";
                    name = "test";
                    description = "testdes";
                    image_lock = "testimage";
                    image_unlock = "testimage";
                };
            };
            upgrades = {};
            languages = {
                english = {
                    language = "english";
                    flagImage = "testimage";
                    package = {
                        credits = {
                            staff = "Staff:";
                            trans = "Translation:";
                            libs = "Libs:";
                            noHWH = "No hamsters were harmed!";
                        };
                    };
                };
                german = {
                    package = {
                        credits = {
                            staff = "Mitwirkende:";
                            trans = "Übersetzung:";
                            libs = "Bibliotheken:";
                            noHWH = "Es kamen keine Hamster zu Schaden.";
                        };
                    };
                };
            };
        };
        _G.love = {
            system = {
                getOS = function(...) return ""; end;
            },
            graphics = {
                newFont = function(...) return {}; end;newImage = function(...) return {
                    getHeight = function (...) return 50 end;
                    getWidth = function (...) return 50 end;
                }
                end;
            }
        };
        _G.Loveframes = {
            Create = function(typeName) return FakeElement(typeName); end;
            util = {
                SetActiveSkin = function(...) end;
            }
        }

        locInstance = testClass();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        for _, v in pairs(myInstance.p_myFrames) do
            v = {};
        end
        for _, v in pairs(locInstance.p_myFrames) do
            v = {};
        end
        locInstance.notification.background = {};
        myInstance.notification.background = {};
        assert.are.same(locInstance.notification, myInstance.notification);
        assert.are.same(locInstance.p_frameChangeActiv, myInstance.p_frameChangeActiv);
        assert.are.same(locInstance.p_states, myInstance.p_states);
        assert.are.same(locInstance.p_textOutput, myInstance.p_textOutput);
    end)

    it("Testing getFrames function", function()
        assert.are.same(locInstance:getFrames(), locInstance.p_myFrames);
    end)

    it("Testing newNotification function", function()
        _G._persTable.config.language = "german";
        _G.data.languages.german = {
            package = {
                testAch = {
                    name = "testAch";
                };
            };
        };

        stub(locInstance.notification, "newNotification");
        locInstance:newNotification("image", "testAch");
        assert.stub(locInstance.notification.newNotification).was_called(1);
    end)

    it("Testing start function", function()
        stub(locInstance, "clearAll");
        stub(locInstance, "changeFrame");
        locInstance:start();
        assert.stub(locInstance.clearAll).was_called();
        assert.stub(locInstance.changeFrame).was_called();
    end)

    it("Testing changeFrame function", function()
        local state = {
            draw = function(...) end;
        }
        locInstance.p_states.currentState = "state1";
        stub(locInstance, "setFrameChangeActivity");
        stub(state, "draw");

        locInstance:changeFrame(state);

        assert.stub(locInstance.setFrameChangeActivity).was_called();
        assert.are.equal(locInstance.p_states.lastState, "state1");
        assert.are.same(locInstance.p_states.currentState, state);
    end)

    it("Testing update function", function()
        local state = {
            onPos = false;
            appear = function(...) end;
            disappear = function(...) end;
            clear = function(...) end;
            update = function(...) end;
            blink = function(...) end;
        };
        function state:checkPosition()
            return self.onPos;
        end

        stub(state, "appear");
        stub(state, "disappear");
        stub(state, "clear");
        stub(state, "blink");
        stub(state, "update");
        stub(locInstance, "setFrameChangeActivity");
        stub(locInstance.notification, "update");
        stub(locInstance, "draw");
        spy.on(state, "checkPosition");
        spy.on(locInstance, "drawGame");

        locInstance.p_frameChangeActiv = true;
        locInstance.p_states.currentState = state;
        locInstance.p_states.lastState = state;
        locInstance.p_myFrames.inGame = state;
        locInstance:update();
        assert.spy(state.checkPosition).was_called();
        assert.stub(state.appear).was_called();
        assert.stub(locInstance.notification.update).was_called();

        state.onPos = true;
        locInstance:update();
        assert.stub(state.appear).was_called();

        locInstance.p_myFrames.inGame = state;
        locInstance.p_states.currentState = state;
        assert.spy(locInstance.drawGame).was_called();
        assert.stub(state.update).was_called();
    end)

    it("testing function setFrameChangeActivity ", function()
        locInstance.p_frameChangeActiv = nil;
        locInstance:setFrameChangeActivity "test";
        assert.are.equal(locInstance.p_frameChangeActiv, "test");
    end);

    it("testing function getLastState ", function()
        locInstance.p_states.lastState = "test";
        assert.are.equal(locInstance:getLastState(), "test");
    end)

    it("testing function clearAll ", function()
        local frame = {
            clear = function(...) end;
        };
        locInstance.p_myFrames = { frame, frame };
        stub(frame, "clear");
        locInstance:clearAll();
        assert.stub(frame.clear).was_called(2);
    end)

    it("testing function drawGame", function()
        locInstance.p_myFrames.inGame = "inGame";
        locInstance.p_states.currentState = "inGame";
        assert.are.equal(locInstance:drawGame(), true);
        locInstance.p_states.currentState = "other";
        assert.are.equal(locInstance:drawGame(), false);
    end)

    it("testing function getCurrentState", function()
        locInstance.p_states.currentState = { name = "test" };
        assert.are.equal(locInstance:getCurrentState(), "test");
    end)

    it("testing function getLevelManager", function()
        locInstance.levMan = "test";
        assert.are.equal(locInstance:getLevelManager(), "test");
    end)

    it("testing function setLevelManager", function()
        locInstance:setLevelManager("test");
        assert.are.equal(locInstance.levMan, "test");
    end)
end)
