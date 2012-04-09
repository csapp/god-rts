local function GetInfo()
    return {
        name = "Village buildings",
        desc = "All buildings that can be built by villages are housed here",
        tickets = "#116",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end
--
-- This file should probably be in UnitMods, not here

include("LuaUI/Headers/utilities.lua")
include("LuaUI/Headers/units.h.lua")
include("LuaUI/Headers/multipliers.h.lua")
include("LuaUI/Headers/villages.h.lua")
include("LuaUI/Headers/msgs.h.lua")

local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitsInSphere = Spring.GetUnitsInSphere
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitHealth = Spring.SetUnitHealth
local gaiaTeamID = Spring.GetGaiaTeamID()

Building = Object:Inherit{
    classname = "Building",
    village = nil,
    buildingName = "",
    multipliers = {},
    researchUpgrades = {},
    tooltip = "",
    buildTime = 1,
    cmdDesc = {},
    cmdType = CMD.ICON,
    cmds = {},
}

function Building:New(village)
    obj = Building.inherited.New(self, {village=village})
    return obj
end

function Building:Update(n)
end

function Building:ExecuteCommand(cmdID) 
    for id, call_info in pairs(self:GetCmds()) do
        if id == cmdID then
            local func, args = unpack(call_info)
            func(unpack(args))
            break
        end
    end
end

function Building:GetCmdDesc()
    local name = self:GetName()
    return {
        id = self:GetCmdID(),
        name = "Build " .. name,
        action = "building_" .. name,
        type = self.cmdType,
        tooltip = "Build a " .. name .. " in this village",
        params = {},
    }
end

function Building:GetKey()
    return self:GetName():upper():gsub(' ', '_')
end

function Building:GetCmdID() 
    return self.cmdID or Buildings.CMD_IDS[self:GetKey()]
end

function Building:GetBuildTime() 
    local am = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager()
    local mult = am:GetBuildingTimeMultiplier():GetValue(self:GetUnitID())
    return self.buildTime * mult
end

function Building:GetResearchUpgrades() return self.researchUpgrades end
function Building:GetCmds() return self.cmds end
function Building:GetVillage() return self.village end
function Building:GetUnitID() return self:GetVillage():GetUnitID() end
function Building:GetTeamID() return self:GetVillage():GetTeamID() end
function Building:GetName() return self.buildingName end
function Building:GetInfo() return self.multipliers end
function Building:GetMultipliers() return self.multipliers end
function Building:GetTooltip() return self.tooltip end

function Building:GetTeamID()
    return GetUnitTeam(self:GetUnitID())
end

function Building:AddResearchUpgrade(upgrade)
    self.researchUpgrades[upgrade:GetKey()] = upgrade
end

function Building:Apply()
    local am = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager()
    for key, multiplier in pairs(self:GetMultipliers()) do
        local value, classes = unpack(multiplier)
        am:AddMultiplier(key, value, classes)
    end
end

function Building:Unapply(oldTeam)
    if oldTeam == gaiaTeamID then return end
    local am = _G.TeamManagers[oldTeam]:GetAttributeManager()
    for key, multiplier in pairs(self:GetMultipliers()) do
        local value, classes = unpack(multiplier)
        am:AddMultiplier(key, -value, classes)
    end
end

function Building:Transfer(oldTeam)
    if not table.isempty(self:GetMultipliers()) then
        self:Unapply(oldTeam)
        self:Apply()
    end
end

------------------------------------------------------------
-- SHRINE
------------------------------------------------------------

Shrine = Building:Inherit{
    classname = "Shrine",
    buildingName = "Shrine",
    buildTime = 90,
    multipliers = {
        [Multipliers.TYPES.XP] = {0.1, {Units.CLASSES.CLERGY}},
    },
    faithBonus = 2,
    faithTimeInterval = 5,
    faithCounter = 0, -- to count up to faithTimeInterval seconds
    tooltip = "Provides automatic faith generation and an XP bonus for Clergy",
}

function Shrine:GetFaithBonus() return self.faithBonus end
function Shrine:GetFaithTimeInterval() return self.faithTimeInterval end

function Shrine:Update(n)
    -- Adds faithBonus faith every faithTimeInterval seconds
    if n % 30 ~= 0 then return end
    self.faithCounter = self.faithCounter + 1
    if self.faithCounter == self:GetFaithTimeInterval() then
        LuaMessages.SendLuaRulesMsg(MSG_TYPES.ADD_FAITH, {self:GetTeamID(), self:GetFaithBonus()})
        self.faithCounter = 0
    end
end
    
------------------------------------------------------------
-- TURRET
------------------------------------------------------------

Turret = Building:Inherit{
    classname = "Turret",
    buildingName = "Turret",
    buildTime = 45,
    tooltip = "Allows village to attack",
}

function Turret:Apply()
    Spring.UnitScript.GetScriptEnv(self:GetUnitID()).Upgrade()
end

function Turret:Unapply(oldTeam) 
    Spring.UnitScript.GetScriptEnv(self:GetUnitID()).Downgrade()
end

------------------------------------------------------------
-- MOTEL
------------------------------------------------------------

Motel = Building:Inherit{
    classname = "Motel",
    buildingName = "Motel",
    buildTime = 90,
    radius = 100,
    hpBonus = 0.1,
    multipliers = {
        [Multipliers.TYPES.VILLAGER] = {1},
    },
    tooltip = "Allows units to sleep to regain health, and increases villager generation rate",
}

function Motel:GetHPBonus() return self.hpBonus end
function Motel:GetRadius() return self.radius end

function Motel:Update(n)
    if n % 3 ~= 0 then return end
    -- XXX save village's position somewhere so we don't have to do this
    local x,y,z = GetUnitBasePosition(self:GetUnitID())
    local nearbyUnits = GetUnitsInSphere(x,y,z,self:GetRadius(), self:GetTeamID())
    local myUnitID = self:GetUnitID()
    local hpBonus = self:GetHPBonus()
    for _, unitID in pairs(nearbyUnits) do
        if unitID ~= myUnitID then
            SetUnitHealth(unitID, GetUnitHealth(unitID) + hpBonus)
        end
    end
end

------------------------------------------------------------
-- HIGH RISE
------------------------------------------------------------

HighRise = Building:Inherit{
    classname = "HighRise",
    buildingName = "High Rise",
    buildTime = 150,
    hpBonus = 500,
    supplyCapBonus = 200,
    tooltip = "Provides a 500 HP bonus and increases villager cap",
}

function HighRise:GetHPBonus() return self.hpBonus end
function HighRise:GetSupplyCapBonus() return self.supplyCapBonus end

function HighRise:Apply()
    local unitID = self:GetUnitID()
    local hpBonus = self:GetHPBonus()
    local health, maxHealth = GetUnitHealth(unitID)
    Spring.SetUnitMaxHealth(unitID, maxHealth + hpBonus)
    Spring.SetUnitHealth(unitID, health + hpBonus)

    local supplyCapBonus = self:GetSupplyCapBonus()
    local village = self:GetVillage()
    village:SetSupplyCap(village:GetSupplyCap() + supplyCapBonus)
end

function HighRise:Unapply(oldTeam)
    local unitID = self:GetUnitID()
    local hpBonus = self:GetHPBonus()
    local health, maxHealth = GetUnitHealth(unitID)
    Spring.SetUnitMaxHealth(unitID, maxHealth - hpBonus)
    Spring.SetUnitHealth(unitID, health - hpBonus)

    local supplyCapBonus = self:GetSupplyCapBonus()
    local village = self:GetVillage()
    village:SetSupplyCap(village:GetSupplyCap() - supplyCapBonus)
end

------------------------------------------------------------
-- UPGRADES
------------------------------------------------------------

Upgrade = Object:Inherit{
    classname  = "Upgrade",
    upgradeName = "",
    upgradeType = "",
    cmdType = CMD.ICON,
    researchTime = 1,
    building = nil,
    tooltip = "",
    multipliers = {},
}

function Upgrade:New(building)
    local obj = Upgrade.inherited.New(self, {building=building})
    return obj
end

function Upgrade:GetType() return self.upgradeType end
function Upgrade:GetMultipliers() return self.multipliers end
function Upgrade:GetResearchTime() return self.researchTime end
function Upgrade:GetTooltip() return self.tooltip end
function Upgrade:GetName() return self.upgradeName end
function Upgrade:GetCmdType() return self.cmdType end
function Upgrade:GetBuilding() return self.building end
function Upgrade:GetVillage() return self:GetBuilding():GetVillage() end
function Upgrade:GetUnitID() return self:GetBuilding():GetUnitID() end
function Upgrade:GetTeamID() return self:GetBuilding():GetTeamID() end

function Upgrade:GetKey()
    return self:GetType():upper():gsub(' ', '_')
end

function Upgrade:GetCmdID() 
    return self.cmdID or Buildings.CMD_IDS.RESEARCH[self:GetKey()]
end

function Upgrade:GetCmdDesc()
    local name = self:GetName()
    return {
        id = self:GetCmdID(),
        name = "Research " .. name .. " Upgrade",
        action = "researching_" .. name,
        type = self.cmdType,
        tooltip = self:GetTooltip(),
        params = {},
    }
end

function Upgrade:Research()
    local village = self:GetVillage()
    if village:IsBusy() then return end
    village:SetBusy(true)
    local function _done()
        self:Apply()
        self:GetBuilding():AddResearchUpgrade(self)
        village:SetBusy(false)
    end
    local function _cancelled() self:SetBusy(false) end
    GG.ProgressBars.AddProgressBar(self:GetUnitID(), "Researching " .. self:GetName() .. "...", 
                                   self:GetResearchTime(), _done, _cancelled)
end

function Upgrade:Apply() 
    local am = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager()
    for key, multiplier in pairs(self:GetMultipliers()) do
        local value, classes = unpack(multiplier)
        am:AddMultiplier(key, value, classes)
    end
end

function Upgrade:Unapply() 
    local am = _G.TeamManagers[self:GetTeamID()]:GetAttributeManager()
    for key, multiplier in pairs(self:GetMultipliers()) do
        local value, classes = unpack(multiplier)
        am:AddMultiplier(key, value, classes)
    end
end

DamageUpgrade = Upgrade:Inherit{
    classname = "DamageUpgrade",
    upgradeName = "Battleswords",
    upgradeType = "DAMAGE",
    tooltip = "Increases damage for infantry units",
    researchTime = 120,
    multipliers = {
        [Multipliers.TYPES.DAMAGE] = {.2, {Units.CLASSES.INFANTRY}},
    }
}

AttackRangeUpgrade = Upgrade:Inherit{
    classname = "AttackRangeUpgrade",
    upgradeName = "Long range arrows",
    upgradeType = "ATTACK_RANGE",
    tooltip = "Increases attack range for ranged units",
    researchTime = 120,
    multipliers = {
        [Multipliers.TYPES.ATTACK_RANGE] = {.5, {Units.CLASSES.RANGED}},
    }
}

AttackSpeedUpgrade = Upgrade:Inherit{
    classname = "AttackSpeedUpgrade",
    upgradeName = "Quick swords",
    upgradeType = "ATTACK_SPEED",
    researchTime = 120,
    tooltip = "Increases attack speed for cavalry units",
    multipliers = {
        [Multipliers.TYPES.ATTACK_SPEED] = {.5, {Units.CLASSES.CAVALRY}},
    }
}
------------------------------------------------------------
-- TRAINING FACILITY
------------------------------------------------------------

TrainingFacility = Building:Inherit{
    classname = "TrainingFacility",
    buildingName = "Training Facility",
    buildTime = 45,
    tooltip = "Opens research possibilities for unit upgrades",
}

function TrainingFacility:New(village)
    local obj = TrainingFacility.inherited.New(self, village)
    obj.availableUpgrades = {
        [DamageUpgrade:GetCmdID()] = DamageUpgrade:New(obj),
        [AttackRangeUpgrade:GetCmdID()] = AttackRangeUpgrade:New(obj),
        [AttackSpeedUpgrade:GetCmdID()] = AttackSpeedUpgrade:New(obj),
    }
    return obj
end
function TrainingFacility:GetAvailableUpgrades() return self.availableUpgrades end

function TrainingFacility:GetCmds()
    local cmds = {}
    for cmdID, upgrade in pairs(self:GetAvailableUpgrades()) do
        cmds[cmdID] = {upgrade.Research, {upgrade}}
    end
    return cmds
end

function TrainingFacility:Apply()
    local unitID = self:GetUnitID()
    for cmdID, upgrade in pairs(self:GetAvailableUpgrades()) do
        Spring.InsertUnitCmdDesc(unitID, cmdID, upgrade:GetCmdDesc())
    end
end

function TrainingFacility:Unapply(oldTeam)
    local unitID = self:GetUnitID()
    for cmdID, upgrade in pairs(self:GetAvailableUpgrades()) do
        Spring.RemoveUnitCmdDesc(unitID, cmdID)
    end
end
