-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Notification";
fakeElement = require "Tests.fakeLoveframes.fakeElement";


describe("Unit test for Notification.lua", function()
    local locInstance;

    before_each(function()

        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        };
        
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

    it("Testing function newNotification", function()
        locInstance.imageLength = 50;
        locInstance.imageWidth = 50;
        locInstance:newNotification("imagepath1", "text1");
        locInstance:newNotification("imagepath2", "text2");
        
        assert.are.equal(locInstance.notificationBuffer[1].image.imagepath, "imagepath1");
        assert.are.equal(locInstance.notificationBuffer[2].image.imagepath, "imagepath2");
        assert.are.equal(locInstance.notificationBuffer[1].image.visible, false);
        assert.are.equal(locInstance.notificationBuffer[2].image.visible, false);
        assert.are.equal(locInstance.notificationBuffer[1].image.xScale, 5);
        assert.are.equal(locInstance.notificationBuffer[1].image.yScale, 2.5);
        assert.are.equal(locInstance.notificationBuffer[2].image.xScale, 5);
        assert.are.equal(locInstance.notificationBuffer[2].image.yScale, 2.5);
        assert.are.equal(locInstance.notificationBuffer[1].text.text, "text1");
        assert.are.equal(locInstance.notificationBuffer[1].text.visible, false);
        assert.are.equal(locInstance.notificationBuffer[2].text.text, "text2");
        assert.are.equal(locInstance.notificationBuffer[2].text.visible, false);
    end)

    it("Testing function removeNotification", function()
        locInstance.notificationBuffer = {"test1", "test2", "test3"};
        locInstance:removeNotification();
        assert.are.same(locInstance.notificationBuffer, {"test2", "test3"});
        locInstance:removeNotification();
        assert.are.same(locInstance.notificationBuffer, {"test3"});
        locInstance:removeNotification();
        assert.are.same(locInstance.notificationBuffer, {});
    end)

    it("Testing function flyIn", function()
        stub(locInstance, "SetPos");
        locInstance.x = 10;
        locInstance.speed = 1;
        locInstance:flyIn();
        assert.are.equal(locInstance.x, 9);
        assert.stub(locInstance.SetPos).was_called();
    end)

    it("Testing function flyOut", function()
        stub(locInstance, "SetPos");
        locInstance.x = 10;
        locInstance.speed = 1;
        locInstance:flyOut();
        assert.are.equal(locInstance.x, 11);
        assert.stub(locInstance.SetPos).was_called();
    end)

    it("Testing function checkPosition", function()
        locInstance.x = 5;
        locInstance.defaultX = 10;
        locInstance.length = 5;
        assert.are.equal(locInstance:checkPosition("in"), true);
        locInstance.x = 10;
        assert.are.equal(locInstance:checkPosition("in"), false);
        locInstance.x = 10;
        assert.are.equal(locInstance:checkPosition("out"), true);
        locInstance.x = 5;
        assert.are.equal(locInstance:checkPosition("out"), false);
    end)

    it("Testing function SetPos", function()
        locInstance.offset = 50;
        locInstance.imageLength = 60;
        locInstance.notificationBuffer = {};
        locInstance:SetPos(5, 6);
        assert.same.equal(locInstance.background.x, 5);
        assert.same.equal(locInstance.background.y, 6);
        
        locInstance.notificationBuffer = {
            [1] = {
                image = fakeElement("test");
                text = fakeElement("test");
            };
        };
        
        locInstance:SetPos(5, 6);
        assert.are.equal(locInstance.notificationBuffer[1].image.x, 55);
        assert.are.equal(locInstance.notificationBuffer[1].image.y, 56);
        assert.are.equal(locInstance.notificationBuffer[1].text.x, 115);
        assert.are.equal(locInstance.notificationBuffer[1].text.y, 56);
    end)


    it("Testing function SetVisible", function()
        locInstance.notificationBuffer = {};
        locInstance:SetVisible(true);
        assert.same.equal(locInstance.background.visible, true);
        
        locInstance.notificationBuffer = {
            [1] = {
                image = fakeElement("test");
                text = fakeElement("test");
            };
        };
        
        locInstance:SetVisible(false);
        assert.are.equal(locInstance.notificationBuffer[1].image.visible, false);
        assert.are.equal(locInstance.notificationBuffer[1].text.visible, false);
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
        locInstance.state = 0;
        locInstance:update();
        assert.stub(locInstance.SetVisible).was_called();
        assert.spy(locInstance.checkPosition).was_called();
        assert.stub(locInstance.flyIn).was_called();
        assert.are.equal(locInstance.state, 1);
        
        locInstance.x = 5;
        locInstance:update();
        assert.are.equal(locInstance.time, 1);
        assert.are.equal(locInstance.state, 2);
        
        locInstance:update();
        assert.are.equal(locInstance.time, 2);
        
        assert.are.equal(locInstance.state, 3);
        assert.stub(locInstance.flyOut);
        
        locInstance.x = 11;
        locInstance:update();
        assert.spy(locInstance.checkPosition).was_called();
        assert.stub(locInstance.SetVisible).was_called();
        assert.stub(locInstance.removeNotification).was_called();
        assert.are.equal(locInstance.x, locInstance.defaultX);
        assert.are.equal(locInstance.time, 0);
        assert.are.equal(locInstance.state, 0);
    end)

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end)