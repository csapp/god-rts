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
    Reclaimable = false,
	ShowNanoSpray = false,
	CanBeAssisted = false,	
	workerTime = 1,
	buildoptions = 
        {
            "soldier",
            "horseman",
            "hunter",
        },

    -- Custom
    customParams = {
        class = "village",
        convert_time = 30,
        convert_xp = 500,
        level = 1,
        max_xp = 2000,
        morph_into = "mediumvillage",
    }
}

return lowerkeys({ [unitName] = unitDef })
