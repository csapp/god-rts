include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/villages.h.lua")
include("LuaUI/Headers/customcmds.h.lua")
include("LuaRules/Classes/Units/unit.lua")
include("LuaRules/Classes/Units/village_buildings.lua")

Village = BaseUnit:Inherit{
    classname = "Village",
    buildings = {},
    busy = false,
    disallowedCommands = {
        CMD.ATTACK,
        CMD.REPAIR,
    },
    fortifyTime = 6,
    supplyCap = 0, -- set in New()
}

local CLASS_MAP = {
    [Buildings.TYPES.SHRINE] = Shrine,
    [Buildings.TYPES.TURRET] = Turret,
    [Buildings.TYPES.MOTEL] = Motel,
    [Buildings.TYPES.HIGH_RISE] = HighRise,
    [Buildings.TYPES.TRAINING_FACILITY] = TrainingFacility,
}

local this = Village
local inherited = this.inherited

local fortifyCmdDesc = {
    id = Villages.CMDS.FORTIFY,
    name = "Fortify",
    action = "Fortify",
    type = CMD.ICON,
    tooltip = "Fortify the village to level up",
    params = {},
}

function Village:New(unitID)
    local obj = inherited.New(self, unitID)
    obj.supplyCap = UnitDefs[Spring.GetUnitDefID(unitID)].customParams.supply_cap
    return obj
end

function Village:GetSupplyCap()
    return self.supplyCap
end

function Village:SetSupplyCap(cap)
    self.supplyCap = cap
end

function Village:GetFortifyTime()
    return self.fortifyTime*Units.GetLevel(self:GetUnitID())
end

function Village:ReadyToFortify()
    Spring.InsertUnitCmdDesc(self:GetUnitID(), Villages.CMDS.FORTIFY, fortifyCmdDesc)
end

function Village:Fortify()
    local unitID = self:GetUnitID()
    self:SetBusy(true)
    local function _done()
        LuaMessages.SendLuaRulesMsg(MSG_TYPES.MORPH, {unitID, 1})
        self:SetBusy(false)
    end
    local function _cancelled() 
        self:SetBusy(false)
    end
    
    GG.ProgressBars.AddProgressBar(unitID, "Fortifying...", 
                                   self:GetFortifyTime(), _done, _cancelled)
end

function Village:GetDisallowedCommands()
    return self.disallowedCommands
end

function Village:AllowCommand(command)
    local disallowedCommands = self:GetDisallowedCommands()
    for i, cmd in ipairs(disallowedCommands) do
        if cmd == command then
            table.remove(disallowedCommands, i)
            break
        end
    end
end

function Village:DisallowCommand(command)
    local disallowedCommands = self:GetDisallowedCommands()
    table.insert(disallowedCommands, command)
end

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
    GG.ProgressBars.AddProgressBar(self:GetUnitID(), "Building " .. building:GetName() .. "...", 
                                   building:GetBuildTime(), _done, _cancelled)
end

function Village:GetBuildings()
    return self.buildings
end

function Village:GetBuilding(key)
    return self.buildings[key]
end

function Village:ExecuteCommand(cmdID)
    for _, building in pairs(self:GetBuildings()) do
        building:ExecuteCommand(cmdID)
    end
end

function Village:Update()
    for _, building in pairs(self:GetBuildings()) do
        building:Update()
    end
end

function Village:Transfer(oldTeam)
    for key, building in pairs(self:GetBuildings()) do
        building:Transfer(oldTeam)
    end
end

function Village:GetAvailableBuildings()
    -- All villages have the same buildings available, so for now
    -- just return the class map
    return CLASS_MAP
end

