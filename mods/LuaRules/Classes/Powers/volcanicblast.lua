-- Speed ups
local GetUnitTeam = Spring.GetUnitTeam
local AddUnitDamage = Spring.AddUnitDamage
local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit

VolcanicBlast = RangedPower:Inherit{
    classname = "VolcanicBlast",
    id = CMD_VOLCANIC_BLAST,
    powerName = "Volcanic Blast",
    powerType = POWERS.TYPES.OFFENSIVE,
	volcanoLifetime = 20, 
    rechargeRate = 1/180,
    tooltip = "Cause massive fire damage to units within a certain radius",
    cmdType = CMDTYPE.ICON_MAP,
}

local this = VolcanicBlast
local inherited = this.inherited
local volcanoID

function VolcanicBlast:Initialize()
    inherited.Initialize(self)
    self:SetCustomCursor("cursorVolcanicBlast")
end

function VolcanicBlast:GetRadius()
    return self.radius
end

function VolcanicBlast:SetRadius(r)
    self.radius = r
end

function VolcanicBlast:_DestroyVolcano()
	DestroyUnit(volcanoID)
end

function VolcanicBlast:_Use(cmdParams, cmdOptions)
    local center_x, center_y, center_z = unpack(cmdParams)
    local teamID = self:GetTeamID()
	volcanoID = CreateUnit("Volcano", center_x, center_y, center_z, 0, teamID)
	GG.Delay.CallLater(self.volcanoLifetime, self._DestroyVolcano, {self})
end

return VolcanicBlast

