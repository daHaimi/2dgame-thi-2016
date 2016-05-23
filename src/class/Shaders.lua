Class = require "lib.hump.class";
--- Class containing Funcions to add shaders
local Shaders = Class {
    init = function(self) end;
};

Shaders.p_glowImage = love.graphics.newImage("assets/shader/glow.png");
Shaders.p_glowShader = love.graphics.newShader("shader/fragment/glow.glsl");
Shaders.p_hueShader = love.graphics.newShader("shader/fragment/hueAdjust.glsl");

function Shaders:load()
    Shaders.myShader = love.graphics.newShader [[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords ); //This is the current pixel color
      return pixel * color;
    }
  ]];
end

--- Shader to ajust the color of the image
-- @param hue
function Shaders:hueAjust(hue)
    Shaders.p_hueShader.send("hue", hue);
    love.graphics.setShader(Shaders.p_hueShader);
end

--- function which adds an outline to given image
-- @param image the image which will gea an outline
-- @param outlineColor vec4 in RGBA mode with the color of the outline
-- @param wight the thinkness of the border in pixels
function Shaders:addOutline(image, outlineColor, wight)
    -- TODO add a Shader which is adding an outline in given color the the Image
end

--- Function to reset shader buffer
function Shaders:clear()
    love.graphics.setShader();
end

--- function to add an outside glow to an image
-- @param image the image which will gain the glowing outside
-- @param intensity the glow intensits TODO add intervall and unit
function Shaders:addOutsideGlow(image, intensity)
    -- TODO add shader
end

--- Shader to rotate an image
-- @param image the image to be rotated
-- @param rotateBy the rotation angel TODO add intervall and unit
function Shaders:rotate(image, rotateBy)
    -- TODO add shader
end

return Shaders;
