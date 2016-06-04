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
           scaledDeviceDim = {480, 900};
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
                };
            };
       };
       _G.Loveframes = {
           Create = function(typeName) return FakeElement(typeName); end;
       }
        locInstance = testClass();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        for k, v in pairs (myInstance.p_myFrames) do
            v.elementsOnFrame = {};
        end
        for k, v in pairs (locInstance.p_myFrames) do
            v.elementsOnFrame = {};
        end
            assert.are.same(locInstance, myInstance);
    end)

    it("Testing getFrames function", function()
        assert.are.same(locInstance:getFrames(), locInstance.p_myFrames);
    end)
    
    it("Testing newNotification function", function()
        stub(locInstance.notification, "newNotification");
        locInstance:newNotification("image", "text");
        assert.stub(locInstance.notification.newNotification).was_called();
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
        assert.stub(state.draw).was_called();
    end)

    it("Testing update function", function()
        local state = {
            onPos = false;
            appear = function(...) end;
            disappear = function(...) end;
            clear = function(...) end;
            update = function(...) end;
        };
        function state:checkPosition() 
            return self.onPos; 
        end;
       
        
        stub(state, "appear");
        stub(state, "disappear");
        stub(state, "clear");
        stub(locInstance, "setFrameChangeActivity");
        stub(locInstance.notification, "update");
        spy.on(state, "checkPosition");
        
        locInstance.p_frameChangeActiv = true;
        locInstance.p_states.currentState = state;
        locInstance.p_states.lastState = state;
        locInstance.p_myFrames.inGame = state;
        locInstance:update();
        assert.spy(state.checkPosition).was_called();
        assert.stub(state.appear).was_called();
        assert.stub(locInstance.notification.update).was_called();
        ---coming soon
    end)
    it("testing function clearAll ", function()
        local frame = {
            clear = function(...) end;
        }
        locInstance.p_myFrames = {frame, frame};
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
        locInstance.p_states.currentState = { name = "test"};
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
