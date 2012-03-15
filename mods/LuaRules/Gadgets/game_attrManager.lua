function gadget:GetInfo()
    return {
        name = "Attribute manager",
        desc = "Gadget to control attribute managers",
        author = "cam",
        date = "2012-02-29",
        license = "Public Domain",
        layer = 0,
        enabled = true,
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (not gadgetHandler:IsSyncedCode()) then
    return false
end

local TeamManagers
local gaiaID = Spring.GetGaiaTeamID()

function gadget:Initialize()
    TeamManagers = _G.TeamManagers
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if unitTeam == gaiaID then return end
    local am = TeamManagers[unitTeam]:GetAttributeManager()
    am:ApplyPersistentMultipliers(unitID)
end

