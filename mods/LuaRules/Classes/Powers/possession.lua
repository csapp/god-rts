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
    cmdType = CMDTYPE.ICON_MAP,
    tooltip = "Transfer all units within radius to your team",
}

local this = Possession
local inherited = this.inherited

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
    for _, unitID in pairs(nearbyUnits) do
        if GetUnitTeam(unitID) ~= teamID then
            self:TransferUnit(unitID)
        end
    end
    --Spring.PlaySoundFile("sounds/harp.wav")
end

return Possession

