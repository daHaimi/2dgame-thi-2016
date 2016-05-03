--- Data for the fishable objects
fishableObject {
    name = "nemo",      -- The name
    image = "nemo.png", -- The image file
    minSpeed = 4,       -- Min movement speed
    maxSpeed = 7,       -- Max movement speed
    xHitbox = 40,       -- Hitbox width
    yHitbox = 30,       -- Hitbox height
    value = 30,         -- The worth of the object
    hitpoints = 10,     -- The HP of the object
    deltaXHitbox = 12,  -- The hitbox X adjustment 
    deltaYHitbox = 17,  -- The hitbox Y adjustment 
    enabled = true      -- Whether the object is enabled
}

fishableObject {
    name = "turtle",
    image = "turtle.png",
    minSpeed = 1,
    maxSpeed = 2,
    xHitbox = 50,
    yHitbox = 30,
    value = 30,
    hitpoints = 20,
    deltaXHitbox = 5,
    deltaYHitbox = 17,
    enabled = true
}

fishableObject {
    name = "rat",
    image = "ratte.png",
    minSpeed = 5,
    maxSpeed = 8,
    xHitbox = 60,
    yHitbox = 25,
    value = -10,
    hitpoints = 5,
    deltaXHitbox = 2,
    deltaYHitbox = 25,
    enabled = true
}

fishableObject {
    name = "deadFish",
    image = "deadFish.png",
    minSpeed = 0,
    maxSpeed = 1,
    xHitbox = 64,
    yHitbox = 25,
    value = 20,
    hitpoints = 5,
    deltaXHitbox = 0,
    deltaYHitbox = 20,
    enabled = true
}

fishableObject {
    name = "angler",
    image = "angler.png",
    minSpeed = 1,
    maxSpeed = 5,
    xHitbox = 40,
    yHitbox = 40,
    value = 40,
    hitpoints = 20,
    deltaXHitbox = 12,
    deltaYHitbox = 12,
    enabled = true
}

fishableObject {
    name = "lollipop",
    image = "lolli.png",
    minSpeed = 0,
    maxSpeed = 2,
    xHitbox = 30,
    yHitbox = 30,
    value = 10,
    hitpoints = 5,
    deltaXHitbox = 17,
    deltaYHitbox = 2,
    enabled = true
}

fishableObject {
    name = "ring",
    image = "ring.png",
    minSpeed = 0,
    maxSpeed = 5,
    xHitbox = 40,
    yHitbox = 58,
    value = 100,
    hitpoints = 40,
    deltaXHitbox = 12,
    deltaYHitbox = 2,
    enabled = _G._persTable.enabled.ring;
}

fishableObject {
    name = "shoe",
    image = "shoe.png",
    minSpeed = 0,
    maxSpeed = 0,
    xHitbox = 30,
    yHitbox = 56,
    value = -20,
    hitpoints = 20,
    deltaXHitbox = 25,
    deltaYHitbox = 4,
    enabled = true
}

fishableObject {
    name = "snake",
    image = "snake.png",
    minSpeed = 0,
    maxSpeed = 8,
    xHitbox = 54,
    yHitbox = 56,
    value = 50,
    hitpoints = 20,
    deltaXHitbox = 5,
    deltaYHitbox = 4,
    enabled = true
}

fishableObject {
    name = "crocodile",
    image = "crocodile.png",
    minSpeed = 1,
    maxSpeed = 5,
    xHitbox = 128, 
    yHitbox = 10,
    value = 60,
    hitpoints = 60,
    deltaXHitbox = 0, -- TODO: fix crocodile hitbox, changes on scale -1?
    deltaYHitbox = 40,
    enabled = true
}

--- Data for the swarms for each level
sewer {
    {
        -- Fishables allowed to appear in this swarm 
        allowedFishables = { "turtle", "rat", "deadFish"}, 
        
        -- The odds of allowedFishables (Must be 100)
        fishablesProbability = { 10, 50, 40 },  
        
        -- The minimum amount of fishables in this swarm
        minFishables = 15,   
        
        -- The maximum amount of fishables in this swarm
        maxFishables = 25,
        
        -- The height of this swarm
        swarmHeight = 2500                                  
    },
    
    {
        allowedFishables = { "nemo", "lollipop", "deadFish", "angler"},
        fishablesProbability = { 5, 50, 30, 15 },
        minFishables = 20,
        maxFishables = 25,
        swarmHeight = 2000
    },
    
    {
        allowedFishables = { "ring", "shoe", "snake", "crocodile"},
        fishablesProbability = { 5, 25, 35, 35 },
        minFishables = 20,
        maxFishables = 25,
        swarmHeight = 2000
    }
}
