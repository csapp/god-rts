include("LuaUI/Headers/multipliers.h.lua")

local GetUnitTeam = Spring.GetUnitTeam
local gaiaTeamID = Spring.GetGaiaTeamID()

Building = Object:Inherit{
    classname = "Building",
    village = nil,
    buildingName = "",
    info = {}, -- Contains multipliers, unitmods, etc.
    tooltip = "",
    buildTime = 1,
}

function Building:New(village)
    obj = Building.inherited.New(self, {village=village})
    return obj
end

function Building:GetBuildTime() return self.buildTime end
function Building:GetUnitID() return self.village:GetUnitID() end
function Building:GetTeamID() return self.village:GetTeamID() end
function Building:GetName() return self.buildingName end
function Building:GetInfo() return self.info end
function Building:GetTooltip() return self.tooltip end

function Building:GetTeamID()
    return GetUnitTeam(self:GetUnitID())
end

function Building:Apply()
    local am = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager()
    local info = self:GetInfo()
    for key, multiplier in pairs(info.multipliers) do
        local value, classes = unpack(multiplier)
        Spring.Echo("adding multiplier", key, value, classes)
        am:AddMultiplier(key, value, classes)
    end
end

function Building:Unapply(oldTeam)
    if oldTeam == gaiaTeamID then return end
    local am = _G.TeamManagers[oldTeam]:GetAttributeManager()
    local info = self:GetInfo()
    for key, multiplier in pairs(info.multipliers) do
        local value, classes = unpack(multiplier)
        Spring.Echo("adding multiplier", key, value, classes)
        am:AddMultiplier(key, -value, classes)
    end
end

function Building:Transfer(oldTeam)
    self:Unapply(oldTeam)
    self:Apply()
end

Shrine = Building:Inherit{
    classname = "Shrine",
    buildingName = "Shrine",
    buildTime = 5,
    info = {
        multipliers = {
            --[Multipliers.TYPES.FAITH] = {0.1, {}},
            [Multipliers.TYPES.XP] = {0.1, {"clergy"}},
        }
    },
    tooltip = "Provides automatic faith generation and an XP bonus for Clergy",
}

