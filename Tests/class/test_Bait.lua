-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Bait"


describe("Unit test for Bait.lua", function()
    local locInstance;
    --- possible Window size
    local locWinDim = { 400, 800 };
    local locLevel = {
        moved = 4;
        activateShortGM = function(...) end;
        isFinished = function(...) return 0 end;
        getMoved = function() return 4 end;
        getDirection = function() return 1 end;
        getYPos = function() return 50 end;
    };
    local locImageStub = {
        draw = function(...) end;
        update = function(...) end;
    };

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
                        hitbox = {};
                    }
                },
                getCreatedFishables = function(...) return _G.levMan.curSwarmFac.createdFishables end;
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
                draw = function(...) end;
                rectangle = function(...) end;
                newImage = function(...)
                    return 0;
                end;
                newShader = function(...)
                    return {
                        send = function(...) end;
                    };
                end;
                translate = function(...) end;
                rotate = function(...) end;
                polygon = function(...) end;
                setShader = function(...) end;
            }
        }
        _G._gui = {
            myFrames = {
                inGame = {
                    elementsOnFrame = {
                        healthbar = {
                            object = {
                                minus = function(...) end;
                            };
                        };
                    };
                };
            };
        };
        _G._gui.getFrames = function(...) return _G._gui.myFrames; end;

        locInstance = testClass(locWinDim, levMan);
        locInstance.image = locImageStub;
    end)

    it("Testing Constructor", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Update", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance:update();
        assert.are.same(0.495, myInstance.modifier);

        myInstance.levMan.curLevel = {
            getMoved = function(...) return -4 end;
            isFinished = function(...) return 0 end;
            getDirection = function() return -1; end;
            isFinished = function() return 0 end;
            getYPos = function() return 400 end;
            getSwarmFactory = function() return {
                createdFishables = {
                    {
                        setToCaught = function(...) end;
                        setSpeedMultiplicator = function(...) end;
                        caught = false;
                        hitbox = {};
                    }
                };
            }
            end,
            getCreatedFishables = function(...) return myInstance.levMan.curLevel:getSwarmFactory().createdFishables end;
        }

        myInstance:update();
        assert.are.same(0.5, myInstance.modifier);
    end)

    it("Test sleeping pill duration", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
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
            moreLife = 0;
            oneMoreLife = false; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 0;
        myInstance:checkUpgrades();
        assert.are.same(_G._persTable.upgrades.moreLife, exp);
    end)

    it("Test oneMoreLife", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            moreLife = 0;
            oneMoreLife = true; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 1;
        myInstance:checkUpgrades();
        assert.are.same(_G._persTable.upgrades.moreLife, exp);
    end)
  
      it("Test twoMoreLife", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            moreLife = 0;
            twoMoreLife = true; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 0;
        myInstance:checkUpgrades();
        assert.are.same(_G._persTable.upgrades.moreLife, exp);
    end)
      it("Test twoMoreLife", function()
        _G._persTable = {};
          _G._persTable.upgrades = {
            moreLife = 0;
            twoMoreLife = true;
            oneMoreLife = true;--- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 2;
        myInstance:checkUpgrades();
        assert.are.same(_G._persTable.upgrades.moreLife, exp);
      end)

    it("Test threeMoreLife", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            moreLife = 0;
            threeMoreLife = true;--- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 0;
        myInstance:checkUpgrades();
        assert.are.same(_G._persTable.upgrades.moreLife, exp);
    end)
  
    it("Test allMoreLife upgrades true", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            moreLife = 0;
            oneMoreLife = true;
            twoMoreLife = true;
            threeMoreLife = true; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 3;
        myInstance:checkUpgrades();
        assert.are.same(_G._persTable.upgrades.moreLife, exp);
    end)

    --- test for more speed Upgrade
    it("Test speed 1", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            firstSpeedUp = false; --- "0" no Speedup
            secondSpeedUp = false; --- "0" no Speedup
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
            firstSpeedUp = true; --- "0" no Speedup
            secondSpeedUp = false; --- "0" no Speedup
            moreLife = 0; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        local exp = 400;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test secondSpeed 1", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            firstSpeedUp = false; --- "0" no Speedup
              secondSpeedUp = true;
        };

        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local exp = 400;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test speed 2", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
            firstSpeedUp = true; --- "0" no Speedup
            secondSpeedUp = true; --- "0" no Speedup
            moreLife = 0; --- amount of additional lifes
        };

        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local exp = 600;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test speed -1", function()
        _G._persTable = {};

        _G._persTable.upgrades = {
        firstSpeedUp = false; -- more speed
        secondSpeedUp = false; -- more speed
        };

        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local exp = 200;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test x position limited to maxSpeed (positive direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        }
        myInstance.posXMouse = 70;
        myInstance.xPos = 40;
        local newPos = myInstance.xPos + myInstance.maxSpeedX;
        myInstance.xPos = myInstance.xPos + myInstance:capXMovement();
        assert.are.same(myInstance.xPos, newPos);
    end)

    it("Test x position limited to maxSpeed (negative direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        }
        myInstance.posXMouse = 10;
        myInstance.xPos = 40;
        local newPos = myInstance.xPos - myInstance.maxSpeedX;
        myInstance.xPos = myInstance.xPos + myInstance:capXMovement();
        assert.are.same(myInstance.xPos, newPos);
    end)

    it("Test x position not limited to maxSpeed (positive direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        };
        myInstance.posXMouse = 41;
        myInstance.xPos = 40;
        local newPos = myInstance.posXMouse;
        myInstance.xPos = myInstance.xPos + myInstance:capXMovement();
        assert.are.same(myInstance.xPos, newPos);
    end)

    it("Test x position not limited to maxSpeed (negative direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        }
        myInstance.posXMouse = 40;
        myInstance.xPos = 41;
        local newPos = myInstance.posXMouse;
        myInstance.xPos = myInstance.xPos + myInstance:capXMovement();
        assert.are.same(myInstance.xPos, newPos);
    end)

    it("Test x positon with no change", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.levMan.curLevel = {
            isFinished = function() return 0 end;
        }
        myInstance.posXMouse = 40;
        myInstance.xPos = 40;
        local newPos = myInstance.posXMouse;
        myInstance.xPos = myInstance.xPos + myInstance:capXMovement();
        assert.are.same(myInstance.xPos, newPos);
    end)

    it("Test draw", function()
        --local shadersClass = require "src.class.Shaders";
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local loveGraphicsMock = mock(myInstance.image, true);

        myInstance.levMan.curLevel.getGodModeStat = function() return 0 end;
        myInstance.xPos = 0;
        myInstance.yPos = 0;

        myInstance:draw();
        assert.spy(loveGraphicsMock.draw).was_called();
    end)

    it("Test getXPos", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.xPos = 0;
        assert.are.same(myInstance:getPosX(), 0);
    end)

    it("Test sleepingPillHit", function()
        _G._persTable.upgrades = {
            sleepingPillDuration = 600; -- duration of the effect of the sleeping pill
            sleepingPillSlow = 0.3; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement
        };

        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.sleepingPillDuration = 0;
        myInstance:sleepingPillHit(FishableObject);

        assert.are.same(600, myInstance.sleepingPillDuration);
    end)

    it("Test collisionDetected with a sleeping pill", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "sleepingPill" end };
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(0, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and an extra life", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "deadFish" end };
        myInstance.levMan.curLevel = {
            getGodModeStat = function(...) return 0 end;
            activateShortGM = function(...) end;
            isFinished = function() return 0 end;
            getDirection = function(...) return 1 end;
          };
        _G._persTable.upgrades.moreLife = 1;
        _G._persTable.upgrades.oneMoreLife = true;
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(1, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and no extra life", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "deadFish" end };
        myInstance.levMan.curLevel = {
            getGodModeStat = function(...) return 0 end;
            activateShortGM = function(...) end;
            isFinished = function() return 0 end;
            getDirection = function(...) return 1 end;
            switchToPhase2 = function(...) end;
        };
        _G._persTable.upgrades.moreLife = 0;
        _G._persTable.upgrades.oneMoreLife = false;
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(1, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and godMode", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "deadFish" end };
        myInstance.levMan.curLevel = {
            getGodModeStat = function(...) return 1 end;
            activateShortGM = function(...) end;
            isFinished = function() return 0 end;
            getDirection = function(...) return 1 end;
            switchToPhase2 = function(...) end;
        };
        _G._persTable.upgrades.moreLife = 0;
        _G._persTable.upgrades.oneMoreLife = false;
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(0, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and godMode", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "deadFish" end };
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
        _G._persTable.upgrades.oneMoreLife = false;
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
                    {}
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
