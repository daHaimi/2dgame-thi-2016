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

love.light = {}

_G.love.light.CURRENT = nil
_G.love.light.BODY = nil
_G.love.light.LAST_BUFFER = nil
_G.love.light.SHADOW_GEOMETRY = nil

_G.love.light.BLURV = love.graphics.newShader("shader/blurv.glsl")
_G.love.light.BLURH = love.graphics.newShader("shader/blurh.glsl")
local width, height, flags = love.window.getMode()
local windowDimension = { width, height }
_G.love.light.BLURV:send("screen", windowDimension)
_G.love.light.BLURH:send("screen", windowDimension)

_G.love.light.TRANSLATE_X = 0
_G.love.light.TRANSLATE_Y = 0
_G.love.light.TRANSLATE_X_OLD = 0
_G.love.light.TRANSLATE_Y_OLD = 0
_G.love.light.DIRECTION = 0

-- light world
function love.light.newWorld()
    local worldObject = {}

    worldObject.width, worldObject.height, worldObject.flags = love.window.getMode()

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

    -- update
    worldObject.update = function()
        _G.love.light.LAST_BUFFER = love.graphics.getCanvas()

        if _G.love.light.TRANSLATE_X ~= _G.love.light.TRANSLATE_X_OLD or _G.love.light.TRANSLATE_Y ~= _G.love.light.TRANSLATE_Y_OLD then
            _G.love.light.TRANSLATE_X_OLD = _G.love.light.TRANSLATE_X
            _G.love.light.TRANSLATE_Y_OLD = _G.love.light.TRANSLATE_Y
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
                    if worldObject.lights[i].x + worldObject.lights[i].range > _G.love.light.TRANSLATE_X and worldObject.lights[i].x - worldObject.lights[i].range < worldObject.width + _G.love.light.TRANSLATE_X
                            and worldObject.lights[i].y + worldObject.lights[i].range > _G.love.light.TRANSLATE_Y and worldObject.lights[i].y - worldObject.lights[i].range < worldObject.height + _G.love.light.TRANSLATE_Y
                    then
                        local lightposrange = { worldObject.lights[i].x, worldObject.height - worldObject.lights[i].y, worldObject.lights[i].range }
                        _G.love.light.CURRENT = worldObject.lights[i]
                        _G.love.light.DIRECTION = _G.love.light.DIRECTION + 0.002
                        worldObject.shader:send("lightPosition", { worldObject.lights[i].x - _G.love.light.TRANSLATE_X, worldObject.height - (worldObject.lights[i].y - _G.love.light.TRANSLATE_Y), worldObject.lights[i].z })
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
                        love.graphics.rectangle("fill", _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y, worldObject.width, worldObject.height)

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
                                love.graphics.draw(_G.love.light.BODY[k].shadowMesh, _G.love.light.BODY[k].x - _G.love.light.BODY[k].ox + _G.love.light.TRANSLATE_X, _G.love.light.BODY[k].y - _G.love.light.BODY[k].oy + _G.love.light.TRANSLATE_Y)
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
                        love.graphics.rectangle("fill", _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y, worldObject.width, worldObject.height)

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
            love.graphics.rectangle("fill", _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y, worldObject.width, worldObject.height)
            love.graphics.setColor(255, 255, 255)
            love.graphics.setBlendMode("add")
            for i = 1, #worldObject.lights do
                if worldObject.lights[i].visible then
                    love.graphics.draw(worldObject.lights[i].shadow, _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y)
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
                    love.graphics.draw(worldObject.lights[i].shine, _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y)
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
                    love.graphics.draw(worldObject.body[i].normalMesh, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.TRANSLATE_X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.TRANSLATE_Y)
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
                    love.graphics.draw(worldObject.normalMap, _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y)
                end
            end

            love.graphics.setShader()
            worldObject.pixelShadow:clear(255, 255, 255)
            love.graphics.setCanvas(worldObject.pixelShadow)
            love.graphics.setBlendMode("alpha")
            love.graphics.draw(worldObject.pixelShadow2, _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y)
            love.graphics.setBlendMode("additive")
            love.graphics.setColor({ worldObject.ambient[1], worldObject.ambient[2], worldObject.ambient[3] })
            love.graphics.rectangle("fill", _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y, worldObject.width, worldObject.height)
            love.graphics.setBlendMode("alpha")
        end

        if worldObject.optionGlow and worldObject.isGlow then
            -- create glow map
            worldObject.glowMap:clear(0, 0, 0)
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
                    love.graphics.draw(worldObject.body[i].img, worldObject.body[i].x - worldObject.body[i].ix + _G.love.light.TRANSLATE_X, worldObject.body[i].y - worldObject.body[i].iy + _G.love.light.TRANSLATE_Y)
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
                        love.graphics.draw(normal, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.TRANSLATE_X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.TRANSLATE_Y)
                    else
                        worldObject.body[i].normalMesh:setVertices(worldObject.body[i].normalVert)
                        love.graphics.draw(worldObject.body[i].normalMesh, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.TRANSLATE_X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.TRANSLATE_Y)
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
                        love.graphics.draw(worldObject.body[i].img, worldObject.body[i].x - worldObject.body[i].ix + _G.love.light.TRANSLATE_X, worldObject.body[i].y - worldObject.body[i].iy + _G.love.light.TRANSLATE_Y)
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
                        love.graphics.draw(worldObject.body[i].normalMesh, worldObject.body[i].x - worldObject.body[i].nx + _G.love.light.TRANSLATE_X, worldObject.body[i].y - worldObject.body[i].ny + _G.love.light.TRANSLATE_Y)
                    end
                end
                for i = 1, #worldObject.body do
                    if worldObject.body[i].reflective and worldObject.body[i].img then
                        love.graphics.setColor(0, 255, 0)
                        love.graphics.draw(worldObject.body[i].img, worldObject.body[i].x - worldObject.body[i].ix + _G.love.light.TRANSLATE_X, worldObject.body[i].y - worldObject.body[i].iy + _G.love.light.TRANSLATE_Y)
                    elseif not worldObject.body[i].reflection and worldObject.body[i].img then
                        love.graphics.setColor(0, 0, 0)
                        love.graphics.draw(worldObject.body[i].img, worldObject.body[i].x - worldObject.body[i].ix + _G.love.light.TRANSLATE_X, worldObject.body[i].y - worldObject.body[i].iy + _G.love.light.TRANSLATE_Y)
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
                love.graphics.draw(worldObject.shadow, _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y)
                love.graphics.setCanvas(worldObject.shadow)
                love.graphics.setShader(_G.love.light.BLURH)
                love.graphics.draw(worldObject.shadow2, _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y)
                love.graphics.setCanvas(_G.love.light.LAST_BUFFER)
                love.graphics.setBlendMode("multiply")
                love.graphics.setShader()
                love.graphics.draw(worldObject.shadow, _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y)
                love.graphics.setBlendMode("alpha")
            else
                love.graphics.setBlendMode("multiply")
                love.graphics.setShader()
                love.graphics.draw(worldObject.shadow, _G.love.light.TRANSLATE_X, _G.love.light.TRANSLATE_Y)
                love.graphics.setBlendMode("alpha")
            end
        end
    end
    -- new light
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
        _G.love.light.TRANSLATE_X = translateX
        _G.love.light.TRANSLATE_Y = translateY
    end
    -- set ambient color
    worldObject.setAmbientColor = function(red, green, blue)
        worldObject.ambient = { red, green, blue }
    end
    -- set normal invert
    worldObject.setNormalInvert = function(invert)
        worldObject.normalInvert = invert
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

    return worldObject
end

-- light object
function love.light.newLight(p, x, y, red, green, blue, range)
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
    -- set glow size
    lightObject.setSmooth = function(smooth)
        lightObject.smooth = smooth
        lightObject.changed = true
    end

    return lightObject
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

                    normal = normalize(normal)
                    lightToPoint = normalize(lightToPoint)

                    local dotProduct = dot(normal, lightToPoint)
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

                        local lightVecFrontBack = normalize({ curPolygon[nextIndex * 2 - 1] - light.x, curPolygon[nextIndex * 2] - light.y })
                        curShadowGeometry[3] = curShadowGeometry[1] + lightVecFrontBack[1] * shadowLength
                        curShadowGeometry[4] = curShadowGeometry[2] + lightVecFrontBack[2] * shadowLength

                    elseif not edgeFacingTo[k] and edgeFacingTo[nextIndex] then
                        curShadowGeometry[7] = curPolygon[nextIndex * 2 - 1]
                        curShadowGeometry[8] = curPolygon[nextIndex * 2]

                        local lightVecBackFront = normalize({ curPolygon[nextIndex * 2 - 1] - light.x, curPolygon[nextIndex * 2] - light.y })
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
