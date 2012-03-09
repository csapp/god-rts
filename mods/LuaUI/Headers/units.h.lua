
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
}

Units.UNITDEF_NAMES = {
    GOD = "god",
    GENERAL = "general",
    ARCHER = "archer",
    WARRIOR = "warrior",
    SOLDIER = "soldier",
    SCOUT = "scout",
    PROPHET = "Prophet",
    PRIEST = "priest",
    MARKSMAN = "marksman",
    KNIGHT = "knight",
    HORSEMAN = "horseman",
    HUNTER = "hunter",
}

local function GetCustomParam(unitID, param)
    return UnitDefs[GetUnitDefID(unitID)].customParams[param]
end

function Units.GetLevel(unitID)
    return GetCustomParam(unitID, 'level')
end

function Units.GetConvertTime(villageID)
    return tonumber(GetCustomParam(villageID, 'convert_time'))
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

