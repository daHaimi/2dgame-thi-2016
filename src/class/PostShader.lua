Class = require "lib.hump.class";
--- Class containing Funcions to add shaders
local PostShader = Class {
    init = function(self) end;
};

PostShader.p_blurHShader = love.graphics.newShader("shader/fragment/blurh.glsl");
PostShader.p_blurVShader = love.graphics.newShader("shader/fragment/blurv.glsl");
PostShader.p_nightShader = love.graphics.newShader("shader/fragment/night.glsh");

--- This function does Add a light cone at given position on the display
-- @param displayPosition position on Display {x, y}
-- @param size die radius of the light cone in TODO insert unit
function PostShader:addLightCone(displayPosition, size)
    -- TODO add Shader at this Position
end

--- ajustement Shader to set day/nighttime
-- @param daylight day/nighttime [0, 1] 1 as daylight, 0 black night
function PostShader:daytime(daylight)
    local currentScreen = love.graphics.getCanvas();
    love.graphics.setShader(PostShader.p_nightShader);
    PostShader.p_nightShader:send("nighttime", daylight);
    love.graphics.draw(currentScreen);
    love.graphics.setShader();
end

--- function to make the give image glowing
-- @param blurV
-- @param blurH
function PostShader:addBlur(blurV, blurH)
    local bufferRender = love.graphics.newCanvas();
    local bufferBack = love.graphics.newCanvas();
    love.graphics.setColor(255, 255, 255);
    love.graphics.setBlendMode("alpha");

    PostShader.p_blurVShader:send("screen", { love.graphics.getWidth(), love.graphics.getHeight() });
    PostShader.p_blurHShader:send("screen", { love.graphics.getWidth(), love.graphics.getHeight() });
    PostShader.p_blurVShader:send("steps", blurV);
    PostShader.p_blurHShader:send("steps", blurH);

    love.graphics.setShader(PostShader.p_blurVShader);
    love.graphics.draw(bufferRender);

    love.graphics.setShader(PostShader.p_blurHShader);
    love.graphics.draw(bufferBack);

    love.graphics.setShader();
end

--- implemenation of the drawing interface
-- TODO needs to be called in the end of each Rendering cycle
function PostShader:draw()
    -- TODO for each if shader is set draw

    -- TODO reset canvas
end

return PostShader;
