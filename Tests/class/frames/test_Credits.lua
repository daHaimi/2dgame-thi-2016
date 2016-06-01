-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Credits";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";


describe("Unit test for Credits.lua", function()
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
        _G._persTable = {
            scaledDeviceDim = {
                [1] = 500;
                [2] = 500;
            };
        };
        _G.Frame = function(...) return Frame; end;

        locInstance = testClass();
    end)

    it("Testing create function", function()
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
        };

        locInstance:create();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_back.object.OnClick();
        assert.spy(_gui.changeFrame).was.called();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        myInstance.elementsOnFrame.button_back.object.OnClick = {};
        locInstance.elementsOnFrame.button_back.object.OnClick = {};
        assert.are.same(locInstance, myInstance);
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