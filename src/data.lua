return {
    --- Data for the fishable objects
    fishableObjects = {
        nemo = {
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
            description = "Nemo´s description";    --Description of the object. shown in the dictionary
            -- definition of the hitbox
            hitbox = {
                {
                    width = 40,       -- Hitbox width
                    height = 30,       -- Hitbox height
                    deltaXPos= 12,   -- The hitbox X adjustment 
                    deltaYPos = 17   -- The hitbox Y adjustment 
                }
            }
        },
        
        turtle = {
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
            hitpoints = 5,        
            value = -10,
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
            hitpoints = 5,        
            value = 20,
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
            hitpoints = 20,        
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
            hitpoints = 5,        
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
                }
            }
        },

        ring = {
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
            hitpoints = 20,        
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
            hitpoints = 20,        
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
            hitpoints = 60,        
            value = 60,
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
            hitpoints = 0,        
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
            minSpeed = 3,
            maxSpeed = 8,
            hitpoints = 20,        
            value = 50,
            minAmount = 1,
            maxAmount = 5,
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
            hitpoints = 50,        
            value = 100,
            minAmount = 1,
            maxAmount = 3,
            swarmHeight = 500,
            enabled = true,
            description = "A nice backpack someone seems to have lost";
            hitbox = {
                {
                    width = 50,
                    height = 56,
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
            hitpoints = 20,        
            value = 30,
            minAmount = 0,
            maxAmount = 1,
            swarmHeight = 100,
            enabled = true,
            description = "A delicious drink";
            hitbox = {
                {
                    width = 22,
                    height = 10,
                    deltaXPos = 10,
                    deltaYPos = 3
                },
                {
                    width = 44,
                    height = 20,
                    deltaXPos = 8,
                    deltaYPos = 20
                },
                {
                    width = 30,
                    height = 20,
                    deltaXPos = 16,
                    deltaYPos = 40
                }
            }
        },
        
        egg = {
            name = "egg",
            image = "egg.png",
            spriteSize = 64,
            minSpeed = 0,
            maxSpeed = 0,
            hitpoints = 50,        
            value = 80,
            minAmount = 1,
            maxAmount = 5,
            swarmHeight = 50,
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
            hitpoints = 20,        
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
            hitpoints = 10,        
            value = 40,
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
            hitpoints = 50,        
            value = -30,
            minAmount = 3,
            maxAmount = 8,
            swarmHeight = 200,
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
            maxSpeed = 5,
            hitpoints = -10,        
            value = 20,
            minAmount = 3,
            maxAmount = 10,
            swarmHeight = 20,
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
            hitpoints = 10,        
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
            maxSpeed = 5,
            hitpoints = 5,        
            value = -5,
            minAmount = 1,
            maxAmount = 10,
            swarmHeight = 300,
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
            hitpoints = 100,        
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
            fishablesProbability = { 5, 30, 55, 90, 100}, --(3, 25, 25, 35, 10)
            maxSwarmHeight = 9000
        }
    },

    --- Date for all upgrades
    upgrades = {
        oneMoreLife = {
            nameOnPersTable = "moreLife";--Name of parameter in persTable. Unlock change this parameter to true
            name = "One more life";--Name shown on the Textfield on the shop
            description = "add one more life to your healthbar.";--shown on the shop
            price = 100;--price of this item
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        twoMoreLife = {
            nameOnPersTable = "moreLife";
            name = "Two more life";
            description = "add a third life to your healthbar.";
            price = 200;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        },
        threeMoreLife = {
            nameOnPersTable = "moreLife";
            name = "Three more life";
            description = "upgrade your healthbar up to four lifes.";
            price = 300;
            image = "gui_Test_klickableElement.png";
            image_disable = "gui_Test_klickableElement_disable.png";
        }
        --[[
        oneMoreLife = {
            nameOnPersTable = "oneMoreLife";--Name of parameter in persTable. Unlock change this parameter to true
            name = "One more life";--Name shown on the Textfield on the shop
            description = "add one more life to your healthbar.";--shown on the shop
            price = 100;--price of this item
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },
        twoMoreLife = {
            nameOnPersTable = "twoMoreLife";
            name = "Two more life";
            description = "add a third life to your healthbar.";
            price = 200;
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },
        threeMoreLife = {
            nameOnPersTable = "threeMoreLife";
            name = "Three more life";
            description = "upgrade your healthbar up to four lifes.";
            price = 300;
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },
        firstSpeedUp = {
            nameOnPersTable = "firstSpeedUp";
            name = "1st Speed Update";
            description = "raise your speed.";
            price = 300;
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },
        secondSpeedUp = {
            nameOnPersTable = "secondSpeedUp";
            name = "2nd Speed Update";
            description = "raise your speed again.";
            price = 300;
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },
        moneyMulitplier = {
            nameOnPersTable = "moneyMultiplier";
            name = "Money Multiplier";
            description = "the value of your caught object are multiplied by 2.5.";
            price = 300;
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },
        godMode = {
            nameOnPersTable = "godMode";
            name = "God Mode";
            description = "unlock godMode";
            price = 300;
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },
        mapBreakthrough1 = {
            nameOnPersTable = "mapBreakthrough1";
            name = "MB1";
            description = "blablabla";
            price = 300;
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },
        mapBreakthrough2 = {
            nameOnPersTable = "mapBreakthrough2";
            name = "MB2";
            description = "blablabla";
            price = 300;
            image = "assets/gui/gui_Test_klickableElement.png";
            image_disable = "assets/gui/gui_Test_klickableElement_disable.png";
        },]]--
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
    },
    
    languages = {
        english = {
            language = "english";
            flagImage = "BritishFlag.png";
        },
        german = {
            language = "german";
            flagImage = "GermanFlag.png";
        },
        
    },
    
    android = {
        maxTilt = .3;
    }
}
