
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
--local sx, sy, sz = 0				  
local listOfUnits = {"Soldier", "hunter", "Knight"}

local function getPlayerAndStartLocation()
	for index, ID in pairs(Spring.GetPlayerList()) do
        Spring.Echo(index .. ' ' .. ID)
        local sx,sy,sz = Spring.GetTeamStartPosition(ID)
        team_positions[ID] = {sx,sy,sz}
		--team_positions[index] = {}
			--team_positions[index][1] = ID
			--team_positions[index][2] = sx
			--team_positions[index][3] = sy
			--team_positions[index][4] = sz
			--Spring.Echo("Index: ".. index)
		end
    end



local function spawnInitialUnits()
	for team_id, start_pos in pairs(team_positions) do	--------- For each row
		for j=1, #listOfUnits do	-- for each unit in this list
			Spring.CreateUnit(listOfUnits[j], start_pos[1], start_pos[2], start_pos[3], 0, team_id) 		-- spawn unit at this location
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
