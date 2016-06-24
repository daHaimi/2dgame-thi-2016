-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Credits";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
_G.TEsound = {
    playLooping = function(...) end;
    play = function(...) end;
    stop = function(...) end;
};


describe("Unit test for Credits.lua", function()
    local locInstance;

    before_each(function()
        _G.love = {
            mouse = {
                setVisible = function(...) end;
            };
            graphics = {
                newImage = function(...) return {
                    getHeight = function (...) return 50 end;
                    getWidth = function (...) return 50 end;
                } end;
                draw = function (...) end;
                getFont = function (...) return "a Font" end;
                newFont = function (...) end;
                setFont = function (...) end;
                printf = function (...) end;
                setColor = function (...) end;
            }
        };
        _G._persTable = {
            winDim = {
                [1] = 500;
                [2] = 500;
            };
            config = {
                language = "english";
            };
        };
        
        _G.data = {
            languages = {
                english = {
                    package = {
                        credits = {
                            staff = "Staff:";
                            trans = "Translation:";
                            libs = "Libs:";
                            noHWH = "No hamsters were harmed!";
                        };
                    };
                };
                german = {
                    package = {
                        credits = {
                            staff = "Mitwirkende:";
                            trans = "Übersetzung:";
                            libs = "Bibliotheken:";
                            noHWH = "Es kamen keine Hamster zu Schaden.";
                        };
                    };
                };
            };
        };
        
        _G.Frame = function(...) return Frame; end;

        locInstance = testClass();
    end)

    it("Testing create function", function()
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
        };

        locInstance:create();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_back.gotClicked();
        assert.spy(_gui.changeFrame).was.called();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        
        myInstance.elementsOnFrame.button_back.gotClicked = {};
        myInstance.elementsOnFrame.button_back.image = "image";
        myInstance.background = "background";
        myInstance.imageButton = "imageButton";
        
        locInstance.elementsOnFrame.button_back.gotClicked = {};
        locInstance.elementsOnFrame.button_back.image = "image";
        locInstance.background = "background";
        locInstance.imageButton = "imageButton";
        
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing draw function", function()
        local loveMock = mock(love.graphics, true);
        locInstance:draw();
        assert.spy(loveMock.draw).was_called(2);
    end)

    it("Testing clear function", function()
        stub(locInstance.frame, "clear");
        locInstance.elementsOnFrame = "test"
        locInstance:clear();
        assert.stub(locInstance.frame.clear).was_called(1);
    end)

    it("Testing appear function", function()
        stub(locInstance.frame, "appear");
        locInstance:appear();
        assert.stub(locInstance.frame.appear).was_called(1);
    end)

    it("Testing disappear function", function()
        local creditsAchCalled = false;
        local achBitchAchCalled = false;
        locInstance.startTime = 0;
        
        _G._gui = {
            getLevelManager = function(...) return {
                getAchievmentManager = function(...) return {
                    checkCreditsRed = function(...) creditsAchCalled = true end;
                    achBitch = function(...) achBitchAchCalled = true end;
                } end;
            } end;
        };
        

        stub(locInstance.frame, "disappear");
        locInstance:disappear();
        assert.stub(locInstance.frame.disappear).was_called(1);
        assert.are.same(true, creditsAchCalled);
        assert.are.same(true, achBitchAchCalled);
    end)

    it("Testing checkPosition function", function()
        stub(locInstance.frame, "checkPosition");
        locInstance:checkPosition();
        assert.stub(locInstance.frame.checkPosition).was_called(1);
    end)

    it("Testing createStartTime function", function()
        local timeWasSet = false;
        locInstance:createStartTime();
        
        if locInstance.startTime > 0 then
            timeWasSet = true
        end
        
        assert.are.equal(timeWasSet, true);
    end)

    it("Testing calcTimeSpent function", function()
        locInstance.startTime = 10;
        local diffTime = locInstance:calcTimeSpent();
        
        assert.are_not.equals(diffTime, nil);
    end)

    it("Testing buildCreditsString function", function()
        local creditStr = locInstance:buildCreditsString();
        local shouldBe = "";
        local strings = {
        "hump, Matthias Richter",
        "light, Marcus Ihde",
        "LoveFrames, Kenny Shields",
        "LÖVE 2D",
        "table_serializer, Mathias Haimerl",
        "TEsound, Ensayia and Taehl",
        };
        
        for i = 1, #strings, 1
        do
            shouldBe = shouldBe .. strings[i] .. "\n";
        end
        assert.are.same(shouldBe, creditStr[2]);
        
        _G._persTable.config.language = "german";
        creditStr = locInstance:buildCreditsString();
        assert.are.same(shouldBe, creditStr[2]);
        
    end)

    it("Testing mousepressend", function()
        _G.clicked ={};
        _G.clicked[1] = false;
        locInstance.elementsOnFrame = {
            button_back = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 0, 0 end;
                gotClicked = function() _G.clicked[1] = true end;
            };
        };
        
        locInstance:mousepressed(10, 10);
        assert.are.same(true, _G.clicked[1]);
    end)

    it("testing update function", function()
        locInstance.blinkTimer = 2;
        locInstance:update();
        assert.are.equal(locInstance.blinkTimer, 1);
        locInstance:update();
        assert.are.equal(locInstance.blinkTimer, 25);
    end)
end)
