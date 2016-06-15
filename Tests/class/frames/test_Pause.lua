-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Pause";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";


describe("Unit test for Pause.lua", function()
    local locInstance;


    before_each(function()
        _G.love = {
            mouse = {
                setVisible = function(...) end;
            };
        };
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G.Frame = function(...) return Frame; end;
        _G._persTable = {
            scaledDeviceDim = {
                [1] = 500;
                [2] = 500;
            };
        };
        locInstance = testClass();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        locInstance.elementsOnFrame = {};
        myInstance.elementsOnFrame = {};
        assert.are.same(locInstance, myInstance);
    end)

it("Testing Constructor", function()
        _G._persTable = {
            scaledDeviceDim = {640, 950};
        };
        locInstance = testClass();
        local myInstance = testClass();
        locInstance.elementsOnFrame = {};
        myInstance.elementsOnFrame = {};
        assert.are.same(locInstance, myInstance);
    end)

it("Testing Constructor", function()
        _G._persTable = {
            scaledDeviceDim = {720, 1024};
        };
        locInstance = testClass();
        local myInstance = testClass();
        locInstance.elementsOnFrame = {};
        myInstance.elementsOnFrame = {};
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing create function", function()
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
            getLevelManager = function(...) return {
                freeManagedObjects = function(...) end;
                
            } end;
        };
        stub(locInstance, "checkAchRageQuit");
        locInstance:create();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_backToGame.object.OnClick();
        locInstance.elementsOnFrame.button_backToMenu.object.OnClick();
        locInstance.elementsOnFrame.button_changeLevel.object.OnClick();
        locInstance.elementsOnFrame.button_options.object.OnClick();
        assert.spy(_gui.changeFrame).was.called(4);
        assert.stub(locInstance.checkAchRageQuit).was.called(1);
    end)

    it("Testing draw function", function()
        stub(locInstance.frame, "draw");
        locInstance:draw();
        assert.stub(locInstance.frame.draw).was_called(1);
    end)

    it("Testing clear function", function()
        stub(locInstance.frame, "clear");
        locInstance.elementsOnFrame = "test"
        locInstance:clear();
        assert.stub(locInstance.frame.clear).was_called(1);
    end)

    it("Testing appear function", function()
        stub(locInstance.frame, "appear");
        locInstance:appear();
        assert.stub(locInstance.frame.appear).was_called(1);
    end)

    it("Testing disappear function", function()
        stub(locInstance.frame, "disappear");
        locInstance:disappear();
        assert.stub(locInstance.frame.disappear).was_called(1);
    end)

    it("Testing checkPosition function", function()
        stub(locInstance.frame, "checkPosition");
        locInstance:checkPosition();
        assert.stub(locInstance.frame.checkPosition).was_called(1);
    end)

    it("Testing checkAchRageQuit function", function()
        local rq = false;
        local ab = false;
        _G._persTable.achievements = {};
        _G._persTable.phase = 2;
        _G._gui = {
            getLevelManager = function(...) return {
                getCurLevel = function(...) return {
                    getReachedDepth = function(...) return -500 end;
                } end;
                getAchievmentManager = function(...) return {
                    checkRageQuit = function(...) rq = true end;
                    achBitch = function(...) ab = true end;
                } end;
            } end;
        };

        locInstance:checkAchRageQuit();
        assert.are.same(true, rq);
        assert.are.same(true, ab);
    end)
end)