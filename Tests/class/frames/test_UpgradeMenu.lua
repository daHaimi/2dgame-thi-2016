-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.frames.UpgradeMenu";
fakeElement = require "Tests.fakeLoveframes.fakeElement";
Frame = require "class.Frame";


describe("Unit test for UpgradeMenu.lua", function()
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
        _G.Frame = function(...) return Frame; end;
        _G._persTable = {
            upgrades = {
                test1 = false;
            };
            money = 0;
            scaledDeviceDim = {
                [1] = 500;
                [2] = 500;
            };
            achievements = {
                shoppingQueen = false;
            };
        };
        _G._gui = {
            newNotification = function(...) end;
        };
        _G.data = {
            upgrades = {};
            achievements = {
                boughtAllItems = {
                    image_unlock = "";
                    name = "";
                }
            }
        };
        
        _G.element ={
            price = 10;
            disable = function(...) end;
        };
        
        locInstance = testClass();

end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        locInstance.elementsOnFrame = {};
        myInstance.elementsOnFrame = {};
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor", function()
        _G._persTable = {
            scaledDeviceDim = {640, 950};
        };
        locInstance = testClass();
        local myInstance = testClass();
        locInstance.elementsOnFrame = {};
        myInstance.elementsOnFrame = {};
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing Constructor", function()
        _G._persTable = {
            scaledDeviceDim = {720, 1024};
        };
        locInstance = testClass();
        local myInstance = testClass();
        locInstance.elementsOnFrame = {};
        myInstance.elementsOnFrame = {};
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing checkForAchievement function", function()
        stub(_G._gui, "newNotification");
        locInstance:checkForAchievement();
        assert.are.equal(_G._persTable.achievements.shoppingQueen, false);
        _G._persTable.upgrades.test1 = true;
        locInstance:checkForAchievement();
        assert.are.equal(_G._persTable.achievements.shoppingQueen, true);
    end)

    it("Testing create function", function()
        local achBitchCalled = false;
        _G._gui = {
            getFrames = function(...) return{}; end;
            changeFrame = function(...) end;
            getLevelManager = function(...) return {
                getAchievmentManager = function(...) return{
                    achBitch = function(...) achBitchCalled = true end;
                } end;
            } end;
        };

        local ME = {
         price = 0;
         };
        
        _G._persistence = {
          updateSaveFile = function(...) end;
        };
        
        spy.on(locInstance, "addAllUpgrades");
        spy.on(locInstance, "loadValuesFromPersTable");
        locInstance:create();

        assert.spy(locInstance.addAllUpgrades).was.called();
        assert.spy(locInstance.loadValuesFromPersTable).was.called();

        spy.on(_G._gui, "changeFrame");
        locInstance.elementsOnFrame.button_back.object.OnClick();
        assert.spy(_gui.changeFrame).was.called();
        
        locInstance.elementsOnFrame.chart.object.p_markedElement = locInstance.elementsOnFrame.chart.object.p_elementsOnChart[1];
       
        locInstance.elementsOnFrame.chart.object.p_markedElement = ME;
        stub(locInstance, "buyElement");
        locInstance.elementsOnFrame.button_buy.object.OnClick();
        assert.stub(locInstance.buyElement).was.called();
        assert.are.same(true, achBitchCalled);
    end)

    it("Testing buyElement function", function()
        local KE = {
            disable = function(...) end;
            price = 0;
        }
        
        
        locInstance.elementsOnFrame.chart.object.p_markedElement = KE;
        locInstance.elementsOnFrame.chart.getMarkedElement = function(...) 
            return locInstance.elementsOnFrame.chart.object.p_markedElement; 
        end;
        
        stub(locInstance, "checkForAchievement");
        stub(locInstance.elementsOnFrame.chart.object.p_markedElement, "disable");
        locInstance:buyElement();
        assert.stub(locInstance.elementsOnFrame.chart.object.p_markedElement.disable).was.called();
        assert.stub(locInstance.checkForAchievement).was_called();
    end)

    it("Testing addAllUpgrades function", function()
        _G.data = {
            upgrades = {
                testUp1 = {
                    nameOnPersTable = "test1";
                    sortNumber = 1;
                    name = "test1";
                    description = "test1";
                    image = "path1";
                    image_disable = "path2";
                    price = 1;
                },
                testUp2 = {
                    nameOnPersTable = "test2";
                    sortNumber = 2;
                    name = "test2";
                    description = "test2";
                    image = "path3";
                    image_disable = "path4";
                    price = 2;
                }
            };
        };

        local KE = {
          price = 10;
          };
        
        locInstance.elementsOnFrame.chart.object.p_markedElement = KE;

        
        locInstance:addAllUpgrades();
        locInstance.elementsOnFrame.chart.object.p_elementsOnChart[1].object = {};
        locInstance.elementsOnFrame.chart.object.p_elementsOnChart[2].object = {};
        local KE1 = KlickableElement("test1", "path1", "path2", "test1", 1, "test1");
        local KE2 = KlickableElement("test2", "path3", "path4", "test2", 2, "test2");
        KE1.object = {};
        KE2.object = {};
        assert.not_same(locInstance.elementsOnFrame.chart.object.p_elementsOnChart, {KE2, KE1});
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
        stub(locInstance.frame, "disappear");
        locInstance:disappear();
        assert.stub(locInstance.frame.disappear).was_called(1);
    end)

    it("Testing checkPosition function", function()
        stub(locInstance.frame, "checkPosition");
        locInstance:checkPosition();
        assert.stub(locInstance.frame.checkPosition).was_called(1);
    end)

    it("Testing loadValuesFromPersTable function", function()
        _G._persTable = {
            upgrades = {
                testUp1 = true;
                testUp2 = false;
            };
        };
        _G.data = {
            upgrades = {
                testUp1 = {
                    nameOnPersTable = "testUp1";
                    name = "test1";
                    sortNumber = 1;
                    description = "test1";
                    price = 1;
                    image = "path1";
                    image_disable = "path2";
                },
                testUp2 = {
                    nameOnPersTable = "testUp2";
                    name = "test2";
                    sortNumber = 2;
                    description = "test2";
                    price = 1;
                    image = "path3";
                    image_disable = "path4";
                }
            };
        };
        locInstance:addAllUpgrades();
        locInstance:loadValuesFromPersTable();
        assert.equal(locInstance.elementsOnFrame.chart.object.p_elementsOnChart[1].enable, true);
        assert.equal(locInstance.elementsOnFrame.chart.object.p_elementsOnChart[2].enable, false);
    end)

end)