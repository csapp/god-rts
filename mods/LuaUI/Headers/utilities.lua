-- Some utility functions
-- Some functions borrowed from http://lua-users.org/wiki/FunctionalLibrary

utils = {}
utils.string = {}

 -- map(function, table)
 -- e.g: map(double, {1,2,3})    -> {2,4,6}
function utils.map(func, tbl)
    local newtbl = {}
    for i,v in pairs(tbl) do
        newtbl[i] = func(v)
    end
    return newtbl
end

-- filter(function, table)
-- e.g: filter(is_even, {1,2,3,4}) -> {2,4}
function utils.filter(func, tbl)
    local newtbl= {}
    for i,v in pairs(tbl) do
        if func(v) then
            newtbl[i]=v
        end
    end
    return newtbl
end
--
------------------------------------------------------------
-- STRING UTIL FUNCTIONS
------------------------------------------------------------

local function to_string(data)
	if type(data) == "string" then          
        return data
	elseif type(data) == "number" or type(data) == "boolean" then          
        return tostring(data)
	elseif type(data) == "table" then          
        return table.tostring(data)
	elseif type(data) == "function" then                  
        return "function"
	else          
		Spring.Echo(1, "Error: unknown data type: %s", type(data))      
	end        
end

utils.to_string = to_string
utils.string.to_string = to_string

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

-- generate a random string
-- http://lua-users.org/wiki/RandomStrings
local Chars = {}
for Loop = 0, 255 do
   Chars[Loop+1] = string.char(Loop)
end
local String = table.concat(Chars)

local Built = {['.'] = Chars}

local AddLookup = function(CharSet)
   local Substitute = string.gsub(String, '[^'..CharSet..']', '')
   local Lookup = {}
   for Loop = 1, string.len(Substitute) do
       Lookup[Loop] = string.sub(Substitute, Loop, Loop)
   end
   Built[CharSet] = Lookup

   return Lookup
end

function utils.string.random(Length, CharSet)
   -- Length (number)
   -- CharSet (string, optional); e.g. %l%d for lower case letters and digits

   local CharSet = CharSet or '.'

   if CharSet == '' then
      return ''
   else
      local Result = {}
      local Lookup = Built[CharSet] or AddLookup(CharSet)
      local Range = table.getn(Lookup)

      for Loop = 1,Length do
         Result[Loop] = Lookup[math.random(1, Range)]
      end

      return table.concat(Result)
   end
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

function table.containsvalue(table, value)
    for k,v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function table.isempty(t)
    return next(t) == nil
end

function table.getkeys(t)
    newtbl = {}
    for k,v in pairs(t) do
        table.insert(newtbl, k)
    end
    return newtbl
end

function table.getvalues(t)
    newtbl = {}
    for k,v in pairs(t) do
        table.insert(newtbl, v)
    end
    return newtbl
end

function table.random(t)
    local size = #t 
    if size > 0 then
        return t[math.random(size)]
    end
    return table.random(table.getkeys(t))
end

function table:merge(table2)
  for i,v in pairs(table2) do
    if (type(v)=='table') then
      local sv = type(self[i])
      if (sv == 'table')or(sv == 'nil') then
        if (sv == 'nil') then self[i] = {} end
        table.merge(self[i],v)
      end
    elseif (self[i] == nil) then
      self[i] = v
    end
  end
end

function table:shallowcopy()
  local newTable = {}
  for k, v in pairs(self) do
    newTable[k] = v
  end
  return newTable
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

-- These next three table functions taken from
-- http://lua-users.org/wiki/TableUtils
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function utils.distance_between_points(p1, p2)
    local x1, y1, z1 = unpack(p1)
    local x2, y2, z2 = unpack(p2)
    return math.sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)
end

function utils.distance_between_units(unitID1, unitID2)
    local u1x, u1y, u1z = Spring.GetUnitBasePosition(unitID1)
    local u2x, u2y, u2z = Spring.GetUnitBasePosition(unitID2)
    return utils.distance_between_points({u1x,u1y,u1z}, {u2x,u2y,u2z})
    --local dx, dy, dz = u2x-u1x, u2y-u1y, u2z-u1z
    --return math.sqrt(dx^2 + dy^2 + dz^2)
end

function IsObject(v)
  return ((type(v)=="metatable")or(type(v)=="userdata")) and(v.classname)
end

function IsNumber(v)
  return (type(v)=="number")
end

function isnumber(v)
  return (type(v)=="number")
end

function istable(v)
  return (type(v)=="table")
end

function isstring(v)
  return (type(v)=="string")
end

function isindexable(v)
  local t = type(v)
  return (t=="table")or(t=="metatable")or(t=="userdata")
end

function isfunc(v)
  return (type(v)=="function")
end

