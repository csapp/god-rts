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
DEBUG = 0

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

local imageName = ''
local fileName = 'LuaUI/Widgets/images/' .. imageName .. '.png'

-- SCRIPT FUNCTIONS
-- Returns the caption, parent container and commandtype of the button	

function setUnitInfo(unit)
	local unitInfoString = printUnitName(unit) .. "\n" .. printDescription(unit) .. "\n" .. printUnitLevel(unit) .. "\n" .. printUnitHealth(unit) .. "\n" .. printEXP(unit)

	unitInfo:SetCaption(unitInfoString)
end

--[[
function setUnitStats(unit)
	local unitStatString = printVelocity(unit)
	
	unitStats:SetCaption(unitStatString)
end
]]

function widget:Initialize()
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Chili = WG.Chili
	Label = Chili.Label
	Window = Chili.Window
	Control = Chili.Control
	Image = Chili.Image
	
	local screen0 = Chili.Screen0	

	unitInfo = Label:New{
		parent = statusBar,
		x = 110,
		width = "25%",
		height = "100%",
		fontsize = 13,
		autosize = false,
		autoObeyLineHeight = true,
		textColor = {1,1,1,1},
		anchors = {left=true,bottom=true,right=false,top=false},
		caption = "",
	}
	--[[
	unitStats = Label:New{
		parent = statusBar,
		x = 300,
		y = -220,
		width = "25%",
		height = "100%",
		fontsize = 13,
		autosize = false,
		autoObeyLineHeight = true,
		textColor = {1,1,1,1},
		anchors = {left=true,bottom=true,right=false,top=false},
		caption = "",
	}
	]]

	unitPic = Image:New {
		x = 10,
		width = 96,
		height = 96,
		file = 'unitpics/soldier.png',
	}

	statusBar = Window:New{
		parent = screen0,
		x = 0,
		y = -150,
		width = "100%",
		height = 150,
		draggable = false,
		resizable = false,
		dragUseGrip = false,		
		anchors = {left=true,bottom=true,right=true,top=false},
		skinName  = "DarkGlass",
		children = {unitInfo,unitPic,--[[unitStats]]},
	}
end

function widget:GameStart()
    game_start = true
end

function widget:CommandsChanged()
    local selected_units = Spring.GetSelectedUnits()
	if not game_start then
        return
    end
    if Spring.GetSelectedUnitsCount() == 0 then
        unitInfo:SetCaption("")
		--unitStats:SetCaption("")
        return
    end
    -- XXX need to decide what to do if multiple units are selected
	-- This just handles showing the first unit selected in a group
    setUnitInfo(selected_units[1])
	setUnitName(selected_units[1])
	-- setUnitStats(selected_units[1])
end
	
function widget:Shutdown()
  widgetHandler:ConfigLayoutHandler(nil)
  Spring.ForceLayoutUpdate()
end

function setUnitName(unitID)
	imageName = string.lower(printUnitName(unitID))
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
	defId = Spring.GetUnitDefID(unitID)
	
	if(defId ~= nil) then
        unitDef = UnitDefs[defId]
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

-- This doesn't work right now. Possible workaround:
-- http://springrts.com/phpbb/viewtopic.php?f=14&t=27554&p=512504&hilit=unit+description#p512504
-- However I can't get that to work either
function printDescription(unitID)
	local desc = UnitDefs[Spring.GetUnitDefID(unitID)].description
	
	if desc ~= nil then
		return desc
	else
		return ""
	end
end

--[[
function printVelocity(unitID)
	local velocity = UnitDefs[Spring.GetUnitDefID(unitID)].MaxWaterDepth
	
	Spring.Echo("velocity: ", velocity)
	
	if velocity ~= nil then
		return "Speed: " .. velocity
	else
		return ""
	end
end
]]

	--local range = WeaponDefs[Spring.GetUnitDefID(unitID)].range
	--local damage = WeaponDefs[Spring.GetUnitDefID(unitID)].damge
	--local attackSpeed = WeaponDefs[Spring.GetUnitDefID(unitID)].reloadtime