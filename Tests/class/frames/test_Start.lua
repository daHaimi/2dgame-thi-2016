-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Start";
fakeElement = require "Tests.fakeLoveframes.fakeElement";

describe("Unit test for Start.lua", function()
    local locInstance;

    before_each(function()
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G.love = {
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
            },
            system = {
                getOS = function(...) return "Android"; end;
            };
        }
        _G.data = {
            languages= {
                english = {
                    package = {
                        textStart = "";
                    }
                }
            }
        }
        _G._persTable = {
            winDim = {480, 800},
            config = {
                language = "english";
            }
        }
        
        locInstance = testClass();
    end)


    it("Testing Constructor", function()
        local myInstance = testClass();
        
        myInstance.hamster = "hamster";
        myInstance.title = "title";
        
        locInstance.hamster = "hamster";
        locInstance.title = "title";
        
        assert.are.same(locInstance, myInstance);
    end)

    it("testing update function", function()
        locInstance.blinkTimer = 2;
        locInstance:update();
        assert.are.equal(locInstance.blinkTimer, 1);
        locInstance:update();
        assert.are.equal(locInstance.blinkTimer, 25);
    end)

    it("testing draw function", function()
        local loveMock = mock(_G.love, true);
        locInstance:draw();
        assert.spy(loveMock.graphics.draw).was.called(2);
    end)

    it("testing clear function", function()
        locInstance:clear();
        assert.are.same(locInstance.offset, _G._persTable.winDim[1]);
    end)

    it("testing appear function", function()
        locInstance.offset = 5;
        locInstance.speed = 1;
        
        locInstance:appear();
        assert.are.equal(locInstance.offset, 4);
    end)

    it("testing disappear function", function()
        locInstance.offset = 5;
        locInstance.speed = 1;
        
        locInstance:disappear();
        assert.are.equal(locInstance.offset, 6);
    end)

    it("testing disappear function", function()
        locInstance.offset = 1;
        assert.are.equal(locInstance:checkPosition(), false);
        locInstance.offset = 0;
        assert.are.equal(locInstance:checkPosition(), true);
    end)
end)
