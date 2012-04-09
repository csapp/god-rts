local function GetInfo()
    return {
        name = "Metropolis power",
        desc = "Upgrades villages: increase max supply cap, increase village XP, decrease build time for buildings",
        tickets = "#170",
        author = "cam",
        date = "2012-04-08",
        license = "Public Domain",
    }
end

include("LuaUI/Headers/multipliers.h.lua")
include("LuaUI/Headers/units.h.lua")

Metropolis = PassivePower:Inherit{
    classname = "Metropolis",
    powerName = "Metropolis",
    id = 50000,
    multipliers = {
        [Multipliers.TYPES.XP] = {0.5, {Units.CLASSES.VILLAGE}},
        [Multipliers.TYPES.SUPPLY_CAP] = {0.2, {Units.CLASSES.VILLAGE}},
        [Multipliers.TYPES.BUILDING_TIME] = {0.3, {Units.CLASSES.VILLAGE}},
    },
}

return Metropolis
