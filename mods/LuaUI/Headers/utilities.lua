-- Some utility functions

------------------------------------------------------------
-- STRING UTIL FUNCTIONS
------------------------------------------------------------
-- This function was written by sunspot for his Chili tutorial
-- http://springrts.com/wiki/Lesson_2_:_Dynamicly_change_label_content  

utils = {}
utils.string = {}

function utils.string.to_string(data, indent)
	local str = ""        
	if(indent == nil) then          
		indent = 0      
	end          
	local indenter = "    "      
	-- Check the type      
	if(type(data) == "string") then          
		str = str .. (indenter):rep(indent) .. data .. "\n"      
	elseif(type(data) == "number") then          
		str = str .. (indenter):rep(indent) .. data .. "\n"      
	elseif(type(data) == "boolean") then          
		if(data == true) then              
			str = str .. "true"          
		else              
			str = str .. "false"          
		end      
	elseif(type(data) == "table") then          
		local i, v          
		for i, v in pairs(data) do              
		-- Check for a table in a table              
			if(type(v) == "table") then                  
				str = str .. (indenter):rep(indent) .. i .. ":\n"              
                        str = str .. to_string(v, indent + 2)              
			else                  
				str = str .. (indenter):rep(indent) .. i .. ": " ..  to_string(v, 0)             
			end          
		end          
	elseif(type(data) == "function") then                  
		str = str .. (indenter):rep(indent) .. 'function' .. "\n"      
	else          
		Spring.Echo(1, "Error: unknown data type: %s", type(data))      
	end        
	return str  
end  

-- This function was written by sunspot for his Chili tutorial
-- http://springrts.com/wiki/Lesson_2_:_Dynamicly_change_label_content  
function utils.string.split(pString, pPattern)
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

------------------------------------------------------------
-- TABLE UTIL FUNCTIONS
------------------------------------------------------------
-- This function was written by sunspot for his Chili tutorial
-- http://springrts.com/wiki/Lesson_3_:_Command_and_Build_commands_in_a_chili_window 
function table.contains(table, element)   
	for i=1, #table do     
		if table[i] == element then       
			return true     
		end   
	end   
	return false 
end

function utils.distance_between_units(unitID1, unitID2)
    local u1x, u1y, u1z = Spring.GetUnitBasePosition(unitID1)
    local u2x, u2y, u2z = Spring.GetUnitBasePosition(unitID2)
    local dx, dy, dz = u2x-u1x, u2y-u1y, u2z-u1z
    return math.sqrt(dx^2 + dy^2 + dz^2)
end

