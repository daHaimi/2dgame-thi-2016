-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.Animate"

describe("Unit test for Animate.lua", function()
    local locInstance;
    local locImage = {
        getWidth = function() return 48; end;
        getHeight = function() return 96; end;
        getDimensions = function() return 48, 96; end;
    }
    local function round(num, idp)
        local mult = 10^(idp or 0)
        return math.floor(num * mult + 0.5) / mult
    end
    local almost_equal = function(actual, expected)
        assert.are.equal(round(actual, 6), round(expected, 6));
    end

    before_each(function()
        _G.love = {
            graphics = {
                draw = function(...) end;
                newQuad = function(...) return 0; end;
            }
        };

        locInstance = testClass(locImage, 1, 1);
    end)

    it("Testing Constructor", function()
        local myInstance = testClass(locImage, 1, 1);
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor 4 params", function()
        local myInstance1 = testClass(locImage, 2, 1, .3);
        local myInstance2 = testClass(locImage, 2, 1, .3);
        locInstance.p_cols = 2;
        locInstance.p_numEnd = 2;
        locInstance.p_measures[1] = 24;
        locInstance.p_timeout = .3;
        locInstance.p_quads = {0,0};
        assert.are.same(myInstance1, myInstance2);
    end)

    it("Testing Constructor 5 params", function()
        local myInstance1 = testClass(locImage, 2, 1, .1, 2);
        local myInstance2 = testClass(locImage, 2, 1, .1, 2);
        locInstance.p_cols = 2;
        locInstance.p_numEnd = 2;
        locInstance.p_measures[1] = 24;
        locInstance.p_timeout = .1;
        locInstance.p_quads = {0,0};
        locInstance.p_animType = 2;
        assert.are.same(myInstance1, myInstance2);
    end)

    it("Testing Constructor 6 params", function()
        local myInstance1 = testClass(locImage, 2, 1, .1, 2, true, math.inf);
        local myInstance2 = testClass(locImage, 2, 1, .1, 2, true, math.inf);
        locInstance.p_cols = 2;
        locInstance.p_numStart = 2;
        locInstance.p_curPos = 2;
        locInstance.p_numEnd = 2;
        locInstance.p_measures[1] = 24;
        locInstance.p_timeout = .1;
        locInstance.p_quads = {[2]=0};
        locInstance.p_animType = 2;
        assert.are.same(myInstance1, myInstance2);
    end)

    it("Testing Constructor 6 params", function()
        local myInstance1 = testClass(locImage, 4, 1, .1, 3, true, math.inf);
        local myInstance2 = testClass(locImage, 4, 1, .1, 3, true, math.inf);
        locInstance.p_cols = 4;
        locInstance.p_numStart = 2;
        locInstance.p_curPos = 2;
        locInstance.p_numEnd = 3;
        locInstance.p_measures[1] = 12;
        locInstance.p_timeout = .1;
        locInstance.p_quads = {[2]=0,[3]=0};
        locInstance.p_animType = 3;
        assert.are.same(myInstance1, myInstance2);
    end)

    it("Testing shiftImage linear", function()
        local myInstance = testClass(locImage, 4, 1, .1, 1, true, math.inf);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 2);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 3);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 4);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 1);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 2);
    end)

    it("Testing shiftImage bounce", function()
        local myInstance = testClass(locImage, 4, 1, .1, 2, true, math.inf);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 2);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 3);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 4);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 3);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 2);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 1);
    end)

    it("Testing shiftImage bounce", function()
        local myInstance = testClass(locImage, 4, 1, .1, 2, true, math.inf);
        myInstance:shiftImage();
        assert.are.equal(myInstance.p_curPos, 2);
        myInstance:shiftImage();
        assert.is_true(myInstance.p_curPos >= 2 and myInstance.p_curPos <= 4);
        myInstance:shiftImage();
        assert.is_true(myInstance.p_curPos >= 2 and myInstance.p_curPos <= 4);
        myInstance:shiftImage();
        assert.is_true(myInstance.p_curPos >= 2 and myInstance.p_curPos <= 4);
        myInstance:shiftImage();
        assert.is_true(myInstance.p_curPos >= 2 and myInstance.p_curPos <= 4);
        myInstance:shiftImage();
        assert.is_true(myInstance.p_curPos >= 1 and myInstance.p_curPos <= 4);
    end)

    it("Testing update", function()
        local myInstance = testClass(locImage, 4, 1, .5);
        local s = stub(myInstance, "shiftImage");
        myInstance:update(.1);
        almost_equal(myInstance.p_timer, .1);
        assert.stub(myInstance.shiftImage).was_called(0);
        myInstance:update(.2);
        almost_equal(myInstance.p_timer, .3);
        assert.stub(myInstance.shiftImage).was_called(0);
        myInstance:update(.3);
        almost_equal(myInstance.p_timer, .1);
        assert.stub(myInstance.shiftImage).was_called(1);
    end)

    it("Testing draw", function()
        local myInstance = testClass(locImage, 4, 1, .5, 2, 2);
        local s = stub(love.graphics, "draw");
        myInstance:draw(42, 1337);
        assert.stub(love.graphics.draw).was_called_with(myInstance.p_image, myInstance.p_quads[2], 42, 1337);
    end)

    it("Testing start", function()
        locInstance.start = false;
        locInstance:startAnimation();
        assert.are.same(true, locInstance.start);
    end);

    it("Testing stop", function()
        locInstance.start = true;
        locInstance:stopAnimation();
        assert.are.same(false, locInstance.start);
    end);
end)
