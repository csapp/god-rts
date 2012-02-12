local function split(pString, pPattern)
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

MSGS = {}

function parse_message(message)
    return split(message, ',')
end

MSGS = {
    CONVERT_PROGRESS = "convert_progress",
}

ACTIONS = {
}
