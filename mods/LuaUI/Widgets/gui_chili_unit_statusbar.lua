-- This code is reponsible for displaying the status bar along the bottom of the screen and the information displayed in it.
-- This code is based on code from Alpha Domination (http://www.gravegast.be/~sunspot/temp/)
-- Help with strings is from http://lua-users.org/wiki/StringRecipes

-- WIDGET CODE
function widget:GetInfo()
	return {
		name		= "Unit Status Bar",
		desc		= "Shows various stats for the selected unit, such as name, level, and health.",
		author		= "Kaitlin",
		date		= "February 2012",
		license     = "GNU GPL v2",
		layer		= math.huge,
		enabled   	= true,
		handler		= true,
	}
end

-- Uncomment this to display debug messages:
--DEBUG = 0

-- INCLUDES
VFS.Include("LuaRules/Includes/utilities.lua")

-- CONSTANTS
local Chili
local Label
local Window

-- MEMBERS

-- CONTROLS
local spGetModKeyState			= Spring.GetModKeyState
local spGetMouseState			= Spring.GetMouseState
local spTraceScreenRay			= Spring.TraceScreenRay
local spGetUnitHealth			= Spring.GetUnitHealth
local spGetUnitExp			    = Spring.GetUnitExperience

local game_start = false

-- SCRIPT FUNCTIONS
function setUnitInfo(unit)
	local unitInfoString = printUnitHealth(unit) .. "      " .. printUnitName(unit) .. "      " .. printUnitLevel(unit) .. "      " .. printEXP(unit)

	unitInfo:SetCaption(unitInfoString)
end

function widget:Initialize()
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end

	Chili = WG.Chili
	Label = Chili.Label
	Window = Chili.Window
	local screen0 = Chili.Screen0

	statusBar = Window:New{
		parent = screen0,
		x = 0,
		y = -220,
		width = "100%",
		height = "25%",
		draggable = false,
		resizable = false,
		dragUseGrip = false,		
		anchors = {left=true,bottom=true,right=true,top=false},
		skinName  = "DarkGlass",
	}	

	unitInfo = Label:New{
		parent = statusBar,
		width = 1000,
		caption = "0",
		fontsize = 13,
		autosize = false,
		autoObeyLineHeight = false,
		textColor = {1,1,1,1},
		anchors = {left=true,bottom=true,right=false,top=false},		
	}	
end

function widget:GameStart()
    game_start = true
end

function widget:CommandsChanged()
    if not game_start then
        return
    end
    if Spring.GetSelectedUnitsCount() == 0 then
        unitInfo:SetCaption("")
        return
    end
    local selected_units = Spring.GetSelectedUnits()
    -- XXX need to decide what to do if multiple units are selected
	-- This just handles showing the first unit selected in a group
    setUnitInfo(selected_units[1])
end

function widget:Shutdown()
  widgetHandler:ConfigLayoutHandler(nil)
  Spring.ForceLayoutUpdate()
end


-- String-building functions

function printUnitLevel(unitID)
	local level = UnitDefs[Spring.GetUnitDefID(unitID)].customParams.level
	
	if level ~= nil then
		levelString = "Level: " .. level
		return levelString
	else
		return ""
	end
end

function printUnitName(unitID)
	local defId = Spring.GetUnitDefID(unitID)
	
	if(defId ~= nil) then
        local unitDef = UnitDefs[defId]
		unitName = unitDef.name:gsub("^%l", string.upper)
        return unitName
	else
		return ""
    end
end

function printUnitHealth(unitID)
	local health, maxHealth, _, _, _ = spGetUnitHealth(unitID)
	
	if health and health ~= nil then
		healthString = "HP: " .. math.floor(health) .. " / " .. math.floor(maxHealth)
		return healthString
	else
		return ""
	end
end

function printEXP(unitID)
	local currentXP = Spring.GetUnitExperience(unitID)
	local maxXP = UnitDefs[Spring.GetUnitDefID(unitID)].customParams.max_xp
	
	if currentXP ~= nil and maxXP ~= nil then
		expString = "Experience Points: " .. currentXP .. " / " .. maxXP
		return expString
	else
		return ""
	end
end