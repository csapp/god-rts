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
        layer = 0,
        enabled = true
    }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/customcmds.h.lua")
include("LuaUI/Headers/msgs.h.lua")
include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/villages.h.lua")

-- Speed ups
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitHealth = Spring.GetUnitHealth
local GetUnitTeam = Spring.GetUnitTeam

local convertCmd = {
      id      = CMD_CONVERT,
      name    = "Convert",
      action  = "convert",
      type    = CMDTYPE.ICON_UNIT,
      tooltip = "Convert a neutral village",
      cursor = "Convert",
      params = {},
}

local resurrectCmd = {
	id = CMD_RESURRECT, 
	name = "Resurrect", 
	action = "resurrect",
	type = CMDTYPE.ICON_MAP,
	tooltip = "Resurrect fallen unit",
	params = {
		[1] = 20, -- radius
	},
}

local converting = {}
local convert_pending = {}
local resurrect_pending = {}

local CONVERT_DISTANCE = 100 
local RESURRECT_DISTANCE = 100 

local MAX_CLERGY_COUNT = 2
local clergyUnitCount = {}
local clergyUnitDefs = {
    UnitDefNames[Units.UNITDEF_NAMES.PRIEST].id,
    UnitDefNames[Units.UNITDEF_NAMES.PROPHET].id,
    UnitDefNames[Units.UNITDEF_NAMES.DEMIGOD].id,
}

local gaiaTeamID = Spring.GetGaiaTeamID()
local function GetUnitNeutral(unitID)
    return GetUnitTeam(unitID) == gaiaTeamID
end

local function FinishConvert(clergyID)
    local villageID = nil
    for vID, cID in pairs(converting) do
        if cID == clergyID then
            villageID = vID
            break
        end
    end
    if not villageID then return end

    converting[villageID] = nil
    local oldVillageTeam = GetUnitTeam(villageID)
    Spring.TransferUnit(villageID, GetUnitTeam(clergyID))
    Spring.SetUnitNeutral(villageID, false)
    LuaMessages.SendLuaRulesMsg(MSG_TYPES.CONVERT_FINISHED, {clergyID, villageID, oldVillageTeam})
end

local function GetConvertTime(clergyID, villageID)
    local convertTime = Units.GetConvertTime(villageID)
    local am = _G.TeamManagers[GetUnitTeam(clergyID)]:GetAttributeManager()
    local multValue = am:GetConvertTimeMultiplier():GetValue(clergyID)

    vhealth, vmaxhealth = GetUnitHealth(villageID)
    if vhealth / vmaxhealth <= Villages.WEAK_HP_PCT then
        multValue = multValue - 0.3
    end

    return convertTime * multValue
end

local function StartConvert(clergyID, villageID)
    convert_pending[clergyID] = nil
    converting[villageID] = clergyID
    local convertTime = GetConvertTime(clergyID, villageID)
    GG.ProgressBars.AddProgressBar(clergyID, "Converting...", convertTime, FinishConvert)
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

    for _, teamID in pairs(Spring.GetTeamList()) do
        clergyUnitCount[teamID] = 0
    end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if Units.IsClergyUnit(unitID) then
        InsertUnitCmdDesc(unitID, CMD_CONVERT, convertCmd)
		if Units.GetLevel(unitID) > 1 then
			InsertUnitCmdDesc(unitID, CMD_RESURRECT, resurrectCmd)
		end
    end
end

function gadget:AllowUnitCreation(unitDefID, builderID, builderTeam, x, y, z, facing)
    if not table.contains(clergyUnitDefs, unitDefID) then return true end
    return clergyUnitCount[builderTeam] < MAX_CLERGY_COUNT
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
    if Units.IsClergyUnit(unitID) then
        clergyUnitCount[teamID] = clergyUnitCount[teamID] + 1
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    if Units.IsClergyUnit(unitID) then
        clergyUnitCount[teamID] = clergyUnitCount[teamID] - 1
    end
end


--function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    --if Units.IsClergyUnit(unitID) then
        --return true
    --end

    --if cmdID ~= CMD_CONVERT and convert_pending[unitID] ~= nil then
        --CancelConvert(unitID)
    --end

    --return true
--end

local function CanConvert(clergyID, villageID)
	local reason
	local teamID = Spring.GetUnitTeam(clergyID)
	
    if converting[villageID] then
		reason = "This village is already being converted."
		LuaMessages.SendLuaUIMsg(MSG_TYPES.CONVERT_FAILED, {reason, teamID})
        return false
    end

    -- FIXME this is throwing a weird error sometimes for some reason
    if GetUnitTeam(clergyID) == GetUnitTeam(villageID) then
		reason = "This village is already in your control."
		LuaMessages.SendLuaUIMsg(MSG_TYPES.CONVERT_FAILED, {reason, teamID})
        return false
    end

    if not GetUnitNeutral(villageID) then
        local curHealth, maxHealth = GetUnitHealth(villageID)
        if curHealth / maxHealth > Villages.WEAK_HP_PCT then
			reason = "This village is still too protected to convert. Reduce the village's HP to weaken it and convert again."
			LuaMessages.SendLuaUIMsg(MSG_TYPES.CONVERT_FAILED, {reason, teamID})
            return false
        end
    end

    return true
end

local function StartResurrect(unitID,  resurrectPosition, radius)
-- Create a unit at feature's location for every feature within a given radius
-- The unit to create is found via the unit's custom param 'resurrectinto'
		resurrect_pending[unitID] = nil
		local center_x, center_y, center_z = unpack(resurrectPosition)
		local radius = resurrectCmd.params[1]
		local corpseList = Spring.GetFeaturesInSphere(center_x, center_y, center_z, radius)
		
		for i,featureID in pairs(corpseList) do 
			local teamID = Spring.GetFeatureTeam(featureID)
			if teamID == Spring.GetUnitTeam(unitID) then
				local x,y,z = Spring.GetFeaturePosition(featureID)
				local featureDefID = Spring.GetFeatureDefID(featureID)
				local resurrectinto = FeatureDefs[featureDefID].customParams.resurrectintounit	
				if resurrectinto ~= nil then
					Spring.DestroyFeature(featureID)
					Spring.CreateUnit(resurrectinto, x,y,z,0, teamID)
				end	
			end
		end
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if cmdID == CMD_CONVERT then
        local villageID = cmdParams[1]
        if Units.IsVillageUnit(unitID) then
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
	
	elseif cmdID == CMD_RESURRECT then
		local x,y,z = Spring.GetUnitBasePosition(unitID)
		local center_x, center_y, center_z = unpack(cmdParams)
		local unitPosition = {x,y,z}
		local resurrectPosition = {center_x, center_y, center_z}
		
		if utils.distance_between_points(unitPosition, resurrectPosition) < RESURRECT_DISTANCE then
			StartResurrect(unitID, resurrectPosition)
		else
			GiveOrderToUnit(unitID, CMD.MOVE, resurrectPosition, {})
			resurrect_pending[unitID] = resurrectPosition
		end
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
	for unitID, resurrectPosition in pairs(resurrect_pending) do
		local unitX, unitY, unitZ = Spring.GetUnitBasePosition(unitID)
		local unitPosition = {unitX, unitY, unitZ}
		if utils.distance_between_points(unitPosition, resurrectPosition) < RESURRECT_DISTANCE then
			StartResurrect(unitID, resurrectPosition)
			GiveOrderToUnit(unitID, CMD.STOP, {}, {})
		else
			GiveOrderToUnit(unitID, CMD.MOVE, resurrectPosition, {})
		end
	end
end
