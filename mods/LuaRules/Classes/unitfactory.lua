include("LuaRules/Classes/class.lua")
include("LuaRules/Classes/infantry.lua")
include("LuaRules/Classes/clergy.lua")

UnitFactory = {}
UnitFactory_mt = Class(UnitFactory)

local UNIT_MAP = {
    ['priest']=PriestUnit,
    ['warrior']=WarriorUnit,
}

function UnitFactory:CreateUnit(unitID, unitDefID, teamID)
    local unitDefName = UnitDefs[unitDefID].name
    unitClass = UNIT_MAP[unitDefName]
    if (not(unitClass)) then return end
    return unitClass:new(unitID, unitDefID, teamID)
end

