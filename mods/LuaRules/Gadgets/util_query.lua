
function gadget:GetInfo()
    return {
        name = "Game state queries",
        desc = "Gadget to answer game state queries from widgets",
        author = "cam",
        date = "2012-03-19",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end


------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/msgs.h.lua")

function gadget:RecvLuaMsg(msg, playerID)
    local msgtype, params = LuaMessages.deserialize(msg)
    if msgtype ~= MSG_TYPES.GADGET_STATE_QUERY then return end
    local msgID, funcstring = unpack(params)
    local func = assert(loadstring("return " .. funcstring))
    local return_params = {msgID, func()}
    LuaMessages.SendLuaUIMsg(MSG_TYPES.GADGET_STATE_REPLY, return_params) 
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
return false

end
