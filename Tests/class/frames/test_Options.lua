-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Options";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
ImageButton = require "class.ImageButton";
Slider = require "class.Slider";
Data = require "data";

_G.TEsound = {
    playLooping = function(...) end;
    play = function(...) end;
    stop = function(...) end;
};


describe("Unit test for Options.lua", function()
    local locInstance;
    _G.data = Data;
    _G.TEsound = {
        play = function(...) end;
        volume = function(...) end;
    };
    
    before_each(function()
        _G.love = {
            mouse = {
                setVisible = function(...) end;
            };
            system = {
                vibrate = function(...) end;
                getOS = function (...) return "Android" end;
            };
            graphics = {
                newImage = function(...) return {
                    getHeight = function (...) return 50 end;
                    getWidth = function (...) return 50 end;
                } end;
                draw = function (...) end;
                getFont = function (...) return "a Font" end;
                newFont = function (...) end;
                setFont = function (...) end;
                printf = function (...) end;
                setColor = function (...) end;
                rectangle = function (...) end;
            }
        };
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        };
        _G._persistence = {
            updateSaveFile = function() end;
        }
        
        
        _G._persTable = {
            config = {
                bgm = 50;
                music = 50;
                language = "english";
                vibration = true;
            };
            winDim = {
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
            getLastState = function(...) return {}; end;
        };
        _G._persistence = {
            resetGame = function(...) end;
            updateSaveFile = function(...) end;
        };
        
        spy.on(locInstance, "loadValuesFromPersTable");
        spy.on(locInstance, "loadValuesInPersTable");
        spy.on(_G._gui, "changeFrame");
        spy.on(_G._persistence, "resetGame");
        spy.on(_G._persistence, "updateSaveFile");
        spy.on(TEsound, "play");
        
        locInstance:create();
        
        locInstance.elementsOnFrame.button_reset.gotClicked();
        assert.spy(_G._persistence.resetGame).was.called();
        assert.spy(locInstance.loadValuesFromPersTable).was.called(2);
        
        locInstance.elementsOnFrame.button_back.gotClicked();
        assert.spy(_gui.changeFrame).was.called();
        assert.spy(locInstance.loadValuesInPersTable).was.called(1);
        assert.spy(_G._persistence.updateSaveFile).was.called(3);
        assert.spy(TEsound.play).was.called(2);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        
        locInstance.elementsOnFrame = {};
        locInstance.background = "background";
        locInstance.imageButton = "imageButton";
        locInstance.imagePressedSlider = "imagePressedSlider";
        locInstance.imageUnpressedSlider = "imageUnpressedSlider";
        
        myInstance.elementsOnFrame = {};
        myInstance.background = "background";
        myInstance.imageButton = "imageButton";
        myInstance.imagePressedSlider = "imagePressedSlider";
        myInstance.imageUnpressedSlider = "imageUnpressedSlider";
        
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing loadValuesInPersTable function", function()
        _persTable.config.bgm = 0;
        _persTable.config.music = 0;
        locInstance:loadValuesInPersTable();
        assert.equal(_persTable.config.bgm, 50);
        assert.equal(_persTable.config.music, 50);
    end)
    
    it("Testing draw function", function()
        local loveMock = mock(love.graphics, true);
        locInstance:draw();
        assert.spy(loveMock.draw).was_called(6);
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
    it("Testing mousepressend", function()
        _G.clicked ={};
        _G.clicked[1] = false;
        _G.clicked[2] = false;
        _G.clicked[3] = false;
        _G.clicked[4] = false;
        locInstance.elementsOnFrame = {
            slider_bgm = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 0, 0 end;
                gotClicked = function() _G.clicked[1] = true end;
            };
            slider_music = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 0, 100 end;
                gotClicked = function() _G.clicked[2] = true end;
            };
            button_reset = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 100, 0 end;
                gotClicked = function() _G.clicked[3] = true end;
            };
            button_back = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 100, 100 end;
                gotClicked = function() _G.clicked[4] = true end;
            };
        };
        
        locInstance:mousepressed(10, 10);
        assert.are.same(true, _G.clicked[1]);
        assert.are.same(false, _G.clicked[2]);
        assert.are.same(false, _G.clicked[3]);
        assert.are.same(false, _G.clicked[4]);
        
        locInstance:mousepressed(10, 110);
        assert.are.same(true, _G.clicked[1]);
        assert.are.same(true, _G.clicked[2]);
        assert.are.same(false, _G.clicked[3]);
        assert.are.same(false, _G.clicked[4]);
        
        locInstance:mousepressed(110, 10);
        assert.are.same(true, _G.clicked[1]);
        assert.are.same(true, _G.clicked[2]);
        assert.are.same(true, _G.clicked[3]);
        assert.are.same(false, _G.clicked[4]);
        
        locInstance:mousepressed(110, 110);
        assert.are.same(true, _G.clicked[1]);
        assert.are.same(true, _G.clicked[2]);
        assert.are.same(true, _G.clicked[3]);
        assert.are.same(true, _G.clicked[4]);
    end)

    it("Testing mousereleased", function()
        _G.released = {}
        _G.released[1] = false;
        _G.released[2] = false;
        locInstance.elementsOnFrame.slider_bgm.release = function () _G.released[1] = true; end;
        locInstance.elementsOnFrame.slider_music.release = function () _G.released[2] = true; end;
        locInstance:mousereleased();
        assert.are.same(true, _G.released[1]);
        assert.are.same(true, _G.released[2]);
    end)

    it("Testing Update", function()
        locInstance.elementsOnFrame.slider_bgm.getValue = function() return 25 end;
        locInstance.elementsOnFrame.slider_music.getValue = function() return 50 end;
        locInstance.elementsOnFrame.slider_bgm.getMoveable = function() return true end;
        locInstance.elementsOnFrame.slider_music.getMoveable = function() return true end;
        locInstance:update();
        assert.are.same(_G._persTable.config.bgm, 25);
        assert.are.same(_G._persTable.config.music, 50);
    end)
end)
