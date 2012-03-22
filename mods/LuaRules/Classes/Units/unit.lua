local function GetInfo()
    return {
        name = "Base unit",
        desc = "Base class from which all custom unit classes derive",
        tickets = "#63, #162",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

include("LuaUI/Headers/units.h.lua")
include("LuaRules/Classes/object.lua")

local GetUnitTeam = Spring.GetUnitTeam

BaseUnit = Object:Inherit{
    classname = "BaseUnit",
    unitID = -1,
}

local this = BaseUnit
local inherited = this.inherited

function BaseUnit:New(unitID)
    obj = inherited.New(self, {unitID=unitID})
    return obj
end

function BaseUnit:GetUnitID() return self.unitID end
function BaseUnit:SetUnitID(unitID)
    self.unitID = unitID
end

function BaseUnit:GetClass()
    return Units.GetClass(self:GetUnitID())
end

function BaseUnit:GetTeamID()
    return GetUnitTeam(self:GetUnitID())
end

function BaseUnit:LevelUp(newUnitID)
    self:SetUnitID(newUnitID)
end
