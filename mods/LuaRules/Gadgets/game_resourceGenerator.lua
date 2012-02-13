
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

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

include("LuaUI/Headers/msgs.h.lua")

-- Speed ups
local AddTeamResource = Spring.AddTeamResource
local UseTeamResource = Spring.UseTeamResource
local GetUnitHealth = Spring.GetUnitHealth


local timeInterval = 30 --Denotes the number of frames per second
local counter = -1 -- When the game begins, this value will be -1 
                   -- because at n = 0 it would normally increment the 
				   -- counter value to 1 which we dont want. 
				   -- Hereafter the counter is reset to 0
				   
local counterMaxValue = 5 --Denotes the maximum value for the counter, 
					      --since the counter starts at 0 and ends at 4 this 
						  --interval will be 5 seconds long

local playerID = {}						  
--local GetTeamResources = Spring.GetTeamResources(playerID)

local function getPlayerList()
	for index, ID in pairs(Spring.GetPlayerList()) do
		playerID[index] = ID
		end
end
		


function gadget:Initialize()
    if DEBUG then Spring.Echo("RESOURCE GENERATION ON!") end
	getPlayerList()
end

local function getResources(playerID)
	local eCurr, eStor = Spring.GetTeamResources(playerID, "energy")
	local mCurr, mStor = Spring.GetTeamResources(playerID, "metal")
    Spring.Echo("Metal = " .. mCurr .. " Energy = " .. eCurr)
    Spring.Echo("MetalStorage = " .. mStor .. " EnergyStorage = " .. eStor)
end

local function generateVillagers(playerID)
	return 5 --enter formula that calculates how much villagers to generate for the player
	--Can't properly implement this until we have a list of villages under the players control
end

--local function generateFaith(playerID)
	--idea is to add a certain amount of faith and then 
	--add/subtract based on the outcome of several cases
	
	--Can't properly implement this until we have a list of villages under the players control
--end

local function addFaith(teamID, amt)
    AddTeamResource(teamID, "energy", amt)
end

local function removeFaith(teamID, amt)
    UseTeamResource(teamID, "energy", amt)
end

function gadget:RecvLuaMsg(msg, playerID)
    msg = LuaMessages.deserialize(msg)
    local msg_type = msg[1]
    if msg_type == MSG_TYPES.CONVERT_FINISHED then
        local clergyID = tonumber(msg[2])
        -- XXX is this a static value or should we get it from somewhere?
        addFaith(Spring.GetUnitTeam(clergyID), 1000)
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, adefID, ateamID)
    if attackerID == nil then 
    -- Unit is leveling up, don't remove faith
        return 
    end

    _, maxHealth = GetUnitHealth(unitID)
    removeFaith(teamID, maxHealth/10)
end

function gadget:GameFrame(n)
	--Spring.Echo("Value of N is " .. n) For Debugging only
	if (n % timeInterval == 0) then --denotes one second
		counter = counter + 1
		-- Spring.Echo("Counter Value is " .. counter) For Debugging only
	end
	if (counter == counterMaxValue) then --every five seconds generate resources
		--Spring.Echo("Adding Resources")
		for i=1, #playerID do
			AddTeamResource(playerID[i], "metal", generateVillagers(playerID[i]))
			--AddTeamResource(playerID[i], "energy", generateVillagers(playerID[i]))
			if DEBUG then getResources(playerID[i]) end
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
