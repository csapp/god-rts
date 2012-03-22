local function GetInfo()
    return {
        name = "Passive Power",
        desc = "Base class for passive powers",
        tickets = "#112",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

PassivePower = Power:Inherit{
    classname = "PassivePower",
    powerType = POWERS.TYPES.PASSIVE,
    multipliers = {},
}

local this = PassivePower
local inherited = this.inherited 

function PassivePower:Initialize()
    inherited.Initialize(self)
    self:Apply()
end

function PassivePower:GetMultipliers()
    return self.multipliers
end

function PassivePower:Apply()
    local teamid = self:GetTeamID()
    local am = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager()
    for mtype, minfo in pairs(self:GetMultipliers()) do
        local value, classes = unpack(minfo)
        am:AddMultiplier(mtype, value, classes)
    end
end

