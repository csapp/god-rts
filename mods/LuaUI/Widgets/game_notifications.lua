--some of this code was adapted from author 'knorke'. It can be found here:
--http://pastebin.com/sefpiDGq

function widget:GetInfo()
    return {
        name = "Notification widget",
        desc = "Widget that issues notifications when events occur.",
        author = "Mani",
        tickets = "#78, #119",
        date = "2012-03-21",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

include("customcmds.h.lua")
include("msgs.h.lua")

local warningDelay = 30 * 5     --in frames
local lastWarning = 0                   --in frames
local localTeamID = Spring.GetLocalTeamID ()
local soundCounter

local listOfUnitDamagedSounds = {
	"sounds/fanfare10.wav",
}

local listOfUnitDestroyedSounds = {
	"sounds/aahhh.wav",
	"sounds/Manscreaming2.wav",
}

local listOfUnitFromFactorySounds = {
	"sounds/gong.wav",
}

local listOfUnitLevelUpSounds = {
	"sounds/harp.wav"
}

function unitName(unitID)
        if (not unitID) then return nil end
        local unitDefID = Spring.GetUnitDefID(unitID)
        if (unitDefID) then
                local unitDef = UnitDefs[unitDefID]
                if (unitDef) then
                        return unitDef.name
                end
        end
        return nil
end
 
function widget:UnitDamaged (unitID, unitDefID, unitTeam, damage, paralyzer, weaponID, attackerID, attackerDefID, attackerTeam)
        local currentFrame = Spring.GetGameFrame ()
        if (lastWarning+warningDelay > currentFrame) then              
                return
        end
        if (localTeamID == unitTeam and not Spring.IsUnitInView(unitID)) then
                lastWarning = currentFrame
                local attackedUnit = unitName (unitID) or "unit"
                Spring.Echo ("Your " .. attackedUnit  .." is being attacked!")
				soundCounter = math.random(#listOfUnitDamagedSounds)
                Spring.PlaySoundFile (listOfUnitDamagedSounds[soundCounter])
                local x,y,z = Spring.GetUnitPosition (unitID)
                if (x and y and z) then Spring.SetLastMessagePosition (x,y,z) end
        end
end

function widget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
	if Spring.IsUnitInView(unitID) and attackerID ~= nil then
		soundCounter = math.random(#listOfUnitDestroyedSounds)
		Spring.PlaySoundFile(listOfUnitDestroyedSounds[soundCounter])
	elseif not Spring.IsUnitInView(unitID) and attackerID == nil then
		soundCounter = math.random(#listOfUnitLevelUpSounds)
		Spring.PlaySoundFile(listOfUnitLevelUpSounds[soundCounter])
	end
end

function widget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
	if not Spring.IsUnitInView(unitID) then
		soundCounter = math.random(#listOfUnitFromFactorySounds)
		local builtUnit = unitName (unitID) or "unit"
		Spring.Echo("Your " .. builtUnit  .." is ready for battle.")
		Spring.PlaySoundFile(listOfUnitFromFactorySounds[soundCounter])
	end
end

function widget:RecvLuaMsg(msg, playerID)
	if playerID == Spring.GetLocalPlayerID() then
		local msg_type, params = LuaMessages.deserialize(msg)
		if msg_type == MSG_TYPES.CONVERT_FAILED or msg_type == MSG_TYPES.POWER_FAILED or msg_type == MSG_TYPES.BUILD_UNIT_FAILED then
			Spring.SendMessageToPlayer(playerID, params[1])
		end
	end
end
