
function gadget:GetInfo()
    return {
        name = "Village handler",
        desc = "Handles village units",
        author = "cam",
        date = "Feb 9, 2012",
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
include("LuaUI/Headers/msgs.h.lua")
include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/villages.h.lua")
include("LuaRules/Classes/Units/village.lua")

local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc

local VillageManager
local CMD_KEY_MAP = {}

local function GetVillage(unitID)
    return VillageManager:GetElement(unitID)
end

function gadget:Initialize()
    local um = _G.UnitManager
    VillageManager = um:GetVillageManager()
end

function gadget:GameStart()

    if not VFS.FileExists("mapinfo.lua") then
        Spring.Echo("Village gadget: Can't find mapinfo.lua!")
        return
    end

    local mapcfg = VFS.Include("mapinfo.lua")
    if (not mapcfg) or (not mapcfg.custom) or (not mapcfg.custom.villages) then
        Spring.Echo("Village gadget: Can't find village locations in mapinfo.lua!")
        return
    end

    local CreateUnit = Spring.CreateUnit
    local GetGroundHeight = Spring.GetGroundHeight
    local gaiaTeamID = Spring.GetGaiaTeamID()
    for _, village in pairs(mapcfg.custom.villages) do
        local v = CreateUnit(village.vtype, village.x, GetGroundHeight(village.x, village.z),
                   village.z, 0, gaiaTeamID)
        Spring.SetUnitNeutral(v, true)
    end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if not Units.IsVillageUnit(unitID) then
        return true
    end
    local v = GetVillage(unitID)
    
    -- At the beginning of the game, we don't have village objects yet
    if not v then return false end

    if table.contains(v:GetDisallowedCommands(), cmdID) then
        return false
    end

    if cmdID == CMD.STOP then
        v:Stop()
        return true
    end

    if v:IsBusy() then
        return false
    end

    if cmdID == Villages.CMDS.FORTIFY then
        v:Fortify()
        return true
    end

    local buildingkey = CMD_KEY_MAP[cmdID]
    if buildingkey then 
        v:AddBuilding(buildingkey)
        return true
    end

    if table.containsvalue(Buildings.CMD_IDS.RESEARCH, cmdID) then
        v:ExecuteCommand(cmdID)
        return true
    end
    
    return true
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    if not Units.IsVillageUnit(unitID) then return end
    local village = Village:New(unitID)
    VillageManager:AddElement(unitID, village)
    for key, building in pairs(village:GetAvailableBuildings()) do
        InsertUnitCmdDesc(unitID, building:GetCmdID(), building:GetCmdDesc())
        CMD_KEY_MAP[building:GetCmdID()] = key
    end
end

function gadget:UnitGiven(unitID, unitDefID, newTeam, oldTeam)
    if not Units.IsVillageUnit(unitID) then return end
    local vobj = GetVillage(unitID)
    vobj:Transfer(oldTeam)
end

function gadget:RecvLuaMsg(msg, playerID)
    msgtype, params = LuaMessages.deserialize(msg)
    if msgtype == MSG_TYPES.UNIT_LEVELLED_UP then
        local oldUnitID, newUnitID = unpack(params)
        GetVillage(oldUnitID):LevelUp(newUnitID)
    end
end
