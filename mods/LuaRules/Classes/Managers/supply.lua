local function GetInfo()
    return {
        name = "Supply Manager",
        desc = "Team manager that keeps track of supplies",
        tickets = "#150",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

include("LuaUI/Headers/units.h.lua")

local GetTeamUnits = Spring.GetTeamUnits

SupplyManager = Manager:Inherit{
    classname = "SupplyManager",
    usedSupplies = 0,
}

local this = SupplyManager
local inherited = this.inherited

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

function SupplyManager:GetSupplyCost(unitDefID)
    return tonumber(UnitDefs[unitDefID].customParams.supply_cost)
end

function SupplyManager:CanUse(unitDefID)
    local s = self:GetSupplyCost(unitDefID)
    return self:GetUsedSupplies() + s <= self:GetSupplyCap()
end

function SupplyManager:UseSupplies(unitDefID)
    local s = self:GetSupplyCost(unitDefID)
    if self:CanUse(unitDefID) then
        self:SetUsedSupplies(self:GetUsedSupplies() + s)
        return true
    end
    return false
end

function SupplyManager:ReturnSupplies(unitDefID)
    local s = self:GetSupplyCost(unitDefID)
    self:SetUsedSupplies(self:GetUsedSupplies() - s)
    if self:GetUsedSupplies() < 0 then
        self:SetUsedSupplies(0)
    end
end

