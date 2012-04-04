include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/managers.h.lua")
include("LuaRules/Tests/unittest.lua")
include("LuaRules/Classes/Managers/supply.lua")

SupplyMgrTest = UnitTest:Inherit{
    classname = "SupplyMgrTest"
}

local manager
local teamID = 0

function SupplyMgrTest:Setup()
    manager = _G.TeamManagers[teamID]:GetSupplyManager()
end

function SupplyMgrTest:Teardown()
    _G.TeamManagers[teamID]:AddElement(Managers.TYPES.SUPPLY, SupplyManager:New(teamID))
    manager = nil
end

function SupplyMgrTest:TestGetSupplyCap()
    -- Team starts with one small village
    local orig = tonumber(UnitDefNames["smallvillage"].customParams.supply_cap)
    local expected = orig
    assert_equal(expected, manager:GetSupplyCap())

    local newVillage = Spring.CreateUnit("smallvillage", 0,0,0, 0, teamID)
    local added = tonumber(UnitDefNames["smallvillage"].customParams.supply_cap)
    expected = expected + added
    assert_equal(expected, manager:GetSupplyCap())
    Spring.DestroyUnit(newVillage)

    newVillage = Spring.CreateUnit("mediumvillage", 0,0,0, 0, teamID)
    expected = expected + tonumber(UnitDefNames["mediumvillage"].customParams.supply_cap)
    assert_equal(expected, manager:GetSupplyCap())
    Spring.DestroyUnit(newVillage)

    newVillage = Spring.CreateUnit("largevillage", 0,0,0, 0, teamID)
    expected = expected + tonumber(UnitDefNames["largevillage"].customParams.supply_cap)
    assert_equal(expected, manager:GetSupplyCap())
    Spring.DestroyUnit(newVillage)

    -- XXX Verify that the team supply cap goes to back to 100 by inspection
    -- Can't automate it because Spring.DestroyUnit doesn't take effect
    -- immediately, and can't delay the call because manager gets set to nil
    -- in Teardown()
end

function SupplyMgrTest:TestUseReturnSupplies()
    assert_equal(manager:GetUsedSupplies(), 0)
    local soldierID = UnitDefNames["soldier"].id
    manager:ReturnSupplies(soldierID)
    assert_equal(manager:GetUsedSupplies(), 0)
    manager:UseSupplies(soldierID)
    assert_equal(manager:GetUsedSupplies(), manager:GetSupplyCost(soldierID))
    manager:UseSupplies(soldierID)
    assert_equal(manager:GetUsedSupplies(), 2*manager:GetSupplyCost(soldierID))
    manager:ReturnSupplies(soldierID)
    assert_equal(manager:GetUsedSupplies(), manager:GetSupplyCost(soldierID))
end

function SupplyMgrTest:TestUseTooManySupplies()
    local archerID = UnitDefNames["archer"].id
    local vSupplyCap = tonumber(UnitDefNames["smallvillage"].customParams.supply_cap)
    for i=1,math.floor(vSupplyCap/tonumber(UnitDefNames["archer"].customParams.supply_cost)) do
        manager:UseSupplies(archerID)
    end
    local cap = manager:GetSupplyCap()
    assert_equal(manager:CanUse(archerID), false)
    manager:UseSupplies(archerID)
    assert_equal(cap, manager:GetSupplyCap())
end

return SupplyMgrTest

