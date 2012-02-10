local unitName = "smallvillage"

local unitDef =
{
-- Internal settings	
	Category = "LAND",
	ObjectName = "village.s3o",
	name = "smallvillage",	
	TEDClass = "PLANT",
	script = "smallvillage.lua",
	buildPic = "placeholder.png",

-- Unit limitations and properties
	Description = "A small village that can build Level 1 units",
	MaxDamage = 1500,
	Name = "Small Village",
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
	YardMap ="ooooo occco occco occco occco",

--Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales = "75	50 75",
	collisionVolumeType = "Box",
	collisionVolumeTest = 1,
	
-- Building	
	Builder = true,
    Reclaimable = false,
	ShowNanoSpray = true,
	CanBeAssisted = false,	
	workerTime = 1,
	buildoptions = 
	{
        --"soldier",
        "warrior",
        --"general",
	},
}

return lowerkeys({ [unitName] = unitDef })
