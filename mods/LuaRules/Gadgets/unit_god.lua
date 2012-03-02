function gadget:GetInfo()
    return {
        name = "God Unit gadget",
        desc = "Gadget to control god unit stuff",
        tickets = "#19",
        author = "cam",
        date = "2012-02-29",
        license = "Public Domain",
        layer = -100,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/msgs.h.lua")

local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local god_unitdef_id = UnitDefNames["god"].id

local POWERS_DIR = "LuaRules/Classes/Powers/"

local power_bases = {
    "power.lua",
    "activepower.lua",
    "rangedpower.lua",
}

local power_filepaths = {
    "volcanicblast.lua",
    "teleport.lua",
}

local power_ids = {}
Powers = {}
PowerNames = {}
PowerManagers = {}

local function PopulatePowerTables()
    for _, filepath in pairs(power_bases) do
        VFS.Include(POWERS_DIR .. filepath)
    end
    for _, filepath in pairs(power_filepaths) do
        local power = VFS.Include(POWERS_DIR .. filepath)
        local id = power:GetID()
        Powers[id] = power
        table.insert(power_ids, id)
        PowerNames[power:GetName()] = power
        gadgetHandler:RegisterCMDID(id)
    end
end

local function PopulatePowerManagers()
    VFS.Include("LuaRules/Classes/manager.lua")
    VFS.Include("LuaRules/Classes/manager_power.lua")
    for i, teamID in ipairs(Spring.GetTeamList()) do
        PowerManagers[teamID] = PowerManager:New({teamID=teamID})
    end
end

local function AddPower(teamID, powerName)
    local power = PowerNames[powerName]
    local manager = PowerManagers[teamID]
    manager:AddElement(power.id, power:New({teamID=teamID}))
end

local function SpawnGod(teamID)
    local sx,sy,sz = Spring.GetTeamStartPosition(teamID)
    sx = sx-50
    Spring.SpawnCEG("whitesmoke", sx, Spring.GetGroundHeight(sx, sz) + 10, sz)
    local god = Spring.CreateUnit("God", sx, sy, sz, 0, teamID)
end

function gadget:Initialize()
    VFS.Include("LuaRules/Classes/object.lua")
    PopulatePowerTables()
    PopulatePowerManagers()
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if not table.contains(power_ids, cmdID) then
        return false
    end

    local power_manager = PowerManagers[teamID]
    local power = power_manager:GetElement(cmdID)
    power:Use(cmdParams, cmdOptions)
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if unitDefID ~= god_unitdef_id then
        return
    end

    local teamID = Spring.GetUnitTeam(unitID)
    for powerID, power in pairs(PowerManagers[teamID]:GetElements()) do
        InsertUnitCmdDesc(unitID, powerID, power:GetCmdDesc())
        power:SetGodID(unitID)
    end
end

function gadget:RecvLuaMsg(msg, playerID)
    local msg_type, params = LuaMessages.deserialize(msg)
	if msg_type == MSG_TYPES.GOD_SELECTED then
        local _, _, _, teamID = Spring.GetPlayerInfo(playerID)
        -- XXX The temp powers break this loop
        -- Uncomment it and remove the subsequent AddPowers 
        -- when the temp powers are gone
        --for i=2,#params do
            --AddPower(teamID, params[i])
        --end
        AddPower(teamID, params[1])
        AddPower(teamID, params[2])
        GG.Delay.DelayCall(SpawnGod, {teamID})
	end
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------

return false

end
