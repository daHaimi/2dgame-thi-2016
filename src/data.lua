--- Data for the fishable objects
fishableObject {
    name = "nemo",      -- The name
    image = "nemo.png", -- The image file
    minSpeed = 4,       -- Min movement speed
    maxSpeed = 7,       -- Max movement speed
    xHitbox = 30,        -- Hitbox width
    yHitbox = 30,        -- Hitbox height
    value = 10,         -- The worth of the object
    hitpoints = 10      -- The HP of the object
}

fishableObject {
    name = "turtle",
    image = "turtle.png",
    minSpeed = 1,
    maxSpeed = 2,
    xHitbox = 50,
    yHitbox = 30,
    value = 10,
    hitpoints = 20
}

fishableObject {
    name = "rat",
    image = "ratte.png",
    minSpeed = 5,
    maxSpeed = 8,
    xHitbox = 60,
    yHitbox = 20,
    value = 20,
    hitpoints = 5
}

fishableObject {
    name = "deadFish",
    image = "deadFish.png",
    minSpeed = 0,
    maxSpeed = 2,
    xHitbox = 60,
    yHitbox = 20,
    value = -10,
    hitpoints = 1
}

fishableObject {
    name = "angler",
    image = "anglerfisch.png",
    minSpeed = 3,
    maxSpeed = 8,
    xHitbox = 30,
    yHitbox = 30,
    value = 20,
    hitpoints = 20
}

fishableObject {
    name = "lollipop",
    image = "lolli.png",
    minSpeed = 0,
    maxSpeed = 2,
    xHitbox = 2,
    yHitbox = 4,
    value = -10,
    hitpoints = 5
}

fishableObject {
    name = "ring",
    image = "ring.png",
    minSpeed = 0,
    maxSpeed = 5,
    xHitbox = 15,
    yHitbox = 15,
    value = 40,
    hitpoints = 10
}

fishableObject {
    name = "shoe",
    image = "shoe.png",
    minSpeed = 0,
    maxSpeed = 2,
    xHitbox = 30,
    yHitbox = 40,
    value = -20,
    hitpoints = 20
}

--- Data for the swarms for each level
sewer {
    {
        allowedFishables = { "turtle", "rat", "deadFish" }, -- Fishables allowed to appear in this swarm 
        fishablesProbability = { 10, 50, 40 },              -- The odds of allowedFishables (Must be 100)
        minFishables = 10,                                  -- The minimum amount of fishables in this swarm
        maxFishables = 15,                                  -- The maximum amount of fishables in this swarm
        swarmHeight = 2000                                  -- The height of this swarm
    },
    
    {
        allowedFishables = { "nemo", "lollipop", "deadFish" },
        fishablesProbability = { 60, 30, 10 },
        minFishables = 15,
        maxFishables = 20,
        swarmHeight = 2000
    }
}
