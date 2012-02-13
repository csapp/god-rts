
function gadget:GetInfo()
    return {
        name = "create_god",
        desc = "Synced God Creator",
        tickets = "#65",
        author = "Matt",
        date = "2012-02-11",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

include("LuaUI/Headers/msgs.h.lua")

local function SpawnGod(teamID)
    local sx,sy,sz = Spring.GetTeamStartPosition(teamID)
    sx = sx-50
    Spring.SpawnCEG("whitesmoke", sx, Spring.GetGroundHeight(sx, sz) + 10, sz)
    Spring.CreateUnit("God", sx, sy, sz, 0, teamID)
    gadgetHandler:RemoveGadget()
end

function gadget:RecvLuaMsg(msg, playerID)
    msg = LuaMessages.deserialize(msg)
	local msg_type = msg[1]
	if msg_type == MSG_TYPES.GOD_SELECTED then
        local _, _, _, teamID = Spring.GetPlayerInfo(playerID)
        GG.Delay.DelayCall(SpawnGod, {teamID})
		--p1 = msg[2]
		--p2 = msg[3]
		--p3 = msg[4]
	end
end

function gadget:GameFrame(n)
		if create then
			create = false
		    local sx,sy,sz = Spring.GetTeamStartPosition(PID)
			--Spring.Echo("CREATING",sx,sy,sz,PID)
			--Send selection somewhere
			Spring.CreateUnit("God", sx, sy, sz, 0, PID, false)
			--CREATE GOD SOUND EFFECT
		end
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
	return false

end
