local function GetInfo()
    return {
        name = "Boots of Hermes power",
        desc = "Gives units a large speed upgrade. DISABLED RIGHT NOW, see #154",
        tickets = "#133",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

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
