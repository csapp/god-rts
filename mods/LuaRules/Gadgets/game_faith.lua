
function gadget:GetInfo()
    return {
        name = "Faith",
        desc = "Gadget that handles faith",
        tickets = "#68",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
    return false
end

include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/multipliers.h.lua")
include("LuaUI/Headers/msgs.h.lua")
include("LuaUI/Headers/units.h.lua")

-- Speed ups
local AddTeamResource = Spring.AddTeamResource
local UseTeamResource = Spring.UseTeamResource
local GetTeamResources = Spring.GetTeamResources
local GetUnitHealth = Spring.GetUnitHealth
local GetUnitTeam = Spring.GetUnitTeam
local GetTeamUnits = Spring.GetTeamUnits
local GetTeamList = Spring.GetTeamList

local timeInterval = 30 
local counter = -1 
local counterMaxValue = 5

local attrManagers = {}
local faithMultipliers = {}

local MAX_FAITH = 1000
local MAX_LEVEL = 1

local faithMultTypes = {
    Multipliers.TYPES.CONVERT_TIME,
    Multipliers.TYPES.CONVERT_TIME,
    Multipliers.TYPES.CONVERT_TIME,
    Multipliers.TYPES.POWER_RECHARGE,
    Multipliers.TYPES.POWER_RECHARGE,
    Multipliers.TYPES.POWER_RECHARGE,
    Multipliers.TYPES.XP,
    Multipliers.TYPES.HEALTH,
}


local multsAdded = {}

local function GenerateFaith(teamID)
    return faithMultipliers[teamID]:GetValue()
end

local function GetTeamFaithMultiplier(teamID, level)
    return multsAdded[teamID][level]
end

local function GetFaithLevel(faithPct)
    if faithPct == 1 then 
        return MAX_LEVEL
    elseif faithPct >= 0.9 then
        return 0.5
    elseif faithPct >= 0.75 then
        return 0.3
    elseif faithPct >= 0.25 then
        return 0
    elseif faithPct >= 0.1 then
        return -0.3
    else
        return -0.5
    end
end

local function AddFaithMultiplier(teamID, level)
    local m
    if level == MAX_LEVEL then
        m = {Multipliers.TYPES.DAMAGE, level}
    else
        m = {table.random(faithMultTypes), level}
    end
    attrManagers[teamID]:AddMultiplier(unpack(m))
    multsAdded[teamID][level] = m
end

local function RemoveFaithMultiplier(teamID, level)
    local multKey, multValue = unpack(multsAdded[teamID][level])
    attrManagers[teamID]:AddMultiplier(multKey, -multValue)
    multsAdded[teamID][level] = nil
end

local function UpdateFaithMultipliers(teamID)
    local faithPct = GetTeamResources(teamID, "energy")/MAX_FAITH
    local level = GetFaithLevel(faithPct)
    local teamMultsAdded = multsAdded[teamID]

    -- Remove any multipliers that are not between the current level and 0
    if level <= 0 then
        for multLevel, mult in pairs(teamMultsAdded) do
            if multLevel < level or multLevel > 0 then
                RemoveFaithMultiplier(teamID, multLevel)
            end
        end
    else
        for multLevel, mult in pairs(teamMultsAdded) do
            if multLevel > level or multLevel < 0 then
                RemoveFaithMultiplier(teamID, multLevel)
            end
        end
    end

    -- If we don't already have a multiplier at our current level,
    -- add one (no multipliers at level 0)
    if level ~= 0 and not teamMultsAdded[level] then
        AddFaithMultiplier(teamID, level)
    end
end

local function AddFaith(teamID, amt)
    if not amt then return end
    AddTeamResource(teamID, "energy", amt)
    UpdateFaithMultipliers(teamID)
end

local function RemoveFaith(teamID, amt)
    if not amt then return end
    UseTeamResource(teamID, "energy", amt)
    UpdateFaithMultipliers(teamID)
end

function gadget:Initialize()
    --TeamManagers = _G.TeamManagers
	for _, teamID in pairs(GetTeamList()) do
        local am = _G.TeamManagers[teamID]:GetAttributeManager()
        attrManagers[teamID] = am
        faithMultipliers[teamID] = am:GetFaithMultiplier()
        multsAdded[teamID] = {}
    end
end

function gadget:GameStart()
    for _, teamID in pairs(GetTeamList()) do
		Spring.SetTeamResource(teamID, "es", MAX_FAITH)
		Spring.SetTeamResource(teamID, "e", MAX_FAITH/2)
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, adefID, ateamID)
    -- Unit is leveling up, don't remove faith
    -- XXX Does this have any undesired side effects?
    if not attackerID then return end

    _, maxHealth = GetUnitHealth(unitID)
    local faith = maxHealth/10
    RemoveFaith(teamID, faith)
    AddFaith(ateamID, faith)
end

function gadget:RecvLuaMsg(msg, playerID)
    local msgtype, params = LuaMessages.deserialize(msg)
    if msgtype == MSG_TYPES.ADD_FAITH then
        local teamID = tonumber(params[1])
        local faith = tonumber(params[2])
        AddFaith(teamID, faith)
    elseif msgtype == MSG_TYPES.CONVERT_FINISHED then
        local clergyID = tonumber(params[1])
        local oldVillageTeam = tonumber(params[3])
        -- XXX is this a static value or should we get it from somewhere?
        AddFaith(GetUnitTeam(clergyID), 100)
        RemoveFaith(oldVillageTeam, 100)
    elseif msgtype == MSG_TYPES.UNIT_LEVELLED_UP then
        local newUnitID = tonumber(params[2])
        -- XXX is this a static value or should we get it from somewhere?
        AddFaith(GetUnitTeam(newUnitID), 20)
    end
end

function gadget:GameFrame(n)
	if (n % timeInterval == 0) then
		counter = counter + 1
	end
	if (counter == counterMaxValue) then 
        for _, teamID in pairs(GetTeamList()) do
            AddFaith(teamID, GenerateFaith(teamID))
		end
		counter = 0
	end
end

