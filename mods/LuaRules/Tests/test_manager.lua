include("LuaRules/Tests/unittest.lua")
include("LuaRules/Classes/Managers/manager.lua")

ManagerTest = UnitTest:Inherit{
    classname = "ManagerTest"
}

local manager

function ManagerTest:Setup()
    manager = Manager:New(0)
end

function ManagerTest:Teardown()
    manager = nil
end

function ManagerTest:TestConstructor()
    assert(manager:GetTeamID()==0)
end

function ManagerTest:TestAddElement()
    elem = {2,4}
    key = "e"
    manager:AddElement(key, elem)
    assert(manager:GetElement(key)==elem)
end

function ManagerTest:TestCallOnAll()
    local function echo(self, x) return x end
    local function echo2(self, x) return x*2 end
    local function echo3(self, x) return x*3 end
    local elem1={echo=echo}
    local elem2={echo=echo2}
    local elem3={echo=echo3}
    manager:AddElement("elem1", elem1)
    manager:AddElement("elem2", elem2)
    manager:AddElement("elem3", elem3)
    local expected = {
        elem1= 3,
        elem2= 6,
        elem3= 9,
    }
    actual = manager:CallOnAll("echo", {3})
    local count = 0
    for k,v in pairs(actual) do
        count = count + 1
        assert(actual[k]==expected[k])
    end
    assert(count==3)
end


return ManagerTest
