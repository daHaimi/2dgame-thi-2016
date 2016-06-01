-- Lua 5.1 Hack
_G.math.inf = 1 / 0

testClass = require "src.class.FlagButton"
fakeElement = require "Tests.fakeLoveframes.fakeElement";

describe("Unit test for FlagButton.lua", function()
    local locInstance;
    
    before_each(function()
        _G.Loveframes = {
            Create = function(typeName) return fakeElement(typeName); end
        };
        _G.data = {
            languages = {
                english = {
                    name = "english";
                    flagImage = "path1";
                },
                german = {
                    name = "german";
                    flagImage = "path2";
                };
            };
            
        };
        _G._persTable = {
            config = {
                language = "english";
            };
            scaledDeviceDim = {480, 833};
        };
        locInstance = testClass();
    end)

    it("Testing Constructor", function()
        local myInstance = testClass();
        myInstance.object.OnClick = {};
        locInstance.object.OnClick = {};
        assert.are.same(locInstance, myInstance);
    end)

    it("Testing create function", function()
        stub(locInstance, "changeLanguage");
        locInstance:create();
        assert.are.equal(locInstance.object.type, "imagebutton");
        assert.are.equal(locInstance.object.text, "");
        assert.are.equal(locInstance.object.imagepath, "assets/gui/480px/path1");
        assert.are.equal(locInstance.object.visible, false);
        
        locInstance.object:OnClick();
        assert.stub(locInstance.changeLanguage).was.called();
    end)

    it("Testing changeLanguage function", function()
        locInstance:changeLanguage();
        assert.are.equal(_G._persTable.config.language, "german");
        assert.are.equal(locInstance.object.imagepath, "assets/gui/480px/path2");
        
        locInstance:changeLanguage();
        assert.are.equal(_G._persTable.config.language, "english");
        assert.are.equal(locInstance.object.imagepath, "assets/gui/480px/path1");
    end)

    it("Testing SetVisible function", function()
        locInstance:SetVisible(true);
        assert.are.equal(locInstance.object.visible, true);
    end)

    it("Testing SetPos function", function()
        locInstance:SetPos(5, 5);
        assert.are.equal(locInstance.object.x, 5);
        assert.are.equal(locInstance.object.y, 5);
    end)
end)
