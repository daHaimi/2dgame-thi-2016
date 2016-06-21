-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.MainMenu";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
_G.TEsound = {
    playLooping = function(...) end;
    play = function(...) end;
    stop = function(...) end;
};


describe("Unit test for MainMenu.lua", function()
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
        _G.data = {
            languages = {
                english = {
                    name = "english";
                    flagImage = "path1";
                },
            };
            
        };
        _G._persTable = {
            config = {
                language = "english";
            };
            scaledDeviceDim = {
                [1] = 500;
                [2] = 500;
            };
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
            config = {
                language = "english";
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
            config = {
                language = "english";
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
        _G.love = {
            window = {
                close = function(...)end;
            },
            
            event = {
                quit = function(...)end;
            }
        };
        
        locInstance:create();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_start.object.OnClick();
        locInstance.elementsOnFrame.button_upgradeMenu.object.OnClick();
        locInstance.elementsOnFrame.button_dictionary.object.OnClick();
        locInstance.elementsOnFrame.button_achievements.object.OnClick();
        locInstance.elementsOnFrame.button_options.object.OnClick();
        locInstance.elementsOnFrame.button_credits.object.OnClick();
        assert.spy(_gui.changeFrame).was.called(6);
        
        spy.on(_G.love.window, "close");
        spy.on(_G.love.event, "quit");
        locInstance.elementsOnFrame.button_close.object.OnClick();
        assert.spy(_G.love.window.close).was.called();
        assert.spy(_G.love.event.quit).was.called();
        
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