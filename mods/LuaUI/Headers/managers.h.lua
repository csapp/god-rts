Managers = {}

Managers.TYPES = {
    TEAM = "TeamManager",
    POWER = "PowerManager",
    ATTRIBUTE = "AttributeManager",
    SUPPLY = "SupplyManager",
    UNIT = "UnitManager",
    VILLAGE = "VillageManager",
}

Managers.Team = {}

Managers.Team.TYPES = {
    Managers.TYPES.POWER,
    Managers.TYPES.ATTRIBUTE,
    Managers.TYPES.SUPPLY,
}

Managers.Unit = {}
Managers.Unit.TYPES = {
    Managers.TYPES.VILLAGE,
}
