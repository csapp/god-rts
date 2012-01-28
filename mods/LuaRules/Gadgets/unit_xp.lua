local maxXP = {
    warrior = 5,
    priest = 10,
}

-- XXX until we get some more units in game
local morph = {
    warrior = "priest",
    priest = "warrior",
}

local morphing = {}

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

-- Based on a morphing function written by trepan in Expand and Exterminate (unit_morph) 
local function Morph(unitID, unitDefName, teamID)
    morphing[unitID] = 1
    local myX, myY, myZ = Spring.GetUnitBasePosition(unitID)
    local newUnitID = Spring.CreateUnit(morph[unitDefName], myX, myY, myZ, 0, teamID)

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
    morphing[unitID] = 0
end

function gadget:UnitCmdDone(unitID, unitDefID, teamID, cmdID, cmdTag)
    local curXP = Spring.GetUnitExperience(unitID)
    curXP = curXP + 1
    Spring.SetUnitExperience(unitID, curXP)
    local unitDefName = UnitDefs[unitDefID].name
    if curXP >= maxXP[unitDefName] and not morphing[unitID] then
        Morph(unitID, unitDefName, teamID)
        return
    end
    Spring.Echo("Unit XP at " .. curXP)
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
