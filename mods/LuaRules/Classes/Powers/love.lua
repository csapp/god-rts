local function GetInfo()
    return {
        name = "Whole Lotta Love power",
        desc = "Heals units within a certain radius to full health",
        tickets = "#125",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

-- Speed ups
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitHealth = Spring.SetUnitHealth
local SpawnCEG = Spring.SpawnCEG
local GetUnitTeam = Spring.GetUnitTeam

WholeLottaLove = RangedPower:Inherit{
    classname = "WholeLottaLove",
    radius = 100,
    id = CMD_LOVE,
    powerName = "Whole Lotta Love",
    powerType = POWERS.TYPES.DEFENSIVE,
    rechargeRate = 1/120,
    cmdType = CMDTYPE.ICON_MAP,
    tooltip = "Revive units within a certain radius to full health",
}

local this = WholeLottaLove
local inherited = this.inherited

function WholeLottaLove:GetRadius() return self.radius end
function WholeLottaLove:SetRadius(r) self.radius = r end

function WholeLottaLove:SetUp()
    inherited.SetUp(self)
    self:SetCustomCursor("cursorHeart")
end

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

