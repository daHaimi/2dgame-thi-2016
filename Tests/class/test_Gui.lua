_G.math.inf = 1 / 0




describe("Test Gui", function()
    local locInstance;
    
    before_each(function()
        _G.love = {
            keyboard = {
                setKeyRepeat = function(...) end;
            },
            filesystem = {
                getDirectoryItems = function(...) return {}; end;
            },
            
            graphics = {
                newFont = function(...) end;
            }
        }
    
        _G.Loveframes = {
            objects = {};
                
            base = {
                new = function(...) return {}; end;
            };
            
            libraries = {
                util = {
                    filesystem = function(...) end;
                }
            };
            
            init = {
                graphics = function(...) end;
            }
        };
        
        _G.Mainmenu = {};
        _G.Achievements = {};
        _G.Options = {};
        _G.UpgradeMenu = {};
        _G.Dictionary = {};
        _G.Credits = {};
        _G.Score = {};
        _G.Pause = {};
        _G.ChooseLevel = {};
        _G.InGame = {};
        
        

        testClass = require "class.Gui";
        
        
        locInstance = testClass();
    end)


    it("Testing Constructor", function()
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)
end)
