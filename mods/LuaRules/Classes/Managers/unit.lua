local function GetInfo()
    return {
        name = "Unit Manager",
        desc = "'Meta' manager that is an entry point to access other unit object managers",
        tickets = "#162",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

include("LuaUI/Headers/units.h.lua")
include("LuaRules/Classes/Managers/village.lua")

UnitManager = Manager:Inherit{
    classname = "UnitManager",
}

local this = UnitManager
local inherited = this.inherited

function UnitManager:New()
    local obj = inherited.New(self)
    obj:AddElement(Units.CLASSES.VILLAGE, VillageManager:New())
    return obj
end

function UnitManager:GetVillageManager()
    return self:GetElement(Units.CLASSES.VILLAGE)
end
