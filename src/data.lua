return {
    --- Data for the fishable objects
    fishableObjects = {
        nemo = {
            -- definition of the object
            name = "nemo"; -- The name
            image = "nemo.png"; -- The image file
            sortNumber = 4; --needed to sort objects
            spriteSize = 64; -- width of the image
            minSpeed = 4; -- Min movement speed
            maxSpeed = 7; -- Max movement speed
            value = 30; -- The worth of the object
            animTimeoutMin = 0.1; -- The min animation timeout
            animTimeoutMax = 0.15; -- The max animation timeout

            -- The animation type of the enum Animate.AnimType
            animType = "bounce";
            minAmount = 3; -- min amount of objects per swarm
            maxAmount = 5; -- max amount of objects per swarm
            swarmHeight = 300; -- height of the swarm of this object
            enabled = true; -- Whether the object is enabled

            -- Definition of the hitbox
            hitbox = {
                {
                    width = 40; -- Hitbox width
                    height = 30; -- Hitbox height
                    deltaXPos = 12; -- The hitbox X adjustment 
                    deltaYPos = 17; -- The hitbox Y adjustment
                }
            };
        };
        turtle = {
            name = "turtle";
            image = "turtle.png";
            sortNumber = 3;
            spriteSize = 64;
            minSpeed = 1;
            maxSpeed = 2;
            value = 30;
            animTimeoutMin = 0.15;
            animTimeoutMax = 0.25;
            animType = "bounce";
            minAmount = 2;
            maxAmount = 4;
            swarmHeight = 225;
            enabled = true;
            hitbox = {
                {
                    width = 50;
                    height = 30;
                    deltaXPos = 5;
                    deltaYPos = 17;
                }
            };
        };
        rat = {
            name = "rat";
            image = "rat.png";
            sortNumber = 1;
            spriteSize = 64;
            minSpeed = 3;
            maxSpeed = 4;
            value = -10;
            animTimeoutMin = 0.08;
            animTimeoutMax = 0.15;
            animType = "bounce";
            minAmount = 3;
            maxAmount = 3;
            swarmHeight = 350;
            enabled = true;
            hitbox = {
                {
                    width = 60;
                    height = 25;
                    deltaXPos = 2;
                    deltaYPos = 25;
                }
            };
        };
        deadFish = {
            name = "deadFish";
            image = "deadFish.png";
            sortNumber = 2;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 1;
            value = 20;
            animTimeoutMin = 0.2;
            animTimeoutMax = 0.3;
            minAmount = 1;
            maxAmount = 2;
            swarmHeight = 125;
            enabled = true;
            hitbox = {
                {
                    width = 64;
                    height = 25;
                    deltaXPos = 0;
                    deltaYPos = 20;
                }
            };
        };
        angler = {
            name = "angler";
            image = "angler.png";
            sortNumber = 5;
            spriteSize = 64;
            minSpeed = 1;
            maxSpeed = 5;
            animTimeoutMin = 0.15;
            animTimeoutMax = 0.2;
            animType = "bounce";
            value = 40;
            minAmount = 1;
            maxAmount = 4;
            swarmHeight = 200;
            enabled = true;
            hitbox = {
                {
                    width = 40;
                    height = 40;
                    deltaXPos = 12;
                    deltaYPos = 12;
                }
            };
        };
        lollipop = {
            name = "lollipop";
            image = "lolli.png";
            sortNumber = 9;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 2;
            value = 10;
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 100;
            enabled = true;
            hitbox = {
                {
                    width = 30;
                    height = 30;
                    deltaXPos = 17;
                    deltaYPos = 2;
                },
                {
                    width = 6;
                    height = 40;
                    deltaXPos = 29;
                    deltaYPos = 24;
                }
            };
        };
        ring = {
            name = "ring";
            image = "ring.png";
            sortNumber = 10;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 5;
            value = 100;
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 100;
            hitbox = {
                {
                    width = 40;
                    height = 58;
                    deltaXPos = 12;
                    deltaYPos = 2;
                }
            };
        };
        shoe = {
            name = "shoe";
            image = "shoe.png";
            sortNumber = 6;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 0;
            value = -20;
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 100;
            enabled = true;
            hitbox = {
                {
                    width = 55;
                    height = 17;
                    deltaXPos = 2;
                    deltaYPos = 43;
                },
                {
                    width = 30;
                    height = 56;
                    deltaXPos = 25;
                    deltaYPos = 4;
                }
            };
        };
        snake = {
            name = "snake";
            image = "snake.png";
            sortNumber = 7;
            spriteSize = 64;
            minSpeed = 2;
            maxSpeed = 5;
            animTimeoutMin = 0.15;
            animTimeoutMax = 0.25;
            value = 50;
            minAmount = 2;
            maxAmount = 3;
            swarmHeight = 200;
            enabled = true;
            hitbox = {
                {
                    width = 54;
                    height = 56;
                    deltaXPos = 5;
                    deltaYPos = 4;
                }
            };
        };
        crocodile = {
            name = "crocodile";
            image = "crocodile.png";
            sortNumber = 8;
            spriteSize = 128;
            minSpeed = 1;
            maxSpeed = 5;
            value = 60;
            animTimeoutMin = 0.8;
            animTimeoutMax = 1;
            minAmount = 1;
            maxAmount = 3;
            swarmHeight = 200;
            enabled = true;
            hitbox = {
                {
                    width = 128;
                    height = 10;
                    deltaXPos = 0;
                    deltaYPos = 40;
                }
            };
        };
        sleepingCrocodile = {
            name = "sleepingCrocodile";
            image = "crocodile.png";
            spriteSize = 128;
            minSpeed = 0;
            maxSpeed = 0;
            value = 5;
            animTimeoutMin = 0.8;
            animTimeoutMax = 1;
            minAmount = 3;
            maxAmount = 4;
            swarmHeight = 250;
            enabled = true;
            hitbox = {
                {
                    width = 128;
                    height = 10;
                    deltaXPos = 0;
                    deltaYPos = 40;
                }
            };
        };
        sleepingPill = {
            name = "sleepingPill";
            image = "pill.png";
            spriteSize = 32;
            minSpeed = 0;
            maxSpeed = 0;
            value = 0;
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 50;
            hitbox = {
                {
                    width = 15;
                    height = 15;
                    deltaXPos = 1;
                    deltaYPos = 1;
                },
                {
                    width = 15;
                    height = 15;
                    deltaXPos = 8;
                    deltaYPos = 8;
                },
                {
                    width = 15;
                    height = 15;
                    deltaXPos = 15;
                    deltaYPos = 15;
                }
            };
        };        
        rainbowPill = {
            name = "rainbowPill";
            image = "rainbowPill.png";
            spriteSize = 32;
            minSpeed = 0;
            maxSpeed = 0;
            value = 0;
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 50;
            hitbox = {
                {
                    width = 20;
                    height = 20;
                    deltaXPos = 6;
                    deltaYPos = 6;
                }
            };
        };
        coffee = {
            name = "coffee";
            image = "coffee.png";
            spriteSize = 32;
            minSpeed = 0;
            maxSpeed = 0;
            value = 0;
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 50;
            hitbox = {
                {
                    width = 26;
                    height = 10;
                    deltaXPos = 3;
                    deltaYPos = 11;
                }
            };
        };
        squirrel = {
            name = "squirrel";
            image = "squirrel.png";
            sortNumber = 11;
            spriteSize = 64;
            minSpeed = 4;
            maxSpeed = 6;
            value = 50;
            animTimeoutMin = 0.15;
            animTimeoutMax = 0.17;
            animType = "bounce";
            minAmount = 1;
            maxAmount = 2;
            swarmHeight = 200;
            enabled = true;
            hitbox = {
                {
                    width = 62;
                    height = 0;
                    deltaXPos = 2;
                    deltaYPos = 0;
                };
                {
                    width = 15;
                    height = 34;
                    deltaXPos = 49;
                    deltaYPos = 0;
                };
                {
                    width = 46;
                    height = 64;
                    deltaXPos = 2;
                    deltaYPos = 0;
                }
            };
        };
        crazySquirrel = {
            name = "crazySquirrel";
            image = "squirrel.png";
            spriteSize = 64;
            minSpeed = 6;
            maxSpeed = 8;
            value = 50;
            animTimeoutMin = 0.15;
            animTimeoutMax = 0.17;
            animType = "bounce";
            minAmount = 1;
            maxAmount = 2;
            swarmHeight = 200;
            enabled = true;
            hitbox = {
                {
                    width = 62;
                    height = 0;
                    deltaXPos = 2;
                    deltaYPos = 0;
                };
                {
                    width = 15;
                    height = 34;
                    deltaXPos = 49;
                    deltaYPos = 0;
                };
                {
                    width = 46;
                    height = 64;
                    deltaXPos = 2;
                    deltaYPos = 0;
                }
            };
        };
        backpack = {
            name = "backpack";
            image = "backpack.png";
            sortNumber = 12;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 0;
            downSpeed = 7;
            value = -100;
            minAmount = 1;
            maxAmount = 0;
            swarmHeight = 50;
            enabled = true;
            hitbox = {
                {
                    width = 52;
                    height = 54;
                    deltaXPos = 6;
                    deltaYPos = 6;
                }
            };
        };
        drink = {
            name = "drink";
            image = "drink.png";
            sortNumber = 12;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 0;
            downSpeed = 6;
            value = -30;
            animTimeoutMin = 0.2;
            animTimeoutMax = 0.4;
            animType = "bounce";
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 50;
            enabled = true;
            hitbox = {
                {
                    width = 49;
                    height = 17;
                    deltaXPos = 9;
                    deltaYPos = 13;
                },
                {
                    width = 36;
                    height = 19;
                    deltaXPos = 16;
                    deltaYPos = 30;
                },
                {
                    width = 23;
                    height = 10;
                    deltaXPos = 22;
                    deltaYPos = 49;
                }
            };
        };
        egg = {
            name = "egg";
            image = "egg.png";
            sortNumber = 14;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 0;
            value = 80;
            minAmount = 1;
            maxAmount = 3;
            swarmHeight = 100;
            enabled = true;
            hitbox = {
                {
                    width = 22;
                    height = 10;
                    deltaXPos = 22;
                    deltaYPos = 10;
                },
                {
                    width = 42;
                    height = 36;
                    deltaXPos = 12;
                    deltaYPos = 20;
                }
            };
        };
        camera = {
            name = "camera";
            image = "camera.png";
            sortNumber = 15;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 0;
            downSpeed = 5;
            value = -100;
            animTimeoutMin = 0.15;
            animTimeoutMax = 0.2;
            animType = "bounce";
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 50;
            enabled = true;
            hitbox = {
                {
                    width = 10;
                    height = 8;
                    deltaXPos = 47;
                    deltaYPos = 9;
                },
                {
                    width = 60;
                    height = 38;
                    deltaXPos = 2;
                    deltaYPos = 16;
                }
            };
        };
        canyonSnake = {
            name = "canyonSnake";
            image = "canyon_snake.png";
            sortNumber = 16;
            spriteSize = 64;
            minSpeed = 1;
            maxSpeed = 4;
            value = 40;
            animTimeoutMin = 0.3;
            animTimeoutMax = 0.5;
            minAmount = 1;
            maxAmount = 3;
            swarmHeight = 200;
            enabled = true;
            hitbox = {
                {
                    width = 54;
                    height = 56;
                    deltaXPos = 5;
                    deltaYPos = 4;
                }
            };
        };
        cactus = {
            name = "cactus";
            image = "cactus.png";
            sortNumber = 17;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 0;
            value = -30;
            animTimeoutMin = 0.3;
            animTimeoutMax = 0.5;
            animType = "bounce";
            minAmount = 2;
            maxAmount = 2;
            swarmHeight = 150;
            enabled = true;
            hitbox = {
                {
                    width = 16;
                    height = 54;
                    deltaXPos = 28;
                    deltaYPos = 2;
                },
                {
                    width = 36;
                    height = 10;
                    deltaXPos = 17;
                    deltaYPos = 54;
                },
                {
                    width = 10;
                    height = 14;
                    deltaXPos = 11;
                    deltaYPos = 15;
                },
                {
                    width = 10;
                    height = 14;
                    deltaXPos = 48;
                    deltaYPos = 13;
                }
            };
        };
        leaf = {
            name = "leaf";
            image = "leaf.png";
            sortNumber = 18;
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 2;
            value = 20;
            animTimeoutMin = 0.25;
            animTimeoutMax = 0.3;
            animType = "bounce";
            minAmount = 2;
            maxAmount = 3;
            swarmHeight = 150;
            enabled = true;
            hitbox = {
                {
                    width = 3;
                    height = 10;
                    deltaXPos = 60;
                    deltaYPos = 10;
                },
                {
                    width = 46;
                    height = 20;
                    deltaXPos = 4;
                    deltaYPos = 38;
                },
                {
                    width = 44;
                    height = 20;
                    deltaXPos = 14;
                    deltaYPos = 20;
                }
            };
        };
        bird = {
            name = "bird";
            image = "bird.png";
            sortNumber = 19;
            spriteSize = 64;
            minSpeed = 2;
            maxSpeed = 4;
            value = 20;
            animTimeoutMin = 0.1;
            animTimeoutMax = 0.15;
            animType = "bounce";
            minAmount = 1;
            maxAmount = 3;
            swarmHeight = 250;
            enabled = true;
            hitbox = {
                {
                    width = 60;
                    height = 14;
                    deltaXPos = 2;
                    deltaYPos = 8;
                },
                {
                    width = 22;
                    height = 22;
                    deltaXPos = 18;
                    deltaYPos = 22;
                },
                {
                    width = 10;
                    height = 14;
                    deltaXPos = 30;
                    deltaYPos = 44;
                }
            };
        };
        balloon = {
            name = "balloon";
            image = "balloon.png";
            sortNumber = 13;
            spriteSize = 64;
            minSpeed = 2;
            maxSpeed = 4;
            value = 10;
            minAmount = 2;
            maxAmount = 3;
            swarmHeight = 200;
            enabled = true;
            hitbox = {
                {
                    width = 20;
                    height = 40;
                    deltaXPos = 22;
                    deltaYPos = 4;
                },
                {
                    width = 30;
                    height = 14;
                    deltaXPos = 18;
                    deltaYPos = 14;
                },
                {
                    width = 6;
                    height = 20;
                    deltaXPos = 34;
                    deltaYPos = 44;
                }
            };
        };
        ufo = {
            name = "ufo";
            image = "ufo.png";
            sortNumber = 20;
            spriteSize = 64;
            minSpeed = 1;
            maxSpeed = 4;
            value = 60;
            minAmount = 1;
            maxAmount = 1;
            swarmHeight = 100;
            enabled = true;
            hitbox = {
                {
                    width = 30;
                    height = 14;
                    deltaXPos = 18;
                    deltaYPos = 10;
                },
                {
                    width = 58;
                    height = 16;
                    deltaXPos = 3;
                    deltaYPos = 24;
                },
                {
                    width = 37;
                    height = 22;
                    deltaXPos = 14;
                    deltaYPos = 40;
                }
            };
        };
        bubble = {
            name = "bubble";
            image = "bubble.png";
            spriteSize = 64;
            minSpeed = 0;
            maxSpeed = 0;
            downSpeed = -10;
            value = 0;
            minAmount = 3;
            maxAmount = 5;
            swarmHeight = 0;
            hitbox = {
                {
                    width = 0;
                    height = 0;
                    deltaXPos = 0;
                    deltaYPos = 0;
                }
            };
        };
    };

    --- Data for the swarms for each level
    swarmsSewer = {
        {
            -- Fishables allowed to appear in this swarm 
            allowedFishables = { "turtle"; "rat"; "deadFish" };

            -- The odds of allowedFishables allready added up(10; 40; 40; 10)
            fishablesProbability = { 10; 50; 100 };

            -- The deepest possible height of this swarm
            maxSwarmHeight = 3000;
        },
        {
            allowedFishables = { "nemo"; "lollipop"; "deadFish"; "angler"; };
            fishablesProbability = { 5; 45; 75; 100 }; --(5; 40; 30; 15; 10)
            maxSwarmHeight = 6000
        },
        {
            allowedFishables = { "ring"; "shoe"; "snake"; "crocodile" };
            fishablesProbability = { 1; 30; 55; 100 };
            maxSwarmHeight = 7000
        }
    };
    swarmsCanyon = {
        {
            allowedFishables = { "canyonSnake"; "leaf"; "bird"; "squirrel" };
            fishablesProbability = { 25; 45; 75; 100 };
            maxSwarmHeight = 1500
        },
        {
            allowedFishables = { "cactus" };
            fishablesProbability = { 100 };
            maxSwarmHeight = 1800
        },
        {
            allowedFishables = { "cactus" };
            fishablesProbability = { 100 };
            maxSwarmHeight = 5500;
            typ = "static"
        },
        {
            allowedFishables = { "egg"; "bird"; "cactus" };
            fishablesProbability = { 30; 50; 100 };
            maxSwarmHeight = 9000
        },
        {
            allowedFishables = { "ufo"; "balloon"; "bird"; "egg" };
            fishablesProbability = { 1; 20; 50; 100 };
            maxSwarmHeight = 10000
        }
    };
    
    pills = {
        allowedFishables = {"rainbowPill", "sleepingPill", "coffee" };
         fishablesProbability = {50, 75, 100};
    };
    
    swarmCrocos = {
        {
            allowedFishables = {"sleepingCrocodile" };
            fishablesProbability = {100};
            maxSwarmHeight = 9000
        }
    };   
    crazySquirrels = {
        {
            allowedFishables = {"crazySquirrel"};
            fishablesProbability = {100};
            maxSwarmHeight = 9000
        }
    };

    --- Data for all upgrades
    upgrades = {
        oneMoreLife = {
            sortNumber = 1;
            nameOnPersTable = "oneMoreLife"; --Name of parameter in persTable. Unlock change this parameter to true
            price = 500; --price of this item
            image = "shop_extraLife1.png";
            image_disable = "shop_extraLife1_locked.png";
        };
        twoMoreLife = {
            sortNumber = 2;
            nameOnPersTable = "twoMoreLife";
            price = 1000;
            image = "shop_extraLife2.png";
            image_disable = "shop_extraLife2_locked.png";
            dependency = "oneMoreLife";
        };
        threeMoreLife = {
            sortNumber = 3;
            nameOnPersTable = "threeMoreLife";
            price = 1500;
            image = "shop_extraLife3.png";
            image_disable = "shop_extraLife3_locked.png";
            dependency = "twoMoreLife";
        };
        firstSpeedUp = {
            sortNumber = 4;
            nameOnPersTable = "firstSpeedUp";
            price = 300;
            image = "shop_speedup1.png";
            image_disable = "shop_speedup1_locked.png";
        };
        secondSpeedUp = {
            sortNumber = 5;
            nameOnPersTable = "secondSpeedUp";
            price = 300;
            image = "shop_speedup2.png";
            image_disable = "shop_speedup2_locked.png";
            dependency = "firstSpeedUp";
        };
        godMode = {
            sortNumber = 6;
            nameOnPersTable = "godMode";
            price = 1000;
            image = "shop_godmode.png";
            image_disable = "shop_godmode_locked.png";
        };
        mapBreakthrough1 = {
            sortNumber = 7;
            nameOnPersTable = "mapBreakthrough1";
            price = 2500;
            image = "shop_barrier.png";
            image_disable = "shop_barrier_locked.png";
        };
        mapBreakthrough2 = {
            sortNumber = 8;
            nameOnPersTable = "mapBreakthrough2";
            price = 5000;
            image = "shop_barrier.png";
            image_disable = "shop_barrier_locked.png";
            dependency = "mapBreakthrough1";
        };
        moreFuel1 = {
            sortNumber = 9;
            nameOnPersTable = "moreFuel1";
            price = 1000;
            image = "shop_fuel1.png";
            image_disable = "shop_fuel1_locked.png";
            dependency = "godMode";
        };
        moreFuel2 = {
            sortNumber = 10;
            nameOnPersTable = "moreFuel2";
            price = 1500;
            image = "shop_fuel2.png";
            image_disable = "shop_fuel2_locked.png";
            dependency = "moreFuel1";
        };
        firstPermanentMoneyMulitplier = {
            sortNumber = 11;
            nameOnPersTable = "firstPermanentMoneyMult";
            price = 1000;
            image = "shop_moreMoney1.png";
            image_disable = "shop_moreMoney1_locked.png";
        };
        secondPermanentMoneyMulitplier = {
            sortNumber = 12;
            nameOnPersTable = "secondPermanentMoneyMult";
            price = 2500;
            image = "shop_moreMoney2.png";
            image_disable = "shop_moreMoney2_locked.png";
            dependency = "firstPermanentMoneyMult";
        };
    };
    achievements = {
        getFirstObject = {
            nameOnPersTable = "getFirstObject";
            sortNumber = 1;
            image_lock = "ach_firstObject_locked.png";
            image_unlock = "ach_firstObject.png";
        };
        failedStart = {
            nameOnPersTable = "failedStart";
            sortNumber = 2;
            image_lock = "ach_drop_hamster_locked.png";
            image_unlock = "ach_drop_hamster.png";
        };
        caughtTwoBoots = {
            nameOnPersTable = "caughtTwoBoots";
            sortNumber = 3;
            image_lock = "ach_two_shoes_locked.png";
            image_unlock = "ach_two_shoes.png";
        };
        secondStart = {
            nameOnPersTable = "secondStart";
            sortNumber = 15;
            image_lock = "ach_secondTimeGame_locked.png";
            image_unlock = "ach_secondTimeGame.png";
        };
        bronzeCaughtOneRound = {
            nameOnPersTable = "bronzeCaughtOneRound";
            sortNumber = 4;
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRound.png";
        };
        silverCaughtOneRound = {
            nameOnPersTable = "silverCaughtOneRound";
            sortNumber = 5;
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRound.png";
        };
        goldCaughtOneRound = {
            nameOnPersTable = "goldCaughtOneRound";
            sortNumber = 6;
            image_lock = "ach_objectsOneRound_locked.png";
            image_unlock = "ach_objectsOneRound.png";
        };
        bronzeCoinsOneRound = {
            nameOnPersTable = "bronzeCoinsOneRound";
            sortNumber = 7;
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        };
        silverCoinsOneRound = {
            nameOnPersTable = "silverCoinsOneRound";
            sortNumber = 8;
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        };
        goldCoinsOneRound = {
            nameOnPersTable = "goldCoinsOneRound";
            sortNumber = 9;
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        };
        bMoneyEarnedTotal = {
            nameOnPersTable = "bMoneyEarnedTotal";
            sortNumber = 10;
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        };
        sMoneyEarnedTotal = {
            nameOnPersTable = "sMoneyEarnedTotal";
            sortNumber = 11;
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        };
        gMoneyEarnedTotal = {
            nameOnPersTable = "gMoneyEarnedTotal";
            sortNumber = 12;
            image_lock = "ach_shitcoin_locked.png";
            image_unlock = "ach_shitcoin.png";
        };
        negativCoins = {
            nameOnPersTable = "negativCoins";
            sortNumber = 13;
            image_lock = "ach_negativeShitcoin_locked.png";
            image_unlock = "ach_negativeShitcoin.png";
        };
        boughtAllItems = {
            nameOnPersTable = "shoppingQueen";
            sortNumber = 14;
            image_lock = "ach_shoppingQueen_locked.png";
            image_unlock = "ach_shoppingQueen.png";
        };
        bFishCaughtTotal = {
            nameOnPersTable = "bFishCaughtTotal";
            sortNumber = 16;
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        };
        sFishCaughtTotal = {
            nameOnPersTable = "sFishCaughtTotal";
            sortNumber = 17;
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        };
        gFishCaughtTotal = {
            nameOnPersTable = "gFishCaughtTotal";
            sortNumber = 18;
            image_lock = "ach_objectsOverTime_locked.png";
            image_unlock = "ach_objectsOverTime.png";
        };
        firstBorderRemoved = {
            nameOnPersTable = "firstBorderRemoved";
            sortNumber = 19;
            image_lock = "ach_noLvlBorder_locked.png";
            image_unlock = "ach_noLvlBorder.png";
        };
        onlyNegativeFishesCaught = {
            nameOnPersTable = "onlyNegativeFishesCaught";
            sortNumber = 20;
            image_lock = "ach_negativeShitcoin_locked.png";
            image_unlock = "ach_negativeShitcoin.png";
        };
        allPillsAtLeastOnce = {
            nameOnPersTable = "allPillsAtLeastOnce";
            sortNumber = 22;
            image_lock = "ach_suchti_locked.png";
            image_unlock = "ach_suchti.png";
        };
        nothingCaught = {
            nameOnPersTable = "nothingCaught";
            sortNumber = 21;
            image_lock = "ach_nothingCaught_locked.png";
            image_unlock = "ach_nothingCaught.png";
        };
        allLevelBoardersPassed = {
            nameOnPersTable = "allLevelBoardersPassed";
            sortNumber = 23;
            image_lock = "ach_noLvlBorderInfinity_locked.png";
            image_unlock = "ach_noLvlBorderInfinity.png";
        };
        creditsRed = {
            nameOnPersTable = "creditsRed";
            sortNumber = 24;
            image_lock = "ach_credits_locked.png";
            image_unlock = "ach_credits.png";
        };
        playedTime = {
            nameOnPersTable = "playedTime";
            sortNumber = 26;
            image_lock = "ach_playtime_locked.png";
            image_unlock = "ach_playtime.png";
        };
        rageQuit = {
            nameOnPersTable = "rageQuit";
            sortNumber = 25;
            image_lock = "ach_ragequit_locked.png";
            image_unlock = "ach_ragequit.png";
        };
        unreachable = {
            nameOnPersTable = "unreachable";
            sortNumber = 27;
            image_lock = "ach_unreachable_locked.png";
            image_unlock = "ach_unreachable.png";
        };
        achBitch = {
            nameOnPersTable = "achBitch";
            sortNumber = 28;
            image_lock = "ach_achievmentBitch_locked.png";
            image_unlock = "ach_achievmentBitch.png";
        };
--        onlyOne = {
--            nameOnPersTable = "onlyOne";
--            sortNumber = 28;
--            image_lock = "ach_onlyOne_locked.png";
--            image_unlock = "ach_onlyOne.png";
--        };
    };
    languages = {
        english = {
            language = "english";
            flagImage = "BritishFlag.png";
            package = {
                textOn = "On";
                textOff = "Off";
                buttonStart = "Start Game";
                buttonShop = "Shop";
                buttonDictionary = "Dictionary";
                buttonAchievements = "Achievements";
                buttonOptions = "Options";
                buttonCredits = "Credits";
                buttonClose = "Close Game";
                buttonBack = "Back";
                textDepth = "Depth: ";
                buttonReset = "Reset Game";
                textMusic = "In Game Music:";
                textBGM = "Background Music:";
                buttonRestart = "Restart";
                buttonBTG = "Continue";
                buttonBTM = "Back to menu";
                textScore = "Your Score:";
                textHiScore = "Your Highscore:";
                textNewHighscore = "New Highscore";
                buttonTA = "Try again";
                textStartDesktop = "Click to start!";
                textStartMobile = "Tap to start!";
                buttonChangeLevel = "Change level";
                textPrice = "Price: ";
                textMoney = "Not enough Money!";
                textBought = "Already bought";
                buttonRetry = "Retry";
                textNoNewAchievements = "No unlocked achievements this round";
                buttonBuy = "Buy";
                textMoney2 = "Money: ";
                --credits
                credits = {
                    staff = "Staff:";
                    trans = "Translation:";
                    libs = "Libs:";
                    noHWH = "No hamsters were harmed!";
                };
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
                    name = "The breakthrough";
                    description = "Pass all borders within a level";
                };
                nothingCaught = {
                    name = "Misadventure";
                    description = "You didn't catch a single thing";
                };
                allPillsAtLeastOnce = {
                    name = "Addict";
                    description = "Caught every type of pills";
                };
                onlyNegativeFishesCaught = {
                    name = "Coincidence?";
                    description = "Caught only negative objects";
                };
                firstBorderRemoved = {
                    name = "Get out of my way";
                    description = "The treasury can be continued";
                };
                gFishCaughtTotal = {
                    name = "God of fishing";
                    description = "500 fish in total";
                };
                sFishCaughtTotal = {
                    name = "Master of fishing";
                    description = "200 fish total";
                };
                bFishCaughtTotal = {
                    name = "Fishing trainee";
                    description = "50 fish in total";
                };
                shoppingQueen = {
                    name = "Shopping queen";
                    description = "You bought all items in the shop";
                };
                negativCoins = {
                    name = "Oh no!";
                    description = "-200 coins in one round ... noob";
                };
                gMoneyEarnedTotal = {
                    name = "OVER 9000!";
                    description = "You have earned 9000 coins in total";
                };
                sMoneyEarnedTotal = {
                    name = "Rich boy";
                    description = "5000 coins in total";
                };
                bMoneyEarnedTotal = {
                    name = "Slumdog millionaire";
                    description = "2000 coins in total";
                };
                goldCoinsOneRound = {
                    name = "Amazing!";
                    description = "Earn 1000 coins in one round o.O";
                };
                silverCoinsOneRound = {
                    name = "You are getting better";
                    description = "Earn 600 coins in one round";
                };
                bronzeCoinsOneRound = {
                    name = "200";
                    description = "Earn 200 coins in one round";
                };
                bronzeCaughtOneRound = {
                    name = "Good haul!";
                    description = "Caught more than 10 fish in a single round";
                };
                silverCaughtOneRound = {
                    name = "Better haul!";
                    description = "Caught more than 20 fish in a single round";
                };
                goldCaughtOneRound = {
                    name = "Best haul!";
                    description = "Caught more than 30 fish in a single round";
                };
                secondStart = {
                    name = "Welcome again!";
                    description = "It's nice to see you again";
                };
                caughtTwoBoots = {
                    name = "One for each foot";
                    description = "Your new shoes aren't really that new anymore...";
                };
                failedStart = {
                    name = "Complete failure";
                    description = "Congratulations! You failed to start the game";
                };

                playedTime = {
                    name = "Play time";
                    description = "Congratulations! You played over two hours";
                };
                rageQuit = {
                    name = "Rage quit";
                    description = "Quit the game after a short distance";
                };
                getFirstObject = {
                    name = "First object";
                    description = "You caught your first object";
                };
--                onlyOne = {
--                    name = "I wanted that one";
--                    description = "Caught only one object"
--                };
                unreachable = {
                    name = "Unreachable";
                    description = "Don't try to get it";
                };
                achBitch = {
                    name = "Achievement bitch";
                    description = "You got all achievements?!";
                };
                --objects
                nemo = {
                    name = "Nemo";
                    description = "Congratulations! You have found nemo!";
                };
                turtle = {
                    name = "Turtle";
                    description = "Its house is its shell";
                };
                rat = {
                    name = "Rat";
                    description = "Easy to attract with cheese";
                };
                deadFish = {
                    name = "Dead fish";
                    description = "It was a good fish throughout its whole life";
                };
                angler = {
                    name = "Angler";
                    description = "Very useful if you need some light";
                };
                lollipop = {
                    name = "Lollipop";
                    description = "You know you want it";
                };
                ring = {
                    name = "Ring";
                    description = "One ring to rule them all";
                };
                shoe = {
                    name = "Shoe";
                    description = "One shoe is not enough";
                };
                snake = {
                    name = "Snake";
                    description = "This is a really dangerous snake";
                };
                crocodile = {
                    name = "Crocodile";
                    description = "He just wants to cuddle, I promise!";
                };
                sleepingPill = {
                    name = "Sleeping pill";
                    description = "Makes your haul drowsy";
                };
                squirrel = {
                    name = "Squirrel";
                    description = "Give him a nut and he goes nuts!";
                };
                backpack = {
                    name = "Backpack";
                    description = "Please don't leave your luggage unattended";
                };
                drink = {
                    name = "Drink";
                    description = "Don't spill it!";
                };
                egg = {
                    name = "Egg";
                    description = "What kind of animal will hatch from that egg?";
                };
                camera = {
                    name = "Camera";
                    description = "Say cheeeeese!";
                };
                canyonSnake = {
                    name = "Canyon snake";
                    description = "Wow; it managed to catch its own tail";
                };
                cactus = {
                    name = "Cactus";
                    description = "Do you want to hug it?";
                };
                leaf = {
                    name = "Leaf";
                    description = "Leave it right here please";
                };
                bird = {
                    name = "Bird";
                    description = "Free like a bird";
                };
                balloon = {
                    name = "Ballon";
                    description = "Let it touch the sky";
                };
                ufo = {
                    name = "Ufo";
                    description = "Wanna be our hamster?";
                };
                --upgrades
                oneMoreLife = {
                    name = "One more life"; --Name shown on the Textfield on the shop
                    description = "Just in case you lose your first life."; --shown on the shop
                };
                twoMoreLife = {
                    name = "Two more life";
                    description = "One, two, three, fo... Ah! No! Just three lives now. Too bad!";
                };
                threeMoreLife = {
                    name = "Three more life";
                    description = "Wow, with four lives you are almost a cat now!";
                };
                firstSpeedUp = {
                    name = "1st Speed Update";
                    description = "Speed up that S.H.I.T!";
                };
                secondSpeedUp = {
                    name = "2nd Speed Update";
                    description = "Still not fast enough? Then try this double S.H.I.T-Speed!";
                };
                godMode = {
                    name = "God Mode";
                    description = "Be Go(o)d. Don't give a S.H.I.T about anything";
                };
                mapBreakthrough1 = {
                    name = "Let me go further!";
                    description = "Blow this barrier up! Violence IS a solution.";
                };
                mapBreakthrough2 = {
                    name = "You shall pass";
                    description = "This bomb can take you places.";
                };
                moreFuel1 = {
                    name = "Need more Fuel?";
                    description = "Consider shifting the gear. Upgrade your fuel to 1600";
                };
                moreFuel2 = {
                    name = "Need more Fuel?";
                    description = "Better get yourself a tank wagon. Upgrade your fuel to 2400";
                };
                firstPermanentMoneyMult = {
                    name = "Negotiation Novice";
                    description = "'Convince' the object to give you 20% more money.";
                };
                secondPermanentMoneyMult = {
                    name = "Playground Bully";
                    description = "Take 25% more money from your victims.";
                };
            };
        };
        german = {
            language = "german";
            flagImage = "GermanFlag.png";
            package = {
                textOn = "An";
                textOff = "Aus";
                buttonStart = "Spiel starten";
                buttonShop = "Shop";
                buttonDictionary = "Lexikon";
                buttonAchievements = "Erfolge";
                buttonOptions = "Optionen";
                buttonCredits = "Credits";
                buttonClose = "Spiel beenden";
                buttonBack = "Zurück";
                textDepth = "Tiefe: ";
                buttonReset = "Werkseinstellung";
                textMusic = "Musik im Spiel:";
                textBGM = "Hintergrund Musik:";
                buttonRestart = "Neustarten";
                buttonBTG = "Zurück zum Spiel";
                buttonBTM = "Zurück zum Menü";
                textScore = "Punktestand:";
                textHiScore = "Dein Rekord:";
                textNewHighscore = "Neuer Rekord";
                textStartDesktop = "Klicken zum Starten!";
                textStartMobile = "Drücken zum Starten!";
                buttonChangeLevel = "Levelauswahl";
                textPrice = "Preis: ";
                textMoney = "Nicht genug Geld!";
                textBought = "Already bought";
                buttonRetry = "Neustarten";
                textNoNewAchievements = "Keine neuen Errungenschaften";
                buttonBuy = "Kaufen";
                textMoney2 = "Geld: ";
                --credits
                credits = {
                    staff = "Mitwirkende:";
                    trans = "Übersetzung:";
                    libs = "Bibliotheken:";
                    noHWH = "Es kamen keine Hamster zu Schaden.";
                };
                --achievements
                getFirstObject = {
                    name = "Der erste Fang";
                    description = "Du hast den ersten Fang gemacht";
                };
                creditsRed = {
                    name = "Etwas Respekt bitte";
                    description = "Lies die Credits";
                };
                allLevelBoardersPassed = {
                    name = "Durchbruch";
                    description = "Überwinde alle Grenzen innerhalb des Levels";
                };
                nothingCaught = {
                    name = "Ups...";
                    description = "Du hast gar nichts gefangen!";
                };
                allPillsAtLeastOnce = {
                    name = "Suchti";
                    description = "Fange jede Art von Pillen";
                };
                onlyNegativeFishesCaught = {
                    name = "Absicht?!";
                    description = "Du hast Minuspunkte geangelt";
                };
                firstBorderRemoved = {
                    name = "Aus dem Weg!";
                    description = "Die Schatzsuche kann weitergehen";
                };
                gFishCaughtTotal = {
                    name = "Ultimativer Fischer";
                    description = "Fange 500 Fische";
                };
                sFishCaughtTotal = {
                    name = "Meisterfischer";
                    description = "Fange 200 Fische";
                };
                bFishCaughtTotal = {
                    name = "Fischerlehrling";
                    description = "Fange 50 Fische";
                };
                shoppingQueen = {
                    name = "Shopping Queen";
                    description = "Du hast alle Shop-Gegenstände erworben";
                };
                negativCoins = {
                    name = "Doch nicht so!";
                    description = "Verliere 200 Münzen in einer Runde...";
                };
                gMoneyEarnedTotal = {
                    name = "Mehr als 9000!";
                    description = "Verdiene 9000 Münzen";
                };
                sMoneyEarnedTotal = {
                    name = "Yuppie";
                    description = "Verdiene 5000 Münzen";
                };
                bMoneyEarnedTotal = {
                    name = "Slumdog Millionär";
                    description = "Verdiene 2000 Münzen";
                };
                goldCoinsOneRound = {
                    name = "Prima!";
                    description = "Du hast 1000 Münzen in einer Runde verdient o.O";
                };
                silverCoinsOneRound = {
                    name = "Du wirst besser";
                    description = "Verdiene 600 Münzen in einer Runde";
                };
                bronzeCoinsOneRound = {
                    name = "Nicht schlecht";
                    description = "Verdiene 200 Münzen in einer Runde";
                };
                bronzeCaughtOneRound = {
                    name = "Guter Fang!";
                    description = "Du hast 10 Fische in nur einer Runde gefangen";
                };
                silverCaughtOneRound = {
                    name = "Exzellenter Fang!";
                    description = "Du hast 20 Fische in nur einer Runde gefangen";
                };
                goldCaughtOneRound = {
                    name = "Ultimativer Fang!";
                    description = "Du hast 30 Fische in nur einer Runde gefangen";
                };
                secondStart = {
                    name = "Willkommen zurück!";
                    description = "Schön dich wiederzusehen";
                };
                caughtTwoBoots = {
                    name = "Trendsetter";
                    description = "Wo hast du denn die her?!";
                };
                failedStart = {
                    name = "Totalversagen";
                    description = "Glückwunsch! Du hast es nicht einmal geschafft das Spiel zu starten";
                };
                playedTime = {
                    name = "Zocker";
                    description = "Glückwunsch, deine Spielzeit beträgt über zwei Stunden";
                };
                rageQuit = {
                    name = "Zurück auf Anfang";
                    description = "Starte das Spiel nach einer kurzen Distanz neu";
                };
                unreachable = {
                    name = "Unerreichbar";
                    description = "Versuche es erst gar nicht";
                };
                achBitch = {
                    name = "Achievement Bitch";
                    description = "Du hast alle Erfolge freigeschaltet?!";
                };
--                onlyOne = {
--                    name = "Den wollte ich";
--                    description = "Nur ein Objekt gefangen"
--                };
                --objects
                nemo = {
                    name = "Nemo";
                    description = "Anscheinend hast du Nemo gefunden";
                };
                turtle = {
                    name = "Schildkröte";
                    description = "Sein Panzer ist sein Haus";
                };
                rat = {
                    name = "Ratte";
                    description = "Lässt sich leicht mit Käse anlocken";
                };
                deadFish = {
                    name = "Toter Fisch";
                    description = "Er war zu Lebzeiten ein guter Fisch";
                };
                angler = {
                    name = "Anglerfisch";
                    description = "Mit ihm geht dir ein Licht auf";
                };
                lollipop = {
                    name = "Lutscher";
                    description = "Du weißt du willst ihn";
                };
                ring = {
                    name = "Ring";
                    name = "Ring";
                    description = "Ein Ring sie alle zu knechten";
                };
                shoe = {
                    name = "Schuh";
                    description = "Ein Schuh ist nicht genug";
                };
                snake = {
                    name = "Schlange";
                    description = "Eine sehr gefährliche Schlange";
                };
                crocodile = {
                    name = "Krokodil";
                    description = "Er will nur kuscheln, versprochen!";
                };
                sleepingPill = {
                    name = "Schlafpille";
                    description = "Macht deine Beute schläfrig";
                };
                squirrel = {
                    name = "Eichhörnchen";
                    description = "Gib ihm eine Nuss und er flippt aus";
                };
                backpack = {
                    name = "Rucksack";
                    description = "Bitte lassen Sie Ihr Reisegepäck nicht unbeaufsichtigt";
                };
                drink = {
                    name = "Getränk";
                    description = "Nicht verschütten!";
                };
                egg = {
                    name = "Ei";
                    description = "Welches Tier wird wohl aus diesem Ei schlüpfen?";
                };
                camera = {
                    name = "Kamera";
                    description = "Bitte lächeln!";
                };
                canyonSnake = {
                    name = "Canyon Schlange";
                    description = "Beeindruckend; sie hat ihren eigenen Schwanz gefangen";
                };
                cactus = {
                    name = "Kaktus";
                    description = "Möchtest du ihn vielleicht umarmen?";
                };
                leaf = {
                    name = "Blatt";
                    description = "Mitnahme nicht gestattet";
                };
                bird = {
                    name = "Vogel";
                    description = "Er ist tatsächlich frei wie ein Vogel";
                };
                balloon = {
                    name = "Luftballon";
                    description = "Lass ihn mit deinen Träumen aufsteigen";
                };
                ufo = {
                    name = "Ufo";
                    description = "Willst du unser Versuchskaninchen sein?";
                };
                --upgrades
                oneMoreLife = {
                    name = "Zweites Leben"; --Name shown on the Textfield on the shop
                    description = "Du bekommst dein zweites Leben"; --shown on the shop
                };
                twoMoreLife = {
                    name = "Drittes Leben";
                    description = "Du bekommst dein drittes Leben";
                };
                threeMoreLife = {
                    name = "Viertes Leben";
                    description = "Du erhälst ein viertes Leben";
                };
                firstSpeedUp = {
                    name = "Schneller!";
                    description = "Erhöhe deine Geschwindigkeit";
                };
                secondSpeedUp = {
                    name = "Noch schneller!";
                    description = "Erhöhe deine Geschwindigkeit erneut";
                };
                godMode = {
                    name = "God mode";
                    description = "Schaltet den god mode frei";
                };
                mapBreakthrough1 = {
                    name = "Aus dem Weg!";
                    description = "Zerstöre eine Barriere";
                };
                mapBreakthrough2 = {
                    name = "Freie Bahn";
                    description = "Zerstöre eine weitere Barriere";
                };
                moreFuel1 = {
                    name = "Mehr Treibstoff?";
                    description = "Erhöhe deine Treibstoffmenge auf 1600";
                };
                moreFuel2 = {
                    name = "Volltanken bitte!";
                    description = "Erhöhe deine Treibstoffmenge auf 2400";
                };
                firstPermanentMoneyMult = {
                    name = "Lehrling";
                    description = "Verdiene 20% mehr Geld";
                };
                secondPermanentMoneyMult = {
                    name = "Profi Dealer";
                    description = "Verdiene 25% mehr Geld";
                };
            };
        };
    };
    android = {
        maxTilt = .3;
    };
};
