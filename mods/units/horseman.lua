local unitName  =  "horseman"

--Attribute Defintions
local HP = 160
local ATKDMG = 25
local ATKSPD = 5
local ATKRNG = 20
local MOVESPD = {5,0.15} -- {walkspeed, acceleration}

local unitDef  =  {
--Internal settings
    BuildPic = "horseman.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "horseman.s3o",
	corpse = "dead",
    name = "Horseman",
    script = "horsemanscript.lua",

    customParams = {
        real_speed = 150,
        class = "cavalry",
        morph_into = "scout",
        max_xp = 100,
        level = 1,
        supply_cost = 1,
    },

    sounds = {
      select = {
            [1] = "horse_1",
            [1] = "Horsesnorts4",
        },
      ok = {
            [1] = "Horsegrunt1",
        },
    },
    
--Unit limitations and properties
    BuildTime = 8,
    Description = "An awesomely powerful soldier.. ON A HORSE!",
    MaxDamage = HP,
	mass = 500,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 400,	--This may be too high
    SoundCategory = "TANK",
    Upright = 0,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 10,
    
--Pathfinding and related
    Acceleration = MOVESPD[2],
    BrakeRate = 0.5,
    FootprintX = 1,	--Affects Bounding Box (the green colored one)
    FootprintZ = 1,	--Affects Bounding Box (the green colored one)
    MaxSlope = 15,
    MaxVelocity = 5,
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
	collisionVolumeOffsets = "0 0 -4",
	collisionVolumeScales = "10 25 10",
	collisionVolumeType = "Box",
	collisionVolumeTest = 1,
    
--Weapons and related

	weapons = {
		[1] = {
			def = "LANCE",
			mainDir = "0 0 1",
			maxAngleDif = 180,
		},
	},
	
	weaponDefs = {
	LANCE = {
        soundStart = "swordhit2.wav",
		avoidFriendly = 1,
		collideFriendly = false,
		name = "Lance",
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
			default  = ATKDMG,
			infantry = ATKDMG,
			ranged   = 1.5*ATKDMG,
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
		resurrectintounit	= "Horseman",
		featuredecaytime	= 10		
	},  	
    damage             = 300,
    description        = "Dead Horseman",
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



