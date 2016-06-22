-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Pause";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
ImageButton = require "src.class.ImageButton";
_G.TEsound = {
    playLooping = function(...) end;
    play = function(...) end;
    stop = function(...) end;
};


describe("Unit test for Pause.lua", function()
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
        _G.Frame = function(...) return Frame; end;
        _G._persTable = {
            winDim = {
                [1] = 500;
                [2] = 500;
            }
        };
        locInstance = testClass();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        locInstance.elementsOnFrame = {};
        locInstance.imageButton = "imageButton";
        locInstance.background = "background";
        
        myInstance.elementsOnFrame = {};
        myInstance.imageButton = "imageButton";
        myInstance.background = "background";
        
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
        locInstance.elementsOnFrame.button_backToGame.gotClicked();
        locInstance.elementsOnFrame.button_backToMenu.gotClicked();
        locInstance.elementsOnFrame.button_changeLevel.gotClicked();
        locInstance.elementsOnFrame.button_options.gotClicked();
        assert.spy(_gui.changeFrame).was.called(4);
        assert.stub(locInstance.checkAchRageQuit).was.called(1);
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
