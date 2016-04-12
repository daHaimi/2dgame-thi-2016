local Bait = Class{
    init = function(self, winDim)
        self.winDim = winDim;
        self.posX = (winDim[1] / 2) - (self.size / 2);
    end;
    size = 10;
    speed = 100;
    posX = 0;
    winDim = {};
};

function Bait:draw()
    love.graphics.setColor(127, 0, 255);
    love.graphics.rectangle("fill", self.posX, (self.winDim[2] / 2) - (self.size / 2) , self.size, self.size);
end

return Bait;