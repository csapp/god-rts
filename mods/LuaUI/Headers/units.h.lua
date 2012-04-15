
-- Speed ups
local GetUnitDefID = Spring.GetUnitDefID

Units = {}
Units.CLASSES = {
    INFANTRY = "infantry",
    CAVALRY = "cavalry",
    RANGED = "ranged",
    CLERGY = "clergy",
    VILLAGE = "village",
    GOD = "god",
    ZOMBIE = "zombie",
    VOLCANO = "volcano",
}

Units.UNITDEF_NAMES = {
    GOD = "god",
    GENERAL = "general",
    ARCHER = "archer",
    WARRIOR = "warrior",
    SOLDIER = "soldier",
    SCOUT = "scout",
    PROPHET = "prophet",
    PRIEST = "priest",
    DEMIGOD = "demigod",
    MARKSMAN = "marksman",
    KNIGHT = "knight",
    HORSEMAN = "horseman",
    HUNTER = "hunter",
    --ZOMBIE = "zombie",
}

local function GetCustomParam(unitID, param)
    return UnitDefs[GetUnitDefID(unitID)].customParams[param]
end

function Units.GetMaxXP(unitID)
    return tonumber(GetCustomParam(unitID, 'max_xp'))
end

function Units.GetSpeed(unitID)
    return tonumber(GetCustomParam(unitID, 'real_speed'))
end

function Units.GetLevel(unitID)
    return tonumber(GetCustomParam(unitID, 'level'))
end

function Units.GetConvertTime(villageID)
    return tonumber(GetCustomParam(villageID, 'convert_time'))
end

function Units.GetConvertTimeBonus(clergyID)
    return tonumber(GetCustomParam(clergyID, 'convert_time_bonus'))
end

function Units.GetClass(unitID)
    return GetCustomParam(unitID, 'class')
end

function Units.IsInfantryUnit(unitID)
    return Units.GetClass(unitID) == Units.CLASSES.INFANTRY
end

function Units.IsCavalryUnit(unitID)
    return Units.GetClass(unitID) == Units.CLASSES.CAVALRY
end

function Units.IsRangedUnit(unitID)
    return Units.GetClass(unitID) == Units.CLASSES.RANGED
end

function Units.IsClergyUnit(unitID)
    return Units.GetClass(unitID) == Units.CLASSES.CLERGY
end

function Units.IsVillageUnit(unitID)
    return Units.GetClass(unitID) == Units.CLASSES.VILLAGE
end

function Units.IsGodUnit(unitID)
    return Units.GetClass(unitID) == Units.CLASSES.GOD
end

function Units.IsZombieUnit(unitID)
    return Units.GetClass(unitID) == Units.CLASSES.ZOMBIE
end

function Units.IsVolcanoUnit(unitID)
    return Units.GetClass(unitID) == Units.CLASSES.VOLCANO
end

function Units.IsTempUnit(unitID)
    local temp = GetCustomParam(unitID, 'temp_unit') 
    return temp and temp ~= "false"
end

function Units.IsHeroUnit(unitID)
    local hero = GetCustomParam(unitID, 'hero') 
    return hero and hero ~= "false"
end

