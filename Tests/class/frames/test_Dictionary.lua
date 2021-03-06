-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Dictionary";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
KlickableElement = require "class.KlickableElement";
_G.TEsound = {
    playLooping = function(...) end;
    play = function(...) end;
    stop = function(...) end;
};


describe("Unit test for Dictionary.lua", function()
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
        
        _G.Loveframes = {
            Create = function(typeName) 
                return fakeElement(typeName);
            end
        }
        _G.data = {
            fishableObjects = {};
        }
        _G._persTable = {
            winDim = {
                [1] = 500;
                [2] = 500;
            };
        };
        _G.Frame = function(...) return Frame; end;

        locInstance = testClass();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        
        locInstance.elementsOnFrame = {};
        locInstance.background = "background";
        locInstance.imageButton = "imageButton";
        
        myInstance.elementsOnFrame = {};
        myInstance.background = "background";
        myInstance.imageButton = "imageButton";
        
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing create function", function()
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
        };
        
        spy.on(locInstance, "addAllObjects");
        locInstance:create();

        assert.spy(locInstance.addAllObjects).was.called();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_back.gotClicked();
        assert.spy(_gui.changeFrame).was.called();
        
        stub(locInstance.elementsOnFrame.chart, "mousepressed")
        locInstance.elementsOnFrame.chart.gotClicked();
        assert.stub(locInstance.elementsOnFrame.chart.mousepressed).was.called();
    end)

    it("Testing addAllObjects function", function()
        _G.data = {
            fishableObjects = {
                testObj1 = {
                    name = "test1";
                    description = "test1";
                    image = "path1";
                },
                testObj2 = {
                    name = "test2";
                    description = "test2";
                    image = "path2";
                }
            };
        };
        
        locInstance:addAllObjects();
        locInstance.elementsOnFrame.chart.p_elementsOnChart[1] = {
            description = "test2";
            enable = true;
            image = "image1";
            image_disable = "image2";
            name = "test2";
            xOffset = 0;
            yOffset = 0;
            purchaseable = true;
            object = {};
        };
        locInstance.elementsOnFrame.chart.p_elementsOnChart[2] = {
            description = "test1";
            enable = true;
            image = "image1";
            image_disable = "image2";
            name = "test1";
            purchaseable = true;
            xOffset = 0;
            yOffset = 0;
            object = {};};
        
        local image = {
            getHeight = function (...) return 50 end;
            getWidth = function (...) return 50 end;
        };
        
        local KE1 = KlickableElement("test1", image, image, "test1", nil);
        local KE2 = KlickableElement("test2", image, image, "test2", nil);
        KE1.object = {};
        KE1.image = "image1";
        KE1.image_disable = "image2";
        KE2.image = "image1";
        KE2.image_disable = "image2";
        KE2.object = {};
        assert.same(locInstance.elementsOnFrame.chart.p_elementsOnChart, {KE2, KE1});
    end)

    it("Testing draw function", function()
        local loveMock = mock(love.graphics, true);
        locInstance:draw();
        assert.spy(loveMock.draw).was_called(5);
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
        stub(locInstance.frame, "disappear");
        locInstance:disappear();
        assert.stub(locInstance.frame.disappear).was_called(1);
    end)

    it("Testing checkPosition function", function()
        stub(locInstance.frame, "checkPosition");
        locInstance:checkPosition();
        assert.stub(locInstance.frame.checkPosition).was_called(1);
    end)

    it("Testing mousepressend", function()
        _G.clicked ={};
        _G.clicked[1] = false;
        _G.clicked[2] = false;
        locInstance.elementsOnFrame = {
            button_back = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 0, 0 end;
                gotClicked = function() _G.clicked[1] = true end;
            };
            button_chart = {
                getSize = function () return 50, 50 end;
                getPosition = function () return 0, 100 end;
                gotClicked = function() _G.clicked[2] = true end;
            };
        };
        
        locInstance:mousepressed(10, 10);
        assert.are.same(true, _G.clicked[1]);
        assert.are.same(false, _G.clicked[2]);
        
        locInstance:mousepressed(10, 110);
        assert.are.same(true, _G.clicked[1]);
        assert.are.same(true, _G.clicked[2]);
    end)

    it("Testing setOffset", function()
        locInstance:setOffset(50, 50);
        assert.are.same(locInstance.xOffset, 50);
        assert.are.same(locInstance.yOffset, 50);
    end)

    it("addAllObjects", function()
        locInstance.directory = "directory";
        _G.data.fishableObjects = {
            deadfish = {
                name = "deadFish";
                image = "deadFish.png";
                description = "It was a good fish throughout its whole life";
                sortNumber = 2;
                value = 20;
            }
        }
        stub(locInstance.elementsOnFrame.chart, "addKlickableElement");
        locInstance:addAllObjects();
        assert.stub(locInstance.elementsOnFrame.chart.addKlickableElement).was.called();
    end);
end)
