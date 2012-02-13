--include("utilities.lua")

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

function LuaMessages.serialize(msg_type, params)
    return msg_type .. "," .. table.concat(params, ",")
end

function LuaMessages.deserialize(message)
    return split(message, ',')
end

MSG_TYPES = {
    CONVERT_STARTED = "convert_started",
    CONVERT_PROGRESS = "convert_progress",
    CONVERT_FINISHED = "convert_finished",
    CONVERT_CANCELLED = "convert_cancelled",
    GOD_SELECTED = "god_selected",
}

ACTION_TYPES = {
}
