
function gadget:GetInfo()
    return {
        name = "Resource Generator",
        desc = "Gadget that generates resources for players.",
        author = "Mani",
        date = "2012-01-31",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

local timeInterval = 30 --Denotes the number of frames per second
local counter = -1 -- When the game begins, this value will be -1 
                   -- because at n = 0 it would normally increment the 
				   -- counter value to 1 which we dont want. 
				   -- Hereafter the counter is reset to 0
				   
local counterMaxValue = 5 --Denotes the maximum value for the counter, 
					      --since the counter starts at 0 and ends at 4 this 
						  --interval will be 5 seconds long

local teamID = {}						  
--local GetTeamResources = Spring.GetTeamResources(teamID)

local function getPlayerList()
	for index, ID in pairs(Spring.GetPlayerList()) do
		teamID[index] = ID
		end
end
		


function gadget:Initialize()
    Spring.Echo("RESOURCE GENERATION ON!")
	getPlayerList()
end

local function getResources(teamID)
	local eCurr, eStor = Spring.GetTeamResources(teamID, "energy")
	local mCurr, mStor = Spring.GetTeamResources(teamID, "metal")
	--Spring.Echo("Metal = " .. mCurr .. " Energy = " .. eCurr)
	--Spring.Echo("MetalStorage = " .. mStor .. " EnergyStorage = " .. eStor)
end

local function generateVillagers(teamID)
	return 5 --enter formula that calculates how much villagers to generate for the player
	--Can't properly implement this until we have a list of villages under the players control
end

--local function generateFaith(teamID)
	--idea is to add a certain amount of faith and then 
	--add/subtract based on the outcome of several cases
	
	--Can't properly implement this until we have a list of villages under the players control
--end

function gadget:GameFrame(n)
	--Spring.Echo("Value of N is " .. n) For Debugging only
	if (n % timeInterval == 0) then --denotes one second
		counter = counter + 1
		-- Spring.Echo("Counter Value is " .. counter) For Debugging only
	end
	if (counter == counterMaxValue) then --every five seconds generate resources
		--Spring.Echo("Adding Resources")
		for i=1, #teamID do
			Spring.AddTeamResource(teamID[i], "metal", generateVillagers(teamID[i]))
			Spring.AddTeamResource(teamID[i], "energy", generateVillagers(teamID[i]))
			--getResources(teamID[i]) For Debugging only
		end
		counter = 0
	end
	
end


else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
	return false

end
