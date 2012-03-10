local unitName  =  "god"

--Attribute Defintions
local HP = 2000
local ATKDMG = 20
local ATKSPD = 2
local ATKRNG = 20
local MOVESPD = {3,0.15} -- {walkspeed, acceleration}

local unitDef  =  {
--Internal settings
    BuildPic = "filename.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "god.s3o",
    name = "God",
    script = "godscript.lua",

    customParams = {
        real_speed = 90,
        class = "god",
        level = 1, -- XXX remove this when we have persistent god info
    },

    sounds = {
    },
    
--Unit limitations and properties
    BuildTime = 5,
    Description = "An awesomely powerful soldier",
    MaxDamage = HP,
	mass = 500,
    RadarDistance = 0,
    SightDistance = 400,	--This may be too high
    SoundCategory = "TANK",
    Upright = 0,
    idleAutoHeal = 0,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 0,
    
--Pathfinding and related
    Acceleration = MOVESPD[2],
    BrakeRate = 0.1,
    FootprintX = 1,	--Affects Bounding Box (the green colored one)
    FootprintZ = 1,	--Affects Bounding Box (the green colored one)
    MaxSlope = 15,
    MaxVelocity = 1000,
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
		[2] = {
			def = "VOLCANIC_BLAST",
			mainDir = "0 0 1",
			maxAngleDif = 180,
		},
--[[		[3] = {
			def = "BFB",
			mainDir = "0 1 0",
			maxAngleDif = 180,		
		}]]--
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
	},
	VOLCANIC_BLAST = {
		avoidFriendly = 1,
		burst = 3,
		burstrate = 0.3,
		collideFriendly = false,
		collisionSize = 3,
		name = "Volcanic_Blast",
		energypershot = 0,
		endsmoke = "0",
		impactonly = true,
		model = "VolcanicBlast.S3O",
		noSelfDamage = true,
		range = 200,
		reloadtime = ATKSPD,
		size = 3,
		sprayangle = 1024,
		startVelocity=250,
		targetBorder = 0,
		tolerance = 5000,
		turret = true,
		weaponTimer = 0.1,
		weaponType = "MissileLauncher",
		weaponVelocity = 1000,
		weaponAcceleration=200,
		damage = {
			default = ATKDMG,
		},
	
	},
	
    BadTargetCategory = "NOTAIR",
    ExplodeAs = "TANKDEATH",
    NoChaseCategory = "AIR",

}
}
return lowerkeys({ [unitName]  =  unitDef })

