-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Bait"
SwarmFactory = require"src.class.SwarmFactory";

describe("Unit test for Bait.lua", function()
    local locInstance;
    --- possible Window size
    local locWinDim = { 400, 800 };
    local locLevel = {
        moved = 4;
        getMoved = function() return 4 end;
        getDirection = function() return 1 end;
        getSwarmFactory = function() return 
            { 
                createdFishables = {
                    {
                        caught = false;
                        hitbox = {
                            
                        };
                    }
                    };
            }
        end;
    }
    
    before_each(function()
        _G.love = {
            mouse = {
                setPosition = function(...) end
            }
        }

        locInstance = testClass(locWinDim);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass(locWinDim);
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Update", function()
        local myInstance = testClass(locWinDim, locLevel);
        myInstance:update();
        assert.are.same(0.32, myInstance.modifier);
        myInstance.curLevel = {
            moved = -4;
            getDirection = function () return -1; end;
            getSwarmFactory = function() return 
            { 
                createdFishables = {
                    {
                        caught = false;
                        hitbox = {
                            
                        };
                    }
                    };
            }
        end;
        }
        myInstance:update();
        assert.are.same(0.325, myInstance.modifier);
        myInstance.modifier = 0.8
        myInstance:update();
        assert.are.same(0.68, myInstance.modifier);
    end)

    it("Test sleeping pill duration", function()
        local myInstance = testClass(locWinDim, locLevel);
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

        local myInstance = testClass(locWinDim);
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

        local myInstance = testClass(locWinDim);
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

        local myInstance = testClass(locWinDim);
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

        local myInstance = testClass(locWinDim);
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

        local myInstance = testClass(locWinDim);
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

        local myInstance = testClass(locWinDim);
        local exp = 200;
        myInstance:checkUpgrades();
        assert.are.same(exp, myInstance.speed);
    end)

    it("Test x position limited to maxSpeed (positive direction)", function()
        local myInstance = testClass(locWinDim);
        myInstance.posXMouse = 70;
        myInstance.posXBait = 40;
        local newPos = myInstance.posXBait + myInstance.maxSpeedX;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test x position limited to maxSpeed (negative direction)", function()
        local myInstance = testClass(locWinDim);
        myInstance.posXMouse = 10;
        myInstance.posXBait = 40;
        local newPos = myInstance.posXBait - myInstance.maxSpeedX;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test x position not limited to maxSpeed (positive direction)", function()
        local myInstance = testClass(locWinDim);
        myInstance.posXMouse = 41;
        myInstance.posXBait = 40;
        local newPos = myInstance.posXMouse;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test x position not limited to maxSpeed (negative direction)", function()
        local myInstance = testClass(locWinDim);
        myInstance.posXMouse = 40;
        myInstance.posXBait = 41;
        local newPos = myInstance.posXMouse;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test x positon with no change", function()
        local myInstance = testClass(locWinDim);
        myInstance.posXMouse = 40;
        myInstance.posXBait = 40;
        local newPos = myInstance.posXMouse;
        myInstance:setCappedPosX();
        assert.are.same(myInstance.posXBait, newPos);
    end)

    it("Test getXPos", function()
        local myInstance = testClass(locWinDim);
        myInstance.posXBait = 0;
        assert.are.same(myInstance:getPosX(), 0);
    end)

    it("Test sleepingPillHitted", function()
        _G._persTable.upgrades = {
            sleepingPillDuration = 600; -- duration of the effect of the sleeping pill
            sleepingPillSlow = 0.3; -- sets the slow factor of the sleeping pill 0.25 = 25% of the usual movement
        };
        
        FishableObject = require "src.class.FishableObject";
        
        local myInstance = testClass (locWinDim);
        myInstance.sleepingPillDuration = 0;
        myInstance:sleepingPillHitted(FishableObject);
        
        
        assert.are.same(600, myInstance.sleepingPillDuration);
    end)

    it("Test setLevel", function()
        locInstance:setLevel("just a level");
        assert.are.same("just a level", locInstance.curLevel);
    end)
end)
