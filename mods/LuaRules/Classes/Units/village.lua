include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/buildings.h.lua")
include("LuaRules/Classes/Units/unit.lua")
include("LuaRules/Classes/Units/village_buildings.lua")

Village = BaseUnit:Inherit{
    classname = "Village",
    buildings = {},
    busy = false,
}

local CLASS_MAP = {
    [Buildings.TYPES.SHRINE] = Shrine,
}

local this = Village
local inherited = this.inherited

function Village:GetSlots()
    -- # of building slots = current level
    return Units.GetLevel(self:GetUnitID())
end

function Village:IsBusy() return self.busy end
function Village:SetBusy(b) self.busy = b end

function Village:Stop()
    if not self:IsBusy() then return end
    GG.ProgressBars.CancelProgressBar(self:GetUnitID())
end

function Village:GetBuildingCount()
    local count = 0
    for _, _ in pairs(self:GetBuildings()) do
        count = count + 1
    end
    return count
end

function Village:IsFull()
    return self:GetBuildingCount() >= self:GetSlots()
end

function Village:AddBuilding(key)
    if self:IsFull() or self:IsBusy() then
        return
    end
    self:SetBusy(true)
    local building = CLASS_MAP[key]:New(self)
    local function _done()
        self.buildings[key] = building
        building:Apply()
        self:SetBusy(false)
    end
    local function _cancelled() self:SetBusy(false) end
    GG.ProgressBars.AddProgressBar(self:GetUnitID(), "Building...", 
                                   building:GetBuildTime(), _done, _cancelled)
end

function Village:GetBuildings()
    return self.buildings
end

function Village:GetBuilding(key)
    return self.buildings[key]
end

function Village:Transfer(oldTeam)
    for key, building in pairs(self:GetBuildings()) do
        building:Transfer(oldTeam)
    end
end
