local function GetInfo()
    return {
        name = "Possesion power",
        desc = "Transfers enemy units within a certain radius to your team",
        tickets = "#43",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/units.h.lua")

-- Speed ups
local GetUnitBasePosition = Spring.GetUnitBasePosition
local SpawnCEG = Spring.SpawnCEG
local GetUnitTeam = Spring.GetUnitTeam
local TransferUnit = Spring.TransferUnit

Possession = ActivePower:Inherit{
    classname = "Possession",
    radius = 150,
    id = CMD_POSSESSION,
    powerName = "Possession",
    powerType = POWERS.TYPES.DEFENSIVE,
    rechargeRate = 1/300,
    possessableClasses = {
        Units.CLASSES.INFANTRY,
        Units.CLASSES.CAVALRY,
        Units.CLASSES.RANGED,
    },
    cmdType = CMDTYPE.ICON_MAP,
    tooltip = "Transfer all normal units within radius to your team",
}

local this = Possession
local inherited = this.inherited

function Possession:GetPossessableClasses() return self.possessableClasses end
function Possession:GetRadius() return self.radius end
function Possession:SetRadius(r) self.radius = r end

function Possession:TransferUnit(unitID)
    TransferUnit(unitID, self:GetTeamID(), false)
    local curX, curY, curZ = GetUnitBasePosition(unitID)
    --SpawnCEG("hearts", curX, curY, curZ)
end

function Possession:_Use(cmdParams, cmdOptions)
    local x,y,z = unpack(cmdParams)
	local nearbyUnits = Spring.GetUnitsInSphere(x, y, z, self:GetRadius())
    local teamID = self:GetTeamID()
    local possessableClasses = self:GetPossessableClasses()
    for _, unitID in pairs(nearbyUnits) do
        if (GetUnitTeam(unitID) ~= teamID and 
            table.contains(possessableClasses, Units.GetClass(unitID))) then
            self:TransferUnit(unitID)
        end
    end
    --Spring.PlaySoundFile("sounds/harp.wav")
end

return Possession

