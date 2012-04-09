local function GetInfo()
    return {
        name = "Express Conversion power",
        desc = "Halves clergy conversion time",
        tickets = "#134",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

include("LuaUI/Headers/multipliers.h.lua")

ExpressConversion = PassivePower:Inherit{
    classname = "ExpressConversion",
    powerName = "Express Conversion",
    id = 50001,
    multipliers = {
        [Multipliers.TYPES.CONVERT_TIME] = {0.5},
        [Multipliers.TYPES.FAITH] = {0.5}, -- generate 0.5 faith every 5 seconds
    },
}

return ExpressConversion
