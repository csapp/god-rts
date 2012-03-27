local unitName  =  "Demigod"

--Attribute Defintions
local HP = 200
local ATKDMG = 5
local ATKSPD = 2
local ATKRNG = 100
local MOVESPD = {3,0.15} -- {walkspeed, acceleration}

local unitDef  =  {
--Internal settings
    BuildPic = "prophet.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "Demigod.s3o",
    name = "Demigod",
    script = "demigodscript.lua",
    --cancapture = true,
    --capturespeed = 900,

    customParams = {
        real_speed = 90,
        class = "clergy",
        level = 3,
        supply_cost = 3,
    },

    sounds = {
      select = {
            [1] = "Mansighing2",
        },
      ok = {
            [1] = "Mansighing2",
        },
    },
    
--Unit limitations and properties
    BuildTime = 30,
    Description = "An awesome evangelist",
    MaxDamage = HP,
	mass = 500,
    RadarDistance = 0,
    SightDistance = 400,	--This may be too high
    SoundCategory = "TANK",
    Upright = 0,
    idleAutoHeal = 0,
    
--Energy and metal related
    BuildCostEnergy = 30,
    BuildCostMetal = 10,
    
--Pathfinding and related
    Acceleration = MOVESPD[2],
    BrakeRate = 0.1,
    FootprintX = 1,	--Affects Bounding Box (the green colored one)
    FootprintZ = 1,	--Affects Bounding Box (the green colored one)
    MaxSlope = 15,
    MaxVelocity = 3,
    MaxWaterDepth = 20,
    MovementClass = "Default2x2",
    TurnRate = 900,
    
--Abilities
    Builder = true,
    Reclaimable = false,
    workerTime = 1,
    CanRepair = true,
    CanReclaim = false,
    RepairSpeed = 1, 
    canAttack = true,
	canFight = true,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    
--Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales = "10 25 10",
	collisionVolumeType = "Box",
	collisionVolumeTest = 1,
	
	--Weapons and related

	weapons = {
		[1] = {
			def = "LEFTARM",
			mainDir = "0 0 1",
			maxAngleDif = 180,
		},
		[2] = {
			def = "RIGHTARM",
			mainDir = "0 0 1",
			maxAngleDif = 180,
		},
	},
	
	weaponDefs = {
	LEFTARM = {
        --soundStart = "archery-arrowflyby.wav",
		avoidFriendly = 1,
		burst = 3,
		burstrate = 0.3,
		collideFriendly = false,
		collisionSize = 3,
		name = "Left Arm",
		energypershot = 0,
		endsmoke = "0",
		impactonly = true,
		model = "DemigodBlast.S3O",
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
			default = ATKDMG,
		},
		
	},
	
	RIGHTARM = {
    --    soundStart = "archery-arrowflyby.wav",
		avoidFriendly = 1,
		burst = 3,
		burstrate = 0.3,
		collideFriendly = false,
		collisionSize = 3,
		name = "Right Arm",
		energypershot = 0,
		endsmoke = "0",
		impactonly = true,
		model = "DemigodBlast.S3O",
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
			default = ATKDMG,
		},	
		
	},
	
	},
	
    BadTargetCategory = "NOTAIR",
    ExplodeAs = "TANKDEATH",
    NoChaseCategory = "AIR",

}

return lowerkeys({ [unitName]  =  unitDef })



