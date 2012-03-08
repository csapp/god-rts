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


function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    local attrManager = _G.TeamManagers[unitTeam]:GetAttributeManager()
    attrManager:ApplyPersistentMultipliers(unitID)
end

