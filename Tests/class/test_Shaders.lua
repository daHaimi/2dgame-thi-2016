-- Lua 5.1 Hack
_G.math.inf = 1 / 0

--testClass = require "src.class.Shaders"


describe("Unit test for Shaders.lua", function()
    before_each(function()
        _G.love = {
            graphics = {
                newShader = function(...)
                    return {
                        send = function(...) end;
                    };
                end;
                setShader = function(...) end;
            };
        };
    end)

    it("Testing hueAjust", function()
        local shadersClass = require "src.class.Shaders";
        local hue = 0;
        -- add spyes
        local loveGraphicsMock = mock(_G.love.graphics, true);
        local shaderMock = mock(shadersClass.p_hueShader, true);
        -- call
        shadersClass:hueAjust(hue);
        -- check sypes
        assert.spy(shaderMock.send).was_called();
        assert.spy(loveGraphicsMock.setShader).was_called();
    end)

    it("Testing clear", function()
        local shadersClass = require "src.class.Shaders";

        local loveGraphicsMock = mock(_G.love.graphics, true);

        shadersClass:clear();

        assert.spy(loveGraphicsMock.setShader).was_called();
    end)
end)
