--local volcanicCmd = {
      --id      = CMD_VOLCANIC_BLAST,
      --name    = "Volcanic Blast",
      --action  = "volcanicBlast",
      --type    = CMDTYPE.ICON_MAP,
      --tooltip = "Cause massive fire damage to units within a certain radius",
      --powerType = POWERS.TYPES.OFFENSIVE,
      --params = {},
--}

-- Speed ups
local GetUnitTeam = Spring.GetUnitTeam
local AddUnitDamage = Spring.AddUnitDamage

VolcanicBlast = RangedPower:Inherit{
    classname = "VolcanicBlast",
    id = CMD_VOLCANIC_BLAST,
    powerName = "Volcanic Blast",
    powerType = POWERS.TYPES.OFFENSIVE,
    damage = 400,
    rechargeRate = 1/30,
    radius = 200,
    tooltip = "Cause massive fire damage to units within a certain radius",
    cmdType = CMDTYPE.ICON_MAP,
}

local this = VolcanicBlast
local inherited = this.inherited

function VolcanicBlast:Initialize()
    inherited.Initialize(self)
    self:SetCustomCursor("cursorConvert")
end

function VolcanicBlast:GetRadius()
    return self.radius
end

function VolcanicBlast:SetRadius(r)
    self.radius = r
end

function VolcanicBlast:_Use(cmdParams, cmdOptions)
    local center_x, center_y, center_z = unpack(cmdParams)
    local damage = self:GetDamage()
    local teamID = self:GetTeamID()
    local unitID = self:GetGodID()
    local radius = self:GetRadius()
    local affected_units = Spring.GetUnitsInSphere(center_x, center_y, center_z, radius)
    Spring.SpawnCEG("flames", center_x, center_y, center_z)
    Spring.PlaySoundFile("sounds/cannonshot.wav")
    for _, affected_unit in pairs(affected_units) do
        if GetUnitTeam(affected_unit) ~= teamID then
            AddUnitDamage(affected_unit, damage, 0, unitID)
        end
    end
end

return VolcanicBlast

