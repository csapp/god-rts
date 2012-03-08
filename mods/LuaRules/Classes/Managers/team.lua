local MANAGER_DIR = "LuaRules/Classes/Managers/"

VFS.Include(MANAGER_DIR .. "power.lua")
VFS.Include(MANAGER_DIR .. "attribute.lua")

TeamManager = Manager:Inherit{
    classname = "TeamManager",
}

TeamManager.MANAGER_IDS = {
    POWER = "power",
    ATTRIBUTE = "attribute",
}

local this = TeamManager
local inherited = this.inherited

function TeamManager:AddPowerManager()
    local manager = PowerManager:New(self:GetTeamID())
    self:AddElement(self.MANAGER_IDS.POWER, manager)
end

function TeamManager:GetPowerManager()
    return self:GetElement(self.MANAGER_IDS.POWER)
end

function TeamManager:AddAttributeManager()
    local manager = AttributeManager:New(self:GetTeamID())
    self:AddElement(self.MANAGER_IDS.ATTRIBUTE, manager)
end

function TeamManager:GetAttributeManager()
    return self:GetElement(self.MANAGER_IDS.ATTRIBUTE)
end

function TeamManager:Initialize()
    self:AddAttributeManager()
    self:AddPowerManager()
end

