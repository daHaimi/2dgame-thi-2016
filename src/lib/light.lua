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

_G.love.light = {}
_G.love.light.translate = {}

_G.love.light.CURRENT = nil
_G.love.light.CIRCLE = nil
_G.love.light.POLY = nil
_G.love.light.IMAGE = nil
_G.love.light.BODY = nil
_G.love.light.LAST_BUFFER = nil
_G.love.light.SHADOW_GEOMETRY = nil

_G.love.light.BLURV = love.graphics.newShader("shader/blurv.glsl")
_G.love.light.BLURH = love.graphics.newShader("shader/blurh.glsl")
local width, height, _ = love.window.getMode()
local windowDimension = { width, height }
_G.love.light.BLURV:send("screen", windowDimension)
_G.love.light.BLURH:send("screen", windowDimension)

_G.love.light.translate.X = 0
_G.love.light.translate.Y = 0
_G.love.light.translate.X_OLD = 0
_G.love.light.translate.Y_OLD = 0
_G.love.light.DIRECTION = 0

--- constructor for the light world
-- noinspection LuaOverlyLongMethod
function _G.love.light.newWorld()
    local worldObject = {}

    worldObject.width, worldObject.height, _ = love.window.getMode()

    worldObject.lights = {}
    worldObject.ambient = { 0, 0, 0 }
    worldObject.body = {}
    worldObject.refraction = {}
    worldObject.shadow = love.graphics.newCanvas()
    worldObject.shadow2 = love.graphics.newCanvas()
    worldObject.shine = love.graphics.newCanvas()
    worldObject.shine2 = love.graphics.newCanvas()
    worldObject.normalMap = love.graphics.newCanvas()
    worldObject.glowMap = love.graphics.newCanvas()
    worldObject.glowMap2 = love.graphics.newCanvas()
    worldObject.refractionMap = love.graphics.newCanvas()
    worldObject.refractionMap2 = love.graphics.newCanvas()
    worldObject.reflectionMap = love.graphics.newCanvas()
    worldObject.reflectionMap2 = love.graphics.newCanvas()
    worldObject.normalInvert = false
    worldObject.glowBlur = 1.0
    worldObject.glowTimer = 0.0
    worldObject.glowDown = false
    worldObject.refractionStrength = 8.0
    worldObject.pixelShadow = love.graphics.newCanvas()
    worldObject.pixelShadow2 = love.graphics.newCanvas()
    worldObject.shader = love.graphics.newShader("shader/poly_shadow.glsl")
    worldObject.glowShader = love.graphics.newShader("shader/glow.glsl")
    worldObject.normalShader = love.graphics.newShader("shader/normal.glsl")
    worldObject.normalInvertShader = love.graphics.newShader("shader/normal_invert.glsl")
    worldObject.materialShader = love.graphics.newShader("shader/material.glsl")
    worldObject.refractionShader = love.graphics.newShader("shader/refraction.glsl")
    worldObject.refractionShader:send("screen", { worldObject.width, worldObject.height })
    worldObject.reflectionShader = love.graphics.newShader("shader/reflection.glsl")
    worldObject.reflectionShader:send("screen", { worldObject.width, worldObject.height })
    worldObject.reflectionStrength = 16.0
    worldObject.reflectionVisibility = 1.0
    worldObject.changed = true
    worldObject.blur = 2.0
    worldObject.optionShadows = true
    worldObject.optionPixelShadows = true
    worldObject.optionGlow = true
    worldObject.optionRefraction = true
    worldObject.optionReflection = true
    worldObject.isShadows = false
    worldObject.isLight = false
    worldObject.isPixelShadows = false
    worldObject.isGlow = false
    worldObject.isRefraction = false
    worldObject.isReflection = false

    --- update interface
    worldObject.update = function()
        _G.love.light.LAST_BUFFER = love.graphics.getCanvas()

        local xChanged = _G.love.light.translate.X ~= _G.love.light.translate.X_OLD
        local yChanged = _G.love.light.translate.Y ~= _G.love.light.translate.Y_OLD
        if xChanged or yChanged then
            _G.love.light.translate.X_OLD = _G.love.light.translate.X
            _G.love.light.translate.Y_OLD = _G.love.light.translate.Y
            worldObject.changed = true
        end

        love.graphics.setColor(255, 255, 255)
        love.graphics.setBlendMode("alpha")

        if worldObject.optionShadows and (worldObject.isShadows or worldObject.isLight) then
            love.graphics.setShader(worldObject.shader)

            local lightsOnScreen = 0
            _G.love.light.BODY = worldObject.body
            for i = 1, #worldObject.lights do
                if worldObject.lights[i].changed or worldObject.changed then
                    local xVisionMax = worldObject.lights[i].x + worldObject.lights[i].range
                    local xVisionMin = worldObject.lights[i].x - worldObject.lights[i].range
                    local inXRange = xVisionMax > _G.love.light.translate.X and xVisionMin < worldObject.width + _G.love.light.translate.X
                    local yVisionMax = worldObject.lights[i].y + worldObject.lights[i].range
                    local yVisionMin = worldObject.lights[i].y - worldObject.lights[i].range
                    local inYRange = yVisionMax > _G.love.light.translate.Y and yVisionMin < worldObject.height + _G.love.light.translate.Y
                    if inXRange and inYRange then
                        local lightposrange = { worldObject.lights[i].x, worldObject.height - worldObject.lights[i].y, worldObject.lights[i].range }
                        _G.love.light.CURRENT = worldObject.lights[i]
                        _G.love.light.DIRECTION = _G.love.light.DIRECTION + 0.002
                        worldObject.shader:send("lightPosition", { worldObject.lights[i].x - _G.love.light.translate.X, worldObject.height - (worldObject.lights[i].y - _G.love.light.translate.Y), worldObject.lights[i].z })
                        worldObject.shader:send("lightRange", worldObject.lights[i].range)
                        worldObject.shader:send("lightColor", { worldObject.lights[i].red / 255.0, worldObject.lights[i].green / 255.0, worldObject.lights[i].blue / 255.0 })
                        worldObject.shader:send("lightSmooth", worldObject.lights[i].smooth)
                        worldObject.shader:send("lightGlow", { 1.0 - worldObject.lights[i].glowSize, worldObject.lights[i].glowStrength })
                        worldObject.shader:send("lightAngle", math.pi - worldObject.lights[i].angle / 2.0)
                        worldObject.shader:send("lightDirection", worldObject.lights[i].direction)

                        love.graphics.setCanvas(worldObject.lights[i].shadow)
                        love.graphics.clear()

                        -- calculate shadows
                        _G.love.light.SHADOW_GEOMETRY = _G.love.light.calculateShadows(_G.love.light.CURRENT, _G.love.light.BODY)

                        -- draw shadow
                        love.graphics.stencil(_G.love.light.shadowStencil, "invert", 0)
                        --love.graphics.setInvertedStencil(_G.love.light.shadowStencil)
                        love.graphics.setBlendMode("add")
                        love.graphics.rectangle("fill", _G.love.light.translate.X, _G.love.light.translate.Y, worldObject.width, worldObject.height)

                        -- draw color shadows
                        love.graphics.setBlendMode("multiply")
                        love.graphics.setShader()
                        for k = 1, #_G.love.light.SHADOW_GEOMETRY do
                            if _G.love.light.SHADOW_GEOMETRY[k].alpha < 1.0 then
                                love.graphics.setColor(_G.love.light.SHADOW_GEOMETRY[k].red * (1.0 - _G.love.light.SHADOW_GEOMETRY[k].alpha),
                                    _G.love.light.SHADOW_GEOMETRY[k].green * (1.0 - _G.love.light.SHADOW_GEOMETRY[k].alpha),
                                    _G.love.light.SHADOW_GEOMETRY[k].blue * (1.0 - _G.love.light.SHADOW_GEOMETRY[k].alpha))
                                love.graphics.polygon("fill", unpack(_G.love.light.SHADOW_GEOMETRY[k]))
                            end
                        end

                        for k = 1, #_G.love.light.BODY do
                            if _G.love.light.BODY[k].alpha < 1.0 then
                                love.graphics.setBlendMode("multiply")
                                love.graphics.setColor(_G.love.light.BODY[k].red, _G.love.light.BODY[k].green, _G.love.light.BODY[k].blue)
                                if _G.love.light.BODY[k].shadowType == "circle" then
                                    love.graphics.circle("fill", _G.love.light.BODY[k].x - _G.love.light.BODY[k].ox, _G.love.light.BODY[k].y - _G.love.light.BODY[k].oy, _G.love.light.BODY[k].radius)
                                elseif _G.love.light.BODY[k].shadowType == "rectangle" then
                                    love.graphics.rectangle("fill", _G.love.light.BODY[k].x - _G.love.light.BODY[k].ox, _G.love.light.BODY[k].y - _G.love.light.BODY[k].oy, _G.love.light.BODY[k].width, _G.love.light.BODY[k].height)
                                elseif _G.love.light.BODY[k].shadowType == "polygon" then
                                    love.graphics.polygon("fill", unpack(_G.love.light.BODY[k].data))
                                end
                            end

                            if _G.love.light.BODY[k].shadowType == "image" and _G.love.light.BODY[k].img then
                                love.graphics.setBlendMode("alpha")
                                local length = 1.0
                                local shadowRotation = math.atan2((_G.love.light.BODY[k].x) - worldObject.lights[i].x, (_G.love.light.BODY[k].y + _G.love.light.BODY[k].oy) - worldObject.lights[i].y)
                                --local alpha = math.abs(math.cos(shadowRotation))

                                _G.love.light.BODY[k].shadowVert = {
                                    { math.sin(shadowRotation) * _G.love.light.BODY[k].imgHeight * length, (length * math.cos(shadowRotation) + 1.0) * _G.love.light.BODY[k].imgHeight + (math.cos(shadowRotation) + 1.0) * _G.love.light.BODY[k].shadowY, 0, 0, _G.love.light.BODY[k].red, _G.love.light.BODY[k].green, _G.love.light.BODY[k].blue, _G.love.light.BODY[k].alpha * _G.love.light.BODY[k].fadeStrength * 255 },
                                    { _G.love.light.BODY[k].imgWidth + math.sin(shadowRotation) * _G.love.light.BODY[k].imgHeight * length, (length * math.cos(shadowRotation) + 1.0) * _G.love.light.BODY[k].imgHeight + (math.cos(shadowRotation) + 1.0) * _G.love.light.BODY[k].shadowY, 1, 0, _G.love.light.BODY[k].red, _G.love.light.BODY[k].green, _G.love.light.BODY[k].blue, _G.love.light.BODY[k].alpha * _G.love.light.BODY[k].fadeStrength * 255 },
                                    { _G.love.light.BODY[k].imgWidth, _G.love.light.BODY[k].imgHeight + (math.cos(shadowRotation) + 1.0) * _G.love.light.BODY[k].shadowY, 1, 1, _G.love.light.BODY[k].red, _G.love.light.BODY[k].green, _G.love.light.BODY[k].blue, _G.love.light.BODY[k].alpha * 255 },
                                    { 0, _G.love.light.BODY[k].imgHeight + (math.cos(shadowRotation) + 1.0) * _G.love.light.BODY[k].shadowY, 0, 1, _G.love.light.BODY[k].red, _G.love.light.BODY[k].green, _G.love.light.BODY[k].blue, _G.love.light.BODY[k].alpha * 255 }
                                }

                                _G.love.light.BODY[k].shadowMesh:setVertices(_G.love.light.BODY[k].shadowVert)
                                love.graphics.draw(_G.love.light.BODY[k].shadowMesh, _G.love.light.BODY[k].x - _G.love.light.BODY[k].ox + _G.love.light.translate.X, _G.love.light.BODY[k].y - _G.love.light.BODY[k].oy + _G.love.light.translate.Y)
                            end
                        end

                        love.graphics.setShader(worldObject.shader)

                        -- draw shine
                        love.graphics.setCanvas(worldObject.lights[i].shine)
                        --o.lights[i].shine:clear(255, 255, 255)
                        love.graphics.clear(255, 255, 255)
                        love.graphics.setBlendMode("alpha")
                        --love.graphics.setStencil(_G.love.light.polyStencil)
                        love.graphics.stencil(_G.love.light.polyStencil, "replace", 1)
                        love.graphics.rectangle("fill", _G.love.light.translate.X, _G.love.light.translate.Y, worldObject.width, worldObject.height)

                        lightsOnScreen = lightsOnScreen + 1

                        worldObject.lights[i].visible = true
                    else
                        worldObject.lights[i].visible = false
                    end

                    worldObject.lights[i].changed = worldObject.changed
                end
            end

            -- update shadow
            love.graphics.setShader()
            love.graphics.setCanvas(worldObject.shadow)
            --love.graphics.setStencil()
            love.graphics.clear()
            love.graphics.setColor(unpack(worldObject.ambient))
            love.graphics.setBlendMode("alpha")
            love.graphics.rectangle("fill", _G.love.light.translate.X, _G.love.light.translate.Y, worldObject.width, worldObject.height)
            love.graphics.setColor(255, 255, 255)
            love.graphics.setBlendMode("add")
            for i = 1, #worldObject.lights do
                if worldObject.lights[i].visible then
                    love.graphics.draw(worldObject.lights[i].shadow, _G.love.light.translate.X, _G.love.light.translate.Y)
                end
            end
            worldObject.isShadowBlur = false

            -- update shine
            love.graphics.setCanvas(worldObject.shine)
            love.graphics.setColor(unpack(worldObject.ambient))
            love.graphics.setBlendMode("alpha")
            love.graphics.rectangle("fill", 0, 0, worldObject.width, worldObject.height)
            love.graphics.setColor(255, 255, 255)
            love.graphics.setBlendMode("add")
            for i = 1, #worldObject.lights do
                if worldObject.lights[i].visible then
                    love.graphics.draw(worldObject.lights[i].shine, _G.love.light.translate.X, _G.love.light.translate.Y)
                end
            end
        end

        if worldObject.optionPixelShadows and worldObject.isPixelShadows then
            -- update pixel shadow
            love.graphics.setBlendMode("alpha")

            -- create normal map
            worldObject.normalMap:clear()
            love.graphics.setShader()
            love.graphics.setCanvas(worldObject.normalMap)
            for i = 1, #worldObject.body do
                if worldObject.body[i].type == "image" and worldObject.body[i].normalMesh then
                    love.graphics.setColor(255, 255, 255)
                    love.graphics.draw(worldObject.body[i].normalMesh, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.translate.Y)
                end
            end
            love.graphics.setColor(255, 255, 255)
            love.graphics.setBlendMode("alpha")

            worldObject.pixelShadow2:clear()
            love.graphics.setCanvas(worldObject.pixelShadow2)
            love.graphics.setBlendMode("additive")
            love.graphics.setShader(worldObject.shader2)

            for i = 1, #worldObject.lights do
                if worldObject.lights[i].visible then
                    if worldObject.normalInvert then
                        worldObject.normalInvertShader:send('screenResolution', { worldObject.width, worldObject.height })
                        worldObject.normalInvertShader:send('lightColor', { worldObject.lights[i].red / 255.0, worldObject.lights[i].green / 255.0, worldObject.lights[i].blue / 255.0 })
                        worldObject.normalInvertShader:send('lightPosition', { worldObject.lights[i].x, worldObject.height - worldObject.lights[i].y, worldObject.lights[i].z / 255.0 })
                        worldObject.normalInvertShader:send('lightRange', { worldObject.lights[i].range })
                        worldObject.normalInvertShader:send("lightSmooth", worldObject.lights[i].smooth)
                        worldObject.normalInvertShader:send("lightAngle", math.pi - worldObject.lights[i].angle / 2.0)
                        worldObject.normalInvertShader:send("lightDirection", worldObject.lights[i].direction)
                        love.graphics.setShader(worldObject.normalInvertShader)
                    else
                        worldObject.normalShader:send('screenResolution', { worldObject.width, worldObject.height })
                        worldObject.normalShader:send('lightColor', { worldObject.lights[i].red / 255.0, worldObject.lights[i].green / 255.0, worldObject.lights[i].blue / 255.0 })
                        worldObject.normalShader:send('lightPosition', { worldObject.lights[i].x, worldObject.height - worldObject.lights[i].y, worldObject.lights[i].z / 255.0 })
                        worldObject.normalShader:send('lightRange', { worldObject.lights[i].range })
                        worldObject.normalShader:send("lightSmooth", worldObject.lights[i].smooth)
                        worldObject.normalShader:send("lightAngle", math.pi - worldObject.lights[i].angle / 2.0)
                        worldObject.normalShader:send("lightDirection", worldObject.lights[i].direction)
                        love.graphics.setShader(worldObject.normalShader)
                    end
                    love.graphics.draw(worldObject.normalMap, _G.love.light.translate.X, _G.love.light.translate.Y)
                end
            end

            love.graphics.setShader()
            worldObject.pixelShadow:clear(255, 255, 255)
            love.graphics.setCanvas(worldObject.pixelShadow)
            love.graphics.setBlendMode("alpha")
            love.graphics.draw(worldObject.pixelShadow2, _G.love.light.translate.X, _G.love.light.translate.Y)
            love.graphics.setBlendMode("additive")
            love.graphics.setColor({ worldObject.ambient[1], worldObject.ambient[2], worldObject.ambient[3] })
            love.graphics.rectangle("fill", _G.love.light.translate.X, _G.love.light.translate.Y, worldObject.width, worldObject.height)
            love.graphics.setBlendMode("alpha")
        end

        if worldObject.optionGlow and worldObject.isGlow then
            -- create glow map
            --worldObject.glowMap:clear(0, 0, 0)
            love.graphics.setCanvas(worldObject.glowMap)

            if worldObject.glowDown then
                worldObject.glowTimer = math.max(0.0, worldObject.glowTimer - love.timer.getDelta())
                if worldObject.glowTimer == 0.0 then
                    worldObject.glowDown = not worldObject.glowDown
                end
            else
                worldObject.glowTimer = math.min(worldObject.glowTimer + love.timer.getDelta(), 1.0)
                if worldObject.glowTimer == 1.0 then
                    worldObject.glowDown = not worldObject.glowDown
                end
            end

            for i = 1, #worldObject.body do
                if worldObject.body[i].glowStrength > 0.0 then
                    love.graphics.setColor(worldObject.body[i].glowRed * worldObject.body[i].glowStrength, worldObject.body[i].glowGreen * worldObject.body[i].glowStrength, worldObject.body[i].glowBlue * worldObject.body[i].glowStrength)
                else
                    love.graphics.setColor(0, 0, 0)
                end

                if worldObject.body[i].type == "circle" then
                    love.graphics.circle("fill", worldObject.body[i].x, worldObject.body[i].y, worldObject.body[i].radius)
                elseif worldObject.body[i].type == "rectangle" then
                    love.graphics.rectangle("fill", worldObject.body[i].x, worldObject.body[i].y, worldObject.body[i].width, worldObject.body[i].height)
                elseif worldObject.body[i].type == "polygon" then
                    love.graphics.polygon("fill", unpack(worldObject.body[i].data))
                elseif worldObject.body[i].type == "image" and worldObject.body[i].img then
                    if worldObject.body[i].glowStrength > 0.0 and worldObject.body[i].glow then
                        love.graphics.setShader(worldObject.glowShader)
                        worldObject.glowShader:send("glowImage", worldObject.body[i].glow)
                        worldObject.glowShader:send("glowTime", love.timer.getTime() * 0.5)
                        love.graphics.setColor(255, 255, 255)
                    else
                        love.graphics.setShader()
                        love.graphics.setColor(0, 0, 0)
                    end
                    love.graphics.draw(worldObject.body[i].img, worldObject.body[i].x - worldObject.body[i].ix + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].iy + _G.love.light.translate.Y)
                end
            end
        end

        if worldObject.optionRefraction and worldObject.isRefraction then
            love.graphics.setShader()

            -- create refraction map
            worldObject.refractionMap:clear()
            love.graphics.setCanvas(worldObject.refractionMap)
            for i = 1, #worldObject.body do
                if worldObject.body[i].refraction and worldObject.body[i].normal then
                    love.graphics.setColor(255, 255, 255)
                    if worldObject.body[i].tileX == 0.0 and worldObject.body[i].tileY == 0.0 then
                        love.graphics.draw(worldObject.normalMap, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.translate.Y)
                    else
                        worldObject.body[i].normalMesh:setVertices(worldObject.body[i].normalVert)
                        love.graphics.draw(worldObject.body[i].normalMesh, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.translate.Y)
                    end
                end
            end

            love.graphics.setColor(0, 0, 0)
            for i = 1, #worldObject.body do
                if not worldObject.body[i].refractive then
                    if worldObject.body[i].type == "circle" then
                        love.graphics.circle("fill", worldObject.body[i].x, worldObject.body[i].y, worldObject.body[i].radius)
                    elseif worldObject.body[i].type == "rectangle" then
                        love.graphics.rectangle("fill", worldObject.body[i].x, worldObject.body[i].y, worldObject.body[i].width, worldObject.body[i].height)
                    elseif worldObject.body[i].type == "polygon" then
                        love.graphics.polygon("fill", unpack(worldObject.body[i].data))
                    elseif worldObject.body[i].type == "image" and worldObject.body[i].img then
                        love.graphics.draw(worldObject.body[i].img, worldObject.body[i].x - worldObject.body[i].ix + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].iy + _G.love.light.translate.Y)
                    end
                end
            end
        end

        if worldObject.optionReflection and worldObject.isReflection then
            -- create reflection map
            if worldObject.changed then
                worldObject.reflectionMap:clear(0, 0, 0)
                love.graphics.setCanvas(worldObject.reflectionMap)
                for i = 1, #worldObject.body do
                    if worldObject.body[i].reflection and worldObject.body[i].normal then
                        love.graphics.setColor(255, 0, 0)
                        worldObject.body[i].normalMesh:setVertices(worldObject.body[i].normalVert)
                        love.graphics.draw(worldObject.body[i].normalMesh, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.translate.Y)
                    end
                end
                for i = 1, #worldObject.body do
                    if worldObject.body[i].reflective and worldObject.body[i].img then
                        love.graphics.setColor(0, 255, 0)
                        love.graphics.draw(worldObject.body[i].img, worldObject.body[i].x - worldObject.body[i].ix + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].iy + _G.love.light.translate.Y)
                    elseif not worldObject.body[i].reflection and worldObject.body[i].img then
                        love.graphics.setColor(0, 0, 0)
                        love.graphics.draw(worldObject.body[i].img, worldObject.body[i].x - worldObject.body[i].ix + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].iy + _G.love.light.translate.Y)
                    end
                end
            end
        end

        love.graphics.setShader()
        love.graphics.setBlendMode("alpha")
        --love.graphics.setStencil()
        love.graphics.clear()
        love.graphics.setCanvas(_G.love.light.LAST_BUFFER)

        worldObject.changed = false
    end
    worldObject.refreshScreenSize = function()
        worldObject.shadow = love.graphics.newCanvas()
        worldObject.shadow2 = love.graphics.newCanvas()
        worldObject.shine = love.graphics.newCanvas()
        worldObject.shine2 = love.graphics.newCanvas()
        worldObject.normalMap = love.graphics.newCanvas()
        worldObject.glowMap = love.graphics.newCanvas()
        worldObject.glowMap2 = love.graphics.newCanvas()
        worldObject.refractionMap = love.graphics.newCanvas()
        worldObject.refractionMap2 = love.graphics.newCanvas()
        worldObject.reflectionMap = love.graphics.newCanvas()
        worldObject.reflectionMap2 = love.graphics.newCanvas()
        worldObject.pixelShadow = love.graphics.newCanvas()
        worldObject.pixelShadow2 = love.graphics.newCanvas()
    end
    -- draw shadow
    worldObject.drawShadow = function()
        if worldObject.optionShadows and (worldObject.isShadows or worldObject.isLight) then
            love.graphics.setColor(255, 255, 255)
            if worldObject.blur then
                _G.love.light.LAST_BUFFER = love.graphics.getCanvas()
                _G.love.light.BLURV:send("steps", worldObject.blur)
                _G.love.light.BLURH:send("steps", worldObject.blur)
                love.graphics.setBlendMode("alpha")
                love.graphics.setCanvas(worldObject.shadow2)
                love.graphics.setShader(_G.love.light.BLURV)
                love.graphics.draw(worldObject.shadow, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setCanvas(worldObject.shadow)
                love.graphics.setShader(_G.love.light.BLURH)
                love.graphics.draw(worldObject.shadow2, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setCanvas(_G.love.light.LAST_BUFFER)
                love.graphics.setBlendMode("multiply")
                love.graphics.setShader()
                love.graphics.draw(worldObject.shadow, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setBlendMode("alpha")
            else
                love.graphics.setBlendMode("multiply")
                love.graphics.setShader()
                love.graphics.draw(worldObject.shadow, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setBlendMode("alpha")
            end
        end
    end
    -- draw shine
    worldObject.drawShine = function()
        if worldObject.optionShadows and worldObject.isShadows then
            love.graphics.setColor(255, 255, 255)
            if worldObject.blur and false then
                _G.love.light.LAST_BUFFER = love.graphics.getCanvas()
                _G.love.light.BLURV:send("steps", worldObject.blur)
                _G.love.light.BLURH:send("steps", worldObject.blur)
                love.graphics.setBlendMode("alpha")
                love.graphics.setCanvas(worldObject.shine2)
                love.graphics.setShader(_G.love.light.BLURV)
                love.graphics.draw(worldObject.shine, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setCanvas(worldObject.shine)
                love.graphics.setShader(_G.love.light.BLURH)
                love.graphics.draw(worldObject.shine2, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setCanvas(_G.love.light.LAST_BUFFER)
                love.graphics.setBlendMode("multiply")
                love.graphics.setShader()
                love.graphics.draw(worldObject.shine, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setBlendMode("alpha")
            else
                love.graphics.setBlendMode("multiply")
                love.graphics.setShader()
                love.graphics.draw(worldObject.shine, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setBlendMode("alpha")
            end
        end
    end
    -- draw pixel shadow
    worldObject.drawPixelShadow = function()
        if worldObject.optionPixelShadows and worldObject.isPixelShadows then
            love.graphics.setColor(255, 255, 255)
            love.graphics.setBlendMode("multiply")
            love.graphics.setShader()
            love.graphics.draw(worldObject.pixelShadow, _G.love.light.translate.X, _G.love.light.translate.Y)
            love.graphics.setBlendMode("alpha")
        end
    end
    -- draw material
    worldObject.drawMaterial = function()
        love.graphics.setShader(worldObject.materialShader)
        for i = 1, #worldObject.body do
            if worldObject.body[i].material and worldObject.body[i].normal then
                love.graphics.setColor(255, 255, 255)
                worldObject.materialShader:send("material", worldObject.body[i].material)
                love.graphics.draw(worldObject.body[i].normal, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.translate.X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.translate.Y)
            end
        end
        love.graphics.setShader()
    end
    -- draw glow
    worldObject.drawGlow = function()
        if worldObject.optionGlow and worldObject.isGlow then
            love.graphics.setColor(255, 255, 255)
            if worldObject.glowBlur == 0.0 then
                love.graphics.setBlendMode("additive")
                love.graphics.setShader()
                love.graphics.draw(worldObject.glowMap, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setBlendMode("alpha")
            else
                _G.love.light.BLURV:send("steps", worldObject.glowBlur)
                _G.love.light.BLURH:send("steps", worldObject.glowBlur)
                _G.love.light.LAST_BUFFER = love.graphics.getCanvas()
                love.graphics.setBlendMode("additive")
                worldObject.glowMap2:clear()
                love.graphics.setCanvas(worldObject.glowMap2)
                love.graphics.setShader(_G.love.light.BLURV)
                love.graphics.draw(worldObject.glowMap, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setCanvas(worldObject.glowMap)
                love.graphics.setShader(_G.love.light.BLURH)
                love.graphics.draw(worldObject.glowMap2, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setCanvas(_G.love.light.LAST_BUFFER)
                love.graphics.setShader()
                love.graphics.draw(worldObject.glowMap, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setBlendMode("alpha")
            end
        end
    end
    -- draw refraction
    worldObject.drawRefraction = function()
        if worldObject.optionRefraction and worldObject.isRefraction then
            _G.love.light.LAST_BUFFER = love.graphics.getCanvas()
            if _G.love.light.LAST_BUFFER then
                love.graphics.setColor(255, 255, 255)
                love.graphics.setBlendMode("alpha")
                love.graphics.setCanvas(worldObject.refractionMap2)
                love.graphics.draw(_G.love.light.LAST_BUFFER, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setCanvas(_G.love.light.LAST_BUFFER)
                worldObject.refractionShader:send("backBuffer", worldObject.refractionMap2)
                worldObject.refractionShader:send("refractionStrength", worldObject.refractionStrength)
                love.graphics.setShader(worldObject.refractionShader)
                love.graphics.draw(worldObject.refractionMap, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setShader()
            end
        end
    end
    -- draw reflection
    worldObject.drawReflection = function()
        if worldObject.optionReflection and worldObject.isReflection then
            _G.love.light.LAST_BUFFER = love.graphics.getCanvas()
            if _G.love.light.LAST_BUFFER then
                love.graphics.setColor(255, 255, 255)
                love.graphics.setBlendMode("alpha")
                love.graphics.setCanvas(worldObject.reflectionMap2)
                love.graphics.draw(_G.love.light.LAST_BUFFER, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setCanvas(_G.love.light.LAST_BUFFER)
                worldObject.reflectionShader:send("backBuffer", worldObject.reflectionMap2)
                worldObject.reflectionShader:send("reflectionStrength", worldObject.reflectionStrength)
                worldObject.reflectionShader:send("reflectionVisibility", worldObject.reflectionVisibility)
                love.graphics.setShader(worldObject.reflectionShader)
                love.graphics.draw(worldObject.reflectionMap, _G.love.light.translate.X, _G.love.light.translate.Y)
                love.graphics.setShader()
            end
        end
    end
    --- creating a light object
    -- @param p ?
    -- @param x -position
    -- @param y -position
    -- @param red color value
    -- @param green color value
    -- @param blue color value
    -- @param range range of the light
    worldObject.newLight = function(x, y, red, green, blue, range)
        worldObject.lights[#worldObject.lights + 1] = love.light.newLight(worldObject, x, y, red, green, blue, range)

        return worldObject.lights[#worldObject.lights]
    end
    -- clear lights
    worldObject.clearLights = function()
        worldObject.lights = {}
        worldObject.isLight = false
        worldObject.changed = true
    end
    -- clear objects
    worldObject.clearBodys = function()
        worldObject.body = {}
        worldObject.changed = true
        worldObject.isShadows = false
        worldObject.isPixelShadows = false
        worldObject.isGlow = false
        worldObject.isRefraction = false
        worldObject.isReflection = false
    end
    -- set offset
    worldObject.setTranslation = function(translateX, translateY)
        _G.love.light.translate.X = translateX
        _G.love.light.translate.Y = translateY
    end
    -- set ambient color
    worldObject.setAmbientColor = function(red, green, blue)
        worldObject.ambient = { red, green, blue }
    end
    -- set ambient red
    worldObject.setAmbientRed = function(red)
        worldObject.ambient[1] = red
    end
    -- set ambient green
    worldObject.setAmbientGreen = function(green)
        worldObject.ambient[2] = green
    end
    -- set ambient blue
    worldObject.setAmbientBlue = function(blue)
        worldObject.ambient[3] = blue
    end
    -- set normal invert
    worldObject.setNormalInvert = function(invert)
        worldObject.normalInvert = invert
    end
    -- set blur
    worldObject.setBlur = function(blur)
        worldObject.blur = blur
        worldObject.changed = true
    end
    -- set blur
    worldObject.setShadowBlur = function(blur)
        worldObject.blur = blur
        worldObject.changed = true
    end
    -- set buffer
    worldObject.setBuffer = function(buffer)
        if buffer == "render" then
            love.graphics.setCanvas(_G.love.light.LAST_BUFFER)
        else
            _G.love.light.LAST_BUFFER = love.graphics.getCanvas()
        end

        if buffer == "glow" then
            love.graphics.setCanvas(worldObject.glowMap)
        end
    end
    -- set glow blur
    worldObject.setGlowStrength = function(strength)
        worldObject.glowBlur = strength
        worldObject.changed = true
    end
    -- set refraction blur
    worldObject.setRefractionStrength = function(strength)
        worldObject.refractionStrength = strength
    end
    -- set reflection strength
    worldObject.setReflectionStrength = function(strength)
        worldObject.reflectionStrength = strength
    end
    -- set reflection visibility
    worldObject.setReflectionVisibility = function(visibility)
        worldObject.reflectionVisibility = visibility
    end
    -- new rectangle
    worldObject.newRectangle = function(x, y, w, h)
        return love.light.newRectangle(worldObject, x, y, w, h)
    end
    -- new circle
    worldObject.newCircle = function(x, y, r)
        return love.light.newCircle(worldObject, x, y, r)
    end
    -- new polygon
    worldObject.newPolygon = function(...)
        return love.light.newPolygon(worldObject, ...)
    end
    --- Constructor for a image
    -- @param img the love.graphics image
    -- @param x position
    -- @param x position
    -- @param width
    -- @param height
    -- @param ox offset
    -- @param oy offset
    worldObject.newImage = function(img, x, y, width, height, ox, oy)
        return love.light.newImage(worldObject, img, x, y, width, height, ox, oy)
    end
    -- new refraction
    worldObject.newRefraction = function(normal, x, y)
        return love.light.newRefraction(worldObject, normal, x, y)
    end
    -- new refraction from height map
    worldObject.newRefractionHeightMap = function(heightMap, x, y, strength)
        return love.light.newRefractionHeightMap(worldObject, heightMap, x, y, strength)
    end
    -- new reflection
    worldObject.newReflection = function(normal, x, y)
        return love.light.newReflection(worldObject, normal, x, y)
    end
    -- new reflection from height map
    worldObject.newReflectionHeightMap = function(heightMap, x, y, strength)
        return love.light.newReflectionHeightMap(worldObject, heightMap, x, y, strength)
    end
    -- new body
    worldObject.newBody = function(type, ...)
        return love.light.newBody(worldObject, type, ...)
    end
    -- set polygon data
    worldObject.setPoints = function(n, ...)
        worldObject.body[n].data = { ... }
    end
    -- get polygon count
    worldObject.getBodyCount = function()
        return #worldObject.body
    end
    -- get polygon
    worldObject.getPoints = function(n)
        if worldObject.body[n].data then
            return unpack(worldObject.body[n].data)
        end
    end
    -- set light position
    worldObject.setLightPosition = function(n, x, y, z)
        worldObject.lights[n].setPosition(x, y, z)
    end
    -- set light x
    worldObject.setLightX = function(n, x)
        worldObject.lights[n].setX(x)
    end
    -- set light y
    worldObject.setLightY = function(n, y)
        worldObject.lights[n].setY(y)
    end
    -- set light angle
    worldObject.setLightAngle = function(n, angle)
        worldObject.lights[n].setAngle(angle)
    end
    -- set light direction
    worldObject.setLightDirection = function(n, direction)
        worldObject.lights[n].setDirection(direction)
    end
    -- get light count
    worldObject.getLightCount = function()
        return #worldObject.lights
    end
    -- get light x position
    worldObject.getLightX = function(n)
        return worldObject.lights[n].x
    end
    -- get light y position
    worldObject.getLightY = function(n)
        return worldObject.lights[n].y
    end
    -- get type
    worldObject.getType = function()
        return "world"
    end

    return worldObject
end

-- light object
--noinspection LuaOverlyLongMethod
function _G.love.light.newLight(p, x, y, red, green, blue, range)
    local lightObject = {}
    lightObject.direction = 0
    lightObject.angle = math.pi * 2.0
    lightObject.range = 0
    lightObject.shadow = love.graphics.newCanvas()
    lightObject.shine = love.graphics.newCanvas()
    lightObject.x = x or 0
    lightObject.y = y or 0
    lightObject.z = 15
    lightObject.red = red or 255
    lightObject.green = green or 255
    lightObject.blue = blue or 255
    lightObject.range = range or 300
    lightObject.smooth = 1.0
    lightObject.glowSize = 0.1
    lightObject.glowStrength = 0.0
    lightObject.changed = true
    lightObject.visible = true
    p.isLight = true
    -- set position
    lightObject.setPosition = function(x, y, z)
        if x ~= lightObject.x or y ~= lightObject.y or (z and z ~= lightObject.z) then
            lightObject.x = x
            lightObject.y = y
            if z then
                lightObject.z = z
            end
            lightObject.changed = true
        end
    end
    -- get x
    lightObject.getX = function()
        return lightObject.x
    end
    -- get y
    lightObject.getY = function()
        return lightObject.y
    end
    -- set x
    lightObject.setX = function(x)
        if x ~= lightObject.x then
            lightObject.x = x
            lightObject.changed = true
        end
    end
    -- set y
    lightObject.setY = function(y)
        if y ~= lightObject.y then
            lightObject.y = y
            lightObject.changed = true
        end
    end
    -- set color
    lightObject.setColor = function(red, green, blue)
        lightObject.red = red
        lightObject.green = green
        lightObject.blue = blue
        --p.changed = true
    end
    -- set range
    lightObject.setRange = function(range)
        if range ~= lightObject.range then
            lightObject.range = range
            lightObject.changed = true
        end
    end
    -- set direction
    lightObject.setDirection = function(direction)
        if direction ~= lightObject.direction then
            if direction > math.pi * 2 then
                lightObject.direction = math.mod(direction, math.pi * 2)
            elseif direction < 0.0 then
                lightObject.direction = math.pi * 2 - math.mod(math.abs(direction), math.pi * 2)
            else
                lightObject.direction = direction
            end
            lightObject.changed = true
        end
    end
    -- set angle
    lightObject.setAngle = function(angle)
        if angle ~= lightObject.angle then
            if angle > math.pi then
                lightObject.angle = math.mod(angle, math.pi)
            elseif angle < 0.0 then
                lightObject.angle = math.pi - math.mod(math.abs(angle), math.pi)
            else
                lightObject.angle = angle
            end
            lightObject.changed = true
        end
    end
    -- set glow size
    lightObject.setSmooth = function(smooth)
        lightObject.smooth = smooth
        lightObject.changed = true
    end
    -- set glow size
    lightObject.setGlowSize = function(size)
        lightObject.glowSize = size
        lightObject.changed = true
    end
    -- set glow strength
    lightObject.setGlowStrength = function(strength)
        lightObject.glowStrength = strength
        lightObject.changed = true
    end
    -- get type
    lightObject.getType = function()
        return "light"
    end
    -- clear
    lightObject.clear = function()
        for i = 1, #p.lights do
            if p.lights[i] == lightObject then
                for k = i, #p.lights - 1 do
                    p.lights[k] = p.lights[k + 1]
                end
                p.lights[#p.lights] = nil
                break
            end
        end
    end

    return lightObject
end

-- body object
--noinspection LuaOverlyLongMethod
function _G.love.light.newBody(worldObject, type, ...)
    local args = { ... }
    local bodyObject = {}
    worldObject.body[#worldObject.body + 1] = bodyObject
    worldObject.changed = true
    bodyObject.id = #worldObject.body
    bodyObject.type = type
    bodyObject.normal = nil
    bodyObject.material = nil
    bodyObject.glow = nil
    if bodyObject.type == "circle" then
        bodyObject.x = args[1] or 0
        bodyObject.y = args[2] or 0
        bodyObject.radius = args[3] or 16
        bodyObject.ox = args[4] or 0
        bodyObject.oy = args[5] or 0
        bodyObject.shadowType = "circle"
        bodyObject.reflection = false
        bodyObject.reflective = false
        bodyObject.refraction = false
        bodyObject.refractive = false
        worldObject.isShadows = true
    elseif bodyObject.type == "rectangle" then
        bodyObject.x = args[1] or 0
        bodyObject.y = args[2] or 0
        bodyObject.width = args[3] or 64
        bodyObject.height = args[4] or 64
        bodyObject.ox = bodyObject.width * 0.5
        bodyObject.oy = bodyObject.height * 0.5
        bodyObject.shadowType = "rectangle"
        bodyObject.data = {
            bodyObject.x - bodyObject.ox,
            bodyObject.y - bodyObject.oy,
            bodyObject.x - bodyObject.ox + bodyObject.width,
            bodyObject.y - bodyObject.oy,
            bodyObject.x - bodyObject.ox + bodyObject.width,
            bodyObject.y - bodyObject.oy + bodyObject.height,
            bodyObject.x - bodyObject.ox,
            bodyObject.y - bodyObject.oy + bodyObject.height
        }
        bodyObject.reflection = false
        bodyObject.reflective = false
        bodyObject.refraction = false
        bodyObject.refractive = false
        worldObject.isShadows = true
    elseif bodyObject.type == "polygon" then
        bodyObject.shadowType = "polygon"
        bodyObject.data = args or { 0, 0, 0, 0, 0, 0 }
        bodyObject.reflection = false
        bodyObject.reflective = false
        bodyObject.refraction = false
        bodyObject.refractive = false
        worldObject.isShadows = true
    elseif bodyObject.type == "image" then
        bodyObject.img = args[1]
        bodyObject.x = args[2] or 0
        bodyObject.y = args[3] or 0
        if bodyObject.img then
            bodyObject.imgWidth = bodyObject.img:getWidth()
            bodyObject.imgHeight = bodyObject.img:getHeight()
            bodyObject.width = args[4] or bodyObject.imgWidth
            bodyObject.height = args[5] or bodyObject.imgHeight
            bodyObject.ix = bodyObject.imgWidth * 0.5
            bodyObject.iy = bodyObject.imgHeight * 0.5
            bodyObject.vert = {
                { 0.0, 0.0, 0.0, 0.0 },
                { bodyObject.width, 0.0, 1.0, 0.0 },
                { bodyObject.width, bodyObject.height, 1.0, 1.0 },
                { 0.0, bodyObject.height, 0.0, 1.0 },
            }
            --bodyObject.msh = love.graphics.newMesh(bodyObject.vert, bodyObject.img, "fan")
            bodyObject.msh = love.graphics.newMesh(bodyObject.vert, "fan")
            bodyObject.msh:setTexture(bodyObject.img)
        else
            bodyObject.width = args[4] or 64
            bodyObject.height = args[5] or 64
        end
        bodyObject.ox = args[6] or bodyObject.width * 0.5
        bodyObject.oy = args[7] or bodyObject.height * 0.5
        bodyObject.shadowType = "rectangle"
        bodyObject.data = {
            bodyObject.x - bodyObject.ox,
            bodyObject.y - bodyObject.oy,
            bodyObject.x - bodyObject.ox + bodyObject.width,
            bodyObject.y - bodyObject.oy,
            bodyObject.x - bodyObject.ox + bodyObject.width,
            bodyObject.y - bodyObject.oy + bodyObject.height,
            bodyObject.x - bodyObject.ox,
            bodyObject.y - bodyObject.oy + bodyObject.height
        }
        bodyObject.reflection = false
        bodyObject.reflective = true
        bodyObject.refraction = false
        bodyObject.refractive = false
        worldObject.isShadows = true
    elseif bodyObject.type == "refraction" then
        bodyObject.normal = args[1]
        bodyObject.x = args[2] or 0
        bodyObject.y = args[3] or 0
        if bodyObject.normal then
            bodyObject.normalWidth = bodyObject.normal:getWidth()
            bodyObject.normalHeight = bodyObject.normal:getHeight()
            bodyObject.width = args[4] or bodyObject.normalWidth
            bodyObject.height = args[5] or bodyObject.normalHeight
            bodyObject.nx = bodyObject.normalWidth * 0.5
            bodyObject.ny = bodyObject.normalHeight * 0.5
            bodyObject.normal:setWrap("repeat", "repeat")
            bodyObject.normalVert = {
                { 0.0, 0.0, 0.0, 0.0 },
                { bodyObject.width, 0.0, 1.0, 0.0 },
                { bodyObject.width, bodyObject.height, 1.0, 1.0 },
                { 0.0, bodyObject.height, 0.0, 1.0 }
            }
            bodyObject.normalMesh = love.graphics.newMesh(bodyObject.normalVert, bodyObject.normal, "fan")
        else
            bodyObject.width = args[4] or 64
            bodyObject.height = args[5] or 64
        end
        bodyObject.ox = bodyObject.width * 0.5
        bodyObject.oy = bodyObject.height * 0.5
        bodyObject.reflection = false
        bodyObject.reflective = false
        bodyObject.refraction = true
        bodyObject.refractive = false
        worldObject.isRefraction = true
    elseif bodyObject.type == "reflection" then
        bodyObject.normal = args[1]
        bodyObject.x = args[2] or 0
        bodyObject.y = args[3] or 0
        if bodyObject.normal then
            bodyObject.normalWidth = bodyObject.normal:getWidth()
            bodyObject.normalHeight = bodyObject.normal:getHeight()
            bodyObject.width = args[4] or bodyObject.normalWidth
            bodyObject.height = args[5] or bodyObject.normalHeight
            bodyObject.nx = bodyObject.normalWidth * 0.5
            bodyObject.ny = bodyObject.normalHeight * 0.5
            bodyObject.normal:setWrap("repeat", "repeat")
            bodyObject.normalVert = {
                { 0.0, 0.0, 0.0, 0.0 },
                { bodyObject.width, 0.0, 1.0, 0.0 },
                { bodyObject.width, bodyObject.height, 1.0, 1.0 },
                { 0.0, bodyObject.height, 0.0, 1.0 }
            }
            bodyObject.normalMesh = love.graphics.newMesh(bodyObject.normalVert, bodyObject.normal, "fan")
        else
            bodyObject.width = args[4] or 64
            bodyObject.height = args[5] or 64
        end
        bodyObject.ox = bodyObject.width * 0.5
        bodyObject.oy = bodyObject.height * 0.5
        bodyObject.reflection = true
        bodyObject.reflective = false
        bodyObject.refraction = false
        bodyObject.refractive = false
        worldObject.isReflection = true
    end
    bodyObject.shine = true
    bodyObject.red = 0
    bodyObject.green = 0
    bodyObject.blue = 0
    bodyObject.alpha = 1.0
    bodyObject.glowRed = 255
    bodyObject.glowGreen = 255
    bodyObject.glowBlue = 255
    bodyObject.glowStrength = 0.0
    bodyObject.tileX = 0
    bodyObject.tileY = 0
    -- refresh
    bodyObject.refresh = function()
        if bodyObject.data then
            bodyObject.data[1] = bodyObject.x - bodyObject.ox
            bodyObject.data[2] = bodyObject.y - bodyObject.oy
            bodyObject.data[3] = bodyObject.x - bodyObject.ox + bodyObject.width
            bodyObject.data[4] = bodyObject.y - bodyObject.oy
            bodyObject.data[5] = bodyObject.x - bodyObject.ox + bodyObject.width
            bodyObject.data[6] = bodyObject.y - bodyObject.oy + bodyObject.height
            bodyObject.data[7] = bodyObject.x - bodyObject.ox
            bodyObject.data[8] = bodyObject.y - bodyObject.oy + bodyObject.height
        end
    end
    -- set position
    bodyObject.setPosition = function(x, y)
        if x ~= bodyObject.x or y ~= bodyObject.y then
            bodyObject.x = x
            bodyObject.y = y
            bodyObject.refresh()
            worldObject.changed = true
        end
    end
    -- set x position
    bodyObject.setX = function(x)
        if x ~= bodyObject.x then
            bodyObject.x = x
            bodyObject.refresh()
            worldObject.changed = true
        end
    end
    -- set y position
    bodyObject.setY = function(y)
        if y ~= bodyObject.y then
            bodyObject.y = y
            bodyObject.refresh()
            worldObject.changed = true
        end
    end
    -- get x position
    bodyObject.getX = function()
        return bodyObject.x
    end
    -- get y position
    bodyObject.getY = function(y)
        return bodyObject.y
    end
    -- get width
    bodyObject.getWidth = function()
        return bodyObject.width
    end
    -- get height
    bodyObject.getHeight = function()
        return bodyObject.height
    end
    -- get image width
    bodyObject.getImageWidth = function()
        return bodyObject.imgWidth
    end
    -- get image height
    bodyObject.getImageHeight = function()
        return bodyObject.imgHeight
    end
    -- set dimension
    bodyObject.setDimension = function(width, height)
        bodyObject.width = width
        bodyObject.height = height
        bodyObject.refresh()
        worldObject.changed = true
    end
    -- set offset
    bodyObject.setOffset = function(ox, oy)
        if ox ~= bodyObject.ox or oy ~= bodyObject.oy then
            bodyObject.ox = ox
            bodyObject.oy = oy
            if bodyObject.shadowType == "rectangle" then
                bodyObject.refresh()
            end
            worldObject.changed = true
        end
    end
    -- set offset
    bodyObject.setImageOffset = function(ix, iy)
        if ix ~= bodyObject.ix or iy ~= bodyObject.iy then
            bodyObject.ix = ix
            bodyObject.iy = iy
            bodyObject.refresh()
            worldObject.changed = true
        end
    end
    -- set offset
    bodyObject.setNormalOffset = function(nx, ny)
        if nx ~= bodyObject.nx or ny ~= bodyObject.ny then
            bodyObject.nx = nx
            bodyObject.ny = ny
            bodyObject.refresh()
            worldObject.changed = true
        end
    end
    -- set glow color
    bodyObject.setGlowColor = function(red, green, blue)
        bodyObject.glowRed = red
        bodyObject.glowGreen = green
        bodyObject.glowBlue = blue
        worldObject.changed = true
    end
    -- set glow alpha
    bodyObject.setGlowStrength = function(strength)
        bodyObject.glowStrength = strength
        worldObject.changed = true
    end
    -- get radius
    bodyObject.getRadius = function()
        return bodyObject.radius
    end
    -- set radius
    bodyObject.setRadius = function(radius)
        if radius ~= bodyObject.radius then
            bodyObject.radius = radius
            worldObject.changed = true
        end
    end
    -- set polygon data
    bodyObject.setPoints = function(...)
        bodyObject.data = { ... }
        worldObject.changed = true
    end
    -- get polygon data
    bodyObject.getPoints = function()
        return unpack(bodyObject.data)
    end
    -- set shadow on/off
    bodyObject.setShadowType = function(type)
        bodyObject.shadowType = type
        worldObject.changed = true
    end
    -- set shadow on/off
    bodyObject.setShadow = function(b)
        bodyObject.castsNoShadow = not b
        worldObject.changed = true
    end
    -- set shine on/off
    bodyObject.setShine = function(b)
        bodyObject.shine = b
        worldObject.changed = true
    end
    -- set glass color
    bodyObject.setColor = function(red, green, blue)
        bodyObject.red = red
        bodyObject.green = green
        bodyObject.blue = blue
        worldObject.changed = true
    end
    -- set glass alpha
    bodyObject.setAlpha = function(alpha)
        bodyObject.alpha = alpha
        worldObject.changed = true
    end
    -- set reflection on/off
    bodyObject.setReflection = function(reflection)
        bodyObject.reflection = reflection
    end
    -- set refraction on/off
    bodyObject.setRefraction = function(refraction)
        bodyObject.refraction = refraction
    end
    -- set reflective on other objects on/off
    bodyObject.setReflective = function(reflective)
        bodyObject.reflective = reflective
    end
    -- set refractive on other objects on/off
    bodyObject.setRefractive = function(refractive)
        bodyObject.refractive = refractive
    end
    -- set image
    bodyObject.setImage = function(img)
        if img then
            bodyObject.img = img
            bodyObject.imgWidth = bodyObject.img:getWidth()
            bodyObject.imgHeight = bodyObject.img:getHeight()
            bodyObject.ix = bodyObject.imgWidth * 0.5
            bodyObject.iy = bodyObject.imgHeight * 0.5
        end
    end
    -- set normal
    bodyObject.setNormalMap = function(normal, width, height, nx, ny)
        if normal then
            bodyObject.normal = normal
            bodyObject.normal:setWrap("repeat", "repeat")
            bodyObject.normalWidth = width or bodyObject.normal:getWidth()
            bodyObject.normalHeight = height or bodyObject.normal:getHeight()
            bodyObject.nx = nx or bodyObject.normalWidth * 0.5
            bodyObject.ny = ny or bodyObject.normalHeight * 0.5
            bodyObject.normalVert = {
                { 0.0, 0.0, 0.0, 0.0 },
                { bodyObject.normalWidth, 0.0, bodyObject.normalWidth / bodyObject.normal:getWidth(), 0.0 },
                { bodyObject.normalWidth, bodyObject.normalHeight, bodyObject.normalWidth / bodyObject.normal:getWidth(), bodyObject.normalHeight / bodyObject.normal:getHeight() },
                { 0.0, bodyObject.normalHeight, 0.0, bodyObject.normalHeight / bodyObject.normal:getHeight() }
            }
            bodyObject.normalMesh = love.graphics.newMesh(bodyObject.normalVert, bodyObject.normal, "fan")

            worldObject.isPixelShadows = true
        else
            bodyObject.normalMesh = nil
        end
    end
    -- set height map
    bodyObject.setHeightMap = function(heightMap, strength)
        bodyObject.setNormalMap(_G.love.light.HeightMapToNormalMap(heightMap, strength))
    end
    -- generate flat normal map
    bodyObject.generateNormalMapFlat = function(mode)
        local imgData = bodyObject.img:getData()
        local imgNormalData = love.image.newImageData(bodyObject.imgWidth, bodyObject.imgHeight)
        local color

        if mode == "top" then
            color = { 127, 127, 255 }
        elseif mode == "front" then
            color = { 127, 0, 127 }
        elseif mode == "back" then
            color = { 127, 255, 127 }
        elseif mode == "left" then
            color = { 31, 0, 223 }
        elseif mode == "right" then
            color = { 223, 0, 127 }
        end

        for i = 0, bodyObject.imgHeight - 1 do
            for k = 0, bodyObject.imgWidth - 1 do
                local r, g, b, a = imgData:getPixel(k, i)
                if a > 0 then
                    imgNormalData:setPixel(k, i, color[1], color[2], color[3], 255)
                end
            end
        end

        bodyObject.setNormalMap(love.graphics.newImage(imgNormalData))
    end
    -- generate faded normal map
    bodyObject.generateNormalMapGradient = function(horizontalGradient, verticalGradient)
        local imgData = bodyObject.img:getData()
        local imgNormalData = love.image.newImageData(bodyObject.imgWidth, bodyObject.imgHeight)
        local dx = 255.0 / bodyObject.imgWidth
        local dy = 255.0 / bodyObject.imgHeight
        local nx
        local ny
        local nz

        for i = 0, bodyObject.imgWidth - 1 do
            for k = 0, bodyObject.imgHeight - 1 do
                local r, g, b, a = imgData:getPixel(i, k)
                if a > 0 then
                    if horizontalGradient == "gradient" then
                        nx = i * dx
                    elseif horizontalGradient == "inverse" then
                        nx = 255 - i * dx
                    else
                        nx = 127
                    end

                    if verticalGradient == "gradient" then
                        ny = 127 - k * dy * 0.5
                        nz = 255 - k * dy * 0.5
                    elseif verticalGradient == "inverse" then
                        ny = 127 + k * dy * 0.5
                        nz = 127 - k * dy * 0.25
                    else
                        ny = 255
                        nz = 127
                    end

                    imgNormalData:setPixel(i, k, nx, ny, nz, 255)
                end
            end
        end

        bodyObject.setNormalMap(love.graphics.newImage(imgNormalData))
    end
    -- generate normal map
    bodyObject.generateNormalMap = function(strength)
        bodyObject.setNormalMap(_G.love.light.HeightMapToNormalMap(bodyObject.img, strength))
    end
    -- set material
    bodyObject.setMaterial = function(material)
        if material then
            bodyObject.material = material
        end
    end
    -- set normal
    bodyObject.setGlowMap = function(glow)
        bodyObject.glow = glow
        bodyObject.glowStrength = 1.0

        worldObject.isGlow = true
    end
    -- set tile offset
    bodyObject.setNormalTileOffset = function(tx, ty)
        bodyObject.tileX = tx / bodyObject.normalWidth
        bodyObject.tileY = ty / bodyObject.normalHeight
        bodyObject.normalVert = {
            { 0.0, 0.0, bodyObject.tileX, bodyObject.tileY },
            { bodyObject.normalWidth, 0.0, bodyObject.tileX + 1.0, bodyObject.tileY },
            { bodyObject.normalWidth, bodyObject.normalHeight, bodyObject.tileX + 1.0, bodyObject.tileY + 1.0 },
            { 0.0, bodyObject.normalHeight, bodyObject.tileX, bodyObject.tileY + 1.0 }
        }
        worldObject.changed = true
    end
    -- get type
    bodyObject.getType = function()
        return bodyObject.type
    end
    -- get type
    bodyObject.setShadowType = function(type, ...)
        bodyObject.shadowType = type
        local args = { ... }
        if bodyObject.shadowType == "circle" then
            bodyObject.radius = args[1] or 16
            bodyObject.ox = args[2] or 0
            bodyObject.oy = args[3] or 0
        elseif bodyObject.shadowType == "rectangle" then
            bodyObject.width = args[1] or 64
            bodyObject.height = args[2] or 64
            bodyObject.ox = args[3] or bodyObject.width * 0.5
            bodyObject.oy = args[4] or bodyObject.height * 0.5
            bodyObject.data = {
                bodyObject.x - bodyObject.ox,
                bodyObject.y - bodyObject.oy,
                bodyObject.x - bodyObject.ox + bodyObject.width,
                bodyObject.y - bodyObject.oy,
                bodyObject.x - bodyObject.ox + bodyObject.width,
                bodyObject.y - bodyObject.oy + bodyObject.height,
                bodyObject.x - bodyObject.ox,
                bodyObject.y - bodyObject.oy + bodyObject.height
            }
        elseif bodyObject.shadowType == "polygon" then
            bodyObject.data = args or { 0, 0, 0, 0, 0, 0 }
        elseif bodyObject.shadowType == "image" then
            if bodyObject.img then
                bodyObject.width = bodyObject.imgWidth
                bodyObject.height = bodyObject.imgHeight
                bodyObject.shadowVert = {
                    { 0.0, 0.0, 0.0, 0.0 },
                    { bodyObject.width, 0.0, 1.0, 0.0 },
                    { bodyObject.width, bodyObject.height, 1.0, 1.0 },
                    { 0.0, bodyObject.height, 0.0, 1.0 }
                }
                if not bodyObject.shadowMesh then
                    bodyObject.shadowMesh = love.graphics.newMesh(bodyObject.shadowVert, bodyObject.img, "fan")
                    bodyObject.shadowMesh:setVertexColors(true)
                end
            else
                bodyObject.width = 64
                bodyObject.height = 64
            end
            bodyObject.shadowX = args[1] or 0
            bodyObject.shadowY = args[2] or 0
            bodyObject.fadeStrength = args[3] or 0.0
        end
    end
    -- clear
    bodyObject.clear = function()
        for i = 1, #worldObject.body do
            if worldObject.body[i] == bodyObject then
                for k = i, #worldObject.body - 1 do
                    worldObject.body[k] = worldObject.body[k + 1]
                end
                worldObject.body[#worldObject.body] = nil
                break
            end
        end
        worldObject.changed = true
    end

    return bodyObject
end

-- rectangle object
function _G.love.light.newRectangle(p, x, y, width, height)
    return p.newBody("rectangle", x, y, width, height)
end

-- circle object
function _G.love.light.newCircle(p, x, y, radius)
    return p.newBody("circle", x, y, radius)
end

-- poly object
function _G.love.light.newPolygon(p, ...)
    return p.newBody("polygon", ...)
end

-- image object
function _G.love.light.newImage(lightWorld, img, x, y, width, height, ox, oy)
    return lightWorld.newBody("image", img, x, y, width, height, ox, oy)
end

-- refraction object
function _G.love.light.newRefraction(p, normal, x, y, width, height)
    return p.newBody("refraction", normal, x, y, width, height)
end

-- refraction object (height map)
function _G.love.light.newRefractionHeightMap(p, heightMap, x, y, strength)
    local normal = _G.love.light.HeightMapToNormalMap(heightMap, strength)
    return love.light.newRefraction(p, normal, x, y)
end

-- reflection object
function love.light.newReflection(p, normal, x, y, width, height)
    return p.newBody("reflection", normal, x, y, width, height)
end

-- reflection object (height map)
function love.light.newReflectionHeightMap(p, heightMap, x, y, strength)
    local normal = _G.love.light.HeightMapToNormalMap(heightMap, strength)
    return love.light.newReflection(p, normal, x, y)
end

-- vector functions
function _G.love.light.normalize(v)
    local len = math.sqrt(math.pow(v[1], 2) + math.pow(v[2], 2))
    local normalizedv = { v[1] / len, v[2] / len }
    return normalizedv
end

function _G.love.light.dot(v1, v2)
    return v1[1] * v2[1] + v1[2] * v2[2]
end

function _G.love.light.lengthSqr(v)
    return v[1] * v[1] + v[2] * v[2]
end

function _G.love.light.length(v)
    return math.sqrt(_G.love.light.lengthSqr(v))
end

function _G.love.light.calculateShadows(light, body)
    local shadowGeometry = {}
    local shadowLength = 100000

    for i = 1, #body do
        if body[i].shadowType == "rectangle" or body[i].shadowType == "polygon" then
            local curPolygon = body[i].data
            if not body[i].castsNoShadow then
                local edgeFacingTo = {}
                for k = 1, #curPolygon, 2 do
                    local indexOfNextVertex = (k + 2) % #curPolygon
                    local normal = { -curPolygon[indexOfNextVertex + 1] + curPolygon[k + 1], curPolygon[indexOfNextVertex] - curPolygon[k] }
                    local lightToPoint = { curPolygon[k] - light.x, curPolygon[k + 1] - light.y }

                    normal = _G.love.light.normalize(normal)
                    lightToPoint = _G.love.light.normalize(lightToPoint)

                    local dotProduct = _G.love.light.dot(normal, lightToPoint)
                    if dotProduct > 0 then table.insert(edgeFacingTo, true)
                    else table.insert(edgeFacingTo, false)
                    end
                end

                local curShadowGeometry = {}
                for k = 1, #edgeFacingTo do
                    local nextIndex = (k + 1) % #edgeFacingTo
                    if nextIndex == 0 then nextIndex = #edgeFacingTo end
                    if edgeFacingTo[k] and not edgeFacingTo[nextIndex] then
                        curShadowGeometry[1] = curPolygon[nextIndex * 2 - 1]
                        curShadowGeometry[2] = curPolygon[nextIndex * 2]

                        local lightVecFrontBack = _G.love.light.normalize({ curPolygon[nextIndex * 2 - 1] - light.x, curPolygon[nextIndex * 2] - light.y })
                        curShadowGeometry[3] = curShadowGeometry[1] + lightVecFrontBack[1] * shadowLength
                        curShadowGeometry[4] = curShadowGeometry[2] + lightVecFrontBack[2] * shadowLength

                    elseif not edgeFacingTo[k] and edgeFacingTo[nextIndex] then
                        curShadowGeometry[7] = curPolygon[nextIndex * 2 - 1]
                        curShadowGeometry[8] = curPolygon[nextIndex * 2]

                        local lightVecBackFront = _G.love.light.normalize({ curPolygon[nextIndex * 2 - 1] - light.x, curPolygon[nextIndex * 2] - light.y })
                        curShadowGeometry[5] = curShadowGeometry[7] + lightVecBackFront[1] * shadowLength
                        curShadowGeometry[6] = curShadowGeometry[8] + lightVecBackFront[2] * shadowLength
                    end
                end
                if curShadowGeometry[1]
                        and curShadowGeometry[2]
                        and curShadowGeometry[3]
                        and curShadowGeometry[4]
                        and curShadowGeometry[5]
                        and curShadowGeometry[6]
                        and curShadowGeometry[7]
                        and curShadowGeometry[8]
                then
                    curShadowGeometry.alpha = body[i].alpha
                    curShadowGeometry.red = body[i].red
                    curShadowGeometry.green = body[i].green
                    curShadowGeometry.blue = body[i].blue
                    shadowGeometry[#shadowGeometry + 1] = curShadowGeometry
                end
            end
        elseif body[i].shadowType == "circle" then
            if not body[i].castsNoShadow then
                local length = math.sqrt(math.pow(light.x - (body[i].x - body[i].ox), 2) + math.pow(light.y - (body[i].y - body[i].oy), 2))
                if length >= body[i].radius and length <= light.range then
                    local curShadowGeometry = {}
                    local angle = math.atan2(light.x - (body[i].x - body[i].ox), (body[i].y - body[i].oy) - light.y) + math.pi / 2
                    local x2 = ((body[i].x - body[i].ox) + math.sin(angle) * body[i].radius)
                    local y2 = ((body[i].y - body[i].oy) - math.cos(angle) * body[i].radius)
                    local x3 = ((body[i].x - body[i].ox) - math.sin(angle) * body[i].radius)
                    local y3 = ((body[i].y - body[i].oy) + math.cos(angle) * body[i].radius)

                    curShadowGeometry[1] = x2
                    curShadowGeometry[2] = y2
                    curShadowGeometry[3] = x3
                    curShadowGeometry[4] = y3

                    curShadowGeometry[5] = x3 - (light.x - x3) * shadowLength
                    curShadowGeometry[6] = y3 - (light.y - y3) * shadowLength
                    curShadowGeometry[7] = x2 - (light.x - x2) * shadowLength
                    curShadowGeometry[8] = y2 - (light.y - y2) * shadowLength
                    curShadowGeometry.alpha = body[i].alpha
                    curShadowGeometry.red = body[i].red
                    curShadowGeometry.green = body[i].green
                    curShadowGeometry.blue = body[i].blue
                    shadowGeometry[#shadowGeometry + 1] = curShadowGeometry
                end
            end
        end
    end

    return shadowGeometry
end

_G.love.light.shadowStencil = function()
    for i = 1, #_G.love.light.SHADOW_GEOMETRY do
        if _G.love.light.SHADOW_GEOMETRY[i].alpha == 1.0 then
            love.graphics.polygon("fill", unpack(_G.love.light.SHADOW_GEOMETRY[i]))
        end
    end
    for i = 1, #_G.love.light.BODY do
        if not _G.love.light.BODY[i].castsNoShadow then
            if _G.love.light.BODY[i].shadowType == "circle" then
                love.graphics.circle("fill", _G.love.light.BODY[i].x - _G.love.light.BODY[i].ox, _G.love.light.BODY[i].y - _G.love.light.BODY[i].oy, _G.love.light.BODY[i].radius)
            elseif _G.love.light.BODY[i].shadowType == "rectangle" then
                love.graphics.rectangle("fill", _G.love.light.BODY[i].x - _G.love.light.BODY[i].ox, _G.love.light.BODY[i].y - _G.love.light.BODY[i].oy, _G.love.light.BODY[i].width, _G.love.light.BODY[i].height)
            elseif _G.love.light.BODY[i].shadowType == "polygon" then
                love.graphics.polygon("fill", unpack(_G.love.light.BODY[i].data))
            elseif _G.love.light.BODY[i].shadowType == "image" then
                love.graphics.rectangle("fill", _G.love.light.BODY[i].x - _G.love.light.BODY[i].ox, _G.love.light.BODY[i].y - _G.love.light.BODY[i].oy, _G.love.light.BODY[i].width, _G.love.light.BODY[i].height)
            end
        end
    end
end

_G.love.light.polyStencil = function()
    for i = 1, #_G.love.light.BODY do
        if _G.love.light.BODY[i].shine and (_G.love.light.BODY[i].glowStrength == 0.0 or (_G.love.light.BODY[i].type == "image" and not _G.love.light.BODY[i].normal)) then
            if _G.love.light.BODY[i].shadowType == "circle" then
                love.graphics.circle("fill", _G.love.light.BODY[i].x - _G.love.light.BODY[i].ox, _G.love.light.BODY[i].y - _G.love.light.BODY[i].oy, _G.love.light.BODY[i].radius)
            elseif _G.love.light.BODY[i].shadowType == "rectangle" then
                love.graphics.rectangle("fill", _G.love.light.BODY[i].x - _G.love.light.BODY[i].ox, _G.love.light.BODY[i].y - _G.love.light.BODY[i].oy, _G.love.light.BODY[i].width, _G.love.light.BODY[i].height)
            elseif _G.love.light.BODY[i].shadowType == "polygon" then
                love.graphics.polygon("fill", unpack(_G.love.light.BODY[i].data))
            elseif _G.love.light.BODY[i].shadowType == "image" then
                love.graphics.rectangle("fill", _G.love.light.BODY[i].x - _G.love.light.BODY[i].ox, _G.love.light.BODY[i].y - _G.love.light.BODY[i].oy, _G.love.light.BODY[i].width, _G.love.light.BODY[i].height)
            end
        end
    end
end

function _G.love.light.HeightMapToNormalMap(heightMap, strength)
    local imgData = heightMap:getData()
    local imgData2 = love.image.newImageData(heightMap:getWidth(), heightMap:getHeight())
    local red, green, blue, alpha
    local x, y
    local matrix = {}
    matrix[1] = {}
    matrix[2] = {}
    matrix[3] = {}
    strength = strength or 1.0

    for i = 0, heightMap:getHeight() - 1 do
        for k = 0, heightMap:getWidth() - 1 do
            for l = 1, 3 do
                for m = 1, 3 do
                    if k + (l - 1) < 1 then
                        x = heightMap:getWidth() - 1
                    elseif k + (l - 1) > heightMap:getWidth() - 1 then
                        x = 1
                    else
                        x = k + l - 1
                    end

                    if i + (m - 1) < 1 then
                        y = heightMap:getHeight() - 1
                    elseif i + (m - 1) > heightMap:getHeight() - 1 then
                        y = 1
                    else
                        y = i + m - 1
                    end

                    local red, green, blue, alpha = imgData:getPixel(x, y)
                    matrix[l][m] = red
                end
            end

            red = (255 + ((matrix[1][2] - matrix[2][2]) + (matrix[2][2] - matrix[3][2])) * strength) / 2.0
            green = (255 + ((matrix[2][2] - matrix[1][1]) + (matrix[2][3] - matrix[2][2])) * strength) / 2.0
            blue = 192

            imgData2:setPixel(k, i, red, green, blue)
        end
    end

    return love.graphics.newImage(imgData2)
end
