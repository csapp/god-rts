
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

-- Speed ups

local playerID = {}		
local create = false
local PID = 1
local p1,p2,p3 = "","",""				  

local function getPlayerList()
	for index, ID in pairs(Spring.GetPlayerList()) do
		playerID[index] = ID
		end
end

function gadget:Initialize()
    if DEBUG then Spring.Echo("RESOURCE GENERATION ON!") end
	getPlayerList()
end

function gadget:RecvLuaMsg(msg, playerID)
    msg = LuaMessages.deserialize(msg)
	local msg_type = msg[1]
	if msg_type == MSG_TYPES.GOD_SELECTED then
		p1 = msg[2]
		p2 = msg[3]
		p3 = msg[4]
		PID = 1--tonumber(msg[5]) TEMPORARY UNTIL I CAN GET PLAYER ID PROPERLY in ui widget
		create = true
		--Spring.Echo("CREATE",p1,p2,p3,PID)
		--local sx,sy,sz = Spring.GetTeamStartPosition(playerID)
		--Spring.CreateUnit("God", sx, sy, sz, 0, playerID)
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
