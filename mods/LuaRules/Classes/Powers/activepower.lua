local function GetInfo()
    return {
        name = "Active Power Base class",
        desc = "Base from which all active powers (i.e. non-passive) are derived",
        tickets = "#112",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end
-- includes
include("LuaUI/Headers/msgs.h.lua")

--Speedups
local GetGameSeconds = Spring.GetGameSeconds

ActivePower = Power:Inherit{
    classname = "ActivePower",
    tooltip = "",
    damage = 0,
    
    -- 0 <= rechargeRate <= 1
    -- % power recharges / second
    rechargeRate = 0, 
    charge = POWERS.FULL_CHARGE,
    cost = POWERS.FULL_CHARGE,
    cmdDesc = {},
    cmdType = CMDTYPE.ICON,
    cmdParams = {},
    cmdCursor = nil,
}

local this = ActivePower
local inherited = this.inherited

function ActivePower:GetCmdType() return self.cmdType end
function ActivePower:GetCmdDesc() return self.cmdDesc end
function ActivePower:GetDamage() return self.damage end
function ActivePower:GetCost() return self.cost end
function ActivePower:GetTooltip() return self.tooltip end

function ActivePower:SetUp()
    inherited.SetUp(self)
    self:_SetCmdDesc()
    gadgetHandler:RegisterCMDID(self:GetID())
end

function ActivePower:Initialize()
    inherited.Initialize(self)
    self.attrManager = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager() 
    self.rechargeRateMult = self.attrManager:GetPowerRechargeMultiplier()
end

function ActivePower:_SetCmdDesc()
    self.cmdDesc = {
        id = self:GetID(),
        name = self:GetName(),
        action = self.classname,
        type = self:GetCmdType(),
        tooltip = self:GetTooltip(),
        cursor = self.cmdCursor or self.classname,
        params = self.cmdParams,
    }
end

function ActivePower:SetCustomCursor(cursorName, colour)
    colour = colour or {1, 1, 1, 0.5}
    local cmdDescCursor = self:GetCmdDesc().cursor
    Spring.AssignMouseCursor(cmdDescCursor, cursorName, true, true)
    Spring.SetCustomCommandDrawData(self:GetID(), cmdDescCursor, colour, false)
end

function ActivePower:GetRechargeRate()
    return self.rechargeRate * self.rechargeRateMult:GetValue(self:GetGodID())
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
        LuaMessages.SendMsgToAll(MSG_TYPES.GOD_POWER_USED, {self:GetID(), self:GetTeamID()})
    end
end
