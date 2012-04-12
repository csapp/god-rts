function widget:GetInfo()
    return {
        name = "Util globals",
        desc = "Widget that initializes some globals for widgets",
        author = "cam",
        tickets = "#179",
        date = "2012-04-12",
        license = "GNU GPL v2",
        layer = -math.huge,
        enabled = true,
    }
end

include("powers.h.lua")

local function PopulatePowerTables()
    local powers = {}
    local powerNames = {}

    VFS.Include("LuaRules/Classes/object.lua")

    for _, filepath in pairs(POWERS.FILES.BASES) do
        VFS.Include(POWERS.POWERS_DIR .. filepath)
    end
    for _, filepath in pairs(POWERS.FILES.CLASSES) do
        local power = VFS.Include(POWERS.POWERS_DIR .. filepath)
        powers[power:GetID()] = power
        powerNames[power:GetName()] = power
    end
    WG.Powers = powers
    WG.PowerNames = powerNames
end

function widget:Initialize()
    PopulatePowerTables()
end
