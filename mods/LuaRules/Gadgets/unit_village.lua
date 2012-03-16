
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

include("LuaUI/Headers/msgs.h.lua")
include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/buildings.h.lua")
include("LuaRules/Classes/Units/village.lua")

local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc

local VillageManager

local CMD_BUILD_SHRINE = 31050
local shrineCmd = {
      id      = CMD_BUILD_SHRINE,
      name    = "Build Shrine",
      action  = "building_shrine",
      type    = CMDTYPE.ICON,
      tooltip = "Build a Shrine in this village",
      params = {},
}

local function GetVillage(unitID)
    return VillageManager:GetElement(unitID)
end

function gadget:Initialize()
    VillageManager = _G.VillageManager
end

function gadget:GameStart()

    if not VFS.FileExists("mapinfo.lua") then
        Spring.Echo("Village spawner gadget: Can't find mapinfo.lua!")
        return
    end

    local mapcfg = VFS.Include("mapinfo.lua")
    if (not mapcfg) or (not mapcfg.custom) or (not mapcfg.custom.villages) then
        Spring.Echo("Village spawner gadget: Can't find village locations in mapinfo.lua!")
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
    if cmdID == CMD.STOP then
        v:Stop()
    end
    if cmdID == CMD_BUILD_SHRINE then
        v:AddBuilding(Buildings.TYPES.SHRINE)
    end
    
    return true
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    if not Units.IsVillageUnit(unitID) then return end
    VillageManager:AddElement(unitID, Village:New(unitID))
    InsertUnitCmdDesc(unitID, CMD_BUILD_SHRINE, shrineCmd)
end

function gadget:AllowUnitTransfer(unitID, unitDefID, oldTeam, newTeam, capture)
    if not Units.IsVillageUnit(unitID) then return false end
    local vobj = GetVillage(unitID)
    GG.Delay.DelayCall(vobj.Transfer, {vobj, oldTeam})
    return true
end

function gadget:RecvLuaMsg(msg, playerID)
    msgtype, params = LuaMessages.deserialize(msg)
    if msgtype == MSG_TYPES.LEVEL_UP then
        local oldUnitID, newUnitID = unpack(params)
        GetVillage(oldUnitID):SetUnitID(newUnitID)
    end
end
