-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.inGame";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
ImageButton = require "src.class.ImageButton";


describe("Unit test for inGame.lua", function()
    local locInstance;

    before_each(function()
        _G.love = {
            mouse = {
                setVisible = function(...) end;
                setGrabbed = function(...) end;
            },
            system = {
                getOS = function(...) return "Android"; end;
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
        locInstance.barFuel = "barFuel";
        locInstance.button = "button";
        locInstance.fuelBar = "fuelBar";
        locInstance.fuelBarBackground = "fuelBarBackground";
        
        myInstance.elementsOnFrame = {};
        myInstance.barFuel = "barFuel";
        myInstance.button = "button";
        myInstance.fuelBar = "fuelBar";
        myInstance.fuelBarBackground = "fuelBarBackground";
        
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
        local loveMock = mock(love.graphics, true);
        locInstance.drawBar = true;
        locInstance:draw();
        assert.spy(loveMock.draw).was_called(7);
    end)

    it("Testing activate function", function()
        stub(locInstance.frame, "draw");
        locInstance:activate();
        assert.are.same(locInstance.drawBar, true);
    end)

    it("Testing deactivate function", function()
        stub(locInstance.frame, "draw");
        locInstance.drawBar = true;
        locInstance:deactivate();
        assert.are.same(locInstance.drawBar, false);
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
    
    it("Testing mousepressend", function()
        _G.clicked ={};
        _G.clicked[1] = false;
        _G.clicked[2] = false;
        locInstance.elementsOnFrame.pause = {
            getSize = function () return 50, 50 end;
            getPosition = function () return 0, 0 end;
            gotClicked = function() _G.clicked[1] = true end;
        };
        _gui.levMan = {
            getCurLevel = function() return {
                startStartAnimation = function () _G.clicked[2] = true end;
                getStartAnimationRunning = function () return false end;
                getStartAnimationFinished = function () return false end;
            }end;
        };
        locInstance:mousepressed(10, 10);
        assert.are.same(true, _G.clicked[1]);
        assert.are.same(false, _G.clicked[2]);
        
        locInstance:mousepressed(10, 110);
        assert.are.same(true, _G.clicked[1]);
        assert.are.same(true, _G.clicked[2]);
    end)

    it("Testing update", function()
        _G._persTable.config = {};
        _G._persTable.config.language = 1;
        _G.data = {
            languages = {
                {
                    package = {
                        textDepth = "text";
                    }
                }
            };
        };
        _G._tmpTable = {};
        _G._tmpTable.roundFuel = -100;
        _G._tmpTable.currentDepth = -1000;
        locInstance:update();
        assert.are.same(locInstance.fuelBarPosition, -90);
        _G._tmpTable.roundFuel = 100;
        _G._tmpTable.currentDepth = 400;
        locInstance:update();
        assert.are.same(locInstance.fuelBarPosition, -85);
    end)
end)