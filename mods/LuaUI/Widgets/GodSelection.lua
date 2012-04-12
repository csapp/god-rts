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
 local errorText = ""
 
 -- SCRIPT FUNCTIONS
function selectPower(row, power, button)

	listOfPowers[row] = power

	--Spring.Echo(listOfPowers[1], listOfPowers[2], listOfPowers[3])
	--Highlight Button
	--Set listofPowers
end

function done()
    if(listOfPowers[1] == "" or listOfPowers[2] == "" or listOfPowers[3] == "") then
		errorText = "You must select a power from each tier"
		loadPanel()
	    return false
    end
    LuaMessages.SendLuaRulesMsg(MSG_TYPES.GOD_SELECTED, listOfPowers)
	widgetHandler:RemoveWidget()
end

function ClickFunc(button) 
   if(button.cmdid == 4) then
     done()
	 return
   end
   selectPower(button.cmdid, button.caption, button)
   loadPanel()

end

 -- WIDGET CODE
 
 function DrawButtons()
 	local selected = "unpressed"
 	godselLabel = Chili.Label:New{
 		x = 50,
 		y = '10',
 		width = 12,
 		parent = godselWindow,
 		caption = "Choose your god powers",
 		fontsize = 30,
 	}
	
	Power1Label = Chili.Label:New{
 		x = '30',
 		y = '150',
 		width = 12,
 		parent = godselWindow,
 		caption = "Power 1:",
 		fontsize = 24,
 	}
	Power2Label = Chili.Label:New{
 		x = '30',
 		y = '420',
 		width = 12,
 		parent = godselWindow,
 		caption = "Power 2:",
 		fontsize = 24,
 	}
	Power2Label = Chili.Label:New{
 		x = '30',
 		y = '720',
 		width = 12,
 		parent = godselWindow,
 		caption = "Power 3:",
 		fontsize = 24,
 	}
	-- Row 1
	
	selected = "unpressed"
	if(listOfPowers[1] == "Volcanic Blast") then selected = "pressed" end
	local buttonVolcanicBlast = Chili.Button:New {
		parent = godselWindow,
		x = 130,
		y = 40,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 90,
		minHeight = 90,
		caption = "Volcanic Blast",
		isDisabled = false,
		cmdid = 1,
		OnMouseDown = {ClickFunc},
		state = selected,
		tooltip = "Cause massive fire damage to units within a certain radius.",
	}
	
	Vimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/volcanicblast.png',
		parent = buttonVolcanicBlast;
	}
	
	VolcanicLabel = Chili.Label:New{
 		x = 132,
 		y = 130,
 		width = 12,
 		parent = godselWindow,
 		caption = "Volcanic Blast",
 		fontsize = 10,
 	}
	
	VolcanicCooldownLabel = Chili.Label:New{
 		x = 132,
 		y = 140,
 		width = 12,
 		parent = godselWindow,
 		caption = "Cooldown: 10s",
 		fontsize = 10,
 	}

	selected = "unpressed"
	if(listOfPowers[1] == "Zombie Apocalypse") then selected = "pressed" end
	local buttonZombieApocalyspe = Chili.Button:New {
		parent = godselWindow,
		x = 240,
		y = 40,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 90,
		minHeight = 90,
		caption = "Zombie Apocalypse",
		isDisabled = false,
		cmdid = 1,
		OnMouseDown = {ClickFunc},
		state = selected,
		tooltip = "Spawn a wave of hungry zombies for a short time.",
		}
		
	ZAimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/zombieapocalypse.png',
		parent = buttonZombieApocalyspe;
	}
		
	ZALabel = Chili.Label:New{
 		x = 242,
 		y = 130,
 		width = 12,
 		parent = godselWindow,
 		caption = "Zombie Apocalypse",
 		fontsize = 10,
 	}
	
	ZACooldownLabel = Chili.Label:New{
 		x = 242,
 		y = 140,
 		width = 12,
 		parent = godselWindow,
 		caption = "Cooldown: 10s",
 		fontsize = 10,
 	}

	selected = "unpressed"
	if(listOfPowers[1] == "Big Friendly Bomb") then selected = "pressed" end
	local buttonBFB = Chili.Button:New {
		parent = godselWindow,
		x = 350,
		y = 40,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 90,
		minHeight = 90,
		caption = "Big Friendly Bomb",
		isDisabled = false,
		cmdid = 1,
		OnMouseDown = {ClickFunc},
		state = selected,
		tooltip = "Explode a Massive Bomb causing knockback and damage within a certain radius.",
		}
		
	BFBimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/bfb.png',
		parent = buttonBFB;
	}
		
	BFBLabel = Chili.Label:New{
 		x = 352,
 		y = 130,
 		width = 12,
 		parent = godselWindow,
 		caption = "Big Friendly Bomb",
 		fontsize = 10,
 	}
	
	BFBCooldownLabel = Chili.Label:New{
 		x = 352,
 		y = 140,
 		width = 12,
 		parent = godselWindow,
 		caption = "Cooldown: 10s",
 		fontsize = 10,
 	}

--Row 2

	selected = "unpressed"
	if(listOfPowers[2] == "Teleport") then selected = "pressed" end
	local buttonTeleport = Chili.Button:New {
		parent = godselWindow,
		x = 130,
		y = 170,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 90,
		minHeight = 90,
		caption = "Teleport",
		isDisabled = false,
		cmdid = 2,
		OnMouseDown = {ClickFunc},
		state = selected,
		tooltip = "Teleport to another location on the map.",
	}
	
	teleportimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/teleport.png',
		parent = buttonTeleport;
	}
	
	TeleportLabel = Chili.Label:New{
 		x = 132,
 		y = 260,
 		width = 12,
 		parent = godselWindow,
 		caption = "Teleport",
 		fontsize = 10,
 	}
	
	TeleportCooldownLabel = Chili.Label:New{
 		x = 132,
 		y = 270,
 		width = 12,
 		parent = godselWindow,
 		caption = "Cooldown: 10s",
 		fontsize = 10,
 	}
	

	selected = "unpressed"
	if(listOfPowers[2] == "Whole Lotta Love") then selected = "pressed" end
	local buttonLove= Chili.Button:New {
		parent = godselWindow,
		x = 240,
		y = 170,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 90,
		minHeight = 90,
		caption = "Whole Lotta Love",
		isDisabled = false,
		cmdid = 2,
		OnMouseDown = {ClickFunc},
		state = selected,
		tooltip = "Revive units within a certain radius to full health.",
		}
		
	wllimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/wholelottalove.png',
		parent = buttonLove;
	}
		
	WLLLabel = Chili.Label:New{
 		x = 242,
 		y = 260,
 		width = 12,
 		parent = godselWindow,
 		caption = "Whole Lotta Love",
 		fontsize = 10,
 	}
	
	WLLCooldownLabel = Chili.Label:New{
 		x = 242,
 		y = 270,
 		width = 12,
 		parent = godselWindow,
 		caption = "Cooldown: 10s",
 		fontsize = 10,
 	}
		
	selected = "unpressed"
	if(listOfPowers[2] == "Possession") then selected = "pressed" end
	local buttonPossession = Chili.Button:New {
		parent = godselWindow,
		x = 350,
		y = 170,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 90,
		minHeight = 90,
		caption = "Possession",
		isDisabled = false,
		cmdid = 2,
		OnMouseDown = {ClickFunc},
		state = selected,
		tooltip = "Transfer all normal units within radius to your team.",
		}
		
	possessionimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/possession.png',
		parent = buttonPossession;
	}
		
	PossessionLabel = Chili.Label:New{
 		x = 352,
 		y = 260,
 		width = 12,
 		parent = godselWindow,
 		caption = "Possession",
 		fontsize = 10,
 	}
	
	PossessionCooldownLabel = Chili.Label:New{
 		x = 352,
 		y = 270,
 		width = 12,
 		parent = godselWindow,
 		caption = "Cooldown: 10s",
 		fontsize = 10,
 	}


--Row 3

    -- XXX Commenting this out for now because of issue #154
	--selected = "unpressed"
	--if(listOfPowers[3] == "Boots of Hermes") then selected = "pressed" end
	--local buttonSomething = Chili.Button:New {
		--parent = godselWindow,
		--x = 30,
		--y = 340,
		--padding = {5, 5, 5, 5},
		--margin = {0, 0, 0, 0},
		--minWidth = 90,
		--minHeight = 90,
		--caption = "Boots of Hermes",
		--isDisabled = false,
		--cmdid = 3,
		--OnMouseDown = {ClickFunc},
		--state = selected,
	--}

    selected = "unpressed"
    if(listOfPowers[3] == "Metropolis") then selected = "pressed" end
    local buttonSomething = Chili.Button:New {
        parent = godselWindow,
        x = 130,
        y = 300,
        padding = {5, 5, 5, 5},
        margin = {0, 0, 0, 0},
        minWidth = 90,
        minHeight = 90,
        caption = "Metropolis",
        isDisabled = false,
        cmdid = 3,
        OnMouseDown = {ClickFunc},
        state = selected,
    }
	
	metropolisimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/metropolis.png',
		parent = buttonSomething;
	}
	
	MetropolisLabel = Chili.Label:New{
 		x = 132,
 		y = 390,
 		width = 12,
 		parent = godselWindow,
 		caption = "Metropolis",
 		fontsize = 10,
 	}

	selected = "unpressed"
	if(listOfPowers[3] == "Express Conversion") then selected = "pressed" end
	local buttonExpress = Chili.Button:New {
		parent = godselWindow,
		x = 240,
		y = 300,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 90,
		minHeight = 90,
		caption = "Express Conversion",
		isDisabled = false,
		cmdid = 3,
		OnMouseDown = {ClickFunc},
		state = selected,
		tooltip = "Halves the conversion time of villages.",
		}
		
	ecimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/expressconversion.png',
		parent = buttonExpress;
	}
		
	ECLabel = Chili.Label:New{
 		x = 242,
 		y = 390,
 		width = 12,
 		parent = godselWindow,
 		caption = "Express Conversion",
 		fontsize = 10,
 	}

	selected = "unpressed"
	if(listOfPowers[3] == "Aphrodite") then selected = "pressed" end
	local buttonAphrodite = Chili.Button:New {
		parent = godselWindow,
		x = 350,
		y = 300,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 90,
		minHeight = 90,
		caption = "Aphrodite",
		isDisabled = false,
		cmdid = 3,
		OnMouseDown = {ClickFunc},
		state = selected,
		tooltip = "Increase villager generation rate.",
		}
		
	aphroditeimage = Chili.Image:New {
		width="100%";
		height="90%";
		y="6%";
		keepAspect = true,	--isState;
		file = 'bitmaps/icons/aphrodite.png',
		parent = buttonAphrodite;
	}
		
	AphroditeLabel = Chili.Label:New{
 		x = 352,
 		y = 390,
 		width = 12,
 		parent = godselWindow,
 		caption = "Aphrodite",
 		fontsize = 10,
 	}

--Done

	local button = Chili.Button:New {
		parent = godselWindow,
		x = 370,
		y = 415,
		padding = {5, 5, 5, 5},
		margin = {0, 0, 0, 0},
		minWidth = 40,
		minHeight = 40,
		caption = "Done",
		isDisabled = false,
		cmdid = 4,
		OnMouseDown = {ClickFunc},
		}
		
	local errorLabel = Chili.Label:New {
							parent = godselWindow,
							autosize=false;
							width="100%";
							height="100%";
							align="left";
							valign="bottom";
							caption = errorText;
							fontSize = 16;
							fontShadow = true;
						}
 end
 
 function resetWindow(container)
	container:ClearChildren()
	container.xstep = 1
	container.ystep = 1
end
 
 function loadPanel()
	resetWindow(godselWindow)
	DrawButtons()
end

function widget:DrawScreen()
		--loadPanel()
end
 
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
 		clientWidth = 450,
 		clientHeight = 465,
		skinName  = "Godly",
 	}	
	
	loadPanel()

 end
