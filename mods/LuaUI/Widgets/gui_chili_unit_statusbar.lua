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
include("msgs.h.lua")
VFS.Include("LuaUI/Headers/utilities.lua")
include("managers.h.lua")

-- CONSTANTS
local Chili
local Label
local Window
local MAXBUTTONSONROW = 3
local COMMANDSTOEXCLUDE = {"timewait","deathwait","squadwait","gatherwait","loadonto","nextmenu","prevmenu"}
local MY_PLAYER_ID = Spring.GetMyPlayerID()

-- MEMBERS

local commandWindow

-- CONTROLS
local spGetModKeyState			= Spring.GetModKeyState
local spGetMouseState			= Spring.GetMouseState
local spTraceScreenRay			= Spring.TraceScreenRay
local spGetUnitHealth			= Spring.GetUnitHealth
local spGetUnitExp			    = Spring.GetUnitExperience

local game_start = false

local imageName = ''
local filePath = ''
local unitPic

local updateRequired = true
local progressBars = {}
local statusBar = nil
local pbarWindow = nil
local current_progress_bar = nil
local multipliers = {}
local powerNames = {}

-- SCRIPT FUNCTIONS

-- Returns the caption, parent container and commandtype of the button	
function setUnitInfo(unit)
	local unitInfoString = --printUnitName(unit) .. "\n"..
                           printDescription(unit) .. "\n"..
                           printUnitLevel(unit) .. "\n"..
                           printUnitHealth(unit) .. "\n"..
                           printEXP(unit)

	unitInfo:SetCaption(unitInfoString)
end

function setMultipliers(mults)
	multipliers = mults
end

function LayoutHandler(xIcons, yIcons, cmdCount, commands)
	widgetHandler.commands   = commands
	widgetHandler.commands.n = cmdCount
	widgetHandler:CommandsChanged()
	local reParamsCmds = {}
	local customCmds = {}

	return "", xIcons, yIcons, {}, customCmds, {}, {}, {}, {}, reParamsCmds, {[1337]=9001}
end

function setUnitStats(unit)
	local unitStatString = printVelocity(unit) .. "\n" ..
						   printDamage(unit) .. "\n" ..
						   printRange(unit) .. "\n" ..
						   printAttSpeed(unit)
	
	unitStats:SetCaption(unitStatString)
end

function resetWindow(container)
	container:ClearChildren()
	container.xstep = 1
	container.ystep = 1
end

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

	statusBar = Window:New{
		parent = screen0,
		x = 0,
		y = -250,
		width = -350,
		height = 250,
		draggable = false,
		resizable = false,
		dragUseGrip = false,		
		anchors = {left=true,bottom=true,right=true,top=false},
		skinName  = "Godly",
		--children = {unitInfo,imageWindow,[>unitStats<]},
	}
	unitInfo = Label:New{
		parent = statusBar,
		x = 110,
		width = "25%",
		height = "100%",
		fontsize = 13,
		autosize = false,
		autoObeyLineHeight = true,
		anchors = {left=true,bottom=true,right=false,top=false},
		caption = "",
	}

	unitStats = Label:New{
		parent = statusBar,
		x = 500,
		y = -220,
		width = "25%",
		height = "100%",
		fontsize = 13,
		autosize = false,
		autoObeyLineHeight = true,
		anchors = {left=true,bottom=true,right=false,top=false},
		caption = "",
	}
	
	powerInfo = Label:New{
		parent = statusBar,
		x = 890,
		y = -220,
		width = "25%",
		height = "100%",
		fontsize = 13,
		autosize = false,
		autoObeyLineHeight = true,
		anchors = {left=true,bottom=true,right=false,top=false},
		caption = "",
	}
	
	imageWindow = Control:New{
        parent = statusBar,
		x = 10,
		width = 96,
		height = 96,
		padding = {0, 0, 0, 0},
		margin = {0, 0, 0, 0},
	}

	pbarWindow = Control:New{
        parent = statusBar,
        x = statusBar.width/2 - 100,
		width = 200,
		height = 50,
		padding = {0, 0, 0, 0},
		margin = {0, 0, 0, 0},
	}
	
	commandWindow = Chili.Control:New{
		parent = statusBar,
		x = 200,
		y = 0,
		width = "20%",
		height = "100%",
		xstep = 1,
		ystep = 1,
		draggable = false,
		resizable = false,
		dragUseGrip = false,
		caption = "Commands",
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
        if current_progress_bar ~= nil then
            pbarWindow:RemoveChild(current_progress_bar)
            current_progress_bar = nil
        end
        unitInfo:SetCaption("")
		unitStats:SetCaption("")
		powerInfo:SetCaption("")
		resetWindow(imageWindow)
		resetWindow(commandWindow)
		
        return
    end
    -- XXX need to decide what to do if multiple units are selected
	-- This just handles showing the first unit selected in a group
    --setUnitInfo(selected_units[1])
	setUnitName(selected_units[1])
	setUnitStats(selected_units[1])
	resetWindow(imageWindow)
	resetWindow(commandWindow)
	drawPortrait()
	printPowerInfo()
    
    if current_progress_bar ~= nil then
        pbarWindow:RemoveChild(current_progress_bar)
        current_progress_bar = nil
    end
    current_progress_bar = progressBars[selected_units[1]]
    if current_progress_bar ~= nil then
        pbarWindow:AddChild(current_progress_bar)
    end
	
	if DEBUG then
		for k,v in pairs(multipliers) do
			Spring.Echo(k,v)
		end
	end
	
	WG.GadgetQuery.CallManagerFunctionOnAll(setMultipliers, Managers.TYPES.ATTRIBUTE, 
                                        "GetValue", {selected_units[1]})
	
	updateRequired = true
	
end

-- Put any information into this function which you need to update on the fly.
function widget:Update(dt)
	local selected_units = Spring.GetSelectedUnits()
	
	if not game_start then
        return
    end
	
	if selected_units[1] ~= nil then
		setUnitInfo(selected_units[1])
	end
end

function drawPortrait()
	unitPic = Image:New {
		parent = imageWindow,
		width = '100%',
		height = '100%',
		file = filePath,
	}
end

function widget:DrawScreen()
    if updateRequired then
        updateRequired = false
    end
end
	
function widget:Shutdown()
  widgetHandler:ConfigLayoutHandler(nil)
  Spring.ForceLayoutUpdate()
end

function setUnitName(unitID)
	imageName = string.lower(printUnitName(unitID))
	filePath = 'unitpics/' .. imageName .. '.png'
end

-- STRING BUILDING FUNCTIONS

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
		if multipliers["HEALTH"] ~= 1 and multipliers["HEALTH"] ~= nil then
			healthString = healthString .. '+' .. multipliers["HEALTH"]
		end
		return healthString
	else
		return ""
	end
end

function printEXP(unitID)
	local currentXP = Spring.GetUnitExperience(unitID)
	local maxXP = UnitDefs[Spring.GetUnitDefID(unitID)].customParams.max_xp
	
	if currentXP ~= nil and maxXP ~= nil then
		expString = "Experience Points: " .. math.floor(currentXP) .. " / " .. maxXP
		if multipliers["XP"] ~= 1 and multipliers["XP"] ~= nil then
			expString = expString .. '+' .. multipliers["XP"]
		end
		return expString
	else
		return ""
	end
end

function printDescription(unitID)
	local desc = Spring.GetUnitTooltip(unitID)
	
	if desc ~= nil then
		return desc
	else
		return ""
	end
end

function printVelocity(unitID)
	local speed = Spring.GetUnitMoveTypeData(unitID).maxSpeed
	
	if speed ~= nil then
		speedString = "Speed: " .. speed
		if multipliers["MOVE_SPEED"] ~= 1 and multipliers["MOVE_SPEED"] ~= nil then
			speedString = speedString .. '+' .. multipliers["MOVE_SPEED"]
		end
		return speedString
	else
		return ""
	end
end

function printDamage(unitID)
	local weapons = UnitDefs[Spring.GetUnitDefID(unitID)].weapons
	
    if table.isempty(weapons) then
		return ""
	end
	
    local damage = WeaponDefs[weapons[1].weaponDef].damages[0] -- Good job on the consistent numbering system, Spring.
	
	if damage ~= nil then
		damageString = "Damage: " .. damage
		if multipliers["DAMAGE"] ~= 1 and multipliers["DAMAGE"] ~= nil then
			damageString = damageString .. '+' .. multipliers["DAMAGE"]
		end
		return damageString
	else
		return ""
	end
end

function printRange(unitID)
	local weapons = UnitDefs[Spring.GetUnitDefID(unitID)].weapons
	
    if table.isempty(weapons) then
		return ""
	end
	
    local range = WeaponDefs[weapons[1].weaponDef].range
	
	if range ~= nil then
		rangeString = "Range: " .. range
		if multipliers["ATTACK_RANGE"] ~= 1 and multipliers["ATTACK_RANGE"] ~= nil then
			rangeString = rangeString .. '+' .. multipliers["ATTACK_RANGE"]
		end
		return rangeString
	else
		return ""
	end
end

function printAttSpeed(unitID)
	local weapons = UnitDefs[Spring.GetUnitDefID(unitID)].weapons
	
    if table.isempty(weapons) then
		return ""
	end
	
    local attSpeed = WeaponDefs[weapons[1].weaponDef].reload
	
	if attSpeed ~= nil then
		aspeedString = "Attack Speed: " .. attSpeed
		if multipliers["ATTACK_SPEED"] ~= 1 and multipliers["ATTACK_SPEED"] ~= nil then
			aspeedString = aspeedString .. '+' .. multipliers["ATTACK_SPEED"]
		end
		return aspeedString
	else
		return ""
	end
end

local function getPowerNames()
    local function getNames(names) powerNames = names end
	WG.GadgetQuery.CallManagerFunctionOnAll(getNames, Managers.TYPES.POWER, "GetName")
end

function printPowerInfo()
    -- Wait until we populate the powerNames table before calling this function
    if table.isempty(powerNames) then return end

	local function getCharges(returnCharges)
        local powerString = "Charges \n"
        for k,v in pairs(returnCharges) do
            powerString = powerString..powerNames[k]..": "..math.floor(v*100).."%\n"
        end
	
        powerInfo:SetCaption(powerString)
	end

    WG.GadgetQuery.CallManagerFunctionOnAll(getCharges, Managers.TYPES.POWER, "GetCharge")	
end

local function createProgressBar(unitID, caption)

	local bars = 2
	local function p(a)
        return tostring(a).."%"
    end
	
	local bar_convert = Chili.Progressbar:New{
                parent = pbarWindow,
                color  = {0,0,1,1},
                --height = p(100/bars),
                --right  = 0,
                min = 0,
                max = 100,
                --x      = statusBar.width/2,
                --align = "center",
                --valign = "center",
                --y      = p(100/bars),
				value = 0,
                width = "100%",
                height = "100%",
                tooltip = "This shows your current conversion progress.",
                font   = {color = {1,1,1,1}, outlineColor = {0,0,0,0.7}, },
        }
	
	local lbl_convert = Chili.Label:New{
		parent = bar_convert,
		height = p(100/bars),
		right  = 26,
		width  = 40,
        x      = 0,
		caption = caption,
		valign  = "center",
		align   = "center",
		autosize = false,
		font   = {size = 12, outline = true, color = {0,1,0,1}},
		tooltip = "Amount of time until conversion is complete.",
	}

    progressBars[unitID] = bar_convert
    current_progress_bar = bar_convert
		
end

function destroyProgressBar(unitID)
    local progressBar = progressBars[unitID] 
    if not progressBar then
        return 
    end
    progressBar:Dispose()
    progressBars[unitID] = nil
end

local function updateProgressBar(unitID, progress)
    -- progress given as a decimal e.g. for 10% pass 0.1, not 10
    local progressBar = progressBars[unitID] 
    if not progressBar then
        return
    end
    progressBar:SetValue(progress*100)
end

function widget:RecvLuaMsg(msg, playerID)
    if playerID ~= MY_PLAYER_ID then return end
    local msg_type, params = LuaMessages.deserialize(msg)
    if msg_type == MSG_TYPES.PBAR_CREATE then
        unitID, caption = tonumber(params[1]), params[2]
		createProgressBar(unitID, caption)
    elseif msg_type == MSG_TYPES.PBAR_PROGRESS then
        unitID, progress = tonumber(params[1]), tonumber(params[2])
        updateProgressBar(unitID, progress)
    elseif msg_type == MSG_TYPES.PBAR_DESTROY then
        unitID = tonumber(params[1])
		destroyProgressBar(unitID)
    elseif msg_type == MSG_TYPES.GOD_CREATED then
        getPowerNames()
    end
end

-- These are here simply because Kaitlin is lazy and uses these a lot when testing.
--[[
for k,v in pairs(Spring.GetUnitMoveTypeData(unitID)) do
Spring.Echo(k,v)
end
]]
	
--[[
for k,v in pairs(WeaponDefs[weapons[1].weaponDef].damages) do
   Spring.Echo(k,v)
end
]]	
--[[
 for id,weaponDef in pairs(UnitDefs) do
   for name,param in unitDef:pairs() do
     Spring.Echo(name,param)
   end
 end
 --]]
