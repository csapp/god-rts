
function gadget:GetInfo()
    return {
        name = "Unit XP handler",
        desc = "Gadget to handle unit XP and leveling up",
        author = "cam",
        date = "2012-01-25",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

local morphing = {}

-- Based on a morphing function written by trepan in Expand and Exterminate (unit_morph) 
local function Morph(unitID, morphInto, teamID)
    morphing[unitID] = 1
    local myX, myY, myZ = Spring.GetUnitBasePosition(unitID)
    local newUnitID = Spring.CreateUnit(morphInto, myX, myY, myZ, 0, teamID)

    -- Copy command queue
    local myCmds = Spring.GetUnitCommands(unitID)
    for i = 1, myCmds.n do
        local cmd = myCmds[i]
        Spring.GiveOrderToUnit(newUnitID, cmd.id, cmd.params, cmd.options.coded)
    end

    -- Copy unit's states
    local states = Spring.GetUnitStates(unitID)
    Spring.GiveOrderArrayToUnitArray({ newUnitID }, {
        { CMD.FIRE_STATE, { states.firestate },             {} },
        { CMD.MOVE_STATE, { states.movestate },             {} },
        { CMD.REPEAT,     { states['repeat']  and 1 or 0 }, {} },
        { CMD.CLOAK,      { states.cloak      and 1 or 0 }, {} },
        { CMD.ONOFF,      { 1 }, {} },
        { CMD.TRAJECTORY, { states.trajectory and 1 or 0 }, {} },
    })

    -- Make new unit face in the same direction
    local h = Spring.GetUnitHeading(unitID)
    Spring.SetUnitRotation(newUnitID, 0, -h * math.pi / 32768, 0)

    SendToUnsynced("unit_morph_finished", unitID, newUnitID)
    Spring.SpawnCEG("blacksmoke", myX, myY, myZ)
    Spring.SpawnCEG("levelup", myX, myY, myZ)
    Spring.DestroyUnit(unitID, false, true)
    morphing[unitID] = nil 
end

local function AddXP(unitID, unitDefID, teamID)
    local curXP = Spring.GetUnitExperience(unitID)
    curXP = curXP + 1
    Spring.SetUnitExperience(unitID, curXP)
    local unitDef = UnitDefs[unitDefID]
    local max_xp = tonumber(unitDef.customParams.max_xp)
    if max_xp and curXP >= max_xp and not morphing[unitID] then
        Morph(unitID, unitDef.customParams.morph_into, teamID)
        return
    end
    Spring.Echo("Unit XP at " .. curXP)
end

function gadget:UnitCmdDone(unitID, unitDefID, teamID, cmdID, cmdTag) -- XXX For testing
    AddXP(unitID, unitDefID, teamID)
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------

function SelectSwap(cmd, oldID, newID)
    local selUnits = Spring.GetSelectedUnits()
    for i, unitID in ipairs(selUnits) do
        if (unitID == oldID) then
            selUnits[i] = newID
            Spring.SelectUnitArray(selUnits)
            return true
        end
    end
end

function gadget:Initialize()
    gadgetHandler:AddSyncAction("unit_morph_finished", SelectSwap)
end

function gadget:Shutdown()
    gadgetHandler:RemoveSyncAction("unit_morph_finished")
end

end
