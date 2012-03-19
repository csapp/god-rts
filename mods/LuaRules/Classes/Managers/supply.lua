include("LuaUI/Headers/units.h.lua")

local GetTeamUnits = Spring.GetTeamUnits

SupplyManager = Manager:Inherit{
    classname = "SupplyManager",
    usedSupplies = 0,
}

local this = SupplyManager
local inherited = this.inherited

--function SupplyManager:New(teamID)
    --local obj = SupplyManager.inherited.New(self, teamID)
    --obj:SetUsedSupplies(Spring.GetTeamResource(teamID, "metal"))
    --return obj
--end
function SupplyManager:GetUsedSupplies()
    return self.usedSupplies
end

function SupplyManager:SetUsedSupplies(s)
    self.usedSupplies = s
end

function SupplyManager:GetSupplyCap()
    local total = 0
    local vm = _G.UnitManager:GetVillageManager()
    for _, unitID in pairs(GetTeamUnits(self:GetTeamID())) do
        if Units.IsVillageUnit(unitID) then
            total = total + vm:GetElement(unitID):GetSupplyCap()
        end
    end
    return total
end

function SupplyManager:_CanUse(s)
    return self:GetUsedSupplies() + s <= self:GetSupplyCap()
end

function SupplyManager:UseSupplies(unitDefID)
    local s = UnitDefs[unitDefID].metalCost
    if self:_CanUse(s) then
        self:SetUsedSupplies(self:GetUsedSupplies() + s)
        return true
    end
    return false
end

function SupplyManager:ReturnSupplies(unitDefID)
    local s = UnitDefs[unitDefID].metalCost
    self:SetUsedSupplies(self:GetUsedSupplies() - s)
    if self:GetUsedSupplies() < 0 then
        self:SetUsedSupplies(0)
    end
end

