-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Score";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
Data = require "data";


describe("Unit test for Score.lua", function()
    local locInstance;


    before_each(function()
        _G.love = {
            mouse = {
                setVisible = function(...) end;
            };
        };
        _G.data = Data;
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G._persTable = {
            scaledDeviceDim = {
                [1] = 500;
                [2] = 500;
            };
            config = {
                language = "english";
            };
        };
        _G._tmpTable = {
            earnedMoney = 0;
        }
        _G.Frame = function(...) return Frame; end;
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
            config = {
                language = "english";
            };
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
            config = {
                language = "english";
            };
            scaledDeviceDim = {720, 1024};
        };
        locInstance = testClass();
        local myInstance = testClass();
        locInstance.elementsOnFrame = {};
        myInstance.elementsOnFrame = {};
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing create function", function()
        local table = {
            replayLevel = function(...) end;
            freeManagedObjects = function(...) end;
        }
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeState = function(...) end;
            getLevelManager = function(...) return table end;
        };
        
        stub(table, "replayLevel");
        
        locInstance:create();
        
        spy.on(_G._gui, "changeState");
        locInstance.elementsOnFrame.button_retry.object.OnClick();
        locInstance.elementsOnFrame.button_backToMenu.object.OnClick();
        assert.spy(_gui.changeState).was.called(2);
        assert.stub(table.replayLevel).was.called();
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

end)