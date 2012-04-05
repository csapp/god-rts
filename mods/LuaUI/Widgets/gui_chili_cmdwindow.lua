-- This code is responsible for the commands window.

-- Based on the widget written by Sunspot for his Chili tutorial
-- http://springrts.com/wiki/Lesson_3_:_Command_and_Build_commands_in_a_chili_window

function widget:GetInfo()
	return {
		name		= "command list window",
		desc		= "ChiliUi window that contains all the commands a unit has",
		author		= "Sunspot",
		date		= "2011-06-15",
		license     = "GNU GPL v2",
		layer		= math.huge,
		enabled   	= false,
		handler		= true,
	}
end

-- Comment this out when you don't want to see debug messages.
--DEBUG = 0

-- INCLUDES
VFS.Include("LuaUI/Headers/utilities.lua")

-- CONSTANTS
local MAXBUTTONSONROW = 4
local COMMANDSTOEXCLUDE = {"timewait","deathwait","squadwait","gatherwait","loadonto","nextmenu","prevmenu","firestate","movestate","repeat", "selfd", "patrol", "guard"}
local VILLAGECOMMANDSTOEXCLUDE = {"timewait","deathwait","squadwait","gatherwait","loadonto","nextmenu","prevmenu","firestate","movestate","repeat", "selfd", "patrol", "guard", "move", "attack", "fight", "wait"}
local VOLCANOCOMMANDSTOEXCLUDE = {"timewait","deathwait","squadwait","gatherwait","loadonto","nextmenu","prevmenu","firestate","movestate","repeat", "selfd", "patrol", "guard", "move", "fight", "wait", "stop"}
local Chili

-- MEMBERS
local x
local y
local imageDir = 'LuaUI/Images/commands/'
local commandWindow
local stateCommandWindow
local buildCommandWindow
local updateRequired = true
local selected_units
local buildQueue = {}
local buildQueueUnsorted = {}
local spGetFullBuildQueue = Spring.GetFullBuildQueue
local selectedFac 
local spGetUnitDefID = Spring.GetUnitDefID

-- CONTROLS
local spGetActiveCommand 	= Spring.GetActiveCommand
local spGetActiveCmdDesc 	= Spring.GetActiveCmdDesc
local spGetSelectedUnits    = Spring.GetSelectedUnits
local spSendCommands        = Spring.SendCommands


-- SCRIPT FUNCTIONS
function LayoutHandler(xIcons, yIcons, cmdCount, commands)
	widgetHandler.commands   = commands
	widgetHandler.commands.n = cmdCount
	widgetHandler:CommandsChanged()
	local reParamsCmds = {}
	local customCmds = {}

	return "", xIcons, yIcons, {}, customCmds, {}, {}, {}, {}, reParamsCmds, {[1337]=9001}
end

function ClickFunc(button) 
	local _,_,left,_,right = Spring.GetMouseState()
	local alt,ctrl,meta,shift = Spring.GetModKeyState()
	local index = Spring.GetCmdDescIndex(button.cmdid)
	if (left) then
		if DEBUG then Spring.Echo("active command set to ", button.cmdid) end
		Spring.SetActiveCommand(index,1,left,right,alt,ctrl,meta,shift)
	end
	if (right) then
		if DEBUG then Spring.Echo("active command set to ", button.cmdid) end
		Spring.SetActiveCommand(index,3,left,right,alt,ctrl,meta,shift)
	end
	
end

-- Returns the caption, parent container and commandtype of the button	
function findButtonData(cmd)
	local isState = (cmd.type == CMDTYPE.ICON_MODE and #cmd.params > 1)
	local isBuild = (cmd.id < 0)	
	local buttontext = ""
	local texture = getTexture(cmd.action)--'bitmaps/icons/'..(cmd.action)..'.png'
	local container
	if not isState and not isBuild then
		buttontext = cmd.name
		container = commandWindow
	elseif isState then
		local indexChoice = cmd.params[1] + 2
		buttontext = cmd.params[indexChoice]
		container = commandWindow
	elseif isBuild then
		container = buildCommandWindow
		buttontext = cmd.name:gsub("^%l", string.upper)
	else
		texture = cmd.texture
	end
	return buttontext, container, isState, isBuild, texture	
end

--sets texture to correct path depending on command. Yes I'm I know there is a "right" way to do this but it was taking forever to find
--so in the interest of time.... this works
function getTexture(action)
	--Spring.Echo("texture",action)
	if action == 'VolcanicBlast' then return 'bitmaps/icons/VolcanicBlast.png' end
	if action == 'Teleport' then return 'bitmaps/icons/Teleport.png' end
	if action == 'stop' then return 'bitmaps/icons/stop.png' end
	if action == 'wait' then return 'bitmaps/icons/wait.png' end
	if action == 'move' then return 'bitmaps/icons/move.png' end
	if action == 'attack' then return 'bitmaps/icons/attack.png' end
	if action == 'fight' then return 'bitmaps/icons/fight.png' end
	if action == 'buildunit_horseman' then return 'bitmaps/icons/buildunit_horseman.png' end
	if action == 'buildunit_hunter' then return 'bitmaps/icons/buildunit_hunter.png' end
	if action == 'buildunit_soldier' then return 'bitmaps/icons/buildunit_soldier.png' end
	return nil
end

function createMyButton(cmd)
	local tooltip = cmd.tooltip

	if(type(cmd) == 'table')then
		buttontext, container, isState, isBuild, texture = findButtonData(cmd)

		local result = container.xstep % MAXBUTTONSONROW
		container.xstep = container.xstep + 1
		local increaseRow = false
		if(result==0)then
			result = MAXBUTTONSONROW
			increaseRow = true
		end	

		local y_axis = 0;
		if not texture then
			y_axis = 72 * (container.ystep-1)
		else
			y_axis = 72 * (container.ystep-1)
		end
		
		local color = {0,0,0,1}
		local button = Chili.Button:New {
			parent = container,
			x = 72 * (result-1),
			y = y_axis,
			padding = {5, 5, 5, 5},
			margin = {0, 0, 0, 0},
			Width = 72,
			minHeight = 72,
			caption = buttontext,
			isDisabled = false,
			cmdid = cmd.id,
			OnMouseDown = {ClickFunc},
			tooltip = tooltip,
		}

		local image
		if texture then
			if DEBUG then Spring.Echo("texture",texture) end
			button:Resize(72,72)
			image = Chili.Image:New {
				width="100%";
				height="90%";
				y="6%";
				keepAspect = true,	--isState;
				file = texture;
				parent = button;
			}
			
		if isBuild then
		local countText = ''
		countText = tostring(buildQueueUnsorted[-cmd.id])
		if(countText == 'nil') then countText = '' end
					countLabel = Chili.Label:New {
							parent = image,
							autosize=false;
							width="100%";
							height="100%";
							align="right";
							valign="bottom";
							caption = countText;
							fontSize = 16;
							fontShadow = true;
					}
					local costLabel = Chili.Label:New {
							parent = image,
							right = 0;
							y = 0;
							x = 3;
							bottom = 3;
							autosize=false;
							align="left";
							valign="bottom";
							caption = string.format("%d m", UnitDefs[-cmd.id].metalCost);
							fontSize = 11;
							fontShadow = true;
					}
			end
			
		end
		
		if(increaseRow)then
			container.ystep = container.ystep+1
		end		
	end
end

local function UpdateFactoryBuildQueue() 
        buildQueue = spGetFullBuildQueue(selectedFac)
        buildQueueUnsorted = {}
        for i=1, #buildQueue do
                for udid, count in pairs(buildQueue[i]) do
                        buildQueueUnsorted[udid] = (buildQueueUnsorted[udid] or 0) + count
                        --Spring.Echo(udid .. "\t" .. buildQueueUnsorted[udid])
                end
        end
end

function filterUnwanted(commands)
	local uniqueList = {}
	local exclude = COMMANDSTOEXCLUDE
	if isVolcanoSelected() then exclude = VOLCANOCOMMANDSTOEXCLUDE end
	if isVillageSelected() then exclude = VILLAGECOMMANDSTOEXCLUDE end
	
	if DEBUG then Spring.Echo("Total commands ", #commands) end

	if not(#commands == 0)then
		j = 1
		for _, cmd in ipairs(commands) do
			if not table.contains(exclude,cmd.action) then
				uniqueList[j] = cmd
				j = j + 1
			end
		end
	end
	return uniqueList
end

function resetWindow(container)
	container:ClearChildren()
	container.xstep = 1
	container.ystep = 1
end

function loadPanel()
	resetWindow(commandWindow)
	resetWindow(stateCommandWindow)
	resetWindow(buildCommandWindow)
	local commands = Spring.GetActiveCmdDescs()
	commands = filterUnwanted(commands)
	table.sort(commands,function(x,y) return x.action < y.action end)
	for cmdid, cmd in pairs(commands) do
		rowcount = createMyButton(commands[cmdid]) 
	end
end

function widget:Initialize()
	widgetHandler:ConfigLayoutHandler(LayoutHandler)
	Spring.ForceLayoutUpdate()
	spSendCommands({"tooltip 0"})
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end

	Chili = WG.Chili
	local screen0 = Chili.Screen0
		
	commandWindow = Chili.Control:New{
		x = 0,
		y = 0,
		width = "100%",
		height = "100%",
		xstep = 1,
		ystep = 1,
		draggable = false,
		resizable = false,
		dragUseGrip = false,		
		children = {},
	}

	stateCommandWindow = Chili.Control:New{
		x = 0,
		y = 72,
		width = "100%",
		height = "20%",
		xstep = 1,
		ystep = 1,
		draggable = false,
		resizable = false,
		dragUseGrip = false,		
		children = {},
	}	

	buildCommandWindow = Chili.Control:New{
		x = 0,
		y = 144,
		width = "100%",
		height = "40%",
		xstep = 1,
		ystep = 1,
		draggable = false,
		resizable = false,
		dragUseGrip = false,		
		children = {},
	}		
	
	window0 = Chili.Window:New{
		x = -350,
		y = -250,	
		width = 350,
		height = 250,
		dockable = true,
		parent = screen0,
		textColor = {0.83,0.8,0.52,1},
		caption = "Commands",
		draggable = false,
		resizable = false,
		dragUseGrip = false,
		skinName  = "Godly",		
		children = {commandWindow,stateCommandWindow,buildCommandWindow},
	}
	
end

function isVolcanoSelected()
	newSelection = Spring.GetSelectedUnits()
	if #newSelection==1 and UnitDefs[spGetUnitDefID(newSelection[1])].name == "volcano" then 
		return true
	else 
		return false
	end
end

function isVillageSelected()
	newSelection = Spring.GetSelectedUnits()
	if #newSelection==1 and (UnitDefs[spGetUnitDefID(newSelection[1])].name == "smallvillage" or UnitDefs[spGetUnitDefID(newSelection[1])].name == "mediumvillage" or UnitDefs[spGetUnitDefID(newSelection[1])].name == "largevillage") then 
		return true
	else 
		return false
	end
end

function getMainSelected(selection)
	for i=1,#selection do
		local id = selection[i]
		local name = UnitDefs[spGetUnitDefID(id)].name
	end
end
	

function widget:CommandsChanged()
	if DEBUG then Spring.Echo("commandChanged called") end
	newSelection = Spring.GetSelectedUnits()
	updateRequired = true
	
	for i=1,#newSelection do
                local id = newSelection[i]
                if UnitDefs[spGetUnitDefID(id)].isFactory then
                        selectedFac = id
						UpdateFactoryBuildQueue() 
                        return
                end
        end
        selectedFac = nil
end

function widget:DrawScreen()
    if updateRequired then
        updateRequired = false
		loadPanel()
    end
end

function widget:Shutdown()
  widgetHandler:ConfigLayoutHandler(nil)
  Spring.ForceLayoutUpdate()
  spSendCommands({"tooltip 1"})
end
