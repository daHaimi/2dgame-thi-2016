--- Data for the fishable objects
fishableObject {
    name = "nemo",      -- The name
    image = "nemo.png", -- The image file
    minSpeed = 5,       -- Min movement speed
    maxSpeed = 7,       -- Max movement speed
    xHitbox = 4,        -- Hitbox width
    yHitbox = 2,        -- Hitbox height
    value = 10,         -- The worth of the object
    hitpoints = 10      -- The HP of the object
}

fishableObject {
    name = "turtle",
    image = "turtle.png",
    minSpeed = 1,
    maxSpeed = 2,
    xHitbox = 4,
    yHitbox = 3,
    value = 10,
    hitpoints = 20
}

fishableObject {
    name = "rat",
    image = "ratte.png",
    minSpeed = 8,
    maxSpeed = 10,
    xHitbox = 3,
    yHitbox = 2,
    value = 20,
    hitpoints = 5
}

fishableObject {
    name = "deadFish",
    image = "deadFish.png",
    minSpeed = 2,
    maxSpeed = 5,
    xHitbox = 4,
    yHitbox = 2,
    value = -10,
    hitpoints = 1
}

--- Data for the swarms for each level
sewer {
    {
        allowedFishables = { "turtle", "rat" }, -- Fishables allowed to appear in this swarm 
        fishablesProbability = { 20, 80 },      -- The odds of allowedFishables (Must be 100)
        minFishables = 50,                      -- The minimum amount of fishables in this swarm
        maxFishables = 100,                     -- The maximum amount of fishables in this swarm
        swarmHeight = 300                       -- The height of this swarm
    },
    
    {
        allowedFishables = { "turtle", "rat", "nemo" },
        fishablesProbability = { 30, 60, 10 },
        minFishables = 80,
        maxFishables = 120,
        swarmHeight = 400
    }
}
