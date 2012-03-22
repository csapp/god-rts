
function gadget:GetInfo()
    return {
        name = "Supply handler",
        desc = "Handles supplies and supply caps for teams",
        author = "cam",
        tickets = "#150",
        date = "March 20, 2012",
        license = "Public Domain",
        layer = -1,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (not gadgetHandler:IsSyncedCode()) then
    return false
end

include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/units.h.lua")

local SupplyManagers = {}
local exemptClasses = {
    Units.CLASSES.VILLAGE,
    Units.CLASSES.GOD,
}

function gadget:Initialize()
    for _, teamID in pairs(Spring.GetTeamList()) do
        SupplyManagers[teamID] = _G.TeamManagers[teamID]:GetSupplyManager()
    end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    -- Build commands are negative with cmdID = -unitDefID
    if cmdID < 0 then
        local sm = SupplyManagers[teamID]
        return sm:CanUse(-cmdID)
    end
    return true
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
    if table.contains(exemptClasses, Units.GetClass(unitID)) or Units.IsTempUnit(unitID) then
        return
    end

    local sm = SupplyManagers[teamID]
    sm:UseSupplies(unitDefID)
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, aID, adefID, ateamID)
    if table.contains(exemptClasses, Units.GetClass(unitID)) or Units.IsTempUnit(unitID) then
        return
    end
    SupplyManagers[teamID]:ReturnSupplies(unitDefID)
end

function gadget:AllowUnitCreation(unitDefID, builderID, teamID)
    return SupplyManagers[teamID]:CanUse(unitDefID)
end

