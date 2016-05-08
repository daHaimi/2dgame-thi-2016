Class = require "lib.hump.class";
--- Class containing Funcions to add shaders
local Shaders = class {
    init = {};
};


function Shaders:load()
    Shaders.myShader = love.graphics.newShader [[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords ); //This is the current pixel color
      return pixel * color;
    }
  ]]
end

function Shaders:draw()
    love.graphics.setShader(Shaders.myShader) --draw something here
    love.graphics.setShader()
end

function Shaders:makeRed(vec4, _, _, _)
    return vec4(1, 0, 0, 1);
end

return Shaders;
