-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Score";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
Imagebutton = require "class.ImageButton";

Data = require "data";
_G.TEsound = {
    playLooping = function(...) end;
    play = function(...) end;
    stop = function(...) end;
};


describe("Unit test for Score.lua", function()
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
        _G.data = Data;
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G._persTable = {
            winDim = {
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
        _G.AchievementDisplay.draw  = function (...) end;
        locInstance = testClass();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        
        locInstance.elementsOnFrame = {};
        locInstance.background = "background";
        locInstance.imageButton = "imageButton";
        
        myInstance.elementsOnFrame = {};
        myInstance.background = "background";
        myInstance.imageButton = "imageButton";
        
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing create function", function()
        local table = {
            replayLevel = function(...) end;
            freeManagedObjects = function(...) end;
        }
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
            getLevelManager = function(...) return table end;
        };
        
        stub(table, "replayLevel");
        
        locInstance:create();
        
        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_retry.gotClicked();
        locInstance.elementsOnFrame.button_backToMenu.gotClicked();
        assert.spy(_gui.changeFrame).was.called(2);
        assert.stub(table.replayLevel).was.called();
    end)

    it("Testing draw function", function()
        local loveMock = mock(love.graphics, true);
        locInstance.unlockedAchievements = {}
        locInstance:draw();
        assert.spy(loveMock.draw).was_called(3);
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