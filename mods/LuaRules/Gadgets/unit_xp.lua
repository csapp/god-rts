
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

include("LuaUI/Headers/msgs.h.lua")
include("LuaUI/Headers/units.h.lua")

-- Speed ups
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitHealth = Spring.GetUnitHealth
local GetUnitExperience = Spring.GetUnitExperience
local SetUnitExperience = Spring.SetUnitExperience

--local DEBUG = 1
--
local xpMultipliers = {}

-- Based on a morphing function written by trepan in Expand and Exterminate (unit_morph) 
local function Morph(unitID, noCopyCmds, noCopyStates)--, morphInto, teamID)
    local morphInto = UnitDefs[GetUnitDefID(unitID)].customParams.morph_into
    local teamID = GetUnitTeam(unitID)
    local myX, myY, myZ = Spring.GetUnitBasePosition(unitID)
    local newUnitID = Spring.CreateUnit(morphInto, myX, myY, myZ, 0, teamID)

    -- Copy command queue
    if not noCopyCmds then
        local myCmds = Spring.GetUnitCommands(unitID)
        for i = 1, #myCmds do
            local cmd = myCmds[i]
            Spring.GiveOrderToUnit(newUnitID, cmd.id, cmd.params, cmd.options.coded)
        end
    end

    -- Copy unit's states
    if not noCopyStates then 
        local states = Spring.GetUnitStates(unitID)
        Spring.GiveOrderArrayToUnitArray({ newUnitID }, {
            { CMD.FIRE_STATE, { states.firestate },             {} },
            { CMD.MOVE_STATE, { states.movestate },             {} },
            { CMD.REPEAT,     { states['repeat']  and 1 or 0 }, {} },
            { CMD.CLOAK,      { states.cloak      and 1 or 0 }, {} },
            { CMD.ONOFF,      { 1 }, {} },
            { CMD.TRAJECTORY, { states.trajectory and 1 or 0 }, {} },
        })
    end

    -- Make new unit face in the same direction
    local h = Spring.GetUnitHeading(unitID)
    Spring.SetUnitRotation(newUnitID, 0, -h * math.pi / 32768, 0)

    SendToUnsynced("unit_morph_finished", unitID, newUnitID)
    Spring.SpawnCEG("blacksmoke", myX, myY, myZ)
    Spring.SpawnCEG("levelup", myX, myY, myZ)
    Spring.DestroyUnit(unitID, false, true)

    LuaMessages.SendMsgToAll(MSG_TYPES.UNIT_LEVELLED_UP, {unitID, newUnitID})
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
        if not Units.IsVillageUnit(unitID) then
            Morph(unitID)--, unitDef.customParams.morph_into, teamID)
        else
            local village = _G.VillageManager:GetElement(unitID)
            village:ReadyToFortify()
        end
    end
end

function gadget:UnitDamaged(unitID, unitDefID, teamID, damage, paralyzer,
                            weaponID, attackerID)
    if attackerID == nil or attackerID < 0 then return end
    local xpMult = xpMultipliers[GetUnitTeam(attackerID)]
    local xpGained = damage*xpMult:GetFromDamage(unitID, attackerID, weaponID)
    AddXP(attackerID, xpGained)
end

function gadget:UnitFromFactory(unitID, unitDefID, unitTeam, builderID, builderDefID, _)
    if not builderID or not Units.IsVillageUnit(builderID) then return end
    local _, maxHealth = GetUnitHealth(unitID)
    local xpGained = (maxHealth/10) * xpMultipliers[unitTeam]:GetValue(builderID)
    AddXP(builderID, xpGained)
end

function gadget:RecvLuaMsg(msg, playerID)
    local msgType, params = LuaMessages.deserialize(msg)
    if msgType == MSG_TYPES.CONVERT_FINISHED then
        local clergyID = tonumber(params[1])
        local villageID = tonumber(params[2])
        local xpGained = UnitDefs[GetUnitDefID(villageID)].customParams.convert_xp
        local xpMult = xpMultipliers[GetUnitTeam(clergyID)]:GetValue(clergyID)
        GG.Delay.DelayCall(AddXP, {clergyID, xpGained*xpMult})
    elseif msgType == MSG_TYPES.MORPH then
        local unitID, ncc, ncs = tonumber(params[1]), params[2], params[3]
        GG.Delay.DelayCall(Morph, {unitID, ncc, ncs})
    end
end

function gadget:Initialize()
    -- Get local references to XP multipliers
    local TeamManagers = _G.TeamManagers
    for _, teamID in pairs(Spring.GetTeamList()) do
        xpMultipliers[teamID] = TeamManagers[teamID]:GetAttributeManager():GetXPMultiplier()
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
