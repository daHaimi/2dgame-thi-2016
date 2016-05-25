-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Options";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";


describe("Unit test for Options.lua", function()
    local locInstance;


    before_each(function()
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G._persTable = {
            config = {
                bgm = 50;
                music = 50;
            };
        };
        
        _G.Frame = function(...) return Frame; end;

        locInstance = testClass();
    end)

    it("Testing create function", function()
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
            tempTextOutput = function(...) end;
            getLastState = function(...) return {}; end;
        };
        _G._persistence = {
            resetGame = function(...) end;
        };
        
        spy.on(locInstance, "loadValuesFromPersTable");
        spy.on(locInstance, "loadValuesInPersTable");
        spy.on(_G._gui, "tempTextOutput");
        spy.on(_G._gui, "changeFrame");
        spy.on(_G._persistence, "resetGame");
        
        locInstance:create();

        locInstance.elementsOnFrame.slider_bgm.OnValueChanged();
        assert.equal(_persTable.config.bgm, 50);
        
        locInstance.elementsOnFrame.slider_music.OnValueChanged();
        assert.equal(_persTable.config.music, 50);
        
        locInstance.elementsOnFrame.button_reset.object.OnClick();
        assert.spy(_G._persistence.resetGame).was.called();
        assert.spy(_gui.tempTextOutput).was.called();
        assert.spy(locInstance.loadValuesFromPersTable).was.called(2);
        
        locInstance.elementsOnFrame.button_back.object.OnClick();
        assert.spy(_gui.changeFrame).was.called();
        assert.spy(locInstance.loadValuesInPersTable).was.called(1);
        assert.spy(_gui.tempTextOutput).was.called();
    end)

    it("Testing loadValuesInPersTable function", function()
        _persTable.config.bgm = 0;
        _persTable.config.music = 0;
        locInstance:loadValuesInPersTable();
        assert.equal(_persTable.config.bgm, 50);
        assert.equal(_persTable.config.music, 50);
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