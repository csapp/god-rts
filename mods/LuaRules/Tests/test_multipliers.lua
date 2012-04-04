include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/managers.h.lua")
include("LuaUI/Headers/multipliers.h.lua")
include("LuaRules/Tests/unittest.lua")
include("LuaRules/Classes/Managers/attribute.lua")

MultiplierTest = UnitTest:Inherit{
    classname = "MultiplierTest"
}

local manager
local teamID = 0

function MultiplierTest:Setup()
    manager = _G.TeamManagers[teamID]:GetAttributeManager()
end

function MultiplierTest:Teardown()
    _G.TeamManagers[teamID]:AddElement(Managers.TYPES.ATTRIBUTE, AttributeManager:New(teamID))
    manager = nil
end

function MultiplierTest:TestHealthMultiplier()
    local hp, maxhp
    local mult = manager:GetHealthMultiplier()
    assert_equal(mult:GetValue(), 1)

    local health = {}
    for _, unitID in pairs(Spring.GetTeamUnits(teamID)) do
        hp, maxhp = Spring.GetUnitHealth(unitID)
        health[unitID] = {hp=hp, maxhp=maxhp}
    end
    manager:AddMultiplier(Multipliers.TYPES.HEALTH, 1)
    assert_equal(mult:GetValue(), 2)
    for _, unitID in pairs(Spring.GetTeamUnits(teamID)) do
        hp, maxhp = Spring.GetUnitHealth(unitID)
        assert_equal(math.floor(hp), math.floor(health[unitID].hp*2))
        assert_equal(math.floor(maxhp), math.floor(health[unitID].maxhp*2))
    end

    local soldierID = Spring.CreateUnit("soldier", 0,0,0, 0, teamID)
    local soldierUDhp = UnitDefNames["soldier"].health
    local soldierhp, soldiermaxhp = Spring.GetUnitHealth(soldierID)

    assert_equal(math.floor(soldiermaxhp), math.floor(soldierUDhp*2))

    --Clean up
    Spring.DestroyUnit(soldierID)
    manager:AddMultiplier(Multipliers.TYPES.HEALTH, -1)
end

function MultiplierTest:TestMultiplierClasses()
    manager:AddMultiplier(Multipliers.TYPES.HEALTH, 1, {Units.CLASSES.INFANTRY})

    local id = Spring.CreateUnit("horseman", 0,0,0, 0, teamID)
    local udMaxHP = UnitDefNames["horseman"].health
    local hp, maxhp = Spring.GetUnitHealth(id)
    assert_equal(math.floor(maxhp), math.floor(udMaxHP))
    Spring.DestroyUnit(id)

    local id = Spring.CreateUnit("archer", 0,0,0, 0, teamID)
    local udMaxHP = UnitDefNames["archer"].health
    local hp, maxhp = Spring.GetUnitHealth(id)
    assert_equal(math.floor(maxhp), math.floor(udMaxHP))
    Spring.DestroyUnit(id)

    local id = Spring.CreateUnit("priest", 0,0,0, 0, teamID)
    local udMaxHP = UnitDefNames["priest"].health
    local hp, maxhp = Spring.GetUnitHealth(id)
    assert_equal(math.floor(maxhp), math.floor(udMaxHP))
    Spring.DestroyUnit(id)

    local id = Spring.CreateUnit("god", 0,0,0, 0, teamID)
    local udMaxHP = UnitDefNames["god"].health
    local hp, maxhp = Spring.GetUnitHealth(id)
    assert_equal(math.floor(maxhp), math.floor(udMaxHP))
    Spring.DestroyUnit(id)

    local soldierID = Spring.CreateUnit("soldier", 0,0,0, 0, teamID)
    local soldierUDhp = UnitDefNames["soldier"].health
    local soldierhp, soldiermaxhp = Spring.GetUnitHealth(soldierID)
    assert_equal(math.floor(soldiermaxhp), math.floor(soldierUDhp*2))
    Spring.DestroyUnit(soldierID)

    --Clean up
    manager:AddMultiplier(Multipliers.TYPES.HEALTH, -1, {Units.CLASSES.INFANTRY})
end

function MultiplierTest:TestMultiplierTempUnits()
    -- Multipliers shouldn't affect temp units (e.g. zombie, volcano)
    local id = Spring.CreateUnit("zombie", 0,0,0, 0, teamID)
    local udMaxHP = UnitDefNames["zombie"].health
    local hp, maxhp = Spring.GetUnitHealth(id)
    assert_equal(math.floor(maxhp), math.floor(udMaxHP))

    manager:AddMultiplier(Multipliers.TYPES.HEALTH, 1, {Units.CLASSES.INFANTRY})

    hp, maxhp = Spring.GetUnitHealth(id)
    assert_equal(math.floor(maxhp), math.floor(udMaxHP))
    Spring.DestroyUnit(id)

    local id = Spring.CreateUnit("zombie", 0,0,0, 0, teamID)
    hp, maxhp = Spring.GetUnitHealth(id)
    assert_equal(math.floor(maxhp), math.floor(udMaxHP))
    Spring.DestroyUnit(id)
end

function MultiplierTest:TestAttackSpeedMultiplier()
    local mult = manager:GetAttackSpeedMultiplier()
    assert_equal(mult:GetValue(), 1)

    local speed = {}
    for _, unitID in pairs(Spring.GetTeamUnits(teamID)) do
        if UnitDefs[Spring.GetUnitDefID(unitID)].canAttack then
            speed[unitID] = Spring.GetUnitWeaponState(unitID, 0, "reloadTime")
        end
    end
    manager:AddMultiplier(Multipliers.TYPES.ATTACK_SPEED, 0.5)
    -- Attack speed is really reloadTime, so adding multipliers lessens the value
    assert_equal(mult:GetValue(), 0.5)

    for _, unitID in pairs(Spring.GetTeamUnits(teamID)) do
        local aspeed = Spring.GetUnitWeaponState(unitID, 0, "reloadTime")
        if aspeed and not Units.IsTempUnit(unitID) then
            assert_equal(math.floor(aspeed), math.floor(speed[unitID]*0.5))
        end
    end

    local soldierID = Spring.CreateUnit("soldier", 0,0,0, 0, teamID)
    local aspeed = Spring.GetUnitWeaponState(soldierID, 0, "reloadTime")
    local udSpeed = WeaponDefs[UnitDefNames["soldier"].weapons[1].weaponDef].reload

    assert_equal(math.floor(aspeed), math.floor(udSpeed*0.5))

    --Clean up
    Spring.DestroyUnit(soldierID)
    manager:AddMultiplier(Multipliers.TYPES.ATTACK_SPEED, -0.5)
end

function MultiplierTest:TestAttackRangeMultiplier()
    local mult = manager:GetAttackRangeMultiplier()
    assert_equal(mult:GetValue(), 1)

    local range = {}
    for _, unitID in pairs(Spring.GetTeamUnits(teamID)) do
        if UnitDefs[Spring.GetUnitDefID(unitID)].canAttack then
            range[unitID] = Spring.GetUnitWeaponState(unitID, 0, "range")
        end
    end
    manager:AddMultiplier(Multipliers.TYPES.ATTACK_RANGE, 1)
    assert_equal(mult:GetValue(), 2)

    for _, unitID in pairs(Spring.GetTeamUnits(teamID)) do
        local arange = Spring.GetUnitWeaponState(unitID, 0, "range")
        if arange and not Units.IsTempUnit(unitID) then
            assert_equal(math.floor(arange), math.floor(range[unitID]*2))
        end
    end

    local soldierID = Spring.CreateUnit("soldier", 0,0,0, 0, teamID)
    local arange = Spring.GetUnitWeaponState(soldierID, 0, "range")
    local udrange = WeaponDefs[UnitDefNames["soldier"].weapons[1].weaponDef].range

    assert_equal(math.floor(arange), math.floor(udrange*2))

    --Clean up
    Spring.DestroyUnit(soldierID)
    manager:AddMultiplier(Multipliers.TYPES.ATTACK_RANGE, -1)
end

return MultiplierTest

