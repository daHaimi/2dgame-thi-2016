-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.inGame";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";


describe("Unit test for inGame.lua", function()
    local locInstance;

    before_each(function()
        _G.love = {
            mouse = {
                setVisible = function(...) end;
                setGrabbed = function(...) end;
            },
            system = {
                getOS = function(...) return ""; end;
            }
        };
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G._persTable = {
            upgrades = {
                moreLife = 1;
            };
            scaledDeviceDim = {
                [1] = 500;
                [2] = 500;
            };
            winDim = {1, 2};
        };
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
            upgrades = {
                moreLife = 1;
            },
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
            upgrades = {
                moreLife = 1;
            },
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
        };
        
        locInstance:create();
    end)

    it("Testing draw function", function()
        _G._gui = {
            myFrames = {
                pause = "teststring";
            };
            getLastState = function(...) return _G._gui.myFrames.pause; end;
        };
        _gui.getFrames = function(...) return _G._gui.myFrames; end;
        stub(locInstance.elementsOnFrame.healthbar.object, "SetVisible");
        stub(locInstance.elementsOnFrame.pause.object, "SetVisible");
        locInstance:draw();
        assert.stub(locInstance.elementsOnFrame.healthbar.object.SetVisible).was_called(1);
        assert.stub(locInstance.elementsOnFrame.pause.object.SetVisible).was_called(1);
    end)

    it("Testing activate function", function()
        stub(locInstance.frame, "draw");
        locInstance:activate();
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
        stub(love.mouse, "setVisible");

        locInstance:appear();
        assert.stub(locInstance.frame.appear).was_called(1);
        assert.stub(love.mouse.setVisible).was_called(1);
    end)

    it("Testing disappear function", function()
        stub(locInstance.frame, "disappear");
        stub(love.mouse, "setGrabbed");
        
        locInstance:disappear();
        assert.stub(locInstance.frame.disappear).was_called(1);
        assert.stub(love.mouse.setGrabbed).was_called(1);
    end)

    it("Testing checkPosition function", function()
        stub(locInstance.frame, "checkPosition");
        locInstance:checkPosition();
        assert.stub(locInstance.frame.checkPosition).was_called(1);
    end)

end)