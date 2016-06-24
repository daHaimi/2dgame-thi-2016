Class = require "lib.hump.class";

local Notification = Class {
    init = function(self)
        self.imageWidth = 50;
        self.imageLength = 50;
        self.yPos = 60;
        self.length = 256;
        self.offset = 5;
        self.speed = 16;
        self.defaultX = _G._persTable.scaledDeviceDim[1];
        self.xPos = self.defaultX;
        self.notificationBuffer = {};
        --state 1 = notice fly in
        --state 2 = notice shown on screen
        --state 3 = notice fly out
        self.state = 1;
        self.waitingTime = 200;
        self.time = 0;
        self.background = love.graphics.newImage("assets/gui/NotificationBG.png");
    end;
};

--- called to create and buffer a new notification
function Notification:newNotification(imagepath, text)
    local newNotification = {
        image = love.graphics.newImage(imagepath);
        text = text;
    };
    table.insert(self.notificationBuffer, newNotification);
end

--- removes already shown notifications
function Notification:removeNotification()
    table.remove(self.notificationBuffer, 1);
end

--- draws the notification objects
function Notification:draw()
    if self.notificationBuffer[1] ~= nil then
        love.graphics.setFont(love.graphics.newFont("font/8bitOperatorPlus-Regular.ttf", 12));
        love.graphics.draw(self.background, self.xPos, self.yPos);
        love.graphics.draw(self.notificationBuffer[1].image, self.xPos + self.offset, self.yPos + self.offset);
        love.graphics.printf(self.notificationBuffer[1].text, self.xPos + self.imageLength + self.offset, self.yPos + self.offset, 100, "left");
    end
end

--- called in the fly in state
function Notification:flyIn()
    self.xPos = self.xPos - self.speed;
end

--- called in the fly out state
function Notification:flyOut()
    self.xPos = self.xPos + self.speed;
end

--- function checks the position of the notification frame
-- @parm pos: position "in" or "out" is reached
function Notification:checkPosition(pos)
    if pos == "in" then
        if self.xPos <= self.defaultX - self.length then
            return true;
        else
            return false;
        end
    else
        if self.xPos >= self.defaultX then
            return true;
        else
            return false;
        end
    end
end

--- called in the love.update function/ state machine for notification frame
function Notification:update()
    if self.notificationBuffer[1] ~= nil then
        if self.state == 1 then
            if self:checkPosition("in") then
                self.state = 2;
            else
                self:flyIn();
            end;
        end;
        if self.state == 2 then
            self.time = self.time + 1;
            if self.time >= self.waitingTime then
                self.state = 3;
            end;
        end;
        if self.state == 3 then
            if self:checkPosition("out") then
                self:removeNotification();
                self.xPos = self.defaultX;
                self.time = 0;
                self.state = 1;
            else
                self:flyOut();
            end;
        end;
    end;
end

return Notification;
