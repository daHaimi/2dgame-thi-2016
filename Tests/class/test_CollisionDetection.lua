_G.math.inf = 1 / 0

testClass = require "src.class.CollisionDetection"

describe ( "relative position", function()
    local locInstance = nil;
    
    data_collision = {
        {1, false},
        {2, true},
        {3, true},
        {4, true},
        {5, false}
    };
    
    before_each(function()
        locInstance = testClass();
    end)

    it('testing collision calculation', function()
        for _,v in pairs(data_collision) do
            locInstance:setCollision(false);
            locInstance:calculateCollision ( v[1], 2, 2 );
            local result = locInstance:getCollision();
            assert.are.equal ( v[2], result );
        end
    end)

end)