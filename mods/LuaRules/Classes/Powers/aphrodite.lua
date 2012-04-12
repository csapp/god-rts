local function GetInfo()
    return {
        name = "Aphrodite",
        desc = "Increases villager generation rate",
        tickets = "#136",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

VFS.Include("LuaUI/Headers/multipliers.h.lua")

Aphrodite = PassivePower:Inherit{
    classname = "Aphrodite",
    powerName = "Aphrodite",
    id = 50002,
    multipliers = {
        [Multipliers.TYPES.VILLAGER] = {1},
    },
}

return Aphrodite
