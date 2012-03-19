local MANAGER_DIR = "LuaRules/Classes/Managers/"

VFS.Include(MANAGER_DIR .. "power.lua")
VFS.Include(MANAGER_DIR .. "attribute.lua")
VFS.Include(MANAGER_DIR .. "supply.lua")

TeamManager = Manager:Inherit{
    classname = "TeamManager",
}

TeamManager.MANAGER_IDS = {
    POWER = "power",
    ATTRIBUTE = "attribute",
    SUPPLY = "supply",
}

local this = TeamManager
local inherited = this.inherited


function TeamManager:GetPowerManager()
    return self:GetElement(self.MANAGER_IDS.POWER)
end

function TeamManager:GetSupplyManager()
    return self:GetElement(self.MANAGER_IDS.SUPPLY)
end

function TeamManager:GetAttributeManager()
    return self:GetElement(self.MANAGER_IDS.ATTRIBUTE)
end

function TeamManager:Initialize()
    local teamID = self:GetTeamID()
    self:AddElement(self.MANAGER_IDS.POWER, PowerManager:New(teamID))
    self:AddElement(self.MANAGER_IDS.ATTRIBUTE, AttributeManager:New(teamID))
    self:AddElement(self.MANAGER_IDS.SUPPLY, SupplyManager:New(teamID))
end

