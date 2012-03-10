-- Speed ups
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitHealth = Spring.SetUnitHealth
local SpawnCEG = Spring.SpawnCEG

WholeLottaLove = ActivePower:Inherit{
    classname = "WholeLottaLove",
    id = CMD_LOVE,
    powerName = "Whole Lotta Love",
    powerType = POWERS.TYPES.DEFENSIVE,
    rechargeRate = 1/3,
    cmdType = CMDTYPE.ICON,
    tooltip = "Revive all units to full health",
}

local this = WholeLottaLove
local inherited = this.inherited

function WholeLottaLove:_Use(cmdParams, cmdOptions)
    local units = Spring.GetTeamUnits(self:GetTeamID())
    for _, unitID in pairs(units) do
        _, maxHealth = GetUnitHealth(unitID)
        SetUnitHealth(unitID, maxHealth)
        local curX, curY, curZ = GetUnitBasePosition(unitID)
        SpawnCEG("hearts", curX, curY, curZ)
    end
    Spring.PlaySoundFile("sounds/harp.wav")
end

return WholeLottaLove

