-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Credits";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";


describe("Unit test for Credits.lua", function()
    local locInstance;

    before_each(function()
        _G.love = {
        mouse = {
            setVisible = function(...) end;
            };
        };
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G._persTable = {
            scaledDeviceDim = {
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
        locInstance.elementsOnFrame.button_back.object.OnClick();
        assert.spy(_gui.changeFrame).was.called();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        myInstance.elementsOnFrame.button_back.object.OnClick = {};
        locInstance.elementsOnFrame.button_back.object.OnClick = {};
        assert.are.same(locInstance, myInstance);
    end)
it("Testing Constructor", function()
        _G._persTable.scaledDeviceDim = {640, 950};

        locInstance = testClass();
        local myInstance = testClass();
        myInstance.elementsOnFrame.button_back.object.OnClick = {};
        locInstance.elementsOnFrame.button_back.object.OnClick = {};
        assert.are.same(locInstance, myInstance);
    end)

it("Testing Constructor", function()
        _G._persTable.scaledDeviceDim = {720, 1024};

        locInstance = testClass();
        local myInstance = testClass();
        myInstance.elementsOnFrame.button_back.object.OnClick = {};
        locInstance.elementsOnFrame.button_back.object.OnClick = {};
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing draw function", function()
        stub(locInstance.frame, "draw");
        locInstance:draw();
        assert.stub(locInstance.frame.draw).was_called(1);
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
        assert.are.same(_G.data.languages.english.package.credits.staff, string.sub(creditStr, 1, 6));
        
        _G._persTable.config.language = "german";
        creditStr = locInstance:buildCreditsString();
        assert.are.same(_G.data.languages.german.package.credits.staff, string.sub(creditStr, 1, 12));
        
    end)
end)