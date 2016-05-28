Class = require "lib.hump.class";
require "socket"

--- Class for simple Animations
-- @param image                                 The sprite as love.graphics.Image instance
-- @param cols                                  The number of cols in the sprite
-- @param rows                                  The number of rows in the sprite
-- @param timeout (0.2)                         The timeout between the images in seconds
-- @param animType (Animate.AnimType.linear)    The animation type of the enum Animate.AnimType
-- @param numStart (1)                          The frame of the image the animation should start with
-- @param numEnd (cols * rows)                  The frame of the image the animation should end with
local Animate = Class {
    init = function(self, image, cols, rows, timeout, animType, numStart, numEnd)
        self.p_image = image;
        self.p_cols = cols;
        self.p_rows = rows;
        self.p_timeout = timeout or .2;
        self.p_animType = animType or 1;
        self.p_numStart = numStart or 1;
        self.p_numEnd = numEnd or (self.p_cols * self.p_rows);
        self.p_curPos = self.p_numStart;
        self.p_timer = 0;
        self.p_measures = {
            self.p_image:getWidth() / self.p_cols,
            self.p_image:getHeight() / self.p_rows
        };
        self.p_quads = {};
        for i = self.p_numStart, self.p_numEnd, 1 do
            local calcWidth = self.p_measures[1] * (i - 1);
            local offsetLeft = calcWidth % self.p_image:getWidth();
            local offsetTop = math.floor(calcWidth / self.p_image:getWidth());
            self.p_quads[i] = love.graphics.newQuad(offsetLeft, offsetTop, self.p_measures[1], self.p_measures[2], self.p_image:getDimensions());
        end
            
        self.p_forward = true;
    end;
};

--- @enum Animate.AnimType
-- linear = 1: Runs from first frame to last frame and starts over
-- bounce = 2: Runs from first frame to last frame and back to the first frame
-- random = 3: Selects every frame randomly
Animate.AnimType = {
    linear = 1;
    bounce = 2;
    random = 3;
};

--- Update the animation
-- @param dt Delta time since last update in seconds
-- @return nil
function Animate:update(dt)
    self.p_timer = self.p_timer + dt;
    if self.p_timer >= self.p_timeout then
        self.p_timer = self.p_timer - self.p_timeout;
        self:shiftImage();
    end
end

--- Shift quad position to the next position
-- @return nil
function Animate:shiftImage()
    if self.p_animType == self.AnimType.linear then
        self.p_curPos = self.p_curPos + 1;
        if self.p_curPos > self.p_numEnd then
            self.p_curPos = self.p_numStart;
        end
    elseif self.p_animType == self.AnimType.bounce then
        if self.p_curPos == self.p_numEnd then
            self.p_forward = false;
        elseif self.p_curPos == self.p_numStart then
            self.p_forward = true;
        end
        if self.p_forward == true then
            self.p_curPos = self.p_curPos + 1;
        else
            self.p_curPos = self.p_curPos - 1;
        end
    elseif self.p_animType == self.AnimType.random then
        math.randomseed(socket.gettime() * 10000);
        self.p_curPos = math.random(self.p_numStart, self.p_numEnd);
    end
end

--- Draw the current quad to a position
-- @param posX The x position
-- @param posY The y position
-- @return nil
function Animate:draw(posX, posY)
    love.graphics.draw(self.p_image, self.p_quads[self.p_curPos], posX, posY);
end

return Animate;
