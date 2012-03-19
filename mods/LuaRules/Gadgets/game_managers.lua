function gadget:GetInfo()
    return {
        name = "Managers",
        desc = "Gadget to control team managers",
        tickets = "#19",
        author = "cam",
        date = "2012-02-29",
        license = "Public Domain",
        layer = -10000,
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
VFS.Include(MANAGER_DIR .. "unit.lua")


function gadget:Initialize()
    _G.UnitManager = UnitManager:New()

    local TeamManagers = {}
    for _, teamID in pairs(Spring.GetTeamList()) do
        local mgr = TeamManager:New(teamID)
        mgr:Initialize()
        TeamManagers[teamID] = mgr
    end

    _G.TeamManagers = TeamManagers
end

