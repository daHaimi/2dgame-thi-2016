--[[
The MIT License (MIT)

Copyright (c) 2014 Marcus Ihde

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

_G.love.light = {};
_G.love.light.translate = {};
_G.love.light.shadow = {};

_G.love.light.BLURV = love.graphics.newShader("shader/blurv.glsl");
_G.love.light.BLURH = love.graphics.newShader("shader/blurh.glsl");
local width, height, _ = love.window.getMode();
local windowDimension = { width, height };
_G.love.light.BLURV:send("screen", windowDimension);
_G.love.light.BLURH:send("screen", windowDimension);

_G.love.light.translate.X = 0;
_G.love.light.translate.Y = 0;
_G.love.light.translate.X_OLD = 0;
_G.love.light.translate.Y_OLD = 0;
_G.love.light.DIRECTION = 0;

--- constructor for the light world
function love.light.newWorld()
    local worldObject = {};

    worldObject.width, worldObject.height, _ = love.window.getMode();

    worldObject.lights = {};
    worldObject.ambient = { 0, 0, 0 };
    worldObject.body = {};
    worldObject.shadow = love.graphics.newCanvas();
    worldObject.shadow2 = love.graphics.newCanvas();
    worldObject.shine = love.graphics.newCanvas();
    worldObject.glowMap = love.graphics.newCanvas();
    worldObject.shader = love.graphics.newShader("shader/poly_shadow.glsl");
    worldObject.changed = true;
    worldObject.blur = 2.0;
    worldObject.isShadows = false;
    worldObject.isLight = false;

    --- update interface
    worldObject.update = function()
        _G.love.light.LAST_BUFFER = love.graphics.getCanvas();

        love.graphics.setColor(255, 255, 255);
        love.graphics.setBlendMode("alpha");

        if worldObject.isShadows or worldObject.isLight then
            love.graphics.setShader(worldObject.shader);

            _G.love.light.BODY = worldObject.body;
            for i = 1, #worldObject.lights do
                if worldObject.lights[i].changed or worldObject.changed then
                    worldObject.lights[i].changed = worldObject.changed;
                end
            end

            -- update shadow
            love.graphics.setShader();
            love.graphics.setCanvas(worldObject.shadow);
            love.graphics.clear();
            love.graphics.setColor(unpack(worldObject.ambient));
            love.graphics.setBlendMode("alpha");
            love.graphics.rectangle("fill", love.light.translate.X, love.light.translate.Y, worldObject.width,
                worldObject.height); -- TODO might need fixing
            love.graphics.setColor(255, 255, 255);
            love.graphics.setBlendMode("add");
            for i = 1, #worldObject.lights do
                if worldObject.lights[i].visible then
                    love.graphics.draw(worldObject.lights[i].shadow, love.light.translate.X, love.light.translate.Y);
                end
            end
            worldObject.isShadowBlur = false;

            -- update shine
            love.graphics.setCanvas(worldObject.shine);
            love.graphics.setColor(unpack(worldObject.ambient));
            love.graphics.setBlendMode("alpha");
            love.graphics.setColor(255, 255, 255);
            love.graphics.setBlendMode("add");
            for i = 1, #worldObject.lights do
                if worldObject.lights[i].visible then
                    love.graphics.draw(worldObject.lights[i].shine, love.light.translate.X, love.light.translate.Y);
                end
            end
        end

        love.graphics.setShader();
        love.graphics.setBlendMode("alpha");
        love.graphics.clear();
        love.graphics.setCanvas(_G.love.light.LAST_BUFFER);

        worldObject.changed = false;
    end;
    --- draw shadow
    worldObject.drawShadow = function()
        if worldObject.isShadows or worldObject.isLight then
            love.graphics.setColor(255, 255, 255);
            if worldObject.blur then
                _G.love.light.LAST_BUFFER = _G.love.graphics.getCanvas();
                love.light.BLURV:send("steps", worldObject.blur);
                love.light.BLURH:send("steps", worldObject.blur);
                love.graphics.setBlendMode("alpha");
                love.graphics.setCanvas(worldObject.shadow2);
                love.graphics.setShader(_G.love.light.BLURV);
                love.graphics.draw(worldObject.shadow, _G.love.light.translate.X, _G.love.light.translate.Y);
                love.graphics.setCanvas(worldObject.shadow);
                love.graphics.setShader(_G.love.light.BLURH);
                love.graphics.draw(worldObject.shadow2, _G.love.light.translate.X, _G.love.light.translate.Y);
                love.graphics.setCanvas(_G.love.light.LAST_BUFFER);
                love.graphics.setBlendMode("multiply");
                love.graphics.setShader();
                love.graphics.draw(worldObject.shadow, _G.love.light.translate.X, _G.love.light.translate.Y);
                love.graphics.setBlendMode("alpha");
            else
                love.graphics.setBlendMode("multiply");
                love.graphics.setShader();
                love.graphics.draw(worldObject.shadow, _G.love.light.translate.X, _G.love.light.translate.Y);
                love.graphics.setBlendMode("alpha");
            end
        end
    end;
    --- contructor for a light in this world
    -- @param x position
    -- @param y position
    -- @param red color value
    -- @param green color value
    -- @param blue volor value
    -- @param range of the light
    worldObject.newLight = function(x, y, red, green, blue, range)
        worldObject.lights[#worldObject.lights + 1] = love.light.newLight(worldObject, x, y, red, green, blue, range);

        return worldObject.lights[#worldObject.lights];
    end;
    --- set ambient color
    -- @param red color value
    -- @param green color value
    -- @param blue color value
    worldObject.setAmbientColor = function(red, green, blue)
        worldObject.ambient = { red, green, blue };
    end;

    return worldObject;
end

--- creating a light object
-- @param p ?
-- @param x -position
-- @param y -position
-- @param red color value
-- @param green color value
-- @param blue color value
-- @param range range of the light
function _G.love.light.newLight(p, x, y, _, _, _, _)
    local lightObject = {};
    lightObject.range = 0;
    lightObject.x = x or 0;
    lightObject.y = y or 0;
    lightObject.z = 15;
    lightObject.smooth = 1.0;
    lightObject.changed = true;
    p.isLight = true;
    --- set position
    -- @param x position
    -- @param y position
    -- @param z
    lightObject.setPosition = function(x, y, z)
        if x ~= lightObject.x or y ~= lightObject.y or (z and z ~= lightObject.z) then
            lightObject.x = x;
            lightObject.y = y;
            if z then
                lightObject.z = z;
            end
            lightObject.changed = true;
        end
    end;
    --- set glow size
    -- @param smooth glow size
    lightObject.setSmooth = function(smooth)
        lightObject.smooth = smooth;
        lightObject.changed = true;
    end;

    return lightObject;
end
