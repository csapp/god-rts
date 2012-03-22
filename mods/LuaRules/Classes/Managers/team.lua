local function GetInfo()
    return {
        name = "Team Manager",
        desc = "'Meta' manager that is an entry point to access other managers",
        tickets = "#161",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

include("LuaUI/Headers/managers.h.lua")

local MANAGER_DIR = "LuaRules/Classes/Managers/"

VFS.Include(MANAGER_DIR .. "power.lua")
VFS.Include(MANAGER_DIR .. "attribute.lua")
VFS.Include(MANAGER_DIR .. "supply.lua")

TeamManager = Manager:Inherit{
    classname = "TeamManager",
}

local this = TeamManager
local inherited = this.inherited

function TeamManager:GetPowerManager()
    return self:GetElement(Managers.TYPES.POWER)
end

function TeamManager:GetSupplyManager()
    return self:GetElement(Managers.TYPES.SUPPLY)
end

function TeamManager:GetAttributeManager()
    return self:GetElement(Managers.TYPES.ATTRIBUTE)
end

function TeamManager:Initialize()
    local teamID = self:GetTeamID()
    self:AddElement(Managers.TYPES.POWER, PowerManager:New(teamID))
    self:AddElement(Managers.TYPES.ATTRIBUTE, AttributeManager:New(teamID))
    self:AddElement(Managers.TYPES.SUPPLY, SupplyManager:New(teamID))
end

