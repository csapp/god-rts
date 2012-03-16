include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/multipliers.h.lua")
include("LuaUI/Headers/buildings.h.lua")

local GetUnitTeam = Spring.GetUnitTeam
local gaiaTeamID = Spring.GetGaiaTeamID()

Building = Object:Inherit{
    classname = "Building",
    village = nil,
    buildingName = "",
    multipliers = {},
    tooltip = "",
    buildTime = 1,
    cmdDesc = {},
    cmdType = CMD.ICON,
}

function Building:New(village)
    obj = Building.inherited.New(self, {village=village})
    return obj
end

function Building:GetCmdDesc()
    local name = self:GetName()
    return {
        id = self:GetCmdID(),
        name = "Build " .. name,
        action = "building_" .. name,
        type = self.cmdType,
        tooltip = "Build a " .. name .. " in this village",
        params = {},
    }
end

function Building:GetCmdID() 
    local key = self:GetName():upper():gsub(' ', '_')
    return self.cmdID or Buildings.CMD_IDS[key]
end

function Building:GetVillage() return self.village end
function Building:GetBuildTime() return self.buildTime end
function Building:GetUnitID() return self:GetVillage():GetUnitID() end
function Building:GetTeamID() return self:GetVillage():GetTeamID() end
function Building:GetName() return self.buildingName end
function Building:GetInfo() return self.multipliers end
function Building:GetMultipliers() return self.multipliers end
function Building:GetTooltip() return self.tooltip end

function Building:GetTeamID()
    return GetUnitTeam(self:GetUnitID())
end

function Building:Apply()
    local am = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager()
    for key, multiplier in pairs(self:GetMultipliers()) do
        local value, classes = unpack(multiplier)
        Spring.Echo("adding multiplier", key, value, classes)
        am:AddMultiplier(key, value, classes)
    end
end

function Building:Unapply(oldTeam)
    if oldTeam == gaiaTeamID then return end
    local am = _G.TeamManagers[oldTeam]:GetAttributeManager()
    for key, multiplier in pairs(self:GetMultipliers()) do
        local value, classes = unpack(multiplier)
        Spring.Echo("adding multiplier", key, value, classes)
        am:AddMultiplier(key, -value, classes)
    end
end

function Building:Transfer(oldTeam)
    if not table.isempty(self:GetMultipliers()) then
        self:Unapply(oldTeam)
        self:Apply()
    end
end

------------------------------------------------------------
-- SHRINE
------------------------------------------------------------

Shrine = Building:Inherit{
    classname = "Shrine",
    buildingName = "Shrine",
    buildTime = 60,
    multipliers = {
        [Multipliers.TYPES.FAITH] = {2},
        [Multipliers.TYPES.XP] = {0.1, {Units.CLASSES.CLERGY}},
    },
    tooltip = "Provides automatic faith generation and an XP bonus for Clergy",
}

------------------------------------------------------------
-- TURRET
------------------------------------------------------------

Turret = Building:Inherit{
    classname = "Turret",
    buildingName = "Turret",
    buildTime = 5,
    tooltip = "Allows village to attack",
}

function Turret:Apply()
    self:GetVillage():AllowCommand(CMD.ATTACK)
end

function Turret:Unapply(oldTeam) 
    self:GetVillage():DisallowCommand(CMD.ATTACK)
end

------------------------------------------------------------
-- MOTEL
------------------------------------------------------------

Motel = Building:Inherit{
    classname = "Motel",
    buildingName = "Motel",
    buildTime = 5,
    multipliers = {
        [Multipliers.TYPES.VILLAGER] = {1},
    },
    tooltip = "Allows units to sleep to regain health, and increases villager generation rate",
}

function Motel:Apply()
    Motel.inherited.Apply(self)
    self:GetVillage():AllowCommand(CMD.REPAIR)
end

function Motel:Unapply(oldTeam)
    Motel.inherited.Unapply(self, oldTeam)
    self:GetVillage():DisallowCommand(CMD.REPAIR)
end

------------------------------------------------------------
-- HIGH RISE
------------------------------------------------------------

HighRise= Building:Inherit{
    classname = "HighRise",
    buildingName = "High Rise",
    buildTime = 5,
    hpBonus = 500,
    tooltip = "Provides a 500 HP bonus and increases villager cap",
}

function HighRise:GetHPBonus() return self.hpBonus end

function HighRise:Apply()
    local unitID = self:GetUnitID()
    local hpBonus = self:GetHPBonus()
    local health, maxHealth = Spring.GetUnitHealth(unitID)
    Spring.SetUnitMaxHealth(unitID, maxHealth + hpBonus)
    Spring.SetUnitHealth(unitID, health + hpBonus)
end

function HighRise:Unapply(oldTeam)
    local unitID = self:GetUnitID()
    local hpBonus = self:GetHPBonus()
    local health, maxHealth = Spring.GetUnitHealth(unitID)
    Spring.SetUnitMaxHealth(unitID, maxHealth - hpBonus)
    Spring.SetUnitHealth(unitID, health - hpBonus)
end

