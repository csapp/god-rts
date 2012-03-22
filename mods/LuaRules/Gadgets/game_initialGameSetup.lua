function gadget:GetInfo()
    return {
        name = "Initial Setup",
        desc = "Gadget that sets up the initial state of the game.",
        tickets = "#60, #61",
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
local listOfUnits = {"smallVillage", "priest"}
local spawnOffset = 50

--**********
--Function: getPlayerAndStartLocation
--Input: None
--Output: None
--Purpose: Gets a list of start positions for each team.
--**********
local function getPlayerAndStartLocation()
    local gaia = Spring.GetGaiaTeamID()
	for index, ID in ipairs(Spring.GetTeamList()) do
        if ID ~= gaia then
            local sx,sy,sz = Spring.GetTeamStartPosition(ID)
            team_positions[ID] = {sx,sy,sz}
        end
    end
end

--**********
--Function: spawnInitialUnits
--Input: None
--Output: None
--Purpose: Creates the initial units.
--**********
local function spawnInitialUnits()
	for player_id, start_pos in pairs(team_positions) do	--------- For each row
		for j=1, #listOfUnits do	-- for each unit in this list
			Spring.CreateUnit(listOfUnits[j], start_pos[1] + spawnOffset*j, start_pos[2], start_pos[3] + spawnOffset, 0, player_id) 		-- spawn unit at this location
		end
	end
end


--**********
--Function: setDefaultResources
--Input: None
--Output: None
--Purpose: Initializes the Villager starting amount and maximum amount.
--**********
local function setDefaultResources()
    local tm = _G.TeamManagers
	for teamID, start_pos in pairs(team_positions) do
        local initialVillagers = 50
		Spring.SetTeamResource(teamID, "m", 50)
		Spring.SetTeamResource(teamID, "ms", 10000)
	end
end
	
function gadget:Initialize()
	getPlayerAndStartLocation()
end


function gadget:GameStart()
	spawnInitialUnits()
	setDefaultResources()
end


else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
	return false

end
