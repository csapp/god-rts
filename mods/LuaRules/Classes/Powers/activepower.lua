--Speedups
local GetGameSeconds = Spring.GetGameSeconds

ActivePower = Power:Inherit{
    classname = "ActivePower",
    powerName = "",
    powerType = "",
    id = 0,
    damage = 0,
    
    -- 0 <= rechargeRate <= 1
    -- % power recharges / second
    rechargeRate = 0, 

    teamID = -1,
    godID = -1,
    charge = POWERS.FULL_CHARGE,
    cost = POWERS.FULL_CHARGE,
    cmdDesc = {},
}

local this = ActivePower
local inherited = this.inherited

function ActivePower:GetCmdDesc() return self.cmdDesc end
function ActivePower:GetDamage() return self.damage end
function ActivePower:GetCost() return self.cost end

function ActivePower:GetID()
    return self.id
end

function ActivePower:GetRechargeRate()
    return self.rechargeRate
end

function ActivePower:SetRechargeRate(rate)
    self.rechargeRate = rate
end

function ActivePower:GetCharge()
    return self.charge
end

function ActivePower:SpendCharge(charge)
    self:_SetCharge(self:GetCharge() - charge)
end

function ActivePower:_SetCharge(charge)
    self.charge = charge 
end

function ActivePower:Recharge()
    self:_RechargeUpdate(GetGameSeconds(), self:GetCharge())
end

function ActivePower:_RechargeUpdate(startTime, initialCharge)
    local curTime = GetGameSeconds()

    charge = initialCharge + (curTime-startTime)*self:GetRechargeRate()*POWERS.FULL_CHARGE

    if charge >= POWERS.FULL_CHARGE then
        self:_SetCharge(POWERS.FULL_CHARGE)
        self:_RechargeFinished()
    else
        self:_SetCharge(charge)
        GG.Delay.DelayCall(self._RechargeUpdate, {self, startTime, initialCharge})
    end
end

function ActivePower:_RechargeFinished()
end

function ActivePower:CanUse(cmdParams, cmdOptions)
    return self:GetCharge() >= self:GetCost()
end

function ActivePower:_Use(cmdParams, cmdOptions)
    -- Implement this in subclasses
end

function ActivePower:Use(cmdParams, cmdOptions)
    -- do not override this in subclasses, override _Use instead
    if self:CanUse(cmdParams, cmdOptions) then
        self:SpendCharge(self:GetCost())
        self:_Use(cmdParams, cmdOptions)
        self:Recharge()
    end
end
