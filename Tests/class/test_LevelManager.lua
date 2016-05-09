-- Lua 5.1 Hack
_G.math.inf = 1 / 0

LevelManager = require "src.class.LevelManager";
match = require 'luassert.match';

describe("Unit test suite for the LevelManager class", function()
    before_each(function()
        _G.love = {
            graphics = {
                newImage = function(...) end,
                newQuad = function(...) end,
                setColor = function(...) end,
                print = function(...) end,
                Canvas = {
                    setWrap = function(...) end
                }
            },
            image = {
                CompressedImageData = {
                    getWidth = function(...) return 4 end,
                    getHeight = function(...) return 5 end
                }
            }
        }
        
        _G.Level = {
            init = function(...) return {1} end
        };

        _G.Bait = {
            init = function(...) end,
            checkUpgrades = function(...) end
        };

        _G.SwarmFactory = {
            init = function(...) end
        };

        _G._persTable = {
            winDim = {930, 523.125},
            upgrades = {
                godMode = 1
            },
            phase = 1;
        };

        _G.loveMock = mock(_G.love, true);
        _G.levelMock = mock(_G.Level, true);
        _G.playerMock = mock(_G.Bait, true);
        _G.swarmFacMock = mock(_G.SwarmFactory, true);
        levMan = LevelManager();
    end)

    it("Testing Constructor", function()
        local const = spy.on(LevelManager, "init");
        local myInstance = LevelManager();
        assert.spy(const).was.called(1);
        assert.spy(const).was.called_with(myInstance);
    end)

    it("Testing newLevel", function()
        
        levMan:newLevel("testPfad", 1, "data.lua");
        assert.spy(levelMock.init).was.called_with("testPfad", 1, "data.lua");
    end)

    it("Testing getCurLevel", function()
        levMan.curLevel = {1, 2, 4};
        assert.are.same(levMan.curLevel, levMan:getCurLevel());
    end)

    it("Testing getCurPlayer", function()
        levMan.curPlayer = {4, 689, 693};
        assert.are.same(levMan.curPlayer, levMan:getCurPlayer());
    end)

    it("Testing getCurSwarmFactory", function()
        levMan.curSwarmFac = {2, 46, 8939};
        assert.are.same(levMan.curSwarmFac, levMan:getCurSwarmFactory());
    end)
end)