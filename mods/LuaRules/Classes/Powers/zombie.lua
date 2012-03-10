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
    tooltip = "Spawn a wave of hungry zombies for a short time",
    cmdType = CMDTYPE.ICON_MAP,
    cmdCursor = "Attack",
}

local this = ZombieApocalypse
local inherited = this.inherited

function ZombieApocalypse:_SpawnZombie(x, y, z, teamID)
end

function ZombieApocalypse:_KillZombies()
end

function ZombieApocalypse:_Use(cmdParams, cmdOptions)
    local x, y, z = unpack(cmdParams)
    local teamID = self:GetTeamID()
    for i=1,#self.zombieCount do
        self:_SpawnZombie(x,y,z,teamID)
    end
    GG.Delay.CallLater(self.zombieLifetime, self._KillZombies, {self})
end

return ZombieApocalypse

