local function GetInfo()
    return {
        name = "Attribute Manager",
        desc = "Manager to keep track of multipliers",
        tickets = "#132",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

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

    obj:RegisterMultiplier(Multipliers.TYPES.DAMAGE, DamageMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.XP, XPMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.VILLAGER, VillagerMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.POWER_RECHARGE, PowerRechargeMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.CONVERT_TIME, ConvertTimeMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.FAITH, FaithMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.BUILDING_TIME, BuildingTimeMultiplier:New(teamID))
    obj:RegisterMultiplier(Multipliers.TYPES.SUPPLY_CAP, SupplyCapMultiplier:New(teamID))
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

function AttributeManager:GetBuildingTimeMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.BUILDING_TIME)
end

function AttributeManager:GetSupplyCapMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.SUPPLY_CAP)
end

function AttributeManager:GetDamageMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.DAMAGE)
end

function AttributeManager:GetFaithMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.FAITH)
end

function AttributeManager:GetPowerRechargeMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.POWER_RECHARGE)
end

function AttributeManager:GetConvertTimeMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.CONVERT_TIME)
end

function AttributeManager:GetVillagerMultiplier()
    return self:GetMultiplier(Multipliers.TYPES.VILLAGER)
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
