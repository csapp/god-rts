
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


function Units.GetClassFromUnitID(unitID)
    return UnitDefs[GetUnitDefID(unitID)].customParams.class
end

function Units.IsInfantryUnit(unitID)
    return Units.GetClassFromUnitID(unitID) == Units.CLASSES.INFANTRY
end

function Units.IsCavalryUnit(unitID)
    return Units.GetClassFromUnitID(unitID) == Units.CLASSES.CAVALRY
end

function Units.IsRangedUnit(unitID)
    return Units.GetClassFromUnitID(unitID) == Units.CLASSES.RANGED
end

function Units.IsClergyUnit(unitID)
    return Units.GetClassFromUnitID(unitID) == Units.CLASSES.CLERGY
end

function Units.IsVillageUnit(unitID)
    return Units.GetClassFromUnitID(unitID) == Units.CLASSES.VILLAGE
end

function Units.IsGodUnit(unitID)
    return Units.GetClassFromUnitID(unitID) == Units.CLASSES.GOD
end

