local function GetInfo()
    return {
        name = "Teleport power",
        desc = "Allows god to teleport to another location on the map",
        tickets = "#19",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end
--
-- Speed ups
local GetUnitTeam = Spring.GetUnitTeam

Teleport = RangedPower:Inherit{
    classname = "Teleport",
    id = CMD_TELEPORT,
    powerName = "Teleport",
    powerType = POWERS.TYPES.DEFENSIVE,
    rechargeRate = 1/30,
    cmdType = CMDTYPE.ICON_MAP,
    tooltip = "Teleport to another location on the map",
}

local this = Teleport
local inherited = this.inherited

function Teleport:Initialize()
    inherited.Initialize(self)
    self:SetCustomCursor("cursorTeleport")
end

function Teleport:_Use(cmdParams, cmdOptions)
    local destX, destY, destZ = unpack(cmdParams)
    local unitID = self:GetGodID()
    local curX, curY, curZ = Spring.GetUnitBasePosition(unitID)
    Spring.SpawnCEG("whitesmoke", curX, curY, curZ)
    Spring.SetUnitPosition(unitID, destX, destY, destZ)
    Spring.SpawnCEG("whitesmoke", destX, destY, destZ)

    -- XXX is this synced?
    Spring.PlaySoundFile("sounds/teleport.wav")
end

return Teleport

