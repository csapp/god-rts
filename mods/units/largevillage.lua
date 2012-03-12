local unitName = "largevillage"

local unitDef =
{
-- Internal settings	
	Category = "LAND",
	ObjectName = "LargeVillage.s3o",
	TEDClass = "PLANT",
	Name = "Large Village",
	script = "villagescript.lua",
	buildPic = "placeholder.png",

-- Unit limitations and properties
	Description = "A large village that can build all units",
	MaxDamage = 5000,
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
    Reclaimable = false,
	ShowNanoSpray = false,
	CanBeAssisted = false,	
	workerTime = 1,
	buildoptions = 
        {
            "soldier",
            "horseman",
            "hunter",

            "warrior",
            "scout",
            "marksman",

            "general",
            "knight",
            "archer",
        },

    -- Custom
    customParams = {
        class = "village",
        convert_time = 120,
        convert_xp = 1000,
        level = 3,
    },

    sounds = {
        select = {"hey_sweetness1",
                  "hey_sweetness2",
                  "hiwoman"},
    },
}

return lowerkeys({ [unitName] = unitDef })
