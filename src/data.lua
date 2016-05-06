--- Data for the fishable objects
fishableObject {
    -- definition of the object
    name = "nemo",      -- The name
    image = "nemo.png", -- The image file
    spriteSize = 64,    -- width of the image
    minSpeed = 4,       -- Min movement speed
    maxSpeed = 7,       -- Max movement speed
    value = 30,         -- The worth of the object
    hitpoints = 10,      -- The HP of the object
    minAmount = 3,            -- min amount of objects per swarm
    maxAmount = 5,            -- max amount of objects per swarm
    swarmHeight = 300,       -- height of the swarm of this object
    enabled = true,      -- Whether the object is enabled
    
    -- definition of the hitbox
    hitbox = {
        {
            width = 40,       -- Hitbox width
            height = 30,       -- Hitbox height
            deltaXPos= 12,   -- The hitbox X adjustment 
            deltaYPos = 17   -- The hitbox Y adjustment 
        }
    }
}

fishableObject {
    name = "turtle",
    image = "turtle.png",
    spriteSize = 64,
    minSpeed = 1,
    maxSpeed = 2,
    hitpoints = 20,        
    value = 30,
    minAmount = 2,
    maxAmount = 4,
    swarmHeight = 225,
    enabled = true,
    
    hitbox = {
        {
            width = 50,
            height = 30,
            deltaXPos = 5,
            deltaYPos = 17
        }
    } 
}

fishableObject {
    name = "rat",
    image = "ratte.png",
    spriteSize = 64,
    minSpeed = 3,
    maxSpeed = 4,
    hitpoints = 5,        
    value = -10,
    minAmount = 3,
    maxAmount = 3,
    swarmHeight = 350,
    enabled = true,
    
    hitbox = {
        {
            width = 60,
            height = 25,
            deltaXPos = 2,
            deltaYPos = 25
        }
    }
}

fishableObject {
    name = "deadFish",
    image = "deadFish.png",
    spriteSize = 64,
    minSpeed = 0,
    maxSpeed = 1,
    hitpoints = 5,        
    value = 20,
    minAmount = 1,
    maxAmount = 2,
    swarmHeight = 125,
    enabled = true,

    hitbox = {
        {
            width = 64,
            height = 25,
            deltaXPos = 0,
            deltaYPos = 20
        }
    } 
}
fishableObject {
    name = "angler",
    image = "angler.png",
    spriteSize = 64,
    minSpeed = 1,
    maxSpeed = 5,
    hitpoints = 20,        
    value = 40,
    minAmount = 1,
    maxAmount = 4,
    swarmHeight = 200,
    enabled = true,
    
    hitbox = {
        {
            width = 40,
            height = 40,
            deltaXPos = 12,
            deltaYPos = 12
        }
    }
}

fishableObject {
    name = "lollipop",
    image = "lolli.png",
    spriteSize = 64,
    minSpeed = 0,
    maxSpeed = 2,
    hitpoints = 5,        
    value = 10,
    minAmount = 1,
    maxAmount = 1,
    swarmHeight = 100,
    enabled = true,
    
    hitbox = {
        {
            width = 30,
            height = 30,
            deltaXPos = 17,
            deltaYPos = 2
        }
    }
}

fishableObject {
    name = "ring",
    image = "ring.png",
    spriteSize = 64,
    minSpeed = 0,
    maxSpeed = 5,
    hitpoints = 40,        
    value = 100,
    minAmount = 1,
    maxAmount = 1,
    swarmHeight = 100,
    enabled = _G._persTable.enabled.ring,
    
    hitbox = {
        {
            width = 40,
            height = 58,
            deltaXPos = 12,
            deltaYPos = 2
        }
    }
}

fishableObject {
        name = "shoe",
        image = "shoe.png",
        spriteSize = 64,
        minSpeed = 0,
        maxSpeed = 0,
        hitpoints = 20,        
        value = -20,
        minAmount = 1,
        maxAmount = 1,
        swarmHeight = 100,
        enabled = true,
    
    hitbox = {
        {
            width = 55,
            height = 17,
            deltaXPos = 2,
            deltaYPos = 43            
        },
        
        {
            width = 30,
            height = 56,
            deltaXPos = 25,
            deltaYPos = 4
        }
    }
}

fishableObject {
    name = "snake",
    image = "snake.png",
    spriteSize = 64,
    minSpeed = 2,
    maxSpeed = 5,
    hitpoints = 20,        
    value = 50,
    minAmount = 2,
    maxAmount = 3,
    swarmHeight = 200,
    enabled = true,
    
    hitbox = {
        {
            width = 54,
            height = 56,
            deltaXPos = 5,
            deltaYPos = 4
        }
    }
}

fishableObject {
    name = "crocodile",
    image = "crocodile.png",
    spriteSize = 128,
    minSpeed = 1,
    maxSpeed = 5,
    hitpoints = 60,        
    value = 60,
    minAmount = 1,
    maxAmount = 3,
    swarmHeight = 200,
    enabled = true,

    hitbox = {
        {
            width = 128,
            height = 10,
            deltaXPos = 0,
            deltaYPos = 40
        }
    }
}

fishableObject {
    name = "sleepingPill",
    image = "hamster.png",
    spriteSize = 64,
    minSpeed = 0,
    maxSpeed = 0,
    hitpoints = 0,        
    value = 0,
    minAmount = 1,
    maxAmount = 1,
    swarmHeight = 50,
    enabled = _G._persTable.enabled.sleepingPill,
    
    hitbox = {
        {
            width = 30,
            height = 30,
            deltaXPos = 17,
            deltaYPos = 17
        }
    }
}

--- Data for the swarms for each level
sewer {
    {
        -- Fishables allowed to appear in this swarm 
        allowedFishables = { "turtle", "rat", "deadFish", "sleepingPill"}, 
        
        -- The odds of allowedFishables allready added up(10, 40, 40, 10)
        fishablesProbability = {10, 50, 90, 100},  

        -- The deepest possible height of this swarm
        maxSwarmHeight = 3000;                                  
    },
    
    {
        allowedFishables = { "nemo", "lollipop", "deadFish", "angler", "sleepingPill"},
        fishablesProbability = {5, 45, 75, 90, 100 }, --(5, 40, 30, 15, 10)
        maxSwarmHeight = 6000
    },
    
    {
        allowedFishables = { "ring", "shoe", "snake", "crocodile", "sleepingPill"},
        fishablesProbability = { 5, 30, 55, 90, 100}, --(3, 25, 25, 35, 10)
        maxSwarmHeight = 9000
    }
}
