function gadget:GetInfo()
    return {
        name = "Resource Generator",
        desc = "Gadget that generates resources for players.",
        tickets = "#60",
        author = "Mani",
        date = "2012-01-31",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

if not gadgetHandler:IsSyncedCode() then
    return false
end
------------------------------------------------------------
-- SYNCED
------------------------------------------------------------


include("LuaUI/Headers/msgs.h.lua")
include("LuaUI/Headers/units.h.lua")

-- Speed ups
local AddTeamResource = Spring.AddTeamResource
local UseTeamResource = Spring.UseTeamResource
local GetUnitHealth = Spring.GetUnitHealth
local GetTeamUnits = Spring.GetTeamUnits

local timeInterval = 30 --Denotes the number of frames per second
local counter = -1 -- When the game begins, this value will be -1 
                   -- because at n = 0 it would normally increment the 
				   -- counter value to 1 which we dont want. 
				   -- Hereafter the counter is reset to 0
				   
local counterMaxValue = 5 --Denotes the maximum value for the counter, 
					      --since the counter starts at 0 and ends at 4 this 
						  --interval will be 5 seconds long

local teams = {}
local villagerMultipliers = {}
local TeamManagers
				  
function gadget:Initialize()
    if DEBUG then Spring.Echo("RESOURCE GENERATION ON!") end
    local gaiaTeamID = Spring.GetGaiaTeamID()
	for _, teamID in pairs(Spring.GetTeamList()) do
        if teamID ~= gaiaTeamID then
            table.insert(teams, teamID) 
        end
    end
    InitTeamManagers()
end

function InitTeamManagers()
    TeamManagers = _G.TeamManagers
	for _, teamID in pairs(teams) do
        local am = TeamManagers[teamID]:GetAttributeManager()
        villagerMultipliers[teamID] = am:GetVillagerMultiplier()
    end
end

--**********
--Function: generateVillagers
--Input: teamID - the player's team ID
--Output: None
--Purpose: Generates Villagers for each player at set time intervals based on the 
-- 		   number and level of the villages that the player has under their control.
--**********
local function generateVillagers(teamID)
    -- Each timestamp, a team will generate villagers according to this formula:
    -- villagersGenerated = sum(GetLevel(v)*GetMultiplierValue(v) for v in ownedVillages(teamID))
	local villagersGenerated = 0
	
    for _, unitID in pairs(GetTeamUnits(teamID)) do
        if Units.IsVillageUnit(unitID) then
            local mult = villagerMultipliers[teamID]:GetValue(unitID)
            villagersGenerated = villagersGenerated + Units.GetLevel(unitID)*mult
        end
    end
	
	return villagersGenerated 
end

function gadget:GameFrame(n)
	if (n % timeInterval == 0) then --denotes one second
		counter = counter + 1
	end
	if (counter == counterMaxValue) then --every five seconds generate resources
		for i=1, #teams do
			AddTeamResource(teams[i], "metal", generateVillagers(teams[i]))
			if DEBUG then getResources(teams[i]) end
		end
		counter = 0
	end
end

