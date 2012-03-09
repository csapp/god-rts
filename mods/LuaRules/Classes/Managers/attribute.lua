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
    obj:RegisterMultiplier(Multipliers.TYPES.MOVE_SPEED, MoveSpeedMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.ATTACK_SPEED, AttackSpeedMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.ATTACK_RANGE, AttackRangeMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.XP, XPMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.VILLAGER, VillagerMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.POWER_RECHARGE, PowerRechargeMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.CONVERT_TIME, ConvertTimeMultiplier:New(teamID))
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

function AttributeManager:GetAllMultipliers()
    return self:GetElements()
end

function AttributeManager:GetAllValues(unitID)
    -- If unitID is not passed or nil, global values
    -- will be returned
    local values = {}
    for mtype, mult in pairs(self:GetAllMultipliers()) do 
        values[mtype] = mult:GetValue(unitID)
    end
    return values
end

function AttributeManager:GetPowerRechargeMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.POWER_RECHARGE)
end

function AttributeManager:GetConvertTimeMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.CONVERT_TIME)
end

function AttributeManager:GetHealthMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.HEALTH)
end

function AttributeManager:GetMoveSpeedMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.MOVE_SPEED)
end

function AttributeManager:GetAttackSpeedMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.ATTACK_SPEED)
end

function AttributeManager:GetAttackRangeMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.ATTACK_RANGE)
end

function AttributeManager:GetXPMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.XP)
end

function AttributeManager:AddMultiplier(key, m, classes)
    self:GetMultiplier(key):Add(m, classes)
end

function AttributeManager:ApplyPersistentMultipliers(unitID)
    for _, key in pairs(Multipliers.PERSISTENT_TYPES) do
        self:GetMultiplier(key):Apply(unitID)
    end
end

function AttributeManager:AddTimedMultiplier(key, value, duration, classes)
    self:AddMultiplier(key, value, classes)
    GG.Delay.CallLater(duration, self.AddMultiplier, {self, key, -value, classes})
end
