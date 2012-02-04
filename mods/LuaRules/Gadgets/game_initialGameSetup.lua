
function gadget:GetInfo()
    return {
        name = "Initial Setup",
        desc = "Gadget that sets up the initial state of the game.",
        author = "Mani",
        date = "2012-04-02",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

local teamID = {}	
local sx, sy, sz = 0				  
local listOfUnits = {"Soldier", "Warrior", "Knight"}

local function getPlayerAndStartLocation()
	for index, ID in pairs(Spring.GetPlayerList()) do
        sx,sy,sz = Spring.GetTeamStartPosition(ID)
		teamID[index] = {}
			teamID[index][1] = ID
			teamID[index][2] = sx
			teamID[index][3] = sy
			teamID[index][4] = sz
			Spring.Echo("Index: ".. index)
		end
    end



local function spawnInitialUnits(teamID)
	for i=1, #teamID do	--------- For each row
		for j=1, #listOfUnits do	-- for each unit in this list
			Spring.CreateUnit(listOfUnits[j], teamID[i][2] + 10*j, teamID[i][3], teamID[i][4] + 10*j, 0, teamID[i][1]) 		-- spawn unit at this location
		end
	end
end
		
function gadget:Initialize()
    Spring.Echo("SPAWNING INITIAL UNITS")
	getPlayerAndStartLocation()
	
end


function gadget:GameStart()
	spawnInitialUnits()
	gadgetHandler:RemoveGadget("initialGameSetup")
end


else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
	return false

end
