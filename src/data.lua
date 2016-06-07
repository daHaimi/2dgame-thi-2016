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
            animType = Animate.AnimType.bounce,
            
            minAmount = 3,         -- min amount of objects per swarm
            maxAmount = 5,         -- max amount of objects per swarm
            swarmHeight = 300,     -- height of the swarm of this object
            enabled = true,        -- Whether the object is enabled
            
            -- Description of the object. Shown in the dictionary
            description = "Nemo´s description";    
            
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
            animType = Animate.AnimType.bounce,
            minAmount = 2,
            maxAmount = 4,
            swarmHeight = 225,
            enabled = true,
            description = "Turtle´s description";
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
            animType = Animate.AnimType.bounce,
            minAmount = 3,
            maxAmount = 3,
            swarmHeight = 350,
            enabled = true,
            description = "Rat´s description";
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
            description = "deadFish´s description";
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
            animType = Animate.AnimType.bounce,
            value = 40,
            minAmount = 1,
            maxAmount = 4,
            swarmHeight = 200,
            enabled = true,
            description = "Angler´s description";
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
            description = "Lollipop´s description";
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
            description = "Ring´s description";
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
            description = "Shoe´s description";
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
            description = "Snake´s description";
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
            description = "Crododile´s description";
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
            description = "SleepingPill´s description";
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
            minAmount = 1,
            maxAmount = 2,
            swarmHeight = 300,
            enabled = true,
            description = "Squirrel´s description";
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
            value = 100,
            minAmount = 1,
            maxAmount = 3,
            swarmHeight = 200,
            enabled = true,
            description = "A nice backpack someone seems to have lost";
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
            value = 30,
            minAmount = 0,
            maxAmount = 1,
            swarmHeight = 100,
            enabled = true,
            description = "A delicious drink";
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
            description = "A dinosaur egg. Better sell it fast";
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
            value = 100,
            minAmount = 1,
            maxAmount = 1,
            swarmHeight = 100,
            enabled = true,
            description = "High-Tech 40 MP Camera";
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
            description = "Canyon Snake´s description";
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
            minAmount = 1,
            maxAmount = 2,
            swarmHeight = 100,
            enabled = true,
            description = "Very prickly";
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
            maxSpeed = 4,
            value = 20,
            minAmount = 2,
            maxAmount = 3,
            swarmHeight = 150,
            enabled = true,
            description = "Simply leaf";
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
            maxSpeed = 8,
            value = 20,
            minAmount = 1,
            maxAmount = 6,
            swarmHeight = 200,
            enabled = true,
            description = "A hungry bird";
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
            description = "A balloon";
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
            description = "A mysterious UFO";
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
        }
    },

    --- Data for the swarms for each level
    swarmsSewer = {
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
            fishablesProbability = { 5, 30, 55, 90, 100},
            maxSwarmHeight = 9000
        }
    },
    
    swarmsCanyon = {
        {
            allowedFishables = { "balloon", "camera", "drink", "egg", "sleepingPill"},
            fishablesProbability = {25, 45, 75, 95, 100}, 
            maxSwarmHeight = 3000
        },
        {
            allowedFishables = { "balloon", "cactus", "leaf", "canyonSnake", "sleepingPill"},
            fishablesProbability = {25, 45, 75, 95, 100}, 
            maxSwarmHeight = 6000
        },
        {
            allowedFishables = { "backpack", "balloon", "bird", "squirrel", "sleepingPill"},
            fishablesProbability = {25, 45, 75, 95, 100}, 
            maxSwarmHeight = 9000
        }
    },

    --- Data for all upgrades
    upgrades = {
        oneMoreLife = {
            nameOnPersTable = "oneMoreLife";--Name of parameter in persTable. Unlock change this parameter to true
            name = "One more life";--Name shown on the Textfield on the shop
            description = "add one more life to your healthbar.";--shown on the shop
            price = 500;--price of this item
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        twoMoreLife = {
            nameOnPersTable = "twoMoreLife";
            name = "Two more life";
            description = "add a third life to your healthbar.";
            price = 1000;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        threeMoreLife = {
            nameOnPersTable = "threeMoreLife";
            name = "Three more life";
            description = "upgrade your healthbar up to four lifes.";
            price = 1500;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        firstSpeedUp = {
            nameOnPersTable = "firstSpeedUp";
            name = "1st Speed Update";
            description = "raise your speed.";
            price = 300;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        secondSpeedUp = {
            nameOnPersTable = "secondSpeedUp";
            name = "2nd Speed Update";
            description = "raise your speed again.";
            price = 300;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        moneyMulitplier = {
            nameOnPersTable = "moneyMultiplier";
            name = "Money Multiplier";
            description = "the value of your caught object are doubled";
            price = 300;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        godMode = {
            nameOnPersTable = "godMode";
            name = "God Mode";
            description = "unlock godMode";
            price = 1000;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        mapBreakthrough1 = {
            nameOnPersTable = "mapBreakthrough1";
            name = "Who put this in my way?";
            description = "Smash that barrier";
            price = 2500;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        mapBreakthrough2 = {
            nameOnPersTable = "mapBreakthrough2";
            name = "Not again";
            description = "Smash another barrier";
            price = 5000;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        moreFuel1 = {
            nameOnPersTable = "moreFuel1";
            name = "Need more Fuel?";
            description = "Upgrade your Fuel to 1600";
            price = 1000;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        moreFuel2 = {
            nameOnPersTable = "moreFuel2";
            name = "Need more Fuel?";
            description = "Upgrade your Fuel to 2400";
            price = 1500;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        firstPermanentMoneyMulitplier = {
            nameOnPersTable = "firstPermanentMoneyMult";
            name = "Negotiation Novice";
            description = "earn 20% more money";
            price = 1000;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        secondPermanentMoneyMulitplier = {
            nameOnPersTable = "secondPermanentMoneyMult";
            name = "Negotiation Expert";
            description = "earn 25% more money";
            price = 2500;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
    },
    
    achievements = {
        getFirtsObject = {
            nameOnPersTable = "getFirstObject";
            name = "First object";
            description = "You caught your first object";
            image_lock = "gui_Test_klickableElement_disable.png";
            image_unlock = "gui_Test_klickableElement.png";
        },
        getSecondObject = {
            nameOnPersTable = "getSecondObject";
            name = "Second object";
            description = "You caught your second object";
            image_lock = "gui_Test_klickableElement_disable.png";
            image_unlock = "gui_Test_klickableElement.png";
        },
        failedStart = {
            nameOnPersTable = "failedStart";
            name = "Failed from the beginning";
            description = "Gratulation! You failed to start the game";
            image_lock = "ach_drop_hamster_locked.png";
            image_unlock = "ach_drop_hamster.png";
        },
        caughtTwoBoots = {
            nameOnPersTable = "caughtTwoBoots";
            name = "One for each foot";
            description = "You've got two almost new shoes. At least they used to be new before somebody flushed them down";
            image_lock = "gui_Test_klickableElement_disable.png";
            image_unlock = "ach_two_shoes.png";
        },
        secondStart = {
            nameOnPersTable = "secondStart";
            name = "Welcome again!";
            description = "It's nice to see you again";
            image_lock = "ach_secondTimeGame_locked.png";
            image_unlock = "ach_secondTimeGame.png";
        },
        bronzeCaughtOneRound = {
            nameOnPersTable = "bronzeCaughtOneRound";
            name = "Nice catch!";
            description = "Caught more than 10 fishes in a single Round";
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRoundBronze.png";
        },
        silverCaughtOneRound = {
            nameOnPersTable = "silverCaughtOneRound";
            name = "Nicer catch!";
            description = "Caught more than 20 fishes in a single Round";
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRound.png";
        },
        goldCaughtOneRound = {
            nameOnPersTable = "goldCaughtOneRound";
            name = "Nicesest catch!";
            description = "Caught more than 30 fishes in a single Round";
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRoundGold.png";
        },
        
        bronzeCoinsOneRound = {
            nameOnPersTable = "bronzeCoinsOneRound";
            name = "200";
            description = "200 Coins in one Round";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        silverCoinsOneRound = {
            nameOnPersTable = "silverCoinsOneRound";
            name = "Your getting better ;)";
            description = "600 Coins in one Round";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        goldCoinsOneRound = {
            nameOnPersTable = "goldCoinsOneRound";
            name = "Amazing!";
            description = "1000 Coins in one Round o.O";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        bMoneyEarnedTotal = {
            nameOnPersTable = "bMoneyEarnedTotal";
            name = "slumdog millionaire";
            description = "2000 Coins Total";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        sMoneyEarnedTotal = {
            nameOnPersTable = "sMoneyEarnedTotal";
            name = "Rich Boy";
            description = "5000 Coins Total";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        
        gMoneyEarnedTotal = {
            nameOnPersTable = "gMoneyEarnedTotal";
            name = "OVER 9000!";
            description = "Earned 9000 Coins Total";
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        },
        negativCoins = {
            nameOnPersTable = "negativCoins";
            name = "Your doing it wrong!";
            description = "-200 in one Round ... noob";
            image_lock = "ach_negativeShitcoin_locked.png";
            image_unlock = "ach_negativeShitcoin.png";
        },
        
        boughtAllItems = {
            nameOnPersTable = "shoppingQueen";
            name = "Shopping Queen";
            description = "You bought all Items in the Shop";
            image_lock = "ach_shoppingQueen_locked.png";
            image_unlock = "ach_shoppingQueen.png";
        },
        
        bFishCaughtTotal = {
            nameOnPersTable = "bFishCaugtTotal";
            name = "Apprentice Fisher";
            description = "50 Fishes Total";
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        },
        sFishCaughtTotal = {
            nameOnPersTable = "sFishCaugtTotal";
            name = "Master Fisher";
            description = "200 Fishes Total";
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        },
        gFishCaughtTotal = {
            nameOnPersTable = "gFishCaugtTotal";
            name = "Godlike Fisher";
            description = "500 Fishes Total";
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        },
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
                buttonClose = "Close Game"
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
                buttonClose = "Spiel beenden"
            };
        },
        
    },
    
    android = {
        maxTilt = .3;
    }
}
