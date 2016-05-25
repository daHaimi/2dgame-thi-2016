-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Dictionary";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
KlickableElement = require "class.KlickableElement";


describe("Unit test for Dictionary.lua", function()
    local locInstance;


    before_each(function()
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G.data = {
            fishableObjects = {};
        }
        
        _G.Frame = function(...) return Frame; end;

        locInstance = testClass();
    end)

    it("Testing create function", function()
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
        };
        
        spy.on(locInstance, "addAllObjects");
        locInstance:create();

        assert.spy(locInstance.addAllObjects).was.called();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_back.object.OnClick();
        assert.spy(_gui.changeFrame).was.called();
    end)

    it("Testing addAllObjects function", function()
        _G.data = {
            fishableObjects = {
                testObj1 = {
                    name = "test1";
                    description = "test1";
                    image = "path1";
                },
                testObj2 = {
                    name = "test2";
                    description = "test2";
                    image = "path2";
                }
            };
        };
        
        locInstance:addAllObjects();
        locInstance.elementsOnFrame.chart.object.p_elementsOnChart[1].object = {};
        locInstance.elementsOnFrame.chart.object.p_elementsOnChart[2].object = {};
        local KE1 = KlickableElement("test1", "assets/path1", "assets/path1", "test1", nil);
        local KE2 = KlickableElement("test2", "assets/path2", "assets/path2", "test2", nil);
        KE1.object = {};
        KE2.object = {};
        assert.same(locInstance.elementsOnFrame.chart.object.p_elementsOnChart, {KE2, KE1});
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