--include("utilities.lua")

local SendLuaUIMsg = Spring.SendLuaUIMsg
local SendLuaRulesMsg = Spring.SendLuaRulesMsg

function split(pString, pPattern)
	local tableIndex = 1
	local Table = {} -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			Table[tableIndex] = cap
			tableIndex = tableIndex + 1
		end
		last_end = e+1
		s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
		cap = pString:sub(last_end)
		Table[tableIndex] = cap
		tableIndex = tableIndex + 1
	end
	return Table
end

LuaMessages = {}

MSG_TYPES = {
    -- Progress bars
    PBAR_CREATE = "pbar_create",
    PBAR_PROGRESS = "pbar_progress",
    PBAR_DESTROY = "pbar_destroy",

    CONVERT_FINISHED = "convert_finished",
    GOD_SELECTED = "godselected",
}

ACTION_TYPES = {
}

function LuaMessages.serialize(msg_type, params)
    return msg_type .. "," .. table.concat(params, ",")
end

function LuaMessages.deserialize(message)
    local msg_table = split(message, ',')
    local msg_type = msg_table[1]
    table.remove(msg_table, 1)
    return msg_type, msg_table
end

function LuaMessages.SendLuaUIMsg(msg_type, params)
    SendLuaUIMsg(LuaMessages.serialize(msg_type, params))
end

function LuaMessages.SendLuaRulesMsg(msg_type, params)
    SendLuaRulesMsg(LuaMessages.serialize(msg_type, params))
end

function LuaMessages.SendMsgToAll(msg_type, params)
    local msg = LuaMessages.serialize(msg_type, params)
    SendLuaUIMsg(msg)
    SendLuaRulesMsg(msg)
end
