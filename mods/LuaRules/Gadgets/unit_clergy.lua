-- Based on a gadget created by Baczek at 
-- http://springrts.com/wiki/SetMoveTypeDataExample
-- and a gadget in zero-k
-- LuaRules/Gadgets/unit_transport_ai_buttons.lua

include("LuaRules/Configs/customcmds.h.lua")
include("LuaRules/Includes/utilities.lua")

function gadget:GetInfo()
    return {
        name = "Clergy units",
        desc = "Gadget to control Clergy units",
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


-- Speed ups
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetGameSeconds = Spring.GetGameSeconds

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

-- XXX change to "village" when unitdef is added
local VILLAGE_ID = UnitDefNames["warrior"].id 
local CONVERT_DISTANCE = 50

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
    -- Spring.TransferUnit(villageID, Spring.GetUnitTeam(clergyID))
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
    -- XXX include other clergy IDs here when we make the unitdefs
    if (unitDefID == UnitDefNames['priest'].id) then
        InsertUnitCmdDesc(unitID, CMD_CONVERT, convertCmd)
    end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if unitDefID ~= UnitDefNames["priest"].id then -- XXX add others
        return true
    end

    if cmdID ~= CMD_CONVERT and convert_pending[unitID] == nil then
        CancelConvert(unitID)
    end

    return true
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if cmdID ~= CMD_CONVERT then
        return false
    end

    local villageID = cmdParams[1]
    if Spring.GetUnitDefID(villageID) ~= VILLAGE_ID then
        return false
    end

    --if not Spring.GetUnitNeutral(villageID) or converting[villageID] then
    if converting[villageID] then
        return false
    end

    local villageX, villageY, villageZ = Spring.GetUnitBasePosition(villageID)

    if distance_between_units(unitID, villageID) < CONVERT_DISTANCE then
        -- XXX If this happens, we start, cancel and start again.
        -- Seems to be ok but I'm not sure why this happens
        StartConvert(unitID, villageID)
    else
        convert_pending[unitID] = villageID
        GiveOrderToUnit(unitID, CMD.MOVE, {villageX, villageY, villageZ}, {}) 
    end
    return true, false
end
    
function gadget:UnitDestroyed(unitID, unitDefID, teamID, aID, adefID, ateamID)
    if unitDefID == "priest" then -- XXX add other clergy
        CancelConvert(unitID)
    end
end

function gadget:UnitCmdDone(unitID, unitDefID, teamID, cmdID, cmdTag)
    local villageID = convert_pending[unitID]
    if not villageID then
        return
    end

    if distance_between_units(unitID, villageID) < CONVERT_DISTANCE then
        --if not Spring.GetUnitNeutral(villageID) or converting[villageID] then
        if converting[villageID] then
            CancelConvert(unitID)
        else
            StartConvert(unitID, villageID)
        end
    else
        CancelConvert(unitID)
    end
end

function gadget:GameFrame(n)
    if n % 30 ~= 0 then
        return
    end
    local curTime = GetGameSeconds()
    for villageID, info in pairs(converting) do
        
        -- XXX should we get this value every time or save this value in the converting table?
        local villageConvertTime = 10 -- XXX change to individual village convert time

        local startTime, clergyID = info['time'], info['clergyID']
        if curTime - startTime >= villageConvertTime then 
            FinishConvert(clergyID, villageID)
        end
    end
end
