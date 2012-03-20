function gadget:GetInfo()
    return {
        name = "Attribute manager",
        desc = "Gadget to control attribute managers",
        author = "cam",
        date = "2012-02-29",
        license = "Public Domain",
        layer = 0,
        enabled = true,
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (not gadgetHandler:IsSyncedCode()) then
    return false
end

local TeamManagers
local gaiaID = Spring.GetGaiaTeamID()

function gadget:Initialize()
    TeamManagers = _G.TeamManagers
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if unitTeam == gaiaID then return end
    local am = TeamManagers[unitTeam]:GetAttributeManager()
    am:ApplyPersistentMultipliers(unitID)
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                            weaponID, attackerID, attackerDefID, attackerTeam)
    if not attackerID then return damage end
    local am = TeamManagers[attackerTeam]:GetAttributeManager()
    local mult = am:GetDamageMultiplier():GetFromDamage(unitID, attackerID, weaponID)
    return damage*mult
end
