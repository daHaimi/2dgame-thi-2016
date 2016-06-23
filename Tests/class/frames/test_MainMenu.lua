-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.MainMenu";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
ImageButton = require "class.ImageButton";
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
            }
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
            winDim = {
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
        locInstance.imageButton = "imageButton";
        locInstance.background = "background";
        locInstance.imageFlag = "imageFlag";
        
        myInstance.elementsOnFrame = {};
        myInstance.imageButton = "imageButton";
        myInstance.background = "background";
        myInstance.imageFlag = "imageFlag";
        
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
        locInstance.elementsOnFrame.button_start.gotClicked();
        locInstance.elementsOnFrame.button_upgradeMenu.gotClicked();
        locInstance.elementsOnFrame.button_dictionary.gotClicked();
        locInstance.elementsOnFrame.button_achievements.gotClicked();
        locInstance.elementsOnFrame.button_options.gotClicked();
        locInstance.elementsOnFrame.button_credits.gotClicked();
        assert.spy(_gui.changeFrame).was.called(6);
        
        spy.on(_G.love.window, "close");
        spy.on(_G.love.event, "quit");
        locInstance.elementsOnFrame.button_close.gotClicked();
        assert.spy(_G.love.window.close).was.called();
        assert.spy(_G.love.event.quit).was.called();
        
    end)

    it("Testing draw function", function()
        local loveMock = mock(love.graphics, true);
        locInstance:draw();
        assert.spy(loveMock.draw).was_called(9);
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
            button_start = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 0, 0 end;
                gotClicked = function() _G.clicked[1] = true end;
            };
            button_upgradeMenu = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 0, 100 end;
                gotClicked = function() _G.clicked[2] = true end;
            };
            button_dictionary = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 100, 0 end;
                gotClicked = function() _G.clicked[3] = true end;
            };
            button_restartLevel = {
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
end)
