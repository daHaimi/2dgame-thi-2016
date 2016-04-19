-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Bait"

describe("Unit test for Bait.lua", function()
    local locInstance;
    --- possible Window size
    local locWinDim = {400, 800}; 
    
    
    before_each(function()
        _G.love = {
            mouse = {
                setPosition = function(...)  end
            }
        }
            
        locInstance = testClass(locWinDim);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass(locWinDim);
        assert.are.same(locInstance, myInstance);
    end)


    ---- Tests for more Life
    it("Test moreLife 0", function()
        _G._persTable = {
        };
    
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
        _G._persTable = {
        };
    
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
        _G._persTable = {
        };
    
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
        _G._persTable = {
        };
    
        _G._persTable.upgrades = {
            speedUp = 0; --- "0" no Speedup
            moreLife = 0; --- amount of additional lifes
        };
 
        local myInstance = testClass(locWinDim);
        local exp = 100;
        myInstance:checkUpgrades();
        assert.are.same(myInstance.speed, exp);
    end)
    
    it("Test speed 1", function()
        _G._persTable = {
        };
    
        _G._persTable.upgrades = {
            speedUp = 1; --- "0" no Speedup
            moreLife = 0; --- amount of additional lifes
        };
 
        local myInstance = testClass(locWinDim);
        local exp = 200;
        myInstance:checkUpgrades();
        assert.are.same(myInstance.speed, exp);
    end)
    
    it("Test speed -1", function()
        _G._persTable = {
        };
    
        _G._persTable.upgrades = {
            speedUp = -1; --- weil kleiner null nix passiert wegen if
            moreLife = 0; --- amount of additional lifes
        };
 
        local myInstance = testClass(locWinDim);
        local exp = 100;
        myInstance:checkUpgrades();
        assert.are.same(myInstance.speed, exp);
    end)
    
    
    
end)