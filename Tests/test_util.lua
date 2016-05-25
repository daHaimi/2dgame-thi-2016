-- Lua 5.1 Hack
_G.math.inf = 1 / 0

for k,v in pairs(require "util") do
  _G[k] = v;
end

levelClass = require "src.class.Level";

describe("Unit test for util.lua", function()
    
    before_each(function()
        _G.love = {
            mouse = {
              setVisible = function(...) end
            },
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
        
        _G._gui = {
          drawGame = function(...) return true end,
          }
        
        _G._persTable = {
            upgrades = {
                godMode = 1
            },
            phase = 1;
        }
        
        _G.loveMock = mock(_G.love, true);
        _G.curLevel = levelClass("sewers", "assets/testbg.png", { 512, 256 }, nil, nil);
    
    end)
  
    it("Test set mouse visible true", function()
        curLevel.levelFinished = 1;
        setMouseVisibility(curLevel);
        assert.spy(loveMock.mouse.setVisible).was.called(1);
        assert.spy(loveMock.mouse.setVisible).was.called_with(true);
    end)
  
    it("Test set mouse visible false", function()
        curLevel.levelFinished = 0;
        setMouseVisibility(curLevel);
        assert.spy(loveMock.mouse.setVisible).was.called(1);
        assert.spy(loveMock.mouse.setVisible).was.called_with(false);
    end)
end)

