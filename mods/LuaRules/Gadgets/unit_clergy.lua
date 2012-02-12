-- Based on a gadget created by Baczek at 
-- http://springrts.com/wiki/SetMoveTypeDataExample
-- and a gadget in zero-k
-- LuaRules/Gadgets/unit_transport_ai_buttons.lua


function gadget:GetInfo()
    return {
        name = "Clergy units",
        desc = "Gadget to control Clergy units",
        tickets = "#38",
        author = "cam",
        date = "2011-12-21",
        license = "Public Domain",
        layer = -255,
        enabled = true
    }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

include("LuaRules/Includes/customcmds.h.lua")
include("LuaRules/Includes/utilities.lua")
include("LuaRules/Includes/msgs.h.lua")

-- Speed ups
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetGameSeconds = Spring.GetGameSeconds
local GetUnitDefID = Spring.GetUnitDefID

local convertCmd = {
      id      = CMD_CONVERT,
      name    = "Convert",
      action  = "convert",
      type    = CMDTYPE.ICON_UNIT,
      tooltip = "Convert a neutral village",
      cursor = "Convert",
      params = {},
}

local converting = {}
local convert_pending = {}

-- XXX move to config file?
local VILLAGE_IDS = {UnitDefNames["smallvillage"].id,
                     UnitDefNames["mediumvillage"].id,
                     UnitDefNames["largevillage"].id}
local CLERGY_IDS = {UnitDefNames["priest"].id,
                    UnitDefNames["prophet"].id}

local CONVERT_DISTANCE = 100 

local gaiaTeamID = Spring.GetGaiaTeamID()
local function GetUnitNeutral(unitID)
    return Spring.GetUnitTeam(unitID) == gaiaTeamID
end

local function StartConvert(clergyID, villageID)
    convert_pending[clergyID] = nil
    converting[villageID] = {time = Spring.GetGameSeconds(),
                             clergyID = clergyID}
    Spring.Echo("Beginning convert")
    -- TODO Display some kind of status bar over the clergy's head
end

local function FinishConvert(clergyID, villageID)
    Spring.Echo("Convert finished!")
    converting[villageID] = nil
    Spring.TransferUnit(villageID, Spring.GetUnitTeam(clergyID))
    Spring.SendLuaRulesMsg(MSGS.CONVERT_FINISHED..','..clergyID..","..villageID)
end

local function CancelConvert(clergyID)
    Spring.Echo("canceling convert")
    convert_pending[clergyID] = nil
    for villageID, info in pairs(converting) do
        if info['clergyID'] == clergyID then
            converting[villageID] = nil
            break
        end
    end
end

function gadget:Initialize()
    gadgetHandler:RegisterCMDID(CMD_CONVERT)
    Spring.AssignMouseCursor("Convert", "cursorConvert", true, true)
    Spring.SetCustomCommandDrawData(CMD_CONVERT, "Convert", {0,1,1,0.5}, false)
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if table.contains(CLERGY_IDS, unitDefID) then
        InsertUnitCmdDesc(unitID, CMD_CONVERT, convertCmd)
    end
end

--function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    --if not table.contains(CLERGY_IDS, GetUnitDefID(unitID)) then
        --return true
    --end

    --if cmdID ~= CMD_CONVERT and convert_pending[unitID] ~= nil then
        --CancelConvert(unitID)
    --end

    --return true
--end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if cmdID ~= CMD_CONVERT then
        return false
    end

    local villageID = cmdParams[1]
    if not table.contains(VILLAGE_IDS, Spring.GetUnitDefID(villageID)) then
        return false
    end

    if not GetUnitNeutral(villageID) or converting[villageID] then
        return false
    end

    local villageX, villageY, villageZ = Spring.GetUnitBasePosition(villageID)

    if distance_between_units(unitID, villageID) < CONVERT_DISTANCE then
        StartConvert(unitID, villageID)
    else
        GiveOrderToUnit(unitID, CMD.MOVE, {villageX, villageY, villageZ}, {}) 
        convert_pending[unitID] = villageID
    end
    return true, false
end
    
function gadget:UnitDestroyed(unitID, unitDefID, teamID, aID, adefID, ateamID)
    if table.contains(CLERGY_IDS, unitDefID) then
        CancelConvert(unitID)
    end
end

function gadget:GameFrame(n)
    if n % 30 ~= 0 then
        return
    end
    local curTime = GetGameSeconds()
    for clergyID, villageID in pairs(convert_pending) do
        if distance_between_units(clergyID, villageID) < CONVERT_DISTANCE then
            if not GetUnitNeutral(villageID) or converting[villageID] then
                CancelConvert(clergyID)
            else
                StartConvert(clergyID, villageID)
            end
            GiveOrderToUnit(clergyID, CMD.STOP, {}, {}) 
        end
    end
    for villageID, info in pairs(converting) do
        
        -- XXX should we get this value every time or save this value in the converting table?
        local convertTime = tonumber(UnitDefs[GetUnitDefID(villageID)].customParams.convert_time)

        local startTime, clergyID = info['time'], info['clergyID']
        if curTime - startTime >= convertTime then 
            FinishConvert(clergyID, villageID)
        end
    end
end
