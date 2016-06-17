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
                newFont = function(...) return {}; end;
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
        assert.are.same(locInstance, myInstance);
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

    it("Testing changeState function", function()
        locInstance.p_frameChangeActive = nil;
        locInstance.p_states.currentState = "currentStateTestName";
        locInstance.p_currentState = "currentStateTest";
        locInstance.getNewState = function(...) return "newState"; end;
        
        locInstance:changeState("newState");

        assert.are.equal(locInstance.p_frameChangeActive, true);
        assert.are.equal(locInstance.p_states.lastState, "currentStateTestName");
        assert.are.equal(locInstance.p_states.currentState, "newState");
        assert.are.same(locInstance.p_lastState, "currentStateTest");
        assert.are.same(locInstance.p_currentState, "newState");
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
        stub(locInstance.notification, "update");
        spy.on(state, "checkPosition");
        spy.on(locInstance, "drawGame");

        locInstance.p_frameChangeActive = true;
        locInstance.p_currentState = state;
        locInstance.p_lastState = state;
        locInstance:update();
        assert.spy(state.checkPosition).was_called();
        assert.stub(state.appear).was_called();
        assert.stub(locInstance.notification.update).was_called();

        state.onPos = true;
        locInstance:update();
        assert.are.equal(locInstance.p_frameChangeActive, false);
        assert.stub(state.clear).was_called();

        locInstance.p_states.currentState = "Start";
        locInstance:update();
        assert.stub(state.blink).was_called();
        
        locInstance.p_states.currentState = "InGame";
        locInstance:update();
        assert.stub(state.update).was_called();
    end)

    it("testing function getLastState ", function()
        locInstance.p_states.lastState = "test";
        assert.are.equal(locInstance:getLastStateName(), "test");
    end)

    it("testing function drawGame", function()
        locInstance.p_states.currentState = "InGame";
        assert.are.equal(locInstance:drawGame(), true);
        locInstance.p_states.currentState = "other";
        assert.are.equal(locInstance:drawGame(), false);
    end)

    it("testing function getCurrentStateName", function()
        locInstance.p_states.currentState = "test";
        assert.are.equal(locInstance:getCurrentStateName(), "test");
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
