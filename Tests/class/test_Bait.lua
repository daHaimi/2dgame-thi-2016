-- Lua 5.1 Hack
_G.math.inf = 1 / 0
_G.love = {
    system = {
        vibrate = function(...) end;
    };
    graphics = {
        newCanvas = function(...)
            return 0;
        end;
        newShader = function(...)
            return {
                send = function(...) end;
            };
        end;
        window = 0;
        newQuad = function(...) end;
    };
    window = {
        getMode = function(...)
            return 0, 0, {};
        end;
    };
};
testClass = require "src.class.Bait";
match = require 'luassert.match';


describe("Unit test for Bait.lua", function()
    local locInstance;
    --- possible Window size
    local locWinDim = { 400, 800 };
    local locLevel = {
        moved = 4;
        activateShortGM = function(...) end;
        isFinished = function(...) return 0; end;
        getMoved = function() return 4; end;
        getDirection = function() return 1; end;
        getYPos = function() return 50; end;
        getLevelName = function() return "sewers"; end;
    };
    local locImageStub = {
        draw = function(...) end;
        update = function(...) end;
    };

    before_each(function()
        _G.levMan = {
            curLevel = locLevel;
            curPlayer = nil;
            curSwarmFac = {
                createdFishables = {
                    {
                        getHitboxHeight = function(...) return 10; end;
                        getHitboxWidth = function(...) return 10; end;
                        getHitboxXPosition = function(...) return 15; end;
                        getHitboxYPosition = function(...) return 20; end;
                        setToCaught = function(...) end;
                        setDestroyed = function(...) end;
                        setSpeedMultiplicator = function(...) end;
                        caught = false;
                        hitbox = {};
                    }
                };
                getCreatedFishables = function(...) return _G.levMan.curSwarmFac.createdFishables; end;
                setSpeedMultiplicator = function(...) end;
                setImageToNyan = function (...) end;
            };
            getCurSwarmFactory = function(...) return _G.levMan.curSwarmFac; end;
            getCurPlayer = function(...) return _G.levMan.curPlayer; end;
            getCurLevel = function(...) return _G.levMan.curLevel; end;
        };

        _G._tmpTable = {
            caughtThisRound = {};
            earnedMoney = nil;
            currentDepth = nil;
            roundFuel = 800;
            unlockedAchievements = {};
        };

        _G.love = {
            mouse = {
                setPosition = function(...) end;
            },
            graphics = {
                setColor = function(...) end;
                newQuad = function(...) end;
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
            };
        };
        _G._gui = {
            myFrames = {
                inGame = {
                    elementsOnFrame = {
                        healthbar = {
                            minus = function(...) end;
                        };
                    };
                };
            };
            getFrames = function(...) return _G._gui.myFrames end;
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

    it("Testing destructBait", function()
        local testInstance = testClass(locWinDim, levMan);
        testInstance:destructBait();

        for key, value in pairs(testInstance) do
            assert.are.same(nil, value);
        end
    end)

    it("Testing Update", function()
        --_G.imageCheeks = nil;
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.imageCheeks = locImageStub;
        myInstance.imageCheeks = {
            getDimensions = function(...) end;
        };
        myInstance:update();
        assert.are.same(0.495, myInstance.modifier);

        myInstance.levMan.curLevel = {
            getLevelName = function(...) return "sewers"; end;
            getMoved = function(...) return -4; end;
            isFinished = function(...) return 0; end;
            getDirection = function() return -1; end;
            isFinished = function() return 0; end;
            getYPos = function() return 400; end;
            getSwarmFactory = function()
                return {
                    createdFishables = {
                        {
                            setToCaught = function(...) end;
                            setSpeedMultiplicator = function(...) end;
                            caught = false;
                            hitbox = {};
                        }
                    };
                };
            end;
            getCreatedFishables = function(...) return myInstance.levMan.curLevel:getSwarmFactory().createdFishables; end;
        }

        myInstance:update();
        assert.are.same(0.5, myInstance.modifier);
    end)

    it("Test sleeping pill duration", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.pillDuration[1] = 2;
        myInstance.imageCheeks = locImageStub;
        myInstance.imageCheeks = {
            getDimensions = function(...) end;
        };
        myInstance:update(0.1);
        assert.are.same(1.9, myInstance.pillDuration[1]);
    end)    

    it("Test show Mouth", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.timeShowMouth = 5;
        myInstance.imageCheeks = locImageStub;
        myInstance.imageCheeks = {
            getDimensions = function(...) end;
        };
        myInstance:update(4);
        assert.are.same(1, myInstance.timeShowMouth);
    end)

    it("Test getGoldenRule", function()
        local lower, upper = locInstance:getGoldenRule()
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
            oneMoreLife = true; --- amount of additional lifes
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
            threeMoreLife = true; --- amount of additional lifes
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
        local exp = myInstance.speed;
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
        local exp = myInstance.speed + 200;
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
        local exp = myInstance.speed + 200;
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
        local exp = myInstance.speed + 400;
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
        local exp = myInstance.speed;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test x position limited to maxSpeed (positive direction)", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.levMan.curLevel = {
            isFinished = function() return false end;
        };
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
            isFinished = function() return false end;
        };
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
            isFinished = function() return false end;
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
            isFinished = function() return false end;
        };
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
            isFinished = function() return 0; end;
        };
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

        myInstance.levMan.curLevel.getGodModeStat = function() return 0; end;
        myInstance.timeShowMouth = 0.1;
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
            pillDuration = 600; -- duration of the effect of the sleeping pill
            sleepingPillSlow = 0.3; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement
        };

        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.pillDuration[1] = 0;
        _G._persTable.fish = {
            caught = {
                sleepingPill = 0;
                coffee = 0;
                rainbowPill = 0;
            };
        };
        myInstance:sleepingPillHit();

        assert.are.same(600, myInstance.pillDuration[1]);
    end)

    it("Test rainbowPillHit", function()
        _G._persTable.upgrades = {
            rainbowPillDuration = 600; -- duration of the effect of the sleeping pill
        };

        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.pillDuration[3] = 0;
        _G._persTable.fish = {
            caught = {
                sleepingPill = 0;
                coffee = 0;
                rainbowPill = 0;
            };
        };
        myInstance:rainbowPillHit();

        assert.are.same(600, myInstance.pillDuration[3]);
    end)

    it("Test coffeeHit", function()
        _G._persTable.upgrades = {
            pillDuration = 600; -- duration of the effect of the sleeping pill
            coffeeSpeedup = 2; -- sets the speedup factor for coffe 2 = 200% of the usual movement speed
        };

        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        myInstance.pillDuration[2] = 0;
        _G._persTable.fish = {
            caught = {
                sleepingPill = 0;
                coffee = 0;
                rainbowPill = 0;
            };
        };
        myInstance:coffeeHit();

        assert.are.same(600, myInstance.pillDuration[2]);
    end)

    it("Test collisionDetected with a sleeping pill", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "sleepingPill" end };
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(0, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a rainbowpill pill", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "rainbowPill" end };
        _G._persTable.fish = {
            caught = {
                sleepingPill = 0;
                coffee = 0;
                rainbowPill = 0;
            };
        };
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(0, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and an extra life", function()
        _G.love.system = {
                vibrate = function(...) end;
        };
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "deadFish"; end; };
        myInstance.levMan.curLevel = {
            getGodModeStat = function(...) return false; end;
            activateShortGM = function(...) end;
            isFinished = function() return false; end;
            getDirection = function(...) return 1; end;
        };
        _G._persTable.upgrades.moreLife = 1;
        _G._persTable.upgrades.oneMoreLife = true;
        _G._persTable.fish = {
            caught = {
                sleepingPill = 0;
                coffee = 0;
                rainbowPill = 0;
            };
        };
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(1, myInstance.numberOfHits);
    end)

    it("Test collisionDetected with a fishable and no extra life", function()
        _G.love.system = {
            vibrate = function(...) end;
        };
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local fishable = { getName = function() return "deadFish"; end; };
        myInstance.levMan.curLevel = {
            getGodModeStat = function(...) return false; end;
            activateShortGM = function(...) end;
            isFinished = function() return false; end;
            getDirection = function(...) return 1; end;
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
        local fishable = { getName = function() return "deadFish"; end; };
        myInstance.levMan.curLevel = {
            getGodModeStat = function(...) return 1; end;
            activateShortGM = function(...) end;
            isFinished = function() return 0; end;
            getDirection = function(...) return 1; end;
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
        local fishable = { getName = function() return "deadFish"; end };
        myInstance.levMan.curLevel = {
            getGodModeStat = function(...) return 1; end;
            activateShortGM = function(...) end;
            getDirection = function(...) return -1; end;
            switchToPhase2 = function(...) end;
            isFinished = function() return 0; end;
            addToCaught = function(...) end;
            getSwarmFactory = function(...) return {
                createdFishables = {
                    {
                        setToCaught = function(...) end;
                    }
                };
            };
            end;
        };
        _G._persTable.upgrades.moreLife = 0;
        _G._persTable.upgrades.oneMoreLife = false;
        myInstance:collisionDetected(fishable, 1);
        assert.are.same(0.3, myInstance.timeShowMouth);
        assert.are.same(0, myInstance.numberOfHits);
    end)

    it("Test checkForCollision", function()
        levMan.curLevel = {
            getGodModeStat = function(...) return 0; end;
            moved = 4;
            activateShortGM = function(...) end;
            getMoved = function() return 4; end;
            getDirection = function() return 1; end;
            switchToPhase2 = function() end;
        }
        local myInstance = testClass(locWinDim, levMan);
        myInstance.xPos = 20;
        myInstance.yPos = 25;
        local someFishables = {
            {
                getHitboxHeight = function(...) return 10; end;
                getHitboxWidth = function(...) return 10; end;
                getHitboxXPosition = function(...) return 15; end;
                getHitboxYPosition = function(...) return 20; end;
                getName = function(...) return "deadFish"; end;
                hitbox = {
                    {}
                };
            }
        };
        myInstance:checkForCollision(someFishables, 21);
        myInstance:checkForCollision(someFishables, 19);
        myInstance:checkForCollision(someFishables, 20);
    end)

    it("Test setPosXMouse", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance:setPosXMouse(5);
        assert.are.same(58, myInstance.posXMouse);
        myInstance:setPosXMouse(159);
        assert.are.same(159, myInstance.posXMouse);
        myInstance:setPosXMouse(700);
        assert.are.same(422, myInstance.posXMouse);
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

    it("Test getSpeed", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.speed = 30;
        assert.are.same(myInstance:getSpeed(), 30);
    end)

    it("Test getPosY", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.yPos = 5;
        assert.are.same(myInstance:getPosY(), 5);
    end)

    it("Test big bait cheeks", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local loveMock = mock(_G.love, true);
        myInstance.imageCheeks = locImageStub;
        myInstance.imageCheeks = {
            getDimensions = function(...) return 192, 64; end;
        };
        myInstance.hitFishable = 25;
        local dimX, dimY = myInstance.imageCheeks.getDimensions();
        myInstance:update();
        assert.spy(loveMock.graphics.newQuad).called(1);
        assert.spy(loveMock.graphics.newQuad).was.called_with(2 * dimX / 3, 0, dimX / 3, dimY, dimX, dimY);
    end)

    it("Test middle bait cheeks", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local loveMock = mock(_G.love, true);
        myInstance.imageCheeks = locImageStub;
        myInstance.imageCheeks = {
            getDimensions = function(...) return 192, 64; end;
        };
        myInstance.hitFishable = 17;
        local dimX, dimY = myInstance.imageCheeks.getDimensions();
        myInstance:update();
        assert.spy(loveMock.graphics.newQuad).called(1);
        assert.spy(loveMock.graphics.newQuad).was.called_with(dimX/3, 0, dimX/3, dimY, dimX, dimY);
        assert.spy(loveMock.graphics.newQuad).was.called_with(dimX / 3, 0, dimX / 3, dimY, dimX, dimY);
    end)

    it("Test middle bait cheeks", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local loveMock = mock(_G.love, true);
        myInstance.imageCheeks = locImageStub;
        myInstance.imageCheeks = {
            getDimensions = function(...) return 192, 64; end;
        };
        myInstance.hitFishable = 10;
        local dimX, dimY = myInstance.imageCheeks.getDimensions();
        myInstance:update();
        assert.spy(loveMock.graphics.newQuad).called(1);
        assert.spy(loveMock.graphics.newQuad).was.called_with(0, 0, dimX / 3, dimY, dimX, dimY);
    end)

    it("Test draw cheeks", function()
        local myInstance = testClass(locWinDim, levMan);
        myInstance.image = locImageStub;
        local loveMock = mock(_G.love, true);

        myInstance.levMan.curLevel.getGodModeStat = function() return 0; end;
        myInstance.xPos = 0;
        myInstance.yPos = 0;
        myInstance.quadCheeks = {};
        myInstance:draw();
        assert.spy(loveMock.graphics.draw).was_called();
        assert.spy(loveMock.graphics.draw).was.called_with(myInstance.imageCheeks, myInstance.quadCheeks,
            match._, match._);
    end)

    it("Test resetPill", function()
        local locMock = mock(locInstance.levMan.curSwarmFac, true);
        locInstance:resetPill(1);
        assert.spy(locMock.setSpeedMultiplicator).was.called();
    end);
end)
