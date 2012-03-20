include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/utilities.lua")

local GetTeamUnits = Spring.GetTeamUnits
local SetUnitMaxHealth = Spring.SetUnitMaxHealth
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitHealth = Spring.SetUnitHealth
local GetUnitDefID = Spring.GetUnitDefID
local SetGroundMoveTypeData = Spring.MoveCtrl.SetGroundMoveTypeData
local GetUnitMoveTypeData = Spring.GetUnitMoveTypeData

------------------------------------------------------------
-- BASE MULTIPLIERS
------------------------------------------------------------

Multiplier = Object:Inherit{
    classname = "Multiplier",
    globalValue = 1,
    teamID = -1,
    classValues = {},
}

function Multiplier:New(teamID)
    local new = {
        teamID = teamID,
    }
    return Multiplier.inherited.New(self, new)
end

function Multiplier:GetTeamID() return self.teamID end

function Multiplier:GetClassValue(class)
    return self.classValues[class] or 0
end

function Multiplier:SetClassValue(class, value)
    self.classValues[class] = value
end

function Multiplier:AddClassValue(class, value)
    local cur = self.classValues[class] or 0
    self:SetClassValue(class, cur+value)
end

function Multiplier:GetGlobalValue()
    return self.globalValue
end

function Multiplier:SetGlobalValue(value)
    self.globalValue = value
end

function Multiplier:AddGlobalValue(value)
    self:SetGlobalValue(self:GetGlobalValue() + value)
end

function Multiplier:Add(value, classes)
    if not classes or table.isempty(classes) then
        self:AddGlobalValue(value)
    else
        for _, class in pairs(classes) do
            self:AddClassValue(class, value)
        end
    end
end

function Multiplier:GetValue(unitID)
    local globalValue = self:GetGlobalValue()
    if not unitID then
        return globalValue
    end

    -- Multipliers should not affect temp units e.g. zombies, volcano
    if Units.IsTempUnit(unitID) then return 1 end

    return globalValue + self:GetClassValue(Units.GetClass(unitID))
end

------------------------------------------------------------
-- EVENT MULTIPLIER
------------------------------------------------------------
EventMultiplier = Multiplier:Inherit{
    classname = "EventMultiplier"
}

------------------------------------------------------------
-- XP MULTIPLIER
------------------------------------------------------------
XPMultiplier = EventMultiplier:Inherit{
    classname = "XPMultiplier"
}

function XPMultiplier:GetFromDamage(victimID, attackerID, weaponID)
    local levelDiff = Units.GetLevel(attackerID) - Units.GetLevel(victimID)
    local levelMult = -0.2*levelDiff
    return self:GetValue(attackerID) + levelMult
end

function XPMultiplier:GetValue(unitID)
    local v = XPMultiplier.inherited.GetValue(self, unitID)
    if not unitID then return v end
    for hero, units in pairs(GG.InfluencedUnits) do
        for _, influencedUnit in pairs(units) do
            if influencedUnit == unitID then
                v = v + 0.2 -- XXX get this value from the influencing hero?
                break
            end
        end
    end
    return v
end
------------------------------------------------------------
-- VILLAGER GENERATION MULTIPLIER
------------------------------------------------------------

VillagerMultiplier = EventMultiplier:Inherit{
    classname = "VillagerMultiplier",
}

function VillagerMultiplier:Add(value)
    VillagerMultiplier.inherited.Add(self, value, {Units.CLASSES.VILLAGE})
end

------------------------------------------------------------
-- POWER RECHARGE RATE MULTIPLIER
------------------------------------------------------------

PowerRechargeMultiplier = EventMultiplier:Inherit{
    classname = "PowerRechargeMultiplier",
}

function PowerRechargeMultiplier:Add(value)
    PowerRechargeMultiplier.inherited.Add(self, value, {Units.CLASSES.GOD})
end

------------------------------------------------------------
-- CONVERT TIME MULTIPLIER
------------------------------------------------------------

ConvertTimeMultiplier =  EventMultiplier:Inherit{
    classname = "ConvertTimeMultiplier",
}

function ConvertTimeMultiplier:Add(value)
    ConvertTimeMultiplier.inherited.Add(self, -value, {Units.CLASSES.CLERGY})
end

------------------------------------------------------------
-- FAITH MULTIPLIER
------------------------------------------------------------

FaithMultiplier =  EventMultiplier:Inherit{
    classname = "FaithMultiplier",
    globalValue = 0,
}

-- ****************************************************** --
-- ****************************************************** --
-- ****************************************************** --

------------------------------------------------------------
-- PERSISTENT MULTIPLIER
------------------------------------------------------------

PersistentMultiplier = Multiplier:Inherit{
    classname = "PersistentMultiplier"
}

function PersistentMultiplier:Apply()
end

function PersistentMultiplier:ApplyToTeam()
    local units = GetTeamUnits(self:GetTeamID())
    for _, unitID in pairs(units) do
        self:Apply(unitID)
    end
end

function PersistentMultiplier:Add(value, classes)
    PersistentMultiplier.inherited.Add(self, value, classes)
    self:ApplyToTeam()
end

------------------------------------------------------------
-- HEALTH
------------------------------------------------------------

HealthMultiplier = PersistentMultiplier:Inherit{
    classname = "HealthMultiplier"
}

function HealthMultiplier:Apply(unitID)
    -- Use original unitdef value so we don't compound multipliers
    local maxHealth = UnitDefs[GetUnitDefID(unitID)].health
    local value = self:GetValue(unitID)
    SetUnitMaxHealth(unitID, maxHealth * value)
    SetUnitHealth(unitID, GetUnitHealth(unitID) * value)
end

------------------------------------------------------------
-- MOVE SPEED
------------------------------------------------------------

MoveSpeedMultiplier = PersistentMultiplier:Inherit{
    classname = "MoveSpeedMultiplier",
}

function MoveSpeedMultiplier:GetValue(unitID)
    if not unitID or UnitDefs[GetUnitDefID(unitID)].canMove then
        return MoveSpeedMultiplier.inherited.GetValue(self, unitID)
    end
end
 
function MoveSpeedMultiplier:Apply(unitID)
    local value = self:GetValue(unitID)

    -- value will be nil if the unit can't move
    if not value then return end

    local origspeed = Units.GetSpeed(unitID)
    if origspeed then 
        SetGroundMoveTypeData(unitID, "maxSpeed", origspeed * value)
    end
end

------------------------------------------------------------
-- ATTACK SPEED
------------------------------------------------------------

AttackSpeedMultiplier = PersistentMultiplier:Inherit{
    classname = "AttackSpeedMultiplier"
}

function AttackSpeedMultiplier:GetValue(unitID)
    if not unitID or UnitDefs[GetUnitDefID(unitID)].canAttack then
        return AttackSpeedMultiplier.inherited.GetValue(self, unitID)
    end
end

function AttackSpeedMultiplier:Add(value, classes)
    AttackSpeedMultiplier.inherited.Add(self, -value, classes)
end

function AttackSpeedMultiplier:Apply(unitID)
    local value = self:GetValue(unitID)
    if not value then return end
    
    local weapons = UnitDefs[GetUnitDefID(unitID)].weapons
    if table.isempty(weapons) then return end
    local attackSpeed = WeaponDefs[weapons[1].weaponDef].reload
    Spring.SetUnitWeaponState(unitID, 0, "reloadTime", attackSpeed*value)
end

------------------------------------------------------------
-- ATTACK RANGE
------------------------------------------------------------
AttackRangeMultiplier = PersistentMultiplier:Inherit{
    classname = "AttackRangeMultiplier"
}

function AttackRangeMultiplier:GetValue(unitID)
    if not unitID or UnitDefs[GetUnitDefID(unitID)].canAttack then
        return AttackRangeMultiplier.inherited.GetValue(self, unitID)
    end
end

function AttackRangeMultiplier:Apply(unitID)
    local value = self:GetValue(unitID)
    if not value then return end
    
    local weapons = UnitDefs[GetUnitDefID(unitID)].weapons
    if table.isempty(weapons) then return end
    local attackRange = WeaponDefs[weapons[1].weaponDef].range
    Spring.SetUnitWeaponState(unitID, 0, "range", attackRange*value)
end
