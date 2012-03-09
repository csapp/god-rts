
PassivePower = Power:Inherit{
    classname = "PassivePower",
    powerType = POWERS.TYPES.PASSIVE,
    multipliers = {},
}

local this = PassivePower
local inherited = this.inherited 

--function PassivePower:New(teamID)
    --Spring.Echo('in new, teamid ' .. teamID)
    --obj = inherited.New(self, teamID)
    --obj.Apply(self)
    --return obj
--end

function PassivePower:Initialize()
    inherited.Initialize(self)
    self:Apply()
end

function PassivePower:GetMultipliers()
    return self.multipliers
end

function PassivePower:Apply()
    local teamid = self:GetTeamID()
    Spring.Echo('teamid ' .. teamid)
    local tm = _G.TeamManagers[self:GetTeamID()]
    local am = tm:GetAttributeManager()
    for mtype, minfo in pairs(self:GetMultipliers()) do
        local value, classes = unpack(minfo)
        am:AddMultiplier(mtype, value, classes)
    end
end

