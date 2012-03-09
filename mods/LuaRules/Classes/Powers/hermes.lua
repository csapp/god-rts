include("LuaUI/Headers/multipliers.h.lua")

BootsOfHermes = PassivePower:Inherit{
    classname = "BootsOfHermes",
    powerName = "Boots of Hermes",
    id = 50000,
    multipliers = {
        [Multipliers.TYPES.MOVE_SPEED] = {3},
    },
}

return BootsOfHermes
