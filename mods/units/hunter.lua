local unitName  =  "hunter"

--Attribute Defintions
local HP = 80
local ATKDMG = 5
local ATKSPD = 2
local ATKRNG = 50
local MOVESPD = {3,0.15} -- {walkspeed, acceleration}

local unitDef  =  {
--Internal settings
    BuildPic = "hunter.PNG",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "hunter.s3o",
	corpse = "dead",
    name = "Hunter",
    script = "hunterscript.lua",

    customParams = {
        real_speed = 90,
        class = "ranged",
        morph_into = "marksman",
        max_xp = 100,
        level = 1,
        supply_cost = 1,
    },

    sounds = {
      select = {
            [1] = "huh_1",
            [1] = "huh_2",
        },
      ok = {
            [1] = "you_got_it_1",
        },
    },
    
--Unit limitations and properties
    BuildTime = 5,
    Description = "Stealthy, accurate and well-dressed",
    MaxDamage = HP,
	mass = 500,
    RadarDistance = 0,
    SightDistance = 400,	--This may be too high
    SoundCategory = "TANK",
    Upright = 0,
    idleAutoHeal = 0,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 2,
    
--Pathfinding and related
    Acceleration = MOVESPD[2],
    BrakeRate = 1,
    FootprintX = 1,	--Affects Bounding Box (the green colored one)
    FootprintZ = 1,	--Affects Bounding Box (the green colored one)
    MaxSlope = 15,
    MaxVelocity = 3,
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
			def = "BOW",
			mainDir = "0 0 1",
			maxAngleDif = 180,
		},
	},
	
	weaponDefs = {
	BOW = {
        soundStart = "archery-arrowflyby.wav",
		avoidFriendly = 1,
		burst = 0.3,
		burstrate = 1,
		collideFriendly = false,
		collisionSize = 3,
		name = "Bow",
		energypershot = 0,
		endsmoke = "0",
		impactonly = true,
		model = "Arrow.S3O",
		noSelfDamage = true,
		range = ATKRNG,
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
			default  = ATKDMG,
			infantry = 1.5*ATKDMG,
			ranged   = ATKDMG,
			cavalry  = ATKDMG,
			hero     = 1.25*ATKDMG,
			clergy   = ATKDMG,
			god 	 = ATKDMG,
		},
		
	},
	
	},
	
    BadTargetCategory = "NOTAIR",
    ExplodeAs = "TANKDEATH",
    NoChaseCategory = "AIR",

}

--------------------------------------------------------------------------------

local featureDefs = {
  dead = {
    blocking           = false,
	customParams          = {
		resurrectintounit	= "Hunter",
		featuredecaytime	= 10		
	},  	
    damage             = 300,
    description        = "Dead Hunter",
    energy             = 0,
    footprintX         = 2,
    footprintZ         = 2,
    height             = "5",
    hitdensity         = "100",
    metal              = 0,
    object             = "Tombstone.s3o",
    reclaimable        = false,
	resurrectable  	   = 1,
	smoketime 		   = 0,	
  },
}
unitDef.featureDefs = featureDefs

--------------------------------------------------------------------------------

return lowerkeys({ [unitName]  =  unitDef })



