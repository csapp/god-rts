
function gadget:GetInfo()
    return {
        name = "Unit XP handler",
        desc = "Gadget to handle unit XP and leveling up",
        tickets = "#37, #41",
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

include("LuaRules/Includes/utilities.lua")
include("LuaRules/Includes/msgs.h.lua")

-- Speed ups
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitHealth = Spring.GetUnitHealth
local GetUnitExperience = Spring.GetUnitExperience
local SetUnitExperience = Spring.SetUnitExperience

--local DEBUG = 1
local VILLAGE_IDS = {UnitDefNames["smallvillage"].id,
                     UnitDefNames["mediumvillage"].id,
                     UnitDefNames["largevillage"].id}

-- Based on a morphing function written by trepan in Expand and Exterminate (unit_morph) 
local function Morph(unitID, morphInto, teamID)
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
end

local function AddXP(unitID, xp)
    local unitDefID = GetUnitDefID(unitID)
    local teamID = GetUnitTeam(unitID)
    if unitDefID == nil or teamID == nil then return end

    local curXP = GetUnitExperience(unitID)
    local unitDef = UnitDefs[unitDefID]
    local max_xp = tonumber(unitDef.customParams.max_xp)
    if not max_xp or curXP >= max_xp then
        return
    end
    curXP = curXP + xp 
    SetUnitExperience(unitID, curXP)
    if DEBUG then Spring.Echo("Unit XP at " .. curXP) end
    if max_xp and curXP >= max_xp then
        Morph(unitID, unitDef.customParams.morph_into, teamID)
        return
    end
end

function gadget:UnitDamaged(unitID, unitDefID, teamID, damage, paralyzer,
                            weaponID, attackerID)
    if attackerID == nil or attackerID < 0 then return end
    AddXP(attackerID, damage)
end

function gadget:UnitFromFactory(unitID, unitDefID, unitTeam, builderID, builderDefID, _)
    if not builderID then return end
    if not table.contains(VILLAGE_IDS, builderDefID) then
        return 
    end
    local _, max_health = GetUnitHealth(unitID)
    AddXP(builderID, max_health/10)
end

function gadget:RecvLuaMsg(msg, playerID)
    msg = split(msg, ",")
    local msg_type = msg[1]
    if msg_type == MSGS.CONVERT_FINISHED then
        local clergyID = tonumber(msg[2])
        local xp_gained = 500 -- XXX
        GG.Delay.DelayCall(AddXP, {clergyID, xp_gained})

    end
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
