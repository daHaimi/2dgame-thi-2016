-- Lua 5.1 Hack
_G.math.inf = 1 / 0

_G.testLevelManagerStub = function(...)
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
        window = {
            getMode = function(...) return 0, 0, {}; end;
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
    };
    _G.love.light.world.newLight = function(...) return _G.love.light; end;
    _G.love.light.newWorld = function(...) return _G.love.light.world; end;
    _G.love.graphics.newShader = function(...) return _G.love.graphics.shader; end;
    _G.love.graphics.newCanvas = function(...) return _G.love.graphics.Canvas; end;

    _G._persistence = {
        resetGame = function(...) end;
    };

    _G._gui = {
        getFrames = function(...) return {
            inGame = {
                elementsOnFrame = {
                    healthbar = {
                        object = {
                            resetHearts = function(...) end;
                        };
                    };
                };
            };
        };
        end;
    };


    _G.Bait = function(...) return { checkUpgrades = function(...) return 42; end }; end;
    _G.Level = function(...) return { 4, 5 }; end;
    _G.SwarmFactory = function(...) return { 3 }; end;

    _G._persTable = {
        winDim = { 930, 523.125 };
        upgrades = {
            godMode = 1;
        };
        phase = 1;
    };
end;

_G.testLevelManagerStub();

LevelManager = require "src.class.LevelManager";
match = require 'luassert.match';

describe("Unit test suite for the LevelManager class", function()
    before_each(function()
        _G.testLevelManagerStub();

        levMan = LevelManager();
        --_G.loveMock = mock(_G.love, true);
        --_G.levelMock = mock(_G.Level, true);
        --_G.playerMock = mock(_G.Bait, true);
        --_G.swarmFacMock = mock(_G.SwarmFactory, true);
    end)
        _G._tmpTable = {
            caughtThisRound = {};
            earnedMoney = nil;
            currentDepth = nil;
            roundFuel = 800;
            unlockedAchievements = {};
        };
    it("Testing Constructor", function()
        local const = spy.on(LevelManager, "init");
        local myInstance = LevelManager();
        assert.spy(const).was.called(1);
        assert.spy(const).was.called_with(myInstance);
    end)

    it("Testing newLevel", function()
        local sewers = {
            levelName = "sewers";
            direction = 1;
            bgPath = "assets/testbg.png";
        };
        levMan:newLevel(sewers, "data.lua");
        assert.are.same(levMan.curLevel, { 4, 5 });
        assert.are.same(levMan.curSwarmFac, { 3 });
    end)

    it("Testing replayLevel", function()
        levMan.p_levelProperties = {
            sewers = {
                levelName = "sewers",
                direction = 1,
                bgPath = "assets/testbg.png";
            }
        };
        levMan.curLevel = { 445, 79862, getLevelName = function(...) return "sewers" end; };
        levMan.curPlayer = { 2268, -45 };
        levMan.curSwarmFac = { 33688 };
        levMan.p_curDataRef = { 66823 };

        levMan:replayLevel();
        assert.are_not.same({ 445, 79862, getLevelName = function(...) return "sewers" end; }, levMan:getCurLevel());
        assert.are_not.same({ 2268, -45 }, levMan:getCurPlayer());
        assert.are_not.same({ 33688 }, levMan:getCurSwarmFactory());
    end)

    it("Testing getCurLevel", function()
        levMan.curLevel = { 1, 2, 4 };
        assert.are.same(levMan.curLevel, levMan:getCurLevel());
    end)

    it("Testing getCurPlayer", function()
        levMan.curPlayer = { 4, 689, 693 };
        assert.are.same(levMan.curPlayer, levMan:getCurPlayer());
    end)

    it("Testing getCurSwarmFactory", function()
        levMan.curSwarmFac = { 2, 46, 8939 };
        assert.are.same(levMan.curSwarmFac, levMan:getCurSwarmFactory());
    end)

    it("Testing getLevelPropMapByName", function()
        levMan.p_levelProperties = {
            sewers = {
                levelName = "sewers",
                direction = 1,
                bgPath = "assets/testbg.png";
            }
        };

        assert.are.same("sewers", levMan:getLevelPropMapByName("sewers").levelName);
    end)
end)
