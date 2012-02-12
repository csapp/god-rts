
function gadget:GetInfo()
    return {
        name = "God power: teleport",
        desc = "Gadget to control god teleport power",
        tickets = "#19",
        author = "cam",
        date = "2012-02-04",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

include("LuaRules/Includes/customcmds.h.lua")
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc

local teleportCmd = {
      id      = CMD_TELEPORT,
      name    = "Teleport",
      action  = "teleport",
      type    = CMDTYPE.ICON_MAP,
      tooltip = "Teleport to another location on the map",
      params = {},
}

local god_unitdef_id = UnitDefNames["god"].id

function gadget:Initialize()
    gadgetHandler:RegisterCMDID(CMD_TELEPORT)
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if unitDefID == god_unitdef_id then
        InsertUnitCmdDesc(unitID, CMD_TELEPORT, teleportCmd)
    end
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if cmdID ~= CMD_TELEPORT then
        return false
    end

    local destX, destY, destZ = cmdParams[1], cmdParams[2], cmdParams[3]
    local curX, curY, curZ = Spring.GetUnitBasePosition(unitID)
    Spring.SpawnCEG("whitesmoke", curX, curY, curZ)
    Spring.SetUnitPosition(unitID, destX, destY, destZ)
    Spring.SpawnCEG("whitesmoke", destX, destY, destZ)

    -- XXX is this synced?
    Spring.PlaySoundFile("sounds/teleport.wav")
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------

return false

end
