local unitName = "mediumvillage"

local unitDef =
{
-- Internal settings	
	Category = "LAND",
	ObjectName = "MediumVillage.s3o",
	TEDClass = "PLANT",
	Name = "Medium Village",
	script = "villagescript.lua",
	buildPic = "placeholder.png",

-- Unit limitations and properties
	Description = "A medium village that can build Level 1 and 2 units",
	MaxDamage = 3000,
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
    yardMap ="ooooo occco occco occco occco",

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
            "priest",
            "soldier",
            "horseman",
            "hunter",

            "warrior",
            "scout",
            "marksman",
        },

    -- Custom
        supply_cap = 200,
    customParams = {
        class = "village",
        convert_time = 60,
        convert_xp = 750,
        level = 2,
        max_xp = 5000,
        morph_into = "largevillage",
    },
    sounds = {
        select = {"hey_sweetness1",
                  "hey_sweetness2",
                  "hiwoman"},
    },
}

return lowerkeys({ [unitName] = unitDef })
