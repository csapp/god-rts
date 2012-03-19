local unitName = "smallvillage"

local unitDef =
{
-- Internal settings	
	Category = "LAND",
	ObjectName = "village.s3o",
	TEDClass = "PLANT",
	Name = "Small Village",
	script = "villagescript.lua",
	buildPic = "placeholder.png",

-- Unit limitations and properties
	Description = "A small village that can build Level 1 units",
	MaxDamage = 1500,
	RadarDistance = 0,
	SightDistance = 400,	
	Upright = 1,	
	levelground = 1,
	
--Cost
	buildCostMetal = 0,
	buildCostEnergy = 0,
	buildTime = 10,

-- Pathfinding and related
	FootprintX = 5,
	FootprintZ = 5,
	MaxSlope = 10,	
    yardMap ="ooooo occco ccccc ccccc ccccc",

--Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales = "75	50 75",
	collisionVolumeType = "Box",
	collisionVolumeTest = 1,
	
-- Building	
	Builder = true,
	workerTime = 1,
    CanRepair = true,
    RepairSpeed = 1, 
    CanRestore = false,
    Reclaimable = false,
	ShowNanoSpray = false,
	CanBeAssisted = false,	

	buildoptions = 
        {
            "soldier",
            "horseman",
            "hunter",
        },

    -- Custom
    customParams = {
        supply_cap = 100,
        class = "village",
        convert_time = 30,
        convert_xp = 500,
        level = 1,
        max_xp = 2000,
        morph_into = "mediumvillage",
    },
    sounds = {
        select = {"hey_sweetness1",
                  "hey_sweetness2",
                  "hiwoman"},
    },

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
            burst = 3,
            burstrate = 0.3,
            collideFriendly = false,
            collisionSize = 3,
            name = "Bow",
            energypershot = 0,
            endsmoke = "0",
            impactonly = true,
            model = "Arrow.S3O",
            noSelfDamage = true,
            range = 200,
            reloadtime = 2,
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
                default = 2,
            },
            
        },
    },
}

return lowerkeys({ [unitName] = unitDef })
