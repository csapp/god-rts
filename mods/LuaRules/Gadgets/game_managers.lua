function gadget:GetInfo()
    return {
        name = "Managers",
        desc = "Gadget to control team managers",
        tickets = "#19",
        author = "cam",
        date = "2012-02-29",
        license = "Public Domain",
        layer = -100,
        enabled = true,
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (not gadgetHandler:IsSyncedCode()) then
    return false
end

local MANAGER_DIR = "LuaRules/Classes/Managers/"

VFS.Include("LuaRules/Classes/object.lua")
VFS.Include(MANAGER_DIR .. "manager.lua")
VFS.Include(MANAGER_DIR .. "team.lua")


function gadget:Initialize()
    local TeamManagers = {}
    local gaiateamID = Spring.GetGaiaTeamID()
    for _, teamID in pairs(Spring.GetTeamList()) do
        if teamID ~= gaiateamID then
            local mgr = TeamManager:New(teamID)
            mgr:Initialize()
            TeamManagers[teamID] = mgr
        end
    end

    _G.TeamManagers = TeamManagers
end

