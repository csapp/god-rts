
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
include("LuaRules/Includes/customcmds.h.lua")
include("LuaRules/Includes/godCmdDesc.lua")

local pow1,pow2,pow3 = "","",""

local function SpawnGod(teamID)
    local sx,sy,sz = Spring.GetTeamStartPosition(teamID)
    sx = sx-50
    Spring.SpawnCEG("whitesmoke", sx, Spring.GetGroundHeight(sx, sz) + 10, sz)
    local god = Spring.CreateUnit("God", sx, sy, sz, 0, teamID)
	AddPowers(god)
    gadgetHandler:RemoveGadget()
end

function AddPowers(godID)
	--Power One
	if pow1 == "Volcanic Blast" then Spring.InsertUnitCmdDesc(tonumber(godID), volcanicCmd) end
	--Power Two
	if pow2 == "Teleport" then Spring.InsertUnitCmdDesc(tonumber(godID), teleportCmd) end
	--Power Three
	--if pow3 == "Something" then Spring.InsertUnitCmdDesc(tonumber(godID), somethingCmd) end
	return
end

function gadget:RecvLuaMsg(msg, playerID)
    msg = LuaMessages.deserialize(msg)
	local msg_type = msg[1]
	if msg_type == MSG_TYPES.GOD_SELECTED then
        local _, _, _, teamID = Spring.GetPlayerInfo(playerID)
		pow1 = msg[2]
		pow2 = msg[3]
		pow3 = msg[4]
        GG.Delay.DelayCall(SpawnGod, {teamID})
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
