local function GetInfo()
    return {
        name = "Ranged power",
        desc = "Base class for active powers that must only work in a certain range",
        tickets = "107",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

VFS.Include("LuaUI/Headers/msgs.h.lua")

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
    local reason
	local teamID = Spring.GetUnitTeam(self:GetGodID())
	if inherited.CanUse(self, cmdParams, cmdOptions) then
		if self:InRange(cmdParams) then
			return true
		else
			reason = "You do not have line of sight in that area."
			LuaMessages.SendLuaUIMsg(MSG_TYPES.POWER_FAILED, {reason, teamID})
			return false
		end
	else
		local charge = math.floor(inherited.GetCharge(self) * 100)
		reason = "This God Power is on cooldown. " .. charge .. "% recharged."
		LuaMessages.SendLuaUIMsg(MSG_TYPES.POWER_FAILED, {reason, teamID})
		return false
	end
	--return inherited.CanUse(self, cmdParams, cmdOptions) and self:InRange(cmdParams)
end
