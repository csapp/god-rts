include("LuaUI/Headers/multipliers.h.lua")

Aphrodite = PassivePower:Inherit{
    classname = "Aphrodite",
    powerName = "Aphrodite",
    id = 50002,
    multipliers = {
        [Multipliers.TYPES.VILLAGER] = {1},
    },
}

return Aphrodite
