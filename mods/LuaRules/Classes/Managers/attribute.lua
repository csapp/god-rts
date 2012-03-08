include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/multipliers.h.lua")
include("LuaRules/Classes/UnitMods/multipliers.lua")

local GetTeamUnits = Spring.GetTeamUnits
local SetUnitMaxHealth = Spring.SetUnitMaxHealth
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitHealth = Spring.SetUnitHealth
local GetUnitDefID = Spring.GetUnitDefID

AttributeManager = Manager:Inherit{
    classname = "AttributeManager",
}

local this = AttributeManager
local inherited = this.inherited

function AttributeManager:New(teamID)
    obj = inherited.New(self, teamID)

    obj:RegisterMultiplier(Multipliers.TYPES.HEALTH, HealthMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.XP, XPMultiplier:New(teamID))
    return obj
end

function AttributeManager:RegisterMultiplier(key, mult)
    if not self.elements[key] then
        self:AddElement(key, mult)
    end
end

function AttributeManager:GetMultiplier(key)
    return self:GetElement(key)
end

function AttributeManager:GetHealthMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.HEALTH)
end

function AttributeManager:GetXPMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.XP)
end

function AttributeManager:AddMultiplier(key, m, classes)
    self:GetMultiplier(key):Add(m, classes)
end

--function AttributeManager:AddHealthMultiplier(m)
    --self:AddMultiplier(Multipliers.TYPES.HEALTH, m)
--end

function AttributeManager:ApplyPersistentMultipliers(unitID)
    self:GetHealthMultiplier():Apply(unitID)
end

function AttributeManager:AddTimedMultiplier(key, value, duration, classes)
    self:AddMultiplier(key, value, classes)
    GG.Delay.CallLater(duration, self.AddMultiplier, {self, key, -value, classes})
end
