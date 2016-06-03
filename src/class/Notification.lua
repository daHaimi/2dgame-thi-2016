Class = require "lib.hump.class";

local Notification = Class {
    init = function(self)
        if _G._persTable.scaledDeviceDim[1] < 640 then
            self.directory = "assets/gui/480px/";
            self.imageWidth = 50;
            self.imageLength = 50;
            self.yPos = 30;
            self.length = 256;
            self.offset = 7;
        elseif _G._persTable.scaledDeviceDim[1] < 720 then
            self.directory = "assets/gui/640px/";
            self.imageWidth = 75;
            self.imageLength = 75;
            self.yPos = 50;
            self.length = 384;
            self.offset = 10;
        else
            self.directory = "assets/gui/720px/";
            self.imageWidth = 100;
            self.imageLength = 100;
            self.yPos = 70;
            self.length = 512
            self.offset = 14;
        end
        self.speed = 16;
        self.defaultX = _G._persTable.scaledDeviceDim[1];
        self.x = self.defaultX;
        self.background = Loveframes.Create("image");
        self.background:SetImage(self.directory .. "NotificationBG.png");
        self.notificationBuffer = {};
        --state 0 = no notice shown
        --state 1 = notice fly in
        --state 2 = notice shown on screen
        --state 3 = notice fly out
        self.state = 0;
        self.waitingTime = 200;
        self.time = 0;
        self:SetPos(self.x, self.yPos);
        self:SetVisible(false);
    end;
};

---called to create and buffer a new notification 
function Notification:newNotification(imagepath, text)
    local newNotification = {
        image = Loveframes.Create("image");
        text = Loveframes.Create("text");
    };
    newNotification.image:SetImage(imagepath);
    local x, y = newNotification.image:GetImageSize();
    newNotification.image:SetScale(self.imageWidth / x, self.imageLength / y);
    newNotification.image:SetVisible(false);
    newNotification.text:SetText(text);
    newNotification.text:SetVisible(false);
    table.insert(self.notificationBuffer, newNotification);
end

---removes already shown notifications
function Notification:removeNotification()
    table.remove(self.notificationBuffer, 1);
end

---called in the fly in state
function Notification:flyIn()
    self.x = self.x - self.speed;
    self:SetPos(self.x, self.yPos);
end

---called in the fly out state
function Notification:flyOut()
    self.x = self.x + self.speed;
    self:SetPos(self.x, self.yPos);
end

---function checks the position of the notification frame
--@parm pos: position "in" or "out" is reached
function Notification:checkPosition(pos)
    if pos == "in" then
        if self.x <= self.defaultX - self.length then
            return true;
        else
            return false;
        end
    else 
        if self.x >= self.defaultX then
            return true;
        else
            return false;
        end
        
    end
end

---sets position of the notification frame
function Notification:SetPos(x, y)
    self.background:SetPos(x,y);
    if self.notificationBuffer[1] ~= nil then
        self.notificationBuffer[1].image:SetPos(x + self.offset, y + self.offset);
        self.notificationBuffer[1].text:SetPos(x + self.imageLength + self.offset, y + self.offset);
    end
end

---sets the visible of the notification frame
function Notification:SetVisible(visible)
    self.background:SetVisible(visible);
    if self.notificationBuffer[1] then
        self.notificationBuffer[1].image:SetVisible(visible);
        self.notificationBuffer[1].text:SetVisible(visible);
    end
end

---called in the love.update function/ state machine for notification frame
function Notification:update()
    if self.notificationBuffer[1] ~= nil then
        if self.state == 0 then
            self:SetVisible(true);
            self.state = 1;
        end;
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
                self:SetVisible(false);
                self:removeNotification();
                self.x = self.defaultX;
                self.time = 0;
                self.state = 0;
            else
                self:flyOut();
            end;
        end;
    end;
end;

return Notification;