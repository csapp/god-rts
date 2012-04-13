local unitName  =  "Volcano"

--Attribute Defintions
local HP = 2000000
local ATKDMG = 20
local ATKSPD = 0.5
local ATKRNG = 400

local unitDef  =  {
--Internal settings
    BuildPic = "placeholder.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "Volcano.s3o",
    name = "Volcano",
    script = "volcanoscript.lua",
	
    customParams = {
        class = "volcano",
		temp_unit = true,
        level = 1,
    },
	
--Unit limitations and properties
    BuildTime = 5,
    Description = "Lava-spouting behemoth",
    MaxDamage = HP,
	--mass = 500,
    RadarDistance = 0,
    SightDistance = 400,	--This may be too high
    SoundCategory = "TANK",
    idleAutoHeal = 0,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 3,
    
--Pathfinding and related
    Acceleration = 0,
    BrakeRate = 0.1,
    FootprintX = 7,	--Affects Bounding Box (the green colored one)
    FootprintZ = 7,	--Affects Bounding Box (the green colored one)
    MaxSlope = 15,
    MaxVelocity = 0,
    MaxWaterDepth = 20,
    MovementClass = "Default2x2",
    TurnRate = 900,
    
--Abilities
    canAttack = true,
    CanStop = true,
    Builder = 0,
	canFight = 0,
    CanGuard = 0,
    CanMove = 0, 
    CanPatrol = 0,
    LeaveTracks = 0,
    Reclaimable = 0,
    
--Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales = "50 50 50",
	collisionVolumeType = "Box",
	collisionVolumeTest = 1,
	
	--Weapons and related

	weapons = {
		[1] = {
			def = "FIREBALL",
			mainDir = "0 0 1",
			maxAngleDif = 360,
		},
		[2] = {
			def = "FIREBALL2",
			mainDir = "0 0 1",
			maxAngleDif = 360,
		},
		[3] = {
			def = "FIREBALL3",
			mainDir = "0 0 1",
			maxAngleDif = 360,
		},
	},
	
	weaponDefs = {
	FIREBALL = {
		avoidFriendly = 1,
		areaOfEffect = 50,
		burst = 3,
		burstrate = 0.2,
		collideFriendly = false,
		collisionSize = 30,
		name = "FIREBALL",
		edgeEffectiveness = 1,
		energypershot = 0,
		endsmoke = "0",
		impactonly = true,
		model = "Fireball.S3O",
		noSelfDamage = true,
		projectiles = 3,
		proximityPriority=1,
		range = ATKRNG,
		reloadtime = ATKSPD,
		size = 3,
		sprayangle = 8000,		
		startVelocity=250,
		targetBorder = 1,
		tolerance = 5000,
		turret = true,
		turnrate = 64000,
		weaponTimer = 0.5,
		weaponType = "StarburstLauncher",
		weaponVelocity = 1000,
		weaponAcceleration=200,
		damage = {
			default = ATKDMG,
		},
        soundStart = "cannonshot.wav",
	},
	
	FIREBALL2 = {
		avoidFriendly = 1,
		areaOfEffect = 50,
		burst = 3,
		burstrate = 0.2,
		collideFriendly = false,
		collisionSize = 30,
		name = "FIREBALL",
		edgeEffectiveness = 1,
		energypershot = 0,
		endsmoke = "0",
		impactonly = true,
		model = "Fireball.S3O",
		noSelfDamage = true,
		projectiles = 3,
		proximityPriority=3,
		range = ATKRNG,
		reloadtime = ATKSPD,
		size = 3,
		sprayangle = 8000,		
		startVelocity=250,
		targetBorder = 1,
		tolerance = 5000,
		turret = true,
		turnrate = 64000,
		weaponTimer = 0.5,
		weaponType = "StarburstLauncher",
		weaponVelocity = 1000,
		weaponAcceleration=200,
		damage = {
			default = ATKDMG,
		},
	},
	
	FIREBALL3 = {
		avoidFriendly = 1,
		areaOfEffect = 50,
		burst = 3,
		burstrate = 0.2,
		collideFriendly = false,
		collisionSize = 30,
		name = "FIREBALL",
		edgeEffectiveness = 1,
		energypershot = 0,
		endsmoke = "0",
		impactonly = true,
		model = "Fireball.S3O",
		noSelfDamage = true,
		projectiles = 3,
		proximityPriority=-1,
		range = ATKRNG,
		reloadtime = ATKSPD,
		size = 3,
		sprayangle = 8000,		
		startVelocity=250,
		targetBorder = 1,
		tolerance = 5000,
		turret = true,
		turnrate = 64000,
		weaponTimer = 0.5,
		weaponType = "StarburstLauncher",
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



