return {
    --- Data for the fishable objects
    fishableObjects = {
        nemo = {
            -- definition of the object
            name = "nemo",         -- The name
            image = "nemo.png",    -- The image file
            spriteSize = 64,       -- width of the image
            minSpeed = 4,          -- Min movement speed
            maxSpeed = 7,          -- Max movement speed
            value = 30,            -- The worth of the object
            animTimeoutMin = 0.1, -- The min animation timeout
            animTimeoutMax = 0.15, -- The max animation timeout
            
            -- The animation type of the enum Animate.AnimType
            animType = "bounce",
            
            minAmount = 3,         -- min amount of objects per swarm
            maxAmount = 5,         -- max amount of objects per swarm
            swarmHeight = 300,     -- height of the swarm of this object
            enabled = true,        -- Whether the object is enabled
            
            -- Definition of the hitbox
            hitbox = {
                {
                    width = 40,    -- Hitbox width
                    height = 30,   -- Hitbox height
                    deltaXPos= 12, -- The hitbox X adjustment 
                    deltaYPos = 17 -- The hitbox Y adjustment 
                }
            }
        },
        
        turtle = {
            name = "turtle",
            image = "turtle.png",
            spriteSize = 64,
            minSpeed = 1,
            maxSpeed = 2,
            value = 30,
            animTimeoutMin = 0.15,
            animTimeoutMax = 0.25,
            animType = "bounce",
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
        },
        
        rat = {
            name = "rat",
            image = "rat.png",
            spriteSize = 64,
            minSpeed = 3,
            maxSpeed = 4,
            value = -10,
            animTimeoutMin = 0.08,
            animTimeoutMax = 0.15,
            animType = "bounce",
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
        },
    
        deadFish = {
            name = "deadFish",
            image = "deadFish.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 1,
            value = 20,
            animTimeoutMin = 0.2,
            animTimeoutMax = 0.3,
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
        },
        
        angler = {
            name = "angler",
            image = "angler.png",
            spriteSize = 64,
            minSpeed = 1,
            maxSpeed = 5,
            animTimeoutMin = 0.15,
            animTimeoutMax = 0.2,
            animType = "bounce",
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
        },

        lollipop = {
            name = "lollipop",
            image = "lolli.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 2,
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
                },
                {
                    width = 6,
                    height = 40,
                    deltaXPos = 29,
                    deltaYPos = 24
                }
            }
        },

        ring = {
            name = "ring",
            image = "ring.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 5,
            value = 100,
            minAmount = 1,
            maxAmount = 1,
            swarmHeight = 100,
--            enabled = _G._persTable.enabled.ring,
            hitbox = {
                {
                    width = 40,
                    height = 58,
                    deltaXPos = 12,
                    deltaYPos = 2
                }
            }
        },

        shoe = {
            name = "shoe",
            image = "shoe.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 0,
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
        },

        snake = {
            name = "snake",
            image = "snake.png",
            spriteSize = 64,
            minSpeed = 2,
            maxSpeed = 5,
            animTimeoutMin = 0.15,
            animTimeoutMax = 0.25,
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
        },

        crocodile = {
            name = "crocodile",
            image = "crocodile.png",
            spriteSize = 128,
            minSpeed = 1,
            maxSpeed = 5,
            value = 60,
            animTimeoutMin = 0.8,
            animTimeoutMax = 1,
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
        },

        sleepingPill = {
            name = "sleepingPill",
            image = "pill.png",
            spriteSize = 32,
            minSpeed = 0,
            maxSpeed = 0,
            value = 0,
            minAmount = 1,
            maxAmount = 1,
            swarmHeight = 50,
--            enabled = _G._persTable.enabled.sleepingPill,
            hitbox = {
                {
                    width = 15,
                    height = 15,
                    deltaXPos = 1,
                    deltaYPos = 1
                },
                {
                    width = 15,
                    height = 15,
                    deltaXPos = 8,
                    deltaYPos = 8
                },
                {
                    width = 15,
                    height = 15,
                    deltaXPos = 15,
                    deltaYPos = 15
                }
            }
        },
        
        squirrel = {
            name = "squirrel",
            image = "squirrel.png",
            spriteSize = 64,
            minSpeed = 4,
            maxSpeed = 6,
            value = 50,
            animTimeoutMin = 0.15,
            animTimeoutMax = 0.17,
            animType = "bounce",
            minAmount = 1,
            maxAmount = 2,
            swarmHeight = 200,
            enabled = true,
            hitbox = {
                {
                    width = 62,
                    height = 0,
                    deltaXPos = 2,
                    deltaYPos = 0
                },
                {
                    width = 15,
                    height = 34,
                    deltaXPos = 49,
                    deltaYPos = 0
                },
                {
                    width = 46,
                    height = 64,
                    deltaXPos = 2,
                    deltaYPos = 0
                }
            }
        },
        
        backpack = {
            name = "backpack",
            image = "backpack.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 0,
            downSpeed = 7;
            value = -100,
            minAmount = 1,
            maxAmount = 0,
            swarmHeight = 50,
            enabled = true,
            hitbox = {
                {
                    width = 52,
                    height = 54,
                    deltaXPos = 6,
                    deltaYPos = 6
                }
            }
        },
        
        drink = {
            name = "drink",
            image = "drink.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 0,
            downSpeed = 6;
            value = -30,
            animTimeoutMin = 0.2,
            animTimeoutMax = 0.4,
            animType = "bounce",
            minAmount = 1,
            maxAmount = 1,
            swarmHeight = 50,
            enabled = true,
            hitbox = {
                {
                    width = 49,
                    height = 17,
                    deltaXPos = 9,
                    deltaYPos = 13
                },
                {
                    width = 36,
                    height = 19,
                    deltaXPos = 16,
                    deltaYPos = 30
                },
                {
                    width = 23,
                    height = 10,
                    deltaXPos = 22,
                    deltaYPos = 49
                }
            }
        },
        
        egg = {
            name = "egg",
            image = "egg.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 0,
            value = 80,
            minAmount = 1,
            maxAmount = 3,
            swarmHeight = 100,
            enabled = true,
            hitbox = {
                {
                    width = 22,
                    height = 10,
                    deltaXPos = 22,
                    deltaYPos = 10
                },
                {
                    width = 42,
                    height = 36,
                    deltaXPos = 12,
                    deltaYPos = 20
                }
            }
        },
        
        camera = {
            name = "camera",
            image = "camera.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 0,
            downSpeed = 5;
            value = -100,
            animTimeoutMin = 0.15,
            animTimeoutMax = 0.2,
            animType = "bounce",
            minAmount = 1,
            maxAmount = 1,
            swarmHeight = 50,
            enabled = true,
            hitbox = {
                {
                    width = 10,
                    height = 8,
                    deltaXPos = 47,
                    deltaYPos = 9
                },
                {
                    width = 60,
                    height = 38,
                    deltaXPos = 2,
                    deltaYPos = 16
                }
            }
        },
        
        canyonSnake = {
            name = "canyonSnake",
            image = "canyon_snake.png",
            spriteSize = 64,
            minSpeed = 1,
            maxSpeed = 4,
            value = 40,
            animTimeoutMin = 0.3,
            animTimeoutMax = 0.5,
            minAmount = 1,
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
        },
        
        cactus = {
            name = "cactus",
            image = "cactus.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 0,
            value = -30,
            animTimeoutMin = 0.3,
            animTimeoutMax = 0.5,
            animType = "bounce",
            minAmount = 2,
            maxAmount = 2,
            swarmHeight = 150,
            enabled = true,
            hitbox = {
                {
                    width = 16,
                    height = 54,
                    deltaXPos = 28,
                    deltaYPos = 2
                },
                {
                    width = 36,
                    height = 10,
                    deltaXPos = 17,
                    deltaYPos = 54
                },
                {
                    width = 10,
                    height = 14,
                    deltaXPos = 11,
                    deltaYPos = 15
                },
                {
                    width = 10,
                    height = 14,
                    deltaXPos = 48,
                    deltaYPos = 13
                }
            }
        },
        
        leaf = {
            name = "leaf",
            image = "leaf.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 2,
            value = 20,
            animTimeoutMin = 0.25,
            animTimeoutMax = 0.3,
            animType = "bounce",
            minAmount = 2,
            maxAmount = 3,
            swarmHeight = 150,
            enabled = true,
            hitbox = {
                {
                    width = 3,
                    height = 10,
                    deltaXPos = 60,
                    deltaYPos = 10
                },
                {
                    width = 46,
                    height = 20,
                    deltaXPos = 4,
                    deltaYPos = 38
                },
                {
                    width = 44,
                    height = 20,
                    deltaXPos = 14,
                    deltaYPos = 20
                }
            }
        },
        
        bird = {
            name = "bird",
            image = "bird.png",
            spriteSize = 64,
            minSpeed = 2,
            maxSpeed = 4,
            value = 20,
            animTimeoutMin = 0.1,
            animTimeoutMax = 0.15,
            animType = "bounce",
            minAmount = 1,
            maxAmount = 3,
            swarmHeight = 250,
            enabled = true,
            hitbox = {
                {
                    width = 60,
                    height = 14,
                    deltaXPos = 2,
                    deltaYPos = 8
                },
                {
                    width = 22,
                    height = 22,
                    deltaXPos = 18,
                    deltaYPos = 22
                },
                {
                    width = 10,
                    height = 14,
                    deltaXPos = 30,
                    deltaYPos = 44
                }
            }
        },
        
        balloon = {
            name = "balloon",
            image = "balloon.png",
            spriteSize = 64,
            minSpeed = 2,
            maxSpeed = 4,
            value = 10,
            minAmount = 2,
            maxAmount = 3,
            swarmHeight = 200,
            enabled = true,
            hitbox = {
                {
                    width = 20,
                    height = 40,
                    deltaXPos = 22,
                    deltaYPos = 4
                },
                {
                    width = 30,
                    height = 14,
                    deltaXPos = 18,
                    deltaYPos = 14
                },
                {
                    width = 6,
                    height = 20,
                    deltaXPos = 34,
                    deltaYPos = 44
                }
            }
        },
        
        ufo = {
            name = "ufo",
            image = "ufo.png",
            spriteSize = 64,
            minSpeed = 1,
            maxSpeed = 4,
            value = 60,
            minAmount = 1,
            maxAmount = 1,
            swarmHeight = 100,
            enabled = true,
            hitbox = {
                {
                    width = 30,
                    height = 14,
                    deltaXPos = 18,
                    deltaYPos = 10
                },
                {
                    width = 58,
                    height = 16,
                    deltaXPos = 3,
                    deltaYPos = 24
                },
                {
                    width = 37,
                    height = 22,
                    deltaXPos = 14,
                    deltaYPos = 40
                }
            }
        },
        bubble = {
            name = "bubble",
            image = "bubble.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 0,
            downSpeed = -10,
            value = 0,
            minAmount = 3,
            maxAmount = 5,
            swarmHeight = 0,
            hitbox = { {
                    width = 0,
                    height = 0,
                    deltaXPos = 0,
                    deltaYPos = 0
                }}
        }
    },

    --- Data for the swarms for each level
    swarmsSewer = {
        {
            -- Fishables allowed to appear in this swarm 
            allowedFishables = { "turtle", "rat", "deadFish"}, 
            
            -- The odds of allowedFishables allready added up(10, 40, 40, 10)
            fishablesProbability = {10, 50, 100},  

            -- The deepest possible height of this swarm
            maxSwarmHeight = 3000;                                  
        },
        
        {
            allowedFishables = { "nemo", "lollipop", "deadFish", "angler",},
            fishablesProbability = {5, 45, 75, 100 }, --(5, 40, 30, 15, 10)
            maxSwarmHeight = 6000
        },
        
        {
            allowedFishables = { "ring", "shoe", "snake", "crocodile"},
            fishablesProbability = { 5, 30, 55, 100},
            maxSwarmHeight = 9000
        }
    },
    
    swarmsCanyon = {
        {
            allowedFishables = { "canyonSnake", "leaf", "bird", "squirrel"},
            fishablesProbability = {25, 45, 75, 100}, 
            maxSwarmHeight = 1500
        },
        {
            allowedFishables = { "cactus"},
            fishablesProbability = {100}, 
            maxSwarmHeight = 1800
        },
        {
            allowedFishables = {"cactus"},
            fishablesProbability = {100}, 
            maxSwarmHeight = 5500,
            typ = "static"
        }, 
        {
            allowedFishables = { "egg", "bird", "cactus"},
            fishablesProbability = {30, 50, 100}, 
            maxSwarmHeight = 9000
        },
        {
            allowedFishables = { "backpack", "camera", "bird", "egg"},
            fishablesProbability = {10, 20, 50, 100}, 
            maxSwarmHeight = 1200
        }
    },

    --- Data for all upgrades
    upgrades = {
        oneMoreLife = {
            nameOnPersTable = "oneMoreLife";--Name of parameter in persTable. Unlock change this parameter to true
            price = 500;--price of this item
            image = "shop_extraLife1.png";
            image_disable = "shop_extraLife1_locked.png";
        },
        twoMoreLife = {
            nameOnPersTable = "twoMoreLife";
            price = 1000;
            image = "shop_extraLife2.png";
            image_disable = "shop_extraLife2_locked.png";
        },
        threeMoreLife = {
            nameOnPersTable = "threeMoreLife";
            price = 1500;
            image = "shop_extraLife3.png";
            image_disable = "shop_extraLife3_locked.png";
        },
        firstSpeedUp = {
            nameOnPersTable = "firstSpeedUp";
            price = 300;
            image = "shop_speedup1.png";
            image_disable = "shop_speedup1_locked.png";
        },
        secondSpeedUp = {
            nameOnPersTable = "secondSpeedUp";
            price = 300;
            image = "shop_speedup2.png";
            image_disable = "shop_speedup2_locked.png";
        },
        moneyMulitplier = {
            nameOnPersTable = "moneyMultiplier";
            price = 300;
            image = "shop_doubleScore.png";
            image_disable = "shop_doubleScore_locked.png";
        },
        godMode = {
            nameOnPersTable = "godMode";
            price = 1000;
            image = "shop_godmode.png";
            image_disable = "shop_godmode_locked.png";
        },
        mapBreakthrough1 = {
            nameOnPersTable = "mapBreakthrough1";
            price = 2500;
            image = "shop_barrier.png";
            image_disable = "shop_barrier_locked.png";
        },
        mapBreakthrough2 = {
            nameOnPersTable = "mapBreakthrough2";
            price = 5000;
            image = "shop_barrier.png";
            image_disable = "shop_barrier_locked.png";
        },
        moreFuel1 = {
            nameOnPersTable = "moreFuel1";
            price = 1000;
            image = "shop_fuel1.png";
            image_disable = "shop_fuel1_locked.png";
        },
        moreFuel2 = {
            nameOnPersTable = "moreFuel2";
            price = 1500;
            image = "shop_fuel2.png";
            image_disable = "shop_fuel2_locked.png";
        },
        firstPermanentMoneyMulitplier = {
            nameOnPersTable = "firstPermanentMoneyMult";
            price = 1000;
            image = "shop_moreMoney1.png";
            image_disable = "shop_moreMoney1_locked.png";
        },
        secondPermanentMoneyMulitplier = {
            nameOnPersTable = "secondPermanentMoneyMult";
            price = 2500;
            image = "shop_moreMoney2.png";
            image_disable = "shop_moreMoney2_locked.png";
        },
    },
    
    achievements = {
        getFirstObject = {
            nameOnPersTable = "getFirstObject";
            image_lock = "ach_firstObject_locked.png";
            image_unlock = "ach_firstObject.png";
        },
        failedStart = {
            nameOnPersTable = "failedStart";
            image_lock = "ach_drop_hamster_locked.png";
            image_unlock = "ach_drop_hamster.png";
        },
        caughtTwoBoots = {
            nameOnPersTable = "caughtTwoBoots";
            image_lock = "ach_two_shoes_locked.png";
            image_unlock = "ach_two_shoes.png";
        },
        secondStart = {
            nameOnPersTable = "secondStart";
            image_lock = "ach_secondTimeGame_locked.png";
            image_unlock = "ach_secondTimeGame.png";
        },
        bronzeCaughtOneRound = {
            nameOnPersTable = "bronzeCaughtOneRound";
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRoundBronze.png";
        },
        silverCaughtOneRound = {
            nameOnPersTable = "silverCaughtOneRound";
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRound.png";
        },
        goldCaughtOneRound = {
            nameOnPersTable = "goldCaughtOneRound";
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRoundGold.png";
        },
        
        bronzeCoinsOneRound = {
            nameOnPersTable = "bronzeCoinsOneRound";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        silverCoinsOneRound = {
            nameOnPersTable = "silverCoinsOneRound";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        goldCoinsOneRound = {
            nameOnPersTable = "goldCoinsOneRound";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        bMoneyEarnedTotal = {
            nameOnPersTable = "bMoneyEarnedTotal";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        sMoneyEarnedTotal = {
            nameOnPersTable = "sMoneyEarnedTotal";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        gMoneyEarnedTotal = {
            nameOnPersTable = "gMoneyEarnedTotal";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        negativCoins = {
            nameOnPersTable = "negativCoins";
            image_lock = "ach_negativeShitcoin_locked.png";
            image_unlock = "ach_negativeShitcoin.png";
        },
        
        boughtAllItems = {
            nameOnPersTable = "shoppingQueen";
            image_lock = "ach_shoppingQueen_locked.png";
            image_unlock = "ach_shoppingQueen.png";
        },
        
        bFishCaughtTotal = {
            nameOnPersTable = "bFishCaugtTotal";
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        },
        sFishCaughtTotal = {
            nameOnPersTable = "sFishCaugtTotal";
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        },
        
        gFishCaughtTotal = {
            nameOnPersTable = "gFishCaugtTotal";
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        },
        
        firstBorderRemoved = {
            nameOnPersTable = "firstBorderRemoved";
            image_lock = "ach_noLvlBorder_locked.png";
            image_unlock = "ach_noLvlBorder.png";
        },
        onlyNegativeFishesCaught = {
            nameOnPersTable = "onlyNegativeFishesCaught";
            image_lock = "ach_negativeShitcoin_locked.png";
            image_unlock = "ach_negativeShitcoin.png";
        },
        
        allPillsAtLeastOnce = {
            nameOnPersTable = "allPillsAtLeastOnce";
            image_lock = "ach_suchti_locked.png";
            image_unlock = "ach_suchti.png";
        },
        
        nothingCaught = {
            nameOnPersTable = "nothingCaught";
            image_lock = "ach_nothingCaught_locked.png";
            image_unlock = "ach_nothingCaught.png";
        },
        
        allLevelBoardersPassed = {
            nameOnPersTable = "allLevelBoardersPassed";
            image_lock = "ach_noLvlBorderInfinity_locked.png";
            image_unlock = "ach_noLvlBorderInfinity.png";
        },
        creditsRed = {
            nameOnPersTable = "creditsRed";
            image_lock = "ach_credits_locked.png";
            image_unlock = "ach_credits.png";
        },
        playedTime = {
            nameOnPersTable = "playedTime";
            image_lock = "ach_playtime_locked.png";
            image_unlock = "ach_playtime.png";
        },
        rageQuit = {
            nameOnPersTable = "rageQuit";
            image_lock = "ach_ragequit_locked.png";
            image_unlock = "ach_ragequit.png";
        },
--        allObjectsAtLeastOnce = {
--            nameOnPersTable = "allObjectsAtLeastOnce";
--            name = "Collector";
--            description = "Every object caught at least once";
--            image_lock = "ach_allFishesAtLeastOnce_locked.png";
--            image_unlock = "ach_allFishesAtLeastOnce.png";
--        },
--        onlyOneCaught = {
--            nameOnPersTable = "onlyOneCaught";
--            name = "I wanted that one";
--            description = "Only one fish caught";
--             image_lock = "ach_onlyOneCaught_locked.png";
--            image_unlock = "ach_onlyOneCaught.png";
--        },
    },
    
    languages = {
        english = {
            language = "english";
            flagImage = "BritishFlag.png";
            package = {
                buttonStart = "Start Game";
                buttonShop = "Shop";
                buttonDictionary = "Dictionary";
                buttonAchievements = "Achievements";
                buttonOptions = "Options";
                buttonCredits = "Credits";
                buttonClose = "Close Game";
                buttonBack = "Back";
                textDepth = "Depth: ";
                buttonReset = "Reset";
                textMusic = "In Game Music:";
                textBGM = "Background Music:";
                buttonRestart = "Restart";
                buttonBTG = "Back to game";
                buttonBTM = "Back to menu";
                textScore = "Your Score:";
                textStart = "Click to start!";
                buttonChangeLevel = "Change level";
                --achievements
                creditsRed = {
                    name = "Respect our Work";
                    description = "Read the credits";
                };
                getFirstObject = {
                    name = "First object";
                    description = "You caught your first object!";
                };
                allLevelBoardersPassed = {
                    name = "The great breakthrough";
                    description = "Pass all boarders in a level";
                };
                nothingCaught = {
                    name = "Misadventure";
                    description = "Don't catch one thing";
                };
                allPillsAtLeastOnce = {
                    name = "Addict";
                    description = "Caught every type of pills";
                };
                onlyNegativeFishesCaught = {
                    name = "Was that on purpose?";
                    description = "Caught only negative objects";
                };
                firstBorderRemoved = {
                    name = "Out of my way";
                    description = "Now I can dive further";
                };
                gFishCaugtTotal = {
                    name = "Godlike Fisher";
                    description = "500 Fishes Total";
                };
                sFishCaugtTotal = {
                    name = "Master Fisher";
                    description = "200 Fishes Total";
                };
                bFishCaugtTotal = {
                    name = "Apprentice Fisher";
                    description = "50 Fishes Total";
                };
                shoppingQueen = {
                    name = "Shopping Queen";
                    description = "You bought all Items in the Shop";
                };
                negativCoins = {
                    name = "You're doing it wrong!";
                    description = "-200 in one Round ... noob";
                };
                gMoneyEarnedTotal = {
                    name = "OVER 9000!";
                    description = "Earned 9000 Coins Total";
                };
                sMoneyEarnedTotal = {
                    name = "Rich Boy";
                    description = "5000 Coins Total";
                };
                bMoneyEarnedTotal = {
                    name = "slumdog millionaire";
                    description = "2000 Coins Total";
                };
                goldCoinsOneRound = {
                    name = "Amazing!";
                    description = "1000 Coins in one Round o.O";
                };
                silverCoinsOneRound = {
                    name = "Your getting better ;)";
                    description = "600 Coins in one Round";
                };
                bronzeCoinsOneRound = {
                    name = "200";
                    description = "200 Coins in one Round";
                };
                bronzeCaughtOneRound = {
                    name = "Nice catch!";
                    description = "Caught more than 10 fishes in a single Round";
                };
                silverCaughtOneRound = {
                    name = "Nicer catch!";
                    description = "Caught more than 20 fishes in a single Round";
                };
                goldCaughtOneRound = {
                    name = "Nicesest catch!";
                    description = "Caught more than 30 fishes in a single Round";
                };
                secondStart = {
                    name = "Welcome again!";
                    description = "It's nice to see you again";
                };
                caughtTwoBoots = {
                    name = "One for each foot";
                    description = "You've got two almost new shoes. At least they used to be new before somebody flushed them down";
                };
                failedStart = {
                    name = "Failed from the beginning";
                    description = "Gratulation! You failed to start the game";
                };

                playedTime = {
                    name = "Play Time";
                    description = "Congratulations! You played over 2 hours";
                },
                rageQuit = {
                    name = "Rage Quit";
                    description = "Quit the game after a short distance";
                },
                getFirstObject = {
                    name = "First object";
                    description = "You caught your first object";
                },
                --objects
                nemo = {
                    name = "Nemo";
                    description = "Seems like you have found nemo";
                },
                turtle = {
                    name = "Turtle";
                    description = "Its house is his shell";
                },
                rat = {
                    name = "rat";
                    description = "Easy to attract with cheese";
                },
                deadFish = {
                    name = "Dead Fish";
                    description = "It was a good fish throughout his whole life";
                },
                angler = {
                    name = "Angler";
                    description = "Very useful if you need some light";
                },
                lollipop = {
                    name = "Lollipop";
                    description = "You know you want it";
                },
                ring = {
                    name = "Ring";
                    description = "One ring to rule them all";
                },
                shoe = {
                    name = "Shoe";
                    description = "One shoe is not enough";
                },
                snake = {
                    name = "Snake";
                    description = "(T)his is a really dangerous snake";
                },
                crocodile = {
                    name = "Crocodile";
                    description = "He just wants to cuddle, I promise";
                },
                sleepingPill = {
                    name = "Sleeping Pill";
                    description = "Makes sea dwellers drowsy";
                },
                squirrel = {
                    name = "Squirrel";
                    description = "Give him a nut and he goes nuts!";
                },
                backpack = {
                    name = "Backpack";
                    description = "Please don't leave your luggage unattended";
                },
                drink = {
                    name = "Drink";
                    description = "Thank god it is sealed";
                },
                egg = {
                    name = "Egg";
                    description = "What kind of animal will hatch from that egg?";
                },
                camera = {
                    name = "Camera";
                    description = "Smile, you are getting photographed";
                },
                canyonSnake = {
                    name = "Canyon Snake";
                    description = "Wow, it managed to catch its own tail";
                },
                cactus = {
                    name = "Cactus";
                    description = "Thinking about giving it a hug?";
                },
                leaf = {
                    name = "Leaf";
                    description = "Leaf it right here please";
                },
                bird = {
                    name = "Bird";
                    description = "It is literally free like a bird";
                },
                balloon = {
                    name = "Ballon";
                    description = "Let it go like your dreams";
                },
                ufo = {
                    name = "Ufo";
                    description = "Wanna get examined?";
                },
                --upgrades
                oneMoreLife = {
                    name = "One more life";--Name shown on the Textfield on the shop
                    description = "add one more life to your healthbar.";--shown on the shop
                },
                twoMoreLife = {
                    name = "Two more life";
                    description = "add a third life to your healthbar.";
                },
                threeMoreLife = {
                    name = "Three more life";
                    description = "upgrade your healthbar up to four lifes.";
                },
                firstSpeedUp = {
                    name = "1st Speed Update";
                    description = "raise your speed.";
                },
                secondSpeedUp = {
                    name = "2nd Speed Update";
                    description = "raise your speed again.";
                },
                moneyMultiplier = {
                    name = "Money Multiplier";
                    description = "the value of your caught object are doubled";
                },
                godMode = {
                    name = "God Mode";
                    description = "unlock godMode";
                },
                mapBreakthrough1 = {
                    name = "Who put this in my way?";
                    description = "Smash that barrier";
                },
                mapBreakthrough2 = {
                    name = "Not again";
                    description = "Smash another barrier";
                },
                moreFuel1 = {
                    name = "Need more Fuel?";
                    description = "Upgrade your Fuel to 1600";
                },
                moreFuel2 = {
                    name = "Need more Fuel?";
                    description = "Upgrade your Fuel to 2400";
                },
                firstPermanentMoneyMult = {
                    name = "Negotiation Novice";
                    description = "earn 20% more money";
                },
                secondPermanentMoneyMult = {
                    name = "Negotiation Expert";
                    description = "earn 25% more money";
                }
            };
        },
        german = {
            language = "german";
            flagImage = "GermanFlag.png";
            package = {
                buttonStart = "Starte Spiel";
                buttonShop = "Shop";
                buttonDictionary = "Lexikon";
                buttonAchievements = "Errungenschaften";
                buttonOptions = "Optionen";
                buttonCredits = "Credits";
                buttonClose = "Spiel beenden";
                buttonBack = "Zurück";
                textDepth = "Tiefe: ";
                buttonReset = "Zurücksetzten";
                textMusic = "In Game Musik:";
                textBGM = "Hintergrund Musik:";
                buttonRestart = "Neustarten";
                buttonBTG = "Zurück zum Spiel";
                buttonBTM = "Zurück zum Menü";
                textScore = "Punktestand:";
                textStart = "Klicken zum Starten!";
                buttonChangeLevel = "Levelauswahl";
                getFirstObject = {
                    name = "Der erste Fang";
                    description = "Du hast den ersten Fang gemacht";
                };
                creditsRed = {
                    name = "Respektiere unsere Arbeit";
                    description = "Lese die Credits";
                };
                allLevelBoardersPassed = {
                    name = "The great breakthrough";
                    description = "Pass all boarders in a level";
                };
                nothingCaught = {
                    name = "DMisadventure";
                    description = "Don't catch one thing";
                };
                allPillsAtLeastOnce = {
                    name = "DAddict";
                    description = "Caught every type of pills";
                };
                onlyNegativeFishesCaught = {
                    name = "DWas that on purpose?";
                    description = "Caught only negative objects";
                };
                firstBorderRemoved = {
                    name = "DOut of my way";
                    description = "Now I can dive further";
                };
                gFishCaugtTotal = {
                    name = "DGodlike Fisher";
                    description = "500 Fishes Total";
                };
                sFishCaugtTotal = {
                    name = "DMaster Fisher";
                    description = "200 Fishes Total";
                };
                bFishCaugtTotal = {
                    name = "DApprentice Fisher";
                    description = "50 Fishes Total";
                };
                shoppingQueen = {
                    name = "DShopping Queen";
                    description = "You bought all Items in the Shop";
                };
                negativCoins = {
                    name = "DYou're doing it wrong!";
                    description = "-200 in one Round ... noob";
                };
                gMoneyEarnedTotal = {
                    name = "DOVER 9000!";
                    description = "Earned 9000 Coins Total";
                };
                sMoneyEarnedTotal = {
                    name = "DRich Boy";
                    description = "5000 Coins Total";
                };
                bMoneyEarnedTotal = {
                    name = "Dslumdog millionaire";
                    description = "2000 Coins Total";
                };
                goldCoinsOneRound = {
                    name = "DAmazing!";
                    description = "1000 Coins in one Round o.O";
                };
                silverCoinsOneRound = {
                    name = "DYour getting better ;)";
                    description = "600 Coins in one Round";
                };
                bronzeCoinsOneRound = {
                    name = "D200";
                    description = "200 Coins in one Round";
                };
                bronzeCaughtOneRound = {
                    name = "DNice catch!";
                    description = "Caught more than 10 fishes in a single Round";
                };
                silverCaughtOneRound = {
                    name = "DNicer catch!";
                    description = "Caught more than 20 fishes in a single Round";
                };
                goldCaughtOneRound = {
                    name = "DNicesest catch!";
                    description = "Caught more than 30 fishes in a single Round";
                };
                secondStart = {
                    name = "DWelcome again!";
                    description = "It's nice to see you again";
                };
                caughtTwoBoots = {
                    name = "DOne for each foot";
                    description = "You've got two almost new shoes. At least they used to be new before somebody flushed them down";
                };
                failedStart = {
                    name = "DFailed from the beginning";
                    description = "Gratulation! You failed to start the game";
                };

                playedTime = {
                    name = "DPlay Time";
                    description = "Congratulations! You played over 2 hours";
                },
                rageQuit = {
                    name = "Rage Quit";
                    description = "Quit the game after a short distance";
                },
                nemo = {
                    name = "Nemo";
                    description = "Anscheinend hast du Nemo gefunden";
                },
                turtle = {
                    name = "Schildkröte";
                    description = "Sein Panzer ist sein Haus";
                },
                rat = {
                    name = "Ratte";
                    description = "Lässt sich leicht mit Käse anlocken";
                },
                deadFish = {
                    name = "Toter Fisch";
                    description = "Er war zu Lebzeiten ein guter Fisch";
                },
                angler = {
                    name = "Anglerfisch";
                    description = "Sehr nützlich, wenn du eine Lichtquelle benötigst";
                },
                lollipop = {
                    name = "Lutscher";
                    description = "Du weißt du willst ihn";
                },
                ring = {
                    name = "Ring";
                    description = "Ein Ring um über alle zu herrschen";
                },
                shoe = {
                    name = "Schuh";
                    description = "Ein Schuh reicht nicht aus";
                },
                snake = {
                    name = "Schlange";
                    description = "Eine sehr gefährliche Schlange";
                },
                crocodile = {
                    name = "Krokodil";
                    description = "Er will nur kuscheln, versprochen!";
                },
                sleepingPill = {
                    name = "Schlafpille";
                    description = "Macht Meeresbewohner schläfrig";
                },
                squirrel = {
                    name = "Eichhörnchen";
                    description = "Gib ihm eine Nuss und er flippt aus";
                },
                backpack = {
                    name = "Rucksack";
                    description = "Bitte lassen Sie Ihr Reisegepäck nicht unbeaufsichtigt";
                },
                drink = {
                    name = "Getränk";
                    description = "Zum Glück ist es versiegelt";
                },
                egg = {
                    name = "Ei";
                    description = "Welches Tier wird wohl aus diesem Ei schlüpfen?";
                },
                camera = {
                    name = "Kamera";
                    description = "Lächle, du wirst gerade fotografiert";
                },
                canyonSnake = {
                    name = "Canyon Schlange";
                    description = "Beeindruckend, sie hat ihren eigenen Schwanz gefangen";
                },
                cactus = {
                    name = "Kaktus";
                    description = "Möchtest du ihn vielleicht umarmen?";
                },
                leaf = {
                    name = "Blatt";
                    description = "Mitnahme nicht gestattet";
                },
                bird = {
                    name = "Vogel";
                    description = "Er ist tatsächlich frei wie ein Vogel";
                },
                balloon = {
                    name = "Luftballon";
                    description = "Lass ihn mit deinen Träumen aufsteigen";
                },
                ufo = {
                    name = "Ufo";
                    description = "Willst du verhört werden?";
                },
                --upgrades
                oneMoreLife = {
                    name = "One more life";--Name shown on the Textfield on the shop
                    description = "add one more life to your healthbar.";--shown on the shop
                },
                twoMoreLife = {
                    name = "Two more life";
                    description = "add a third life to your healthbar.";
                },
                threeMoreLife = {
                    name = "Three more life";
                    description = "upgrade your healthbar up to four lifes.";
                },
                firstSpeedUp = {
                    name = "1st Speed Update";
                    description = "raise your speed.";
                },
                secondSpeedUp = {
                    name = "2nd Speed Update";
                    description = "raise your speed again.";
                },
                moneyMultiplier = {
                    name = "Money Multiplier";
                    description = "the value of your caught object are doubled";
                },
                godMode = {
                    name = "God Mode";
                    description = "unlock godMode";
                },
                mapBreakthrough1 = {
                    name = "Who put this in my way?";
                    description = "Smash that barrier";
                },
                mapBreakthrough2 = {
                    name = "Not again";
                    description = "Smash another barrier";
                },
                moreFuel1 = {
                    name = "Need more Fuel?";
                    description = "Upgrade your Fuel to 1600";
                },
                moreFuel2 = {
                    name = "Need more Fuel?";
                    description = "Upgrade your Fuel to 2400";
                },
                firstPermanentMoneyMult = {
                    name = "Negotiation Novice";
                    description = "earn 20% more money";
                },
                secondPermanentMoneyMult = {
                    name = "Negotiation Expert";
                    description = "earn 25% more money";
                }
            }
        },
        
    },
    
    android = {
        maxTilt = .3;
    }
}
