function widget:GetInfo()
 	return {
 		name		= "GodSelectionWindow",
 		desc		= "Used to select god powers before the god unit is spawned",
 		author		= "matt",
 		date		= "2012-02-10",
 		license         = "GNU GPL v2",
 		layer		= 1,
 		enabled   	= true
 	}
 end
 -- INCLUDES
 include("msgs.h.lua")
 -- CONSTANTS
 -- SYNCED CONTROLS
 -- CHILI CONTROLS
 local Chili
 
 -- MEMBERS
 local listOfPowers = {"","",""}
 local team_positions = {}
 local ID = Spring.GetMyPlayerID()
 local godselLabel
 local godselWindow
 
 -- SCRIPT FUNCTIONS
function selectPower(row, power, button)
	listOfPowers[row] = power
	--Spring.Echo(listOfPowers[1], listOfPowers[2], listOfPowers[3])
	--Highlight Button
	--Set listofPowers
end

function done()
    if(listOfPowers[1] == "" or listOfPowers[2] == "" or listOfPowers[3] == "") then
	    return false
    end
    LuaMessages.SendMsgToAll(MSG_TYPES.GOD_SELECTED, listOfPowers)
	widgetHandler:RemoveWidget()
end

function ClickFunc(button) 
   if(button.cmdid == 4) then
     done()
	 return
   end
   selectPower(button.cmdid, button.caption, button)
end

 -- WIDGET CODE
 function widget:Initialize()	
 	if (not WG.Chili) then
 		widgetHandler:RemoveWidget()
 		return
 	end
 	
 	Chili      = WG.Chili
 	local screen0 = Chili.Screen0

 	godselWindow = Chili.Window:New{
 		x = '25%',
 		y = '25%',	
 		dockable = true,
 		parent = screen0,
 		caption = "",
 		clientWidth = 480,
 		clientHeight = 520,
		skinName  = "Godly",
 	}	
 	
 	godselLabel = Chili.Label:New{
 		x = '150',
 		y = '10',
 		width = 12,
 		parent = godselWindow,
 		caption = "Choose your god powers",
 		fontsize = 30,
 	}

-- Row 1

	local buttonVolcanicBlast = Chili.Button:New {
		parent = godselWindow,
		x = 30,
		y = 40,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Volcanic Blast",
		isDisabled = false,
		cmdid = 1,
		OnMouseDown = {ClickFunc},
	}


	local buttonZombieApocalyspe = Chili.Button:New {
		parent = godselWindow,
		x = 180,
		y = 40,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Zombie Apocalypse",
		isDisabled = false,
		cmdid = 1,
		OnMouseDown = {ClickFunc},
		}

	local buttonBFB = Chili.Button:New {
		parent = godselWindow,
		x = 330,
		y = 40,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Big Friendly Bomb",
		isDisabled = false,
		cmdid = 1,
		OnMouseDown = {ClickFunc},
		}

--Row 2

	local buttonTeleport = Chili.Button:New {
		parent = godselWindow,
		x = 30,
		y = 190,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Teleport",
		isDisabled = false,
		cmdid = 2,
		OnMouseDown = {ClickFunc},
	}


	local buttonLove= Chili.Button:New {
		parent = godselWindow,
		x = 180,
		y = 190,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Whole Lotta Love",
		isDisabled = false,
		cmdid = 2,
		OnMouseDown = {ClickFunc},
		}

	local buttonPossession = Chili.Button:New {
		parent = godselWindow,
		x = 330,
		y = 190,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Possession",
		isDisabled = false,
		cmdid = 2,
		OnMouseDown = {ClickFunc},
		}


--Row 3

	local buttonSomething = Chili.Button:New {
		parent = godselWindow,
		x = 30,
		y = 340,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Boots of Hermes",
		isDisabled = false,
		cmdid = 3,
		OnMouseDown = {ClickFunc},
	}


	local buttonExpress = Chili.Button:New {
		parent = godselWindow,
		x = 180,
		y = 340,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Express Conversion",
		isDisabled = false,
		cmdid = 3,
		OnMouseDown = {ClickFunc},
		}

	local buttonAphrodite = Chili.Button:New {
		parent = godselWindow,
		x = 330,
		y = 340,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 120,
		minHeight = 120,
		caption = "Aphrodite",
		isDisabled = false,
		cmdid = 3,
		OnMouseDown = {ClickFunc},
		}

--Done

	local button = Chili.Button:New {
		parent = godselWindow,
		x = 380,
		y = 470,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 40,
		minHeight = 40,
		caption = "Done",
		isDisabled = false,
		cmdid = 4,
		OnMouseDown = {ClickFunc},
		}

 end
