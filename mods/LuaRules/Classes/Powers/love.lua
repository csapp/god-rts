-- Speed ups
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitHealth = Spring.SetUnitHealth
local SpawnCEG = Spring.SpawnCEG
local GetUnitTeam = Spring.GetUnitTeam

WholeLottaLove = ActivePower:Inherit{
    classname = "WholeLottaLove",
    radius = 150,
    id = CMD_LOVE,
    powerName = "Whole Lotta Love",
    powerType = POWERS.TYPES.DEFENSIVE,
    rechargeRate = 1/300,
    cmdType = CMDTYPE.ICON_MAP,
    tooltip = "Revive units with radius to full health",
}

local this = WholeLottaLove
local inherited = this.inherited

function WholeLottaLove:GetRadius() return self.radius end
function WholeLottaLove:SetRadius(r) self.radius = r end

function WholeLottaLove:HealUnit(unitID)
    _, maxHealth = GetUnitHealth(unitID)
    SetUnitHealth(unitID, maxHealth)
    local curX, curY, curZ = GetUnitBasePosition(unitID)
    SpawnCEG("hearts", curX, curY, curZ)
end

function WholeLottaLove:_Use(cmdParams, cmdOptions)
    local x,y,z = unpack(cmdParams)
	local nearbyUnits = Spring.GetUnitsInSphere(x, y, z, self:GetRadius())
    local teamID = self:GetTeamID()
    for _, unitID in pairs(nearbyUnits) do
        if GetUnitTeam(unitID) == teamID then
            self:HealUnit(unitID)
        end
    end
    Spring.PlaySoundFile("sounds/harp.wav")
end

return WholeLottaLove

