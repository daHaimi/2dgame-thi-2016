-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Level";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";

_G.TEsound = {
    playLooping = function(...) end;
    play = function(...) end;
    stop = function(...) end;
};

describe("Unit test for Level.lua", function()
    local locInstance;


    before_each(function()
        _G.levMan = {
            curLevel = nil,
            curPlayer = nil,
            curSwarmFac = nil,
            getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac end,
            getCurPlayer = function(...) return _G.levMan.curPlayer end,
            getCurLevel = function(...) return _G.levMan.curLevel end
        };
        
            
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        
        _G.love = {
            mouse = {
                setVisible = function(...) end;
            },
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

        _G._persTable = {
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
        locInstance.imageHouse = "imageHouse";
        locInstance.imageCanyonLocked =  "imageCanyonLocked";
        locInstance.imageCanyonUnlocked = "imageCanyonUnlocked";
        locInstance.imageSquirrel = "imageSquirrel";
        locInstance.imageCrocodile = "imageCrocodile";
        locInstance.background = "background";
        
        myInstance.elementsOnFrame = {};
        myInstance.imageButton = "imageButton";
        myInstance.imageHouse = "imageHouse";
        myInstance.imageCanyonLocked =  "imageCanyonLocked";
        myInstance.imageCanyonUnlocked = "imageCanyonUnlocked";
        myInstance.imageSquirrel = "imageSquirrel";
        myInstance.imageCrocodile = "imageCrocodile";
        myInstance.background = "background";
        
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing create function", function()
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
            getLevelManager = function(...) return {
                curLevel = nil,
                curPlayer = nil,
                curSwarmFac = nil,
                getCurSwarmFactory = function(...) return _G._gui.getLevelManager.curSwarmFac end,
                getCurPlayer = function(...) return _G._gui.getLevelManager.curPlayer end,
                getCurLevel = function(...) return _G._gui.getLevelManager.curLevel end,
                getLevelPropMapByName = function(...)  end,
                newLevel = function(...) end;
            } end;
        };
        
        locInstance:create();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_back.gotClicked();
        locInstance.elementsOnFrame.buttonHouse.gotClicked();
        locInstance.elementsOnFrame.buttonCanyon.gotClicked();
        assert.spy(_gui.changeFrame).was.called(3);
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

end)