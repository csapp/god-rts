local unitName  =  "zombie"

--Attribute Defintions
local HP = 50
local ATKDMG = 10
local ATKSPD = 1
local ATKRNG = 20
local MOVESPD = {0.25,0.15} -- {walkspeed, acceleration}

local unitDef  =  {
--Internal settings
    BuildPic = "placeholder.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "Zombie.s3o",
    name = "Zombie",
    script = "zombiescript.lua",

    customParams = {
        class = "zombie",
		temp_unit = true,
        level = 1,
    },

    sounds = {
      select = {
           "zombieselect",
        },
      ok = {
           "zombieok",
        },
    },
    
--Unit limitations and properties
    BuildTime = 5,
    Description = "A scary Zombie! Ahh!",
    MaxDamage = HP,
	mass = 500,
    RadarDistance = 0,
    SightDistance = 400,	--This may be too high
    SoundCategory = "TANK",
    Upright = 0,
    idleAutoHeal = 0,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 3,
    
--Pathfinding and related
    Acceleration = MOVESPD[2],
    BrakeRate = 0.1,
    FootprintX = 1,	--Affects Bounding Box (the green colored one)
    FootprintZ = 1,	--Affects Bounding Box (the green colored one)
    MaxSlope = 15,
    MaxVelocity = MOVESPD[1],
    MaxWaterDepth = 20,
    MovementClass = "Default2x2",
    TurnRate = 900,
    
--Abilities
    Builder = 0,
    canAttack = true,
	canFight = true,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 0,
    
--Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales = "10 25 10",
	collisionVolumeType = "Box",
	collisionVolumeTest = 1,
    
--Weapons and related

	weapons = {
		[1] = {
			def = "ARM",
			mainDir = "0 0 1",
			maxAngleDif = 180,
		},
	},
	
	weaponDefs = {
	ARM = {
		avoidFriendly = 1,
		collideFriendly = false,
		name = "Arm",
		cylinderTargetting = 1,
		energypershot = 0,
		endsmoke = "0",
		impactonly = true,
		noSelfDamage = true,
		range = ATKRNG,
		reloadtime = ATKSPD,
		size = 0,
		targetBorder = 1,
		tolerance = 5000,
		turret = true,
		weaponTimer = 0.1,
		weaponType = "Cannon",
		weaponVelocity = 100,
		damage = {
			default = ATKDMG,
		},
       soundStart = "zombie.wav",
	},
	
	},
	
    BadTargetCategory = "NOTAIR",
    ExplodeAs = "TANKDEATH",
    NoChaseCategory = "AIR",

}

return lowerkeys({ [unitName]  =  unitDef })



