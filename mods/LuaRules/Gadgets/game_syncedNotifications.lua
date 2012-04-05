--some of this code was adapted from author 'knorke'. It can be found here:
--http://pastebin.com/sefpiDGq

function gadget:GetInfo()
    return {
        name = "Notification gadget",
        desc = "Gadget that issues notifications when events occur.",
        author = "Mani",
      --  tickets = "#78, #119",
        date = "2012-04-04",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

include("LuaUI/Headers/customcmds.h.lua")
include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/msgs.h.lua")


function hasEnoughVillagers(unitDefID, unitTeam)
	local mCurr, mStor, mPull, mInco, mExpe, mShar, mSent, mReci = Spring.GetTeamResources(unitTeam, "metal")
	local unitBuildCost = UnitDefs[unitDefID].metalCost
	
	if mCurr - unitBuildCost < 0 then
		return false
	else
		return true
	end
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag)
	if cmdID < 0 and not hasEnoughVillagers(unitDefID, unitTeam) then
		Spring.Echo("Not Enough Villagers (Minerals :P)")
		return false
	end
	return true
end

function gadget:RecvLuaMsg(msg, playerID)
	local msg_type, params = LuaMessages.deserialize(msg)
	if msg_type == MSG_TYPES.CONVERT_FAILED or msg_type == MSG_TYPES.POWER_FAILED then
		Spring.Echo(params[1])
	end
end