-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Bait"


describe("Unit test for Bait.lua", function()
    local locInstance;
    --- possible Window size
    local locWinDim = { 400, 800 };
    local locLevel = {
        moved = 4;
        activateShortGM = function (...) end;
        isFinished = function(...) return 0 end;
        getMoved = function() return 4 end;
        getDirection = function() return 1 end;
    }
    
    before_each(function()
        _G.levMan = {
            curLevel = locLevel,
            curPlayer = nil,
            curSwarmFac = { 
            createdFishables = {
                    {
                        getHitboxHeight = function(...) return 10; end;
                        getHitboxWidth = function(...) return 10; end;
                        getHitboxXPosition = function(...) return 15; end;
                        getHitboxYPosition = function(...) return 20; end;
                        setToCaught = function(...) end;
                        setSpeedMultiplicator = function(...) end;
                        caught = false;
                        hitbox = {
                        };
                    }
                };
            },
            getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac end,
            getCurPlayer = function(...) return _G.levMan.curPlayer end,
            getCurLevel = function(...) return _G.levMan.curLevel end
        }
            
        _G.love = {
            mouse = {
                setPosition = function(...) end
            },
            graphics = {
                setColor = function(...) end;
                rectangle = function(...) end;
            }
        }
        

        locInstance = testClass(locWinDim, levMan);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass(locWinDim, levMan);
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Update", function()
        local myInstance = testClass(locWinDim, levMan);        
        myInstance:update();
        assert.are.same(0.495, myInstance.modifier);
        
        myInstance.levMan.curLevel = {
            getMoved = function(...) return -4 end;
            isFinished = function(...) return 0 end;
            getDirection = function () return -1; end;
            isFinished = function() return 0 end;
            getYPos = function() return 400 end;
            getSwarmFactory = function() return 
            { 
                createdFishables = {
                    {
                        setToCaught = function(...) end;
                        setSpeedMultiplicator = function(...) end;
                        caught = false;
                        hitbox = {
                            
                            };
                        }
                    };
                }
            end;
        }
        
        myInstance:update();
        assert.are.same(0.5, myInstance.modifier);
    end)

    it("Test sleeping pill duration", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.sleepingPillDuration = 10;
        myInstance:update();
        assert.are.same(6, myInstance.sleepingPillDuration);
    end)

    it("Test getGoldenRule", function()
        lower, upper = locInstance:getGoldenRule()
        assert.are.same(0.32, lower);
        assert.are.same(0.68, upper);
    end)

    --- Tests for more Life
    it("Test moreLife 0", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            speedUp = 0; --- "0" no Speedup
            moreLife = 0; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 1;
        myInstance:checkUpgrades();
        assert.are.same(myInstance.life, exp);
    end)

    it("Test moreLife 1", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            speedUp = 0; --- "0" no Speedup
            moreLife = 1; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 2;
        myInstance:checkUpgrades();
        assert.are.same(myInstance.life, exp);
    end)

    it("Test moreLife -1", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            speedUp = 0; --- "0" no Speedup
            moreLife = -1; --- bei
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 1;
        myInstance:checkUpgrades();
        assert.are.same(myInstance.life, exp);
    end)


    --- test for more speed Upgrade
    it("Test speed 0", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            speedUp = 0; --- "0" no Speedup
            moreLife = 0; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 200;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test speed 1", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            speedUp = 1; --- "0" no Speedup
            moreLife = 0; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 400;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test speed -1", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            speedUp = -1; --- weil kleiner null nix passiert wegen if
            moreLife = 0; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 200;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test x position limited to maxSpeed (positive direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        }
        myInstance.posXMouse = 70;
        myInstance.posXBait = 40;
        local newPos = myInstance.posXBait + myInstance.maxSpeedX;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test x position limited to maxSpeed (negative direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        }
        myInstance.posXMouse = 10;
        myInstance.posXBait = 40;
        local newPos = myInstance.posXBait - myInstance.maxSpeedX;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test x position not limited to maxSpeed (positive direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        };
        myInstance.posXMouse = 41;
        myInstance.posXBait = 40;
        local newPos = myInstance.posXMouse;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test x position not limited to maxSpeed (negative direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        }
        myInstance.posXMouse = 40;
        myInstance.posXBait = 41;
        local newPos = myInstance.posXMouse;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test x positon with no change", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        }
        myInstance.posXMouse = 40;
        myInstance.posXBait = 40;
        local newPos = myInstance.posXMouse;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test draw", function()
        local myInstance = testClass(locWinDim, levMan);
        local loveMock = mock(_G.love, true);
        myInstance.levMan.curLevel = {getGodModeStat = function() return 0; end};
        myInstance.xPos = 500;
        myInstance.yPos = 400;
        myInstance.size = 10;
        myInstance:draw();
        assert.spy(loveMock.graphics.setColor).was_called_with(127, 0, 255);
        myInstance.levMan.curLevel = {getGodModeStat = function() return 1; end};
        myInstance:draw();
        assert.spy(loveMock.graphics.setColor).was_called_with(255, 0, 0);
        assert.spy(loveMock.graphics.rectangle).was_called_with("fill", 495, 395, 10, 10);
    end)

    it("Test getXPos", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.posXBait = 0;
        assert.are.same(myInstance:getPosX(), 0);
    end)

    it("Test sleepingPillHitted", function()
        _G._persTable.upgrades = {
            sleepingPillDuration = 600; -- duration of the effect of the sleeping pill
            sleepingPillSlow = 0.3; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement
        };
        
        local myInstance = testClass (locWinDim, levMan);
        myInstance.sleepingPillDuration = 0;
        myInstance:sleepingPillHitted(FishableObject);
        
        
        assert.are.same(600, myInstance.sleepingPillDuration);
    end)

    it("Test collisionDetected with a sleeping pill", function()
        local myInstance = testClass(locWinDim, levMan);
        local fishable = {getName = function() return "sleepingPill" end};
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(0, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and an extra life", function()
        local myInstance = testClass(locWinDim, levMan);
        local fishable = {getName = function() return "deadFish" end};
        myInstance.levMan.curLevel = { 
            getGodModeStat = function(...) return 0 end;
            activateShortGM = function(...) end;
            isFinished = function() return 0 end;
            getDirection = function(...) return 1 end;
            };
        _G._persTable.upgrades.moreLife = 1;
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(1, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and no extra life", function()
        local myInstance = testClass(locWinDim, levMan);
        local fishable = {getName = function() return "deadFish" end};
        myInstance.levMan.curLevel = { 
            getGodModeStat = function(...) return 0 end;
            activateShortGM = function(...) end;
            isFinished = function() return 0 end;
            getDirection = function(...) return 1 end;
            switchToPhase2 = function(...) end;
            };
        _G._persTable.upgrades.moreLife = 0;
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(1, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and godMode", function()
        local myInstance = testClass(locWinDim, levMan);
        local fishable = {getName = function() return "deadFish" end};
        myInstance.levMan.curLevel = { 
            getGodModeStat = function(...) return 1 end;
            activateShortGM = function(...) end;
            isFinished = function() return 0 end;
            getDirection = function(...) return 1 end;
            switchToPhase2 = function(...) end;
            };
        _G._persTable.upgrades.moreLife = 0;
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(0, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and godMode", function()
        local myInstance = testClass(locWinDim, levMan);
        local fishable = {getName = function() return "deadFish" end};
        myInstance.levMan.curLevel = { 
            getGodModeStat = function(...) return 1 end;
            activateShortGM = function(...) end;
            getDirection = function(...) return -1 end;
            switchToPhase2 = function(...) end;
            isFinished = function() return 0 end;
            addToCaught = function(...) end;
            getSwarmFactory = function(...) return { 
                    createdFishables = {
                        {
                            setToCaught = function(...) end;
                        }
                    };
                }
            end;

        }
        _G._persTable.upgrades.moreLife = 0;
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(0, myInstance.numberOfHits);
    end)

    it("Test checkForCollision", function()
        levMan.curLevel = {
            getGodModeStat = function(...) return 0 end;
            moved = 4;
            activateShortGM = function (...) end;
            getMoved = function() return 4 end;
            getDirection = function() return 1 end;
            switchToPhase2 = function() end;
        }
        local myInstance = testClass(locWinDim, levMan);
        myInstance.xPos = 20;
        myInstance.yPos = 25;
        someFishables = {
            {
                getHitboxHeight = function(...) return 10; end;
                getHitboxWidth = function(...) return 10; end;
                getHitboxXPosition = function(...) return 15; end;
                getHitboxYPosition = function(...) return 20; end;
                getName = function(...) return "deadFish"; end;
                     hitbox = {
                    {
                        
                    }
                }
            }
        }
        myInstance:checkForCollision(someFishables, 21);
        myInstance:checkForCollision(someFishables, 19);
        myInstance:checkForCollision(someFishables, 20);
        
    end)

    it("Test setPosXMouse", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance:setPosXMouse("new mouse position");
        assert.are.same("new mouse position", myInstance.posXMouse);
    end)

    it("Test getPosXMouse", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.posXMouse = "new mouse position";
        assert.are.same("new mouse position", myInstance:getPosXMouse());
    end)
    
    it("Test getSize", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.size = "new size";
        assert.are.same("new size", myInstance:getSize())
    end)

    it("Test changeModifierTo()", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.modifier = 0.3;
        myInstance.modifier = myInstance:changeModifierTo(0.5);
        assert.are.same(0.305, myInstance.modifier);
    end)

end)
