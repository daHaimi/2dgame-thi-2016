--- a klickableElement represents an achievement, wikielement or an upgrade
Class = require "lib.hump.class";
ImageButton = require "class.ImageButton";

local KlickableElement = Class {
    init = function(self, name, image, image_disable, description, price, nameOnPersTable, sortNumber, dependency)
        self.name = name;
        self.enable = true;
        self.image = image;
        if image_disable ~= nil then
            self.image_disable = image_disable;
        end
        self.price = price;
        self.dependency = dependency;
        self.purchaseable = true;
        self.nameOnPersTable = nameOnPersTable;
        self.description = description;
        self.object = ImageButton(self.image, 0, 0, true);
        self.object:setImage(self.image);
        self.sortNumber = sortNumber;
        
        self.xOffset = 0;
        self.yOffset = 0;
    end;
};

--- function will be called when clicked
function KlickableElement:gotClicked()
    _gui.p_states.currentState.elementsOnFrame.chart:markElement(self);
end

--- reset the Element (just the enable state and the image)
function KlickableElement:reset()
    self.enable = true;
    self.object:setImage(self.image);
end

--- i.e. represents an upgrade buy
function KlickableElement:disable()
    self.enable = false;
    if self.image_disable ~= nil then 
        self.object:setImage(self.image_disable);
    end
    if _persTable.upgrades[self.nameOnPersTable] ~= nil then
        _persTable.upgrades[self.nameOnPersTable] = true;
    end
end

--- lock an item because of the dependency to an other item
function KlickableElement:lock()
    self.enable = true;
    if self.image_disable ~= nil then 
        self.object:setImage(self.image_disable);
    end
end

--- Function not conform to CC/ implements an interface
--- set the position of the element
-- @parm x: x axis position
-- @parm y: y axis position
function KlickableElement:setPos(x, y)
    self.object:setPosition(x, y);
end

--- getter of the enable parameter
function KlickableElement:getEnable()
    return self.enable;
end

--- getter for x Position
function KlickableElement:getX()
    local x, _ = self.object:getPosition();
    return x;
end

--- getter for y Position
function KlickableElement:getY()
    local _, y = self.object:getPosition();
    return y;
end

--- draws the klickable element
function KlickableElement:draw()
    self.object:draw();
end

--- returns the size of the klickable element
--@return width, height
function KlickableElement:getSize()
    return self.object:getSize();
end

--@parma y y offset of the button
function KlickableElement:setOffset(x,y)
    self.xOffset = x;
    self.yOffset = y;
end

return KlickableElement;
