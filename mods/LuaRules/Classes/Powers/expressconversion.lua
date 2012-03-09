include("LuaUI/Headers/multipliers.h.lua")

ExpressConversion = PassivePower:Inherit{
    classname = "ExpressConversion",
    powerName = "Express Conversion",
    id = 50001,
    multipliers = {
        [Multipliers.TYPES.CONVERT_TIME] = {0.5},
    },
}

return ExpressConversion
