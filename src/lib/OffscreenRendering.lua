local w, h, _ = love.window.getMode();
_G.offscreen = {
    width = 480;
};
_G.offscreen.scale = w / offscreen.width;
_G.offscreen.height = h * offscreen.scale;
_G.offscreen.canvas = love.graphics.newCanvas(_G.offscreen.width, _G.offscreen.height);
_G.offscreen.loveDraw = love.graphics.draw;
_G.offscreen.drawToScreen = function()
    love.graphics.setCanvas();
    _G.offscreen.loveDraw(_G.offscreen.canvas, _G.offscreen.scale, _G.offscreen.scale);
end;

_G.love.graphics.draw = function(...)
    local canvas love.graphics.getCanvas();
    if canvas == nil then
        love.graphics.setCanvas(_G.offscreen.canvas);
        _G.offscreen.loveDraw(...);
        love.graphics.setCanvas();
    else
        _G.offscreen.loveDraw(...);
    end
end;
