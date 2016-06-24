-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Notification";
fakeElement = require "Tests.fakeLoveframes.fakeElement";


describe("Unit test for Notification.lua", function()
    local locInstance;

    before_each(function()

        _G.love = {
            graphics = {
                newImage = function(path) return path; end;
            };
        };
        _G._persTable = {
            winDim = { 500, 500 };
        };
        locInstance = testClass();
    end)


    it("Testing Constructor", function()
        local myInstance = testClass();
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing function newNotification", function()
        locInstance.imageLength = 50;
        locInstance.imageWidth = 50;
        locInstance:newNotification("imagepath1", "text1");
        locInstance:newNotification("imagepath2", "text2");

        assert.are.equal(locInstance.notificationBuffer[1].image, "imagepath1");
        assert.are.equal(locInstance.notificationBuffer[2].image, "imagepath2");
        assert.are.equal(locInstance.notificationBuffer[1].text, "text1");
        assert.are.equal(locInstance.notificationBuffer[2].text, "text2");
    end)

    it("Testing function removeNotification", function()
        locInstance.notificationBuffer = { "test1", "test2", "test3" };
        locInstance:removeNotification();
        assert.are.same(locInstance.notificationBuffer, { "test2", "test3" });
        locInstance:removeNotification();
        assert.are.same(locInstance.notificationBuffer, { "test3" });
        locInstance:removeNotification();
        assert.are.same(locInstance.notificationBuffer, {});
    end)

    it("Testing function flyIn", function()
        locInstance.xPos = 10;
        locInstance.speed = 1;
        locInstance:flyIn();
        assert.are.equal(locInstance.xPos, 9);
    end)

    it("Testing function flyOut", function()
        locInstance.xPos = 10;
        locInstance.speed = 1;
        locInstance:flyOut();
        assert.are.equal(locInstance.xPos, 11);
    end)

    it("Testing function checkPosition", function()
        locInstance.x = 5;
        locInstance.defaultX = 10;
        locInstance.length = 5;
        --assert.are.equal(locInstance:checkPosition("in"), true);
        locInstance.x = 10;
        assert.are.equal(locInstance:checkPosition("in"), false);
        locInstance.x = 10;
        assert.are.equal(locInstance:checkPosition("out"), true);
        locInstance.x = 5;
        --assert.are.equal(locInstance:checkPosition("out"), false);
    end)

    it("Testing function update", function()
        stub(locInstance, "SetVisible");
        spy.on(locInstance, "checkPosition");
        stub(locInstance, "flyIn");
        stub(locInstance, "flyOut");
        stub(locInstance, "removeNotification");
        locInstance.time = 0;
        locInstance.waitingTime = 2;
        locInstance.x = 6;
        locInstance.defaultX = 10;
        locInstance.length = 5;

        locInstance.notificationBuffer = {
            [1] = {
                image = fakeElement("test");
                text = fakeElement("test");
            };
        };
        --state0
        locInstance.state = 1;
        locInstance:update();
        assert.spy(locInstance.checkPosition).was_called();
        assert.stub(locInstance.flyIn).was_called();
        assert.are.equal(locInstance.state, 1);

        locInstance.xPos = 5;
        locInstance:update();
        assert.are.equal(locInstance.time, 1);
        assert.are.equal(locInstance.state, 2);

        locInstance:update();
        assert.are.equal(locInstance.time, 2);

        assert.are.equal(locInstance.state, 3);
        assert.stub(locInstance.flyOut);

        locInstance.xPos = 11;
        locInstance:update();
        assert.spy(locInstance.checkPosition).was_called();
        assert.stub(locInstance.removeNotification).was_called();
        --assert.are.equal(locInstance.x, locInstance.defaultX);
        assert.are.equal(locInstance.time, 0);
        assert.are.equal(locInstance.state, 1);
    end)
end)
