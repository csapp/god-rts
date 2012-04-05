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

include("LuaUI/Headers/msgs.h.lua")

if gadgetHandler:IsSyncedCode() then

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
	local reason
	if cmdID < 0 and not hasEnoughVillagers(unitDefID, unitTeam) then
		reason = "Not Enough Villagers (Minerals :P)"
		--LuaMessages.SendLuaUIMsg(MSG_TYPES.BUILD_UNIT_FAILED, {reason})
        SendToUnsynced("failed_command", reason)
		return false
	end
	return true
end

else 

local function SendMsg(cmd, reason)
    LuaMessages.SendLuaUIMsg(MSG_TYPES.BUILD_UNIT_FAILED, {reason})
end

function gadget:Initialize()
    gadgetHandler:AddSyncAction("failed_command", SendMsg)
end

function gadget:Shutdown()
    gadgetHandler:RemoveSyncAction("failed_command")
end

end
