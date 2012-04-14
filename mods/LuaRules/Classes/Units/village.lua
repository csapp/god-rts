local function GetInfo()
    return {
        name = "Village objects",
        desc = "Handles village operations (e.g. buildings, fortification)",
        tickets = "#70, #116, #150",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/villages.h.lua")
include("LuaUI/Headers/customcmds.h.lua")
include("LuaRules/Classes/Units/unit.lua")
include("LuaRules/Classes/Units/village_buildings.lua")

-- speed ups
local GiveOrderToUnit = Spring.GiveOrderToUnit

local fortifyCmdDesc = {
    id = Villages.CMDS.FORTIFY,
    name = "Fortify",
    action = "Fortify",
    type = CMD.ICON,
    tooltip = "Fortify the village to level up",
    params = {},
}

local CLASS_MAP = {
    [Buildings.TYPES.SHRINE] = Shrine,
    [Buildings.TYPES.TURRET] = Turret,
    [Buildings.TYPES.MOTEL] = Motel,
    [Buildings.TYPES.HIGH_RISE] = HighRise,
    [Buildings.TYPES.TRAINING_FACILITY] = TrainingFacility,
}


Village = BaseUnit:Inherit{
    classname = "Village",
    buildings = {},
    busy = false,
    disallowedCommands = {
        CMD.ATTACK,
        CMD.REPAIR,
    },
    fortifyTime = 60,
    supplyCap = 0, -- set in New()
}

local this = Village
local inherited = this.inherited


function Village:New(unitID)
    local obj = inherited.New(self, unitID)
    obj.supplyCap = UnitDefs[Spring.GetUnitDefID(unitID)].customParams.supply_cap
    return obj
end

function Village:LevelUp(newUnitID)
    local vm = _G.UnitManager:GetVillageManager()
    vm:AddElement(newUnitID, self)
    vm:RemoveElement(self:GetUnitID())
    inherited.LevelUp(self, newUnitID)
    self:CallOnAll("ApplyVillageUpgrades")
end

function Village:GetSupplyCap()
    local am = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager()
    local mult = am:GetSupplyCapMultiplier():GetValue(self:GetUnitID())
    return self.supplyCap * mult
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
function Village:SetBusy(b)
    if b then
        GiveOrderToUnit(self:GetUnitID(), CMD.WAIT, {}, {CMD_OPTS.ALLOW})
        self.busy = b
    else
        self.busy = b
        GiveOrderToUnit(self:GetUnitID(), CMD.WAIT, {}, {CMD_OPTS.ALLOW})
    end
end

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

function Village:CallOnAll(funcname, args)
    args = args or {}
    local results = {}
    for id, element in pairs(self:GetBuildings()) do
        local func = element[funcname]
        if func then 
            results[id] = func(element, unpack(args))
        end
    end
    return results
end

function Village:ExecuteCommand(cmdID)
    for _, building in pairs(self:GetBuildings()) do
        building:ExecuteCommand(cmdID)
    end
end

function Village:Update(n)
    for _, building in pairs(self:GetBuildings()) do
        building:Update(n)
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

