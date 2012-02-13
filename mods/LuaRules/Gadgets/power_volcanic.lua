
function gadget:GetInfo()
    return {
        name = "God power: Volcanic Blast",
        desc = "Gadget to control god volcanic blast power",
        tickets = "#18",
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

-- Speed ups
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local AddUnitDamage = Spring.AddUnitDamage

local god_unitdef_id = UnitDefNames["god"].id

function gadget:Initialize()
    gadgetHandler:RegisterCMDID(CMD_VOLCANIC_BLAST)
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if cmdID ~= CMD_VOLCANIC_BLAST then
        return false
    end

    local center_x, center_y, center_z = cmdParams[1], cmdParams[2], cmdParams[3]
    local radius = 200 -- XXX
    local affected_units = Spring.GetUnitsInSphere(center_x, center_y, center_z, radius)
    Spring.SpawnCEG("flames", center_x, center_y, center_z)
    Spring.PlaySoundFile("sounds/cannonshot.wav")
    local damage = 400 -- XXX
    for _, affected_unit in pairs(affected_units) do
        if Spring.GetUnitTeam(affected_unit) ~= teamID then
            AddUnitDamage(affected_unit, damage, 0, unitID)
        end
    end
    -- play a sound
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------

return false

end
