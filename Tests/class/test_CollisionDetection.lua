_G.math.inf = 1 / 0

testClass = require "src.class.CollisionDetection"

describe ( "relative position", function()
    local locInstance = nil;
    
    data_collision = {
        {1, 1, false},
        {1, 2, false},
        {1, 3, false},
        {1, 4, false},
        {1, 5, false},
        {2, 1, false},
        {2, 2, true},
        {2, 3, true},
        {2, 4, true},
        {2, 5, false},
        {3, 1, false},
        {3, 2, true},
        {3, 3, true},
        {3, 4, true},
        {3, 5, false},
        {4, 1, false},
        {4, 2, true},
        {4, 3, true},
        {4, 4, true},
        {4, 5, false},
        {5, 1, false},
        {5, 2, false},
        {5, 3, false},
        {5, 4, false},
        {5, 5, false},
    };
    
    before_each(function()
        locInstance = testClass();
    end)

    it('testing collision calculation', function()
        for _,v in pairs(data_collision) do
            result = locInstance.calculateCollision ( v[1], v[2], 2, 2,
                2, 2 );
            assert.are.equal ( result, v[3] );
        end
    end)
end)