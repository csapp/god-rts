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
include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/msgs.h.lua")

-- Speed ups
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitHealth = Spring.GetUnitHealth
local SendLuaUIMsg = Spring.SendLuaUIMsg

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

local function FinishConvert(clergyID)
    local villageID = nil
    for vID, cID in pairs(converting) do
        if cID == clergyID then
            villageID = vID
            break
        end
    end
    if villageID == nil then return end

    converting[villageID] = nil
    Spring.TransferUnit(villageID, Spring.GetUnitTeam(clergyID))
    Spring.SetUnitNeutral(villageID, false)
    local message = LuaMessages.serialize(MSG_TYPES.CONVERT_FINISHED, {clergyID, villageID})
    Spring.SendLuaRulesMsg(message)
end

local function StartConvert(clergyID, villageID)
    convert_pending[clergyID] = nil
    converting[villageID] = clergyID
    local convert_time = tonumber(UnitDefs[GetUnitDefID(villageID)].customParams.convert_time)
    GG.ProgressBars.AddProgressBar(clergyID, "Converting...", convert_time, FinishConvert)
end

local function CancelConvert(clergyID)
    if DEBUG then Spring.Echo("Canceling convert") end
    convert_pending[clergyID] = nil
    for villageID, cID in pairs(converting) do
        if cID == clergyID then
            converting[villageID] = nil
            GG.ProgressBars.CancelProgressBar(clergyID)
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

local function CanConvert(clergyID, villageID)
    if converting[villageID] then
        return false
    end

    if not GetUnitNeutral(villageID) then
        local curHealth, maxHealth = GetUnitHealth(villageID)
        if curHealth / maxHealth > 0.1 then
            return false
        end
    end

    return true
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if cmdID ~= CMD_CONVERT then
        return false
    end

    local villageID = cmdParams[1]
    if not table.contains(VILLAGE_IDS, Spring.GetUnitDefID(villageID)) then
        return false
    end

    if not CanConvert(unitID, villageID) then 
        return false 
    end

    local villageX, villageY, villageZ = Spring.GetUnitBasePosition(villageID)

    if utils.distance_between_units(unitID, villageID) < CONVERT_DISTANCE then
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
        local x,y,z = Spring.GetTeamStartPosition(teamID)
        Spring.CreateUnit("priest", x, y, z, 0, teamID) 
    end
end

function gadget:GameFrame(n)
    if n % 30 ~= 0 then
        return
    end
    for clergyID, villageID in pairs(convert_pending) do
        if utils.distance_between_units(clergyID, villageID) < CONVERT_DISTANCE then
            if not CanConvert(clergyID, villageID) then
                CancelConvert(clergyID)
            else
                StartConvert(clergyID, villageID)
            end
            GiveOrderToUnit(clergyID, CMD.STOP, {}, {}) 
        end
    end
end
