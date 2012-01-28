-- Based on a gadget created by Baczek at 
-- http://springrts.com/wiki/SetMoveTypeDataExample
-- and a gadget in zero-k
-- LuaRules/Gadgets/unit_transport_ai_buttons.lua

include("LuaRules/Configs/customcmds.h.lua")

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
local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local FindUnitCmdDesc = Spring.FindUnitCmdDesc
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
local VILLAGE_ID = UnitDefNames["warrior"].id -- XXX change to village when unitdef is added

local function StartConvert(clergyID, villageID)
    local villageX, villageY, villageZ = Spring.GetUnitBasePosition(villageID)
    GiveOrderToUnit(clergyID, CMD.MOVE, {villageX, villageY, villageZ}, {}) 
    -- wait til the unit gets there
    converting[villageID] = {time = Spring.GetGameSeconds(),
                             clergyID = clergyID}
    Spring.Echo("Beginning convert")
    -- Display some kind of status bar over the clergy's head
end

local function FinishConvert(clergyID, villageID)
    Spring.Echo("Convert finished!")
    converting[villageID] = nil
    -- Align the village with the clergyman's team
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

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if (not cmdID == CMD_CONVERT) then
        return false
    end

    local villageID = cmdParams[1]
    if Spring.GetUnitDefID(villageID) ~= VILLAGE_ID then
        return false
    end

    --if Spring.GetUnitNeutral(villageID) and not converting[villageID] then
    if not converting[villageID] then
        StartConvert(unitID, villageID)
        return true, false
    end

    return false
end
    
function gadget:UnitDestroyed(unitID, unitDefID, teamID, aID, adefID, ateamID)
    if unitDefID == "priest" then -- XXX add other clergy
        for villageID, info in pairs(converting) do
            if info['clergyID'] == unitID then
                converting[villageID] = nil
                break
            end
        end
    end
end

function gadget:GameFrame(n)
    if n % 30 ~= 0 then
        return
    end
    local curTime = GetGameSeconds()
    local startTime, clergyID = nil, nil
    for villageID, info in pairs(converting) do
        
        -- XXX should we get this value every time or save this value in the converting table?
        local villageConvertTime = 10 -- XXX change to individual village convert time

        startTime, clergyID = info['time'], info['clergyID']
        if curTime - startTime >= villageConvertTime then 
            FinishConvert(clergyID, villageID)
        end
    end
end
