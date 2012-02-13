
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
local ID = 0
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
		ID = 1--playerID --TEMPORARY UNTIL I CAN GET PLAYER ID PROPERLY
		p1 = msg[2]
		p2 = msg[3]
		p3 = msg[4]
		create = true
		Spring.Echo(p1,p2,p3,ID)
		--local sx,sy,sz = Spring.GetTeamStartPosition(playerID)
		--Spring.CreateUnit("God", sx, sy, sz, 0, playerID)
	end
end

function gadget:GameFrame(n)
		if create then
			Spring.Echo("START")
		    local sx,sy,sz = Spring.GetTeamStartPosition(ID)
			Spring.Echo(sx,sy,sz)
			Spring.CreateUnit("God", sx, sy, sz, 0, ID)
			create = false
		end
end
	


else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
	return false

end
