include("LuaUI/Headers/utilities.lua")

--Speedups
local IsPosInLos = Spring.IsPosInLos
local GetUnitBasePosition = Spring.GetUnitBasePosition

RangedPower = ActivePower:Inherit{
    classname = "RangedPower",
    range = nil,
}

local this = RangedPower
local inherited = this.inherited

function RangedPower:GetRange() return self.range end

function RangedPower:InRange(point)
    local x,y,z = unpack(point)
    local allyID = 0 -- XXX why does this work
    if not IsPosInLos(x, y, z, allyID) then
        return false
    end

    local range = self:GetRange()
    if not range then
        return true
    end

    local godID = self:GetGodID()
    gx, gy, gz = GetUnitBasePosition(godID)
    return utils.distance_between_points(point, {gx, gy, gz}) <= range
end

function RangedPower:CanUse(cmdParams, cmdOptions)
    return inherited.CanUse(self, cmdParams, cmdOptions) and self:InRange(cmdParams)
end
