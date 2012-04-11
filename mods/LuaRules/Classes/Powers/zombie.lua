local function GetInfo()
    return {
        name = "Zombie Apocalypse power",
        desc = "Spawns a wave of hungry zombies for a short time",
        tickets = "#124",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end
--
-- Speed ups
local SpawnCEG = Spring.SpawnCEG
local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit
local listOfZombies = {}

ZombieApocalypse = RangedPower:Inherit{
    classname = "ZombieApocalypse",
    id = CMD_ZOMBIE,
    powerName = "Zombie Apocalypse",
    powerType = POWERS.TYPES.OFFENSIVE,
    rechargeRate = 1/300,
    zombieCount = 20,
    zombieLifetime = 75, -- i.e. zombies die after zombieLifetime seconds
	radius = 50,
    tooltip = "Spawn a wave of hungry zombies for a short time",
    cmdType = CMDTYPE.ICON_MAP,
}

local this = ZombieApocalypse
local inherited = this.inherited

function ZombieApocalypse:SetUp()
    inherited.SetUp(self)
    self:SetCustomCursor("cursorZombieApocalypse")
end

function ZombieApocalypse:_SpawnZombie(x, y, z, teamID)
    Spring.PlaySoundFile("sounds/avalancheshort2.wav")
	local zombieID
	for i=1,self.zombieCount do
		randomNumX = math.random(0,self.radius)
		randomNumZ = math.random(0,self.radius)
		zombieID = CreateUnit("Zombie", x+randomNumX, y, z+randomNumZ, 0, teamID)
        table.insert(listOfZombies, zombieID)
    end
	
end

function ZombieApocalypse:_KillZombies()
    Spring.PlaySoundFile("sounds/Manscreaming1.wav")
    Spring.PlaySoundFile("sounds/Manscreaming2.wav")
    Spring.PlaySoundFile("sounds/Manscreaming3.wav")
	for i=1, #listOfZombies do
		DestroyUnit(listOfZombies[i])
	end
    listOfZombies = {}
end

function ZombieApocalypse:_Use(cmdParams, cmdOptions)
    local x, y, z = unpack(cmdParams)
	local teamID = self:GetTeamID()
	self:_SpawnZombie(x,y,z,teamID)
    GG.Delay.CallLater(self.zombieLifetime, self._KillZombies, {self})
end

return ZombieApocalypse

