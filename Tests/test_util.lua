-- Lua 5.1 Hack
_G.math.inf = 1 / 0

_G.testUtilStub = function()
    _G.love = {
        graphics = {
            newImage = function(...) end;
            newQuad = function(...) end;
            setColor = function(...) end;
            shader = {
                send = function(...) end;
            };
            Canvas = {
                setWrap = function(...) end;
            };
            print = function(...) end;
            draw = function(...) end;
        };
        image = {
            CompressedImageData = {
                getWidth = function(...) return 4 end;
                getHeight = function(...) return 5 end;
            };
        };
        light = {
            world = {
                setAmbientColor = function(...) end;
                update = function(...) end;
                drawShadow = function(...) end;
            };
            setSmooth = function(...) end;
            setPosition = function(...) end;
        };
        mouse = {
            setVisible = function(...) end;
        };
        window = {
            getMode = function(...) return 0, 0, {}; end;
        };
    };
    _G.love.light.world.newLight = function(...) return _G.love.light; end;
    _G.love.light.newWorld = function(...) return _G.love.light.world; end;
    _G.love.graphics.newShader = function(...) return _G.love.graphics.shader; end;
    _G.love.graphics.newCanvas = function(...) return _G.love.graphics.Canvas; end;
    _G._gui = {
        drawGame = function(...) return true end;
    };
    _G._tmpTable = {
        caughtThisRound = {};
    };
    _G._persTable = {
        upgrades = {
            godMode = 1;
        };
        phase = 1;
    };
end;

_G.testUtilStub();

for k, v in pairs(require "util") do
    _G[k] = v;
end

levelClass = require "src.class.Level";

describe("Unit test for util.lua", function()

    before_each(function()
        _G.testUtilStub();
        _G.curLevel = levelClass("sewers", "assets/testbg.png", { 512, 256 }, nil, nil);
    end)

    it("Test set mouse visible true", function()
        local loveMock = mock(_G.love, true);
        curLevel.levelFinished = 1;
        setMouseVisibility(curLevel);
        assert.spy(loveMock.mouse.setVisible).was.called(1);
        assert.spy(loveMock.mouse.setVisible).was.called_with(true);
    end)

    it("Test set mouse visible false", function()
        local loveMock = mock(_G.love, true);
        curLevel.levelFinished = 0;
        setMouseVisibility(curLevel);
        assert.spy(loveMock.mouse.setVisible).was.called(1);
        assert.spy(loveMock.mouse.setVisible).was.called_with(false);
    end)
end)

