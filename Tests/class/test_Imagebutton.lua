-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Imagebutton"

describe("Unit test for Imagebutton.lua", function()
    local locInstance;
    local image = {
            getWidth = function() return 20; end;
            getHeight = function() return 30; end;
         };
    before_each(function()
        _G.love = {
            graphics = {
                getFont = function() return "testFont"; end;
                draw = function(...) end;
                printf = function(...) end;
                setFont = function(...) end;
                newFont = function(...) return "newFont"; end;
            };
        };
        
        
        locInstance = testClass(image, 10, 10, true);
    end)

    it("Testing Constructor1", function()
        local myInstance = testClass(image, 10, 10, true);
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor2", function()
        locInstance = testClass(nil, 10, 10, true);
        local myInstance = testClass(nil, 10, 10, true);
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing draw function", function()
        spy.on(love.graphics, "getFont");
        spy.on(love.graphics, "newFont");
        stub(love.graphics, "setFont");
        stub(love.graphics, "draw");
        stub(love.graphics, "printf");
        locInstance:draw();
        assert.spy(love.graphics.getFont).was_called(1);
        assert.spy(love.graphics.newFont).was_called(1);
        assert.stub(love.graphics.setFont).was_called(2);
        assert.stub(love.graphics.draw).was_called(1);
        assert.stub(love.graphics.printf).was_called(1);
    end)

    it("Testing setText function", function()
        locInstance.text = "";
        locInstance:setText("test");
        assert.are.equal("test", locInstance.text);
    end)

    it("Testing setPosition function", function()
        locInstance.xPosition = 0;
        locInstance.yPosition = 0;
        locInstance:setPosition(1, 2);
        assert.are.equal(1, locInstance.xPosition);
        assert.are.equal(2, locInstance.yPosition);
    end)

    it("Testing getPosition function", function()
        locInstance.xPosition = 1;
        locInstance.yPosition = 2;
        local x, y = locInstance:getPosition();
        assert.are.equal(locInstance.xPosition, x);
        assert.are.equal(locInstance.yPosition, y);
    end)

    it("Testing getSize function", function()
        locInstance.width = 1;
        locInstance.height = 2;
        local w, h = locInstance:getSize();
        assert.are.equal(locInstance.width, w);
        assert.are.equal(locInstance.height, h);
    end)

    it("Testing setOffset function", function()
        locInstance.xOffset = 0;
        locInstance.yOffset = 0;
        locInstance:setOffset(1, 2);
        assert.are.equal(1, locInstance.xOffset);
        assert.are.equal(2, locInstance.yOffset);
    end)

    it("Testing getOffset function", function()
        locInstance.xOffset = 1;
        locInstance.yOffset = 2;
        local x, y = locInstance:getOffset();
        assert.are.equal(locInstance.xOffset, x);
        assert.are.equal(locInstance.yOffset, y);
    end)

    it("Testing setImage function", function()
        locInstance.image = nil;
        locInstance:setImage(image);
        assert.are.same(image, locInstance.image);
        assert.are.equal(20, locInstance.width);
        assert.are.equal(30, locInstance.height);
        
        locInstance:setImage(nil);
        assert.are.same(nil, locInstance.image);
        assert.are.equal(0, locInstance.width);
        assert.are.equal(0, locInstance.height);
    end)

    it("Testing setClickable function", function()
        locInstance.clickable = false;
        locInstance:setClickable(true);
        assert.are.equal(true, locInstance.clickable);
    end)

end)
