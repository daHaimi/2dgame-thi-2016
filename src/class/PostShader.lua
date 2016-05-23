Class = require "lib.hump.class";
--- Class containing Funcions to add shaders
local PostShader = Class {
    init = function(self) end;
};

PostShader.p_blurHShader = love.graphics.newShader("shader/fragment/blurh.glsl");
PostShader.p_blurVShader = love.graphics.newShader("shader/fragment/blurv.glsl");

--- This function does Add a light cone at given position on the display
-- @param displayPosition position on Display {x, y}
-- @param size die radius of the light cone in TODO insert unit
function PostShader:addLightCone(displayPosition, size)
    -- TODO add Shader at this Position
end

--- ajustement Shader to set day/nighttime
-- @param daylight day/nighttime TODO insert range and unit
function PostShader:daytime(daylight)
    -- TODO add Shader ajusting all display
end

function PostShader:addSmoke(position, intensity) end

function PostShader:addSplash(position, intensity) end


--- function to make the give image glowing
-- @param blurV
-- @param blurH
function PostShader:addBlur(blurV, blurH)
    local bufferRender = love.graphics.newCanvas();
    local bufferBack = love.graphics.newCanvas();
    love.graphics.setColor(255, 255, 255);
    love.graphics.setBlendMode("alpha");

    PostShader.p_blurVShader:send("screen", { _G._persTable.winDim[2], _G._persTable.winDim[1] });
    PostShader.P_blurHShader:send("screen", { _G._persTable.winDim[2], _G._persTable.winDim[1] });
    PostShader.p_blurVShader:send("steps", blurV);
    PostShader.P_blurHShader:send("steps", blurH);

    love.graphics.setShader(PostShader.p_blurVShader);
    love.graphics.draw(bufferRender);

    love.graphics.setShader(PostShader.p_blurHShader);
    love.graphics.draw(bufferBack);

    love.graphics.setShader();
end

return PostShader;
