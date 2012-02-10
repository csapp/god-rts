
function gadget:GetInfo()
    return {
        name = "Village spawner",
        desc = "Spawns neutral villages on the map at game start",
        tickets = "#15",
        author = "cam",
        date = "Feb 9, 2012",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (not gadgetHandler:IsSyncedCode()) then
    return false
end

function gadget:Initialize()

    local mapcfg = VFS.Include("mapinfo.lua")
    if (not mapcfg) or (not mapcfg.custom) or (not mapcfg.custom.villages) then
        error("Village spawner gadget: Can't find village locations in mapinfo.lua!")
        gadgetHandler:RemoveGadget()
        return
    end

    local CreateUnit = Spring.CreateUnit
    local GetGroundHeight = Spring.GetGroundHeight
    local gaiaTeamID = Spring.GetGaiaTeamID()
    for _, village in pairs(mapcfg.custom.villages) do
        CreateUnit(village.vtype, village.x, GetGroundHeight(village.x, village.z),
                   village.z, 0, gaiaTeamID)
    end
    gadgetHandler:RemoveGadget()
end
