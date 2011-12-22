include("LuaRules/Classes/class.lua")

BaseUnit = {}
local BaseUnit_mt = Class(BaseUnit)

function BaseUnit:new(unitID, unitDefID, teamID)
    local new = setmetatable({
        unitID=unitID,
        unitDefID=unitDefID,
        teamID=teamID,
        currentLevel=1,
        currentXP=0
    }, BaseUnit_mt)
    return new
end

function BaseUnit:AddXP(xp)
    self.currentXP = self.currentXP + xp
    Spring.Echo("Added XP! Current XP at " .. self.currentXP)
end


