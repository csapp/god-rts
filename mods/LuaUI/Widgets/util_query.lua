function widget:GetInfo()
    return {
        name = "Query Gadget state",
        desc = "Widget that allows UI to query global gadget state",
        author = "cam",
        date = "2012-03-19",
        license = "GNU GPL v2",
        layer = 1,
        enabled = true,
    }
end

include("msgs.h.lua")

local MY_PLAYER_ID = Spring.GetMyPlayerID()
local queue = {}

WG.GadgetQuery = {}

local function AddToQueue(item)
    -- Add item to queue and return index where it was added
    counter = 1
    for k,v in pairs(queue) do
        if k ~= counter then
            queue[k] = item
            return k
        end
        counter = counter + 1
    end
    queue[counter] = item
    return counter
end

local function Callback(id, reply)
    local callback = queue[id]
    if not callback then 
        Spring.Echo('no callback')
        return end
    callback(reply)
end

local function QueryGadgetState(funcstring, callback)
    local id = AddToQueue(callback)
    LuaMessages.SendLuaRulesMsg(MSG_TYPES.GADGET_STATE_QUERY, {id, funcstring})
end

WG.GadgetQuery.QueryGadgetState = QueryGadgetState

function widget:RecvLuaMsg(msg, playerID)
    if playerID ~= MY_PLAYER_ID then return end
    local msgtype, params = LuaMessages.deserialize(msg)
    if msgtype ~= MSG_TYPES.GADGET_STATE_REPLY then return end
    local msgID, reply = unpack(params)
    Callback(tonumber(msgID), reply)
end
