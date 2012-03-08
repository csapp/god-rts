include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/utilities.lua")

local GetTeamUnits = Spring.GetTeamUnits
local SetUnitMaxHealth = Spring.SetUnitMaxHealth
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitHealth = Spring.SetUnitHealth
local GetUnitDefID = Spring.GetUnitDefID

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
    if table.contains(Units.CLASSES, class) then
        self.classValues[class] = value
    end
end

function Multiplier:AddClassValue(class, value)
    local cur = self.classValues[class] or 0
    self.classValues[class] = cur + value
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

    return globalValue + self:GetClassValue(Units.GetClass(unitID))
end
------------------------------------------------------------
-- EVENT MULTIPLIERS
------------------------------------------------------------
EventMultiplier = Multiplier:Inherit{
    classname = "EventMultiplier"
}

XPMultiplier = EventMultiplier:Inherit{
    classname = "XPMultiplier"
}

function XPMultiplier:GetFromDamage(victimID, attackerID, weaponID)
    local levelDiff = Units.GetLevel(attackerID) - Units.GetLevel(victimID)
    local levelMult = -0.2*levelDiff
    return self:GetValue() + levelMult
end

------------------------------------------------------------
-- PERSISTENT MULTIPLIERS
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
