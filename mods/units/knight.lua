local unitName  =  "knight"

local unitDef  =  {
--Internal settings
    BuildPic = "filename.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "knight.s3o",
    name = "knight",
    script = "knightscript.lua",

    customParams = {
        level = 3,
    },

    sounds = {
      select = {
            [1] = "horse_1",
            [1] = "Horsesnorts4",
        },
      ok = {
            [1] = "Horsegrunt1",
        },
    },
    
--Unit limitations and properties
    BuildTime = 1000,
    Description = "An awesomely powerful knight",
    MaxDamage = 800,
    RadarDistance = 0,
    SightDistance = 400,
    SoundCategory = "TANK",
    Upright = 0,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 0,
    
--Pathfinding and related
    Acceleration = 0.15,
    BrakeRate = 0.1,
    FootprintX = 2,
    FootprintZ = 2,
    MaxSlope = 15,
    MaxVelocity = 2.0,
    MaxWaterDepth = 20,
    MovementClass = "Default2x2",
    TurnRate = 900,
    
--Abilities
    Builder = 0,
    CanAttack = 1,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 0,
    
--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "20 20 20",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",
    
--Weapons and related
    BadTargetCategory = "NOTAIR",
    ExplodeAs = "TANKDEATH",
    NoChaseCategory = "AIR",

}

return lowerkeys({ [unitName]  =  unitDef })



