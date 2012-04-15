local unitName  =  "shark"

--Attribute Defintions
local HP = 10000
local ATKDMG = 20
local ATKSPD = 3
local ATKRNG = 20
local MOVESPD = {2,0.15} -- {walkspeed, acceleration}

local unitDef  =  {
--Internal settings
    BuildPic = "shark.png",
    Category = "SUB FIREPROOF",
    ObjectName = "shark.s3o",
	corpse = "dead",
    name = "Shark",
    script = "sharkscript.lua",

    customParams = {
        real_speed = 90,
        class = "infantry",
        level = 1,
        supply_cost = 1,
    },

    sounds = {
      select = {
     --       "come_on_2",
       --     "come_on_3",
        },
      ok = {
         --   "yes_1",
        },
    },
    
--Unit limitations and properties
    BuildTime = 4,
    Description = "SHARK WITH LASERSSSS",
    MaxDamage = HP,
	mass = 500,
    RadarDistance = 0,
    SightDistance = 1000,	--This may be too high
    SoundCategory = "BOAT",
    Upright = 0,
    idleAutoHeal = 0,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 3,
    
--Pathfinding and related
    Acceleration = MOVESPD[2],
    BrakeRate = 0.1,
  --  FootprintX = 1,	--Affects Bounding Box (the green colored one)
 --   FootprintZ = 1,	--Affects Bounding Box (the green colored one)
    MaxSlope = 1,
    MaxVelocity = 3,
    minWaterDepth = 20,
    MovementClass = "BOAT",
    TurnRate = 900,
	waterline = 25,
    
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
			def = "LASER",
		},
	},
	
  weaponDefs          = {

    LASER = {
      name                    = [[High Intensity Laserbeam]],
      areaOfEffect            = 8,
      beamlaser               = 1,
      beamTime                = 0.1,
      coreThickness           = 0.5,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 30,
        subs    = 1.5,
      },

      fireStarter             = 30,
	  fireSubmersed			  = true,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 4.33,
      lineOfSight             = true,
      minIntensity            = 1,
      noSelfDamage            = true,
      range                   = 1000,
      reloadtime              = 0.1,
      renderType              = 0,
      rgbColor                = [[0 1 0]],
      soundStart              = "laser_burn10",
      soundTrigger            = true,
      sweepfire               = false,
	  texture1                = [[largelaser]],
	  targetBorder 			  = 1,
      texture2                = [[flare]],
      texture3                = [[flare]],
      texture4                = [[smallflare]],
      thickness               = 4.33,
      tolerance               = 18000,
      turret                  = true,
      weaponType              = [[BeamLaser]],
      weaponVelocity          = 500,
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
		resurrectintounit	= "Soldier",
		featuredecaytime	= 10		
	},  	
    damage             = 300,
    description        = "Dead Soldier",
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



