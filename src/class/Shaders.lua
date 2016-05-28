Class = require "lib.hump.class";

--- Class containing Funcions to add shaders
local Shaders = Class {
    p_glowShader = _G.love.graphics.newShader("shader/fragment/glow.glsl");
    p_hueShader = _G.love.graphics.newShader("shader/fragment/hueAdjust.glsl");
};

--- Shader to ajust the color of the image
-- @param hue
function Shaders:hueAjust(hue)
    Shaders.p_hueShader:send("hue", hue);
    love.graphics.setShader(Shaders.p_hueShader);
end

--- Function to reset shader buffer
function Shaders:clear()
    love.graphics.setShader();
end

return Shaders;
