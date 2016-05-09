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
        
        Level = {
            
        }

        _G._persTable = {
            winDim = {930, 523.125}
            upgrades = {
                godMode = 1
            },
            phase = 1;
        }

        _G.loveMock = mock(_G.love, true);
            
        levMan = LevelManager("testPfad", 1, "data.lua");
    end)

    it("Testing Constructor", function()
        local myInstance = LevelManager();
        assert.are.same(levMan, myInstance);
    end)

    it("Testing newLevel", function()
        levMan:newLevel("testPfad", 1, "data.lua");
        assert.spy(loveMock.graphics.newImage).was.called_with("testPfad");
        
    end)

    it("Testing getCurLevel", function()
        
    end)
end)