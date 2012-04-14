function widget:GetInfo()
  return {
    name      = "Hotkey widget",
    desc      = "Provides hotkeys for easy access to common actions.",
    author    = "Mani",
	date		= "2012-04-12",
	license     = "GNU GPL v2",
	layer		= 1,
	enabled   	= true,
  }
end

include("Headers/utilities.lua")
include("units.h.lua")
include("customcmds.h.lua")
include("msgs.h.lua")

local godID
local offensiveGodPowers = {CMD_VOLCANIC_BLAST, CMD_ZOMBIE, CMD_BFB}
local defensiveGodPowers = {CMD_TELEPORT, CMD_LOVE, CMD_POSSESSION}
local oGodPowerIndex, dGodPowerIndex


local function getGodPowers()
	-- Find out which Offensive god power was chosen
	for i, k in pairs(offensiveGodPowers) do
		local index = Spring.FindUnitCmdDesc(godID, k)
		if index ~= nil then
			oGodPowerIndex = Spring.FindUnitCmdDesc(godID, k)
		end
	end
	-- Find out which Defensive god power was chosen
	for i, k in pairs(defensiveGodPowers) do
		local index = Spring.FindUnitCmdDesc(godID, k)
		if index ~= nil then
			dGodPowerIndex = Spring.FindUnitCmdDesc(godID, k)
		end
	end
	
end

function widget:RecvLuaMsg(msg, playerID)
	--Get us the God unitID
	local msg_type, params = LuaMessages.deserialize(msg)
	if msg_type == MSG_TYPES.GOD_CREATED then
		godID = params[1]
		getGodPowers()
	end
end

function widget:KeyPress(key, mods, isRepeat)
	--key to select God unit
	if key == string.byte("g") then							--Select and center on god unit
		local x, y, z = Spring.GetUnitPosition(godID)
		Spring.SetCameraTarget(x, y, z)
		Spring.SelectUnitArray({godID}, true)
	elseif key == string.byte("z") then						--If god unit is selected, set active the offensive god power
		local selUnits = Spring.GetSelectedUnits()
		if table.contains(selUnits, math.floor(godID)) then
			Spring.SetActiveCommand(oGodPowerIndex,1)
		end
	elseif key == string.byte("x") then						--If god unit is selected, set active the defensive god power
		local selUnits = Spring.GetSelectedUnits()
		if table.contains(selUnits, math.floor(godID)) then
			Spring.SetActiveCommand(dGodPowerIndex,1)
		end
	elseif key == string.byte("c") then						--If Clergy unit is selected, set active the conversion command
		local selUnits = Spring.GetSelectedUnits()
		for i, unitID in pairs(selUnits) do
			if Units.IsClergyUnit(unitID) then
				Spring.SetActiveCommand(Spring.FindUnitCmdDesc(unitID, CMD_CONVERT), 1)
				break
			end
		end
	elseif key == string.byte("e") then						--If Clergy unit is selected and its a leveled up unit, set active the resurrect command
		local selUnits = Spring.GetSelectedUnits()
		for i, unitID in pairs(selUnits) do
			if Units.IsClergyUnit(unitID) and Units.GetLevel(unitID) > 1 then
				Spring.SetActiveCommand(Spring.FindUnitCmdDesc(unitID, CMD_RESURRECT), 1)
				break
			end
		end
	end

end