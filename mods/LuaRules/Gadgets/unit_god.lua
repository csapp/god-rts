function gadget:GetInfo()
    return {
        name = "God Unit gadget",
        desc = "Gadget to control god unit stuff",
        tickets = "#112, #129",
        author = "cam",
        date = "2012-02-29",
        license = "Public Domain",
        layer = -10,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/msgs.h.lua")
include("LuaUI/Headers/powers.h.lua")

local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local god_unitdef_id = UnitDefNames["god"].id

local listOfGodIDs = {}

local power_ids = {}
local power_managers = {}
Powers = {}
PowerNames = {}

local function PopulatePowerManagers()
    local team_managers = _G.TeamManagers
    for teamID, manager in pairs(team_managers) do
        local power_mgr = manager:GetPowerManager()
        power_managers[teamID] = power_mgr
    end
end

local function PopulatePowerTables()
    for _, filepath in pairs(POWERS.FILES.BASES) do
        VFS.Include(POWERS.POWERS_DIR .. filepath)
    end
    for _, filepath in pairs(POWERS.FILES.CLASSES) do
        local power = VFS.Include(POWERS.POWERS_DIR .. filepath)
        power:SetUp()
        local id = power:GetID()
        Powers[id] = power
        table.insert(power_ids, id)
        PowerNames[power:GetName()] = power
    end
end

local function AddPower(teamID, powerName)
    local power = PowerNames[powerName]
    local manager = power_managers[teamID]
    local powerobj = power:New(teamID)
    powerobj:Initialize()
    manager:AddElement(power.id, powerobj)
end

local function SpawnGod(teamID)
    local sx,sy,sz = Spring.GetTeamStartPosition(teamID)
    sx = sx-50
    Spring.SpawnCEG("whitesmoke", sx, Spring.GetGroundHeight(sx, sz) + 10, sz)
    local god = Spring.CreateUnit("God", sx, sy, sz, 0, teamID)
    LuaMessages.SendLuaUIMsg(MSG_TYPES.GOD_CREATED, {god})
	table.insert(listOfGodIDs, god)
end

local function DestroyPlayer(teamID)
	--Destroy all units on team
	local listOfUnits = Spring.GetTeamUnits(teamID)
	local listOfVillageUnitDefIDs = {UnitDefNames["smallvillage"].id, UnitDefNames["mediumvillage"].id, UnitDefNames["largevillage"].id}
	for i, uID in pairs(listOfUnits) do
		if table.contains(listOfVillageUnitDefIDs, Spring.GetUnitDefID(uID)) then
			Spring.TransferUnit(uID, Spring.GetGaiaTeamID())	--transfer villages to neutral team
		else
			Spring.DestroyUnit(uID)
		end
	end
	--Really quick hack
	local allyTeamList = Spring.GetAllyTeamList()
	local teamList = {}
	for i, allyTeamID in pairs(allyTeamList) do
		teamList = Spring.GetTeamList(allyTeamID)
			for j,tID in pairs(teamList) do
				if tID ~= teamID then
					table.remove(allyTeamList, i)
				end
			end
	end
	--end of really quick hack
	Spring.KillTeam(teamID)
end

local function EndGame(teamID)
	local allyTeamList = Spring.GetAllyTeamList()
	local teamList = {}
	for i, allyTeamID in pairs(allyTeamList) do
		teamList = Spring.GetTeamList(allyTeamID)
			for j,tID in pairs(teamList) do
				if tID ~= teamID then
					table.remove(allyTeamList, i)
				end
			end
	end
	
	Spring.GameOver(allyTeamList)
end

function gadget:Initialize()
    VFS.Include("LuaRules/Classes/object.lua")
    PopulatePowerManagers()
    PopulatePowerTables()
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag)
    if not table.contains(power_ids, cmdID) then
        return false
    end

    local power_manager = power_managers[teamID]
    local power = power_manager:GetElement(cmdID)
    power:Use(cmdParams, cmdOptions)
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if unitDefID ~= god_unitdef_id then
        return
    end

    local teamID = unitTeam
    for powerID, power in pairs(power_managers[teamID]:GetElements()) do
        power:SetGodID(unitID)
        if power:GetType() ~= POWERS.TYPES.PASSIVE then 
            InsertUnitCmdDesc(unitID, powerID, power:GetCmdDesc())
        end
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
	for i=1, #listOfGodIDs do
		if listOfGodIDs[i] == unitID then
			table.remove(listOfGodIDs, i)
			if #listOfGodIDs > 1 then
				DestroyPlayer(teamID)
			else
				EndGame(attackerTeamID)
			end
		end
	end
	

end

function gadget:RecvLuaMsg(msg, playerID)
    local msg_type, params = LuaMessages.deserialize(msg)
	if msg_type == MSG_TYPES.GOD_SELECTED then
        local _, _, _, teamID = Spring.GetPlayerInfo(playerID)
        Spring.Echo('RecvLuaMsg', teamID)
        for i=1,#params do
            AddPower(teamID, params[i])
        end
        GG.Delay.DelayCall(SpawnGod, {teamID})
	end
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------

return false

end
