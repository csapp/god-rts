local unitName  =  "god"

--Attribute Defintions
local HP = 2000
local ATKDMG = 50
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
        ok = {"godyes2", "godyesindeed"},
        select = "godselect",
    },
    
--Unit limitations and properties
    BuildTime = 5,
    Description = "Almighty conqueror",
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
    CanSelfDestruct = false,
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
        soundStart = "punch2.wav",
		avoidFriendly = 1,
		areaofeffect = 8,
		collideFriendly = false,
		name = "Arm",
		cylinderTargetting = 1,
		energypershot = 0,
		edgeEffectiveness = 0.5,
		endsmoke = "0",
		impactonly = true,
		impulseBoost = 5,
		impulseFactor = 20,
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
			infantry = 1.5*ATKDMG,
			ranged   = 1.5*ATKDMG,
			cavalry  = 1.5*ATKDMG,
			hero     = ATKDMG,
			clergy   = ATKDMG,
			god 	 = ATKDMG,
		},
	},
	
	},
	
    BadTargetCategory = "NOTAIR",
    ExplodeAs = "TANKDEATH",
    NoChaseCategory = "AIR",

}

return lowerkeys({ [unitName]  =  unitDef })

