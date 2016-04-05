local Level = Class{
    init = function(self, bgimg, winDim)
        self.winDim = winDim;
        self.posY = winDim[2] / 2;
        bgimg:setWrap("repeat", "repeat");
        self.bg = bgimg
        self.bgq = love.graphics.newQuad(0, 0, winDim[1], 20000, bgimg:getWidth(), bgimg:getHeight());
    end,
    posY = 0;
    dir = 1; -- -1 means up
    bg = nil;
    bgq = nil;
    winDim = {};
};

function Level:update(dt, bait)
    if self.dir == 1 then
        self.sizeY = self.winDim[2] + math.ceil(dt * bait.speed);
        self.posY = self.posY - math.ceil(dt * bait.speed);
    end
end

function Level:draw(bait)
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(self.bg, self.bgq, 0, self.posY);
    bait:draw();
end

return Level;