include("LuaRules/Classes/class.lua")
include("LuaRules/Classes/baseunit.lua")

UnitCollection = {}
UnitCollection_mt = Class(UnitCollection)

function UnitCollection:new(teamID)
    local new = setmetatable({
        teamID=teamID,
        units={},
    }, UnitCollection_mt)
    return new
end

function UnitCollection:AddUnit(unit)
    self.units[unit.unitID] = unit
end

function UnitCollection:RemoveUnit(unitID)
    self.units[unitID] = nil
end
