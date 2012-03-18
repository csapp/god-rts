-- Speed ups
local GetUnitTeam = Spring.GetUnitTeam
local AddUnitDamage = Spring.AddUnitDamage
local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit
local AddUnitImpulse = Spring.AddUnitImpulse

BFB = RangedPower:Inherit{
    classname = "BFB",
    id = CMD_BFB,
    powerName = "Big Friendly Bomb",
    powerType = POWERS.TYPES.OFFENSIVE,
	damage = 100, 	   --maxDamage
	radius = 200,
	impulse = {5,5,5}, --maxImpulse vectors: x, y, z 
    rechargeRate = 1/60,
    tooltip = "Explode a Massive Bomb causing knockback and damage within a certain radius",
    cmdType = CMDTYPE.ICON_MAP,
}

local this = BFB
local inherited = this.inherited

function BFB:SetUp()
    inherited.SetUp(self)
    --self:SetCustomCursor("cursorVolcanicBlast")
end

function BFB:GetRadius()
    return self.radius
end

function BFB:SetRadius(r)
    self.radius = r
end

function BFB:GetImpulse()
	return self.impulse
end

function GetActualDamage(centerX, centerZ, unitX, unitZ, radius, maxDamage)
	local distance = math.sqrt((unitX - centerX)^2 + (unitZ - centerZ)^2)
	-- A check put in place to make sure we don't divide by 0
	if distance == 0 then
		distance = 0.1
	end
	actualDamage = (1-distance/radius) * maxDamage 
	return actualDamage
end

function GetActualImpulseVectors(centerX, centerZ, unitX, unitZ, radius, maxImpulse)
	local x, y, z
	local distance = math.sqrt((unitX - centerX)^2 + (unitZ - centerZ)^2)
	if distance == 0 then
		distance = 0.1
	end	
	--calculate x
	x = (1 - distance/radius) * maxImpulse[1]
	--calculate y
	y = (1 - distance/radius) * maxImpulse[2] 
	--calculate z
	z = (1 - distance/radius) * maxImpulse[3]
	
	if(unitX - centerX < 0) then
		x = -x
	end
	if (unitZ - centerZ < 0) then
		z = -z
	end
	
	return x, y, z
end

function BFB:_Use(cmdParams, cmdOptions)
    local center_x, center_y, center_z = unpack(cmdParams)
	local actualDamage
	local unitX, unitY, unitZ
	local impulseX, impulseY, impulseZ
    local teamID = self:GetTeamID()
	local radius = self:GetRadius() 
	local maxDamage = self:GetDamage()
	local maxImpulse = self:GetImpulse()
	local affected_units = Spring.GetUnitsInSphere(center_x, center_y, center_z, radius)
	
    for _, affected_unit in pairs(affected_units) do  	  	 
	    if GetUnitTeam(affected_unit) ~= teamID then
			unitX, unitY, unitZ = Spring.GetUnitPosition(affected_unit)
			actualDamage = GetActualDamage(center_x, center_z, unitX, unitZ, radius, maxDamage)
			impulseX, impulseY, impulseZ = GetActualImpulseVectors(center_x, center_z, unitX, unitZ, radius, maxImpulse)
			AddUnitImpulse(affected_unit, impulseX, impulseY, impulseZ)
			AddUnitDamage(affected_unit, actualDamage, 0, unitID)
			Spring.Echo(unitX .. "," .. unitZ .. "," .. center_x .. "," .. center_z  .. "," .. actualDamage)
			Spring.Echo(impulseX .. "," .. impulseY .. "," .. impulseZ)
	    end  	  	 
    end 
	
end

return BFB