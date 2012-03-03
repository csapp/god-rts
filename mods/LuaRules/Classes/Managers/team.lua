local MANAGER_DIR = "LuaRules/Classes/Managers/"

VFS.Include(MANAGER_DIR .. "power.lua")
VFS.Include(MANAGER_DIR .. "bonus.lua")

TeamManager = Manager:Inherit{
    classname = "TeamManager",
}

TeamManager.MANAGER_IDS = {
    POWER = "power",
    BONUS = "bonus",
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

function TeamManager:AddBonusManager()
    local manager = BonusManager:New(self:GetTeamID())
    self:AddElement(self.MANAGER_IDS.BONUS, manager)
end

function TeamManager:GetBonusManager()
    return self:GetElement(self.MANAGER_IDS.BONUS)
end

function TeamManager:Initialize()
    self:AddBonusManager()
    self:AddPowerManager()
end

