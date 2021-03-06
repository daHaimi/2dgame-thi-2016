-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.Achievements";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";
KlickableElement = require "class.KlickableElement";
_G.TEsound = {
    playLooping = function(...) end;
    play = function(...) end;
    stop = function(...) end;
};


describe("Unit test for Achievements.lua", function()
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
            achievements = {    
            };
            upgrades = {
                oneMoreLife = {
                    nameOnPersTable = "moreLife";--Name of parameter in persTable. Unlock change this parameter to true
                    name = "One more life";--Name shown on the Textfield on the shop
                    description = "add one more life to your healthbar.";--shown on the shop
                    price = 100;--price of this item
                    image = "gui_Test_klickableElement.png";
                    image_disable = "gui_Test_klickableElement_disable.png";
                }
            }
        }
        _G._persTable = {
            winDim = {500, 500};
        };
        _G.Frame = function(...) return Frame; end;

        locInstance = testClass();
    end)


    it("Testing Constructor", function()
        local myInstance = testClass();
        
        locInstance.elementsOnFrame = {};
        locInstance.imageButton = "imageButton";
        locInstance.background = "background";
        
        myInstance.elementsOnFrame = {};
        myInstance.imageButton = "imageButton";
        myInstance.background = "background";
        
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing create function", function()
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
        };
        
        spy.on(locInstance, "addAllAchievements");
        spy.on(locInstance, "loadValuesFromPersTable");
        locInstance:create();

        assert.spy(locInstance.addAllAchievements).was.called();
        assert.spy(locInstance.loadValuesFromPersTable).was.called();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_back.gotClicked();
        assert.spy(_gui.changeFrame).was.called();
        
        stub(locInstance.elementsOnFrame.chart, "mousepressed")
        locInstance.elementsOnFrame.chart.gotClicked();
        assert.stub(locInstance.elementsOnFrame.chart.mousepressed).was.called();
    end)

    it("Testing addAllAchievements function", function()
        _G.data = {
            achievements = {
                testAch1 = {
                    nameOnPersTable = "test1";
                    name = "test1";
                    sortNumber = 1;
                    description = "test1";
                    image_lock = "path1";
                    image_unlock = "path2";
                },
                testAch2 = {
                    nameOnPersTable = "test2";
                    name = "test2";
                    sortNumber = 2;
                    description = "test2";
                    image_lock = "path3";
                    image_unlock = "path4";
                }
            };
        };
        local image = {
            getHeight = function (...) return 50 end;
            getWidth = function (...) return 50 end;
        }
        
        locInstance:addAllAchievements();
        locInstance.elementsOnFrame.chart.p_elementsOnChart[1].object = {};
        locInstance.elementsOnFrame.chart.p_elementsOnChart[2].object = {};
        local KE1 = KlickableElement("test1", image, image, "test1", nil, "test1");
        local KE2 = KlickableElement("test2", image, image, "test2", nil, "test2");
        KE1.object = {};
        KE2.object = {};
        assert.not_same(locInstance.elementsOnFrame.chart.p_elementsOnChart, {KE1, KE2});
    end)

    it("Testing loadValuesFromPersTable function", function()
        _G._persTable = {
            upgrades = {};
            achievements = {
                testAch1 = true;
                testAch2 = false;
            };
        };
        _G.data = {
            achievements = {
                testAch1 = {
                    nameOnPersTable = "testAch1";
                    name = "test1";
                    sortNumber = 1;
                    description = "test1";
                    image_lock = "path1";
                    image_unlock = "path2";
                },
                testAch2 = {
                    nameOnPersTable = "testAch2";
                    name = "test2";
                    sortNumber = 2;
                    description = "test2";
                    image_lock = "path3";
                    image_unlock = "path4";
                }
            };
        };

        locInstance:addAllAchievements();
        locInstance:loadValuesFromPersTable();

        assert.equal(locInstance.elementsOnFrame.chart.p_elementsOnChart[1].enable, false);
        assert.equal(locInstance.elementsOnFrame.chart.p_elementsOnChart[2].enable, true);
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
    
    it("Testing setOffset", function()
        locInstance:setOffset(50, 50);
        assert.are.same(locInstance.xOffset, 50);
        assert.are.same(locInstance.yOffset, 50);
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

end)