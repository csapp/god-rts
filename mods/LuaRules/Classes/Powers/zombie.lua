-- Speed ups
local SpawnCEG = Spring.SpawnCEG
local CreateUnit = Spring.CreateUnit

ZombieApocalypse = RangedPower:Inherit{
    classname = "ZombieApocalypse",
    id = CMD_ZOMBIE,
    powerName = "Zombie Apocalypse",
    powerType = POWERS.TYPES.OFFENSIVE,
    rechargeRate = 1/180,
    zombieCount = 20,
    zombieLifetime = 30, -- i.e. zombies die after zombieLifetime seconds
}

local this = ZombieApocalypse
local inherited = this.inherited

function ZombieApocalypse:New(teamID)
    obj = inherited.New(self, teamID)
    obj.cmdDesc = {
        id      = CMD_ZOMBIE,
        name    = obj:GetName(),
        action  = "ZombieApocalypse",
        type    = CMDTYPE.ICON_MAP,
        tooltip = "Spawn a wave of hungry zombies for " .. self.zombieLifetime .. " seconds",
        params = {},
    }
    return obj
end

local function SpawnZombie(x, y, z, teamID)
end

function ZombieApocalypse:_Use(cmdParams, cmdOptions)
    local x, y, z = unpack(cmdParams)
    local teamID = self:GetTeamID()
    for i=1,#self.zombieCount do
        SpawnZombie(x,y,z,teamID)
    end
end

return ZombieApocalypse

