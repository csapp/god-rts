local unitName  =  "priest"

--Attribute Defintions
local HP = 100
local ATKDMG = 0
local ATKSPD = 1
local ATKRNG = 1
local MOVESPD = {3,0.15} -- {walkspeed, acceleration}

local unitDef  =  {
--Internal settings
    BuildPic = "priest.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "priest.s3o",
    name = "Priest",
    script = "priestscript.lua",
    builder = true,
    --cancapture = true,
    --capturespeed = 900,

    customParams = {
        convert_time_bonus = 0,
        real_speed = 90,
        class = "clergy",
        morph_into = "prophet",
        max_xp = 1500,
        level = 1,
        supply_cost = 1,
    },

    sounds = {
      select = {
            [1] = "Mansighing2",
        },
      ok = {
            [1] = "Mansighing2",
        },
      underattack = "manscreaming2",
    },
    
--Unit limitations and properties
    BuildTime = 5,
    Description = "Well-groomed evangelist",
    MaxDamage = HP,
	mass = 500,
    RadarDistance = 0,
    SightDistance = 400,	--This may be too high
    SoundCategory = "TANK",
    Upright = 0,
    idleAutoHeal = 0,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 8,
    
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
    Builder = 0,
    canAttack = false,
	canFight = false,
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
	
    BadTargetCategory = "NOTAIR",
    ExplodeAs = "TANKDEATH",
    NoChaseCategory = "AIR",

}

return lowerkeys({ [unitName]  =  unitDef })



