-- Lua 5.1 Hack
_G.math.inf = 1 / 0

--testClass = require "src.class.PostShader"


describe("Unit test for PostShader.lua", function()
    before_each(function()
        _G.love = {
            graphics = {
                getWidth = function()
                    return 1;
                end;
                getHeight = function()
                    return 1;
                end;
                draw = function(...) end;
                setColor = function(...) end;
                setBlendMode = function(...) end;
                getCanvas = function(...) end;
                newCanvas = function(...)
                    return 0;
                end;
                newShader = function(...)
                    return {
                        send = function(...) end;
                    };
                end;
                setShader = function(...) end;
            };
        };
    end)

    it("Testing addLightCone", function(...)
        -- function not implemented jet
    end)

    it("Testing draw", function(...)
        -- function not implemented jet
    end)

    it("Testing daytime", function()
        local postShader = require "src.class.PostShader";
        local time = 0.2;
        local graphicsMock = mock(_G.love.graphics, true);

        postShader:daytime(time);

        assert.spy(graphicsMock.getCanvas).was_called();
        assert.spy(graphicsMock.draw).was_called();
        assert.spy(graphicsMock.setShader).was_called();
    end)

    it("Testing addBlur", function()
        local postShader = require "src.class.PostShader";
        local blurV = 0;
        local blurH = 1;
        local graphicsMock = mock(_G.love.graphics, true);

        postShader:addBlur(blurV, blurH);

        assert.spy(graphicsMock.setColor).was_called();
        assert.spy(graphicsMock.setBlendMode).was_called();
        assert.spy(graphicsMock.setShader).was_called();
    end)
end)
