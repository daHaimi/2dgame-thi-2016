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
        _G._persTable = {
            scaledDeviceDim = {500, 500};
        };
        locInstance = testClass();
    end)


    it("Testing Constructor", function()
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor", function()
        _G._persTable = {
            scaledDeviceDim = {640, 950};
        };
        locInstance = testClass();
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor", function()
        _G._persTable = {
            scaledDeviceDim = {720, 1024};
        };
        locInstance = testClass();
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)

    it("testing create function", function()
        assert.are.equal(locInstance.elementsOnFrame.title.type, "image");
        assert.are.equal(locInstance.elementsOnFrame.title.imagepath, "assets/gui/title.png");
        
        assert.are.equal(locInstance.elementsOnFrame.hamster.type, "image");
        assert.are.equal(locInstance.elementsOnFrame.hamster.imagepath, "assets/gui/hamster.png");
        
        assert.are.equal(locInstance.elementsOnFrame.text.type, "text");
        assert.are.equal(locInstance.elementsOnFrame.text.text, "Click to start!");
    end)

    it("testing blink function", function()
        locInstance.elementsOnFrame.text.visible = true;
        locInstance.blinkTimer = 2;
        locInstance:blink();
        assert.are.equal(locInstance.blinkTimer, 1);
        assert.are.equal(locInstance.elementsOnFrame.text.visible, true);
        locInstance:blink();
        assert.are.equal(locInstance.blinkTimer, 50);
        assert.are.equal(locInstance.elementsOnFrame.text.visible, false);
    end)

    it("testing draw function", function()
        locInstance:draw();
        for k, v in pairs(locInstance.elementsOnFrame) do
            assert.are.equal(v.visible, true);
        end
    end)

    it("testing clear function", function()
        locInstance:clear();
        for k, v in pairs(locInstance.elementsOnFrame) do
            assert.are.equal(v.visible, false);
        end
    end)

    it("testing appear function", function()
        locInstance.x = 50;
        locInstance.y = 60;
        locInstance.offset = 5;
        locInstance.speed = 1;
        
        locInstance:appear();
        
        assert.are.equal(locInstance.elementsOnFrame.title.x, 45);
        assert.are.equal(locInstance.elementsOnFrame.title.y, 60);
        assert.are.equal(locInstance.elementsOnFrame.hamster.x, 355);
        assert.are.equal(locInstance.elementsOnFrame.hamster.y, 10);
        assert.are.equal(locInstance.offset, 4);
    end)

    it("testing disappear function", function()
        locInstance.x = 50;
        locInstance.y = 60;
        locInstance.offset = 5;
        locInstance.speed = 1;
        
        locInstance:disappear();
        
        assert.are.equal(locInstance.elementsOnFrame.title.x, 55);
        assert.are.equal(locInstance.elementsOnFrame.title.y, 60);
        assert.are.equal(locInstance.elementsOnFrame.hamster.x, 295);
        assert.are.equal(locInstance.elementsOnFrame.hamster.y, 10);
        assert.are.equal(locInstance.offset, 4);
    end)

    it("testing disappear function", function()
        locInstance.offset = 1;
        assert.are.equal(locInstance:checkPosition(), false);
        locInstance.offset = 0;
        assert.are.equal(locInstance:checkPosition(), true);
    end)
end)