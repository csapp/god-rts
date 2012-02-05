
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

local team_positions = {}				  
local listOfUnits = {"smallVillage", "Soldier"}
--local listOfUnits = {"Soldier", "Warrior", "General", "Hunter", "Marksman", "Archer", "Horseman", "Scout", "Knight", "Priest", "Prophet", "God"}
local spawnOffset = 50

local function getPlayerAndStartLocation()
	for index, ID in pairs(Spring.GetPlayerList()) do
        --Spring.Echo(index .. ' ' .. ID)
        local sx,sy,sz = Spring.GetTeamStartPosition(ID)
        team_positions[ID] = {sx,sy,sz}
		end
end

local function spawnInitialUnits()
	for player_id, start_pos in pairs(team_positions) do	--------- For each row
		for j=1, #listOfUnits do	-- for each unit in this list
			Spring.CreateUnit(listOfUnits[j], start_pos[1] + spawnOffset*j, start_pos[2], start_pos[3] + spawnOffset, 0, player_id) 		-- spawn unit at this location
		end
	end
end

local function setDefaultResources()
	for player_id, start_pos in pairs(team_positions) do
		Spring.SetTeamResource(player_id, "m", 50)
		Spring.SetTeamResource(player_id, "e", 50)
		Spring.SetTeamResource(player_id, "ms", 10000)
		Spring.SetTeamResource(player_id, "es", 10000)
	end
end
	
function gadget:Initialize()
    Spring.Echo("SPAWNING INITIAL UNITS")
	getPlayerAndStartLocation()
end


function gadget:GameStart()
	spawnInitialUnits()
	setDefaultResources()
	gadgetHandler:RemoveGadget("initialGameSetup")
end


else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
	return false

end
