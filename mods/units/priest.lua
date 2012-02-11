local unitName  =  "priest"

local unitDef  =  {
--Internal settings
    BuildPic = "filename.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "priest.s3o",
    name = "Priest",
    script = "priestscript.lua",
    builder = true,
    cancapture = true,
    capturespeed = 900,

    customParams = {
        morph_into = "prophet",
        max_xp = 1500,
        level = 1,
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
    BuildTime = 1000,
    Description = "An awesome evangelist",
    MaxDamage = 800,
    idleAutoHeal = 0,
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
    --BadTargetCategory = "NOTAIR",
    --ExplodeAs = "TANKDEATH",
    --NoChaseCategory = "AIR",

}

return lowerkeys({ [unitName]  =  unitDef })



