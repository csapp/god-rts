include("LuaRules/Classes/unitcollection.lua")
include("LuaRules/Classes/unitfactory.lua")

local AllUnitCollections = {}

function gadget:GetInfo()
    return {
        name = "Unit handler",
        desc = "Gadget to handle units",
        author = "cam",
        date = "2011-12-22",
        license = "Public Domain",
        layer = -255,
        enabled = true
    }
end

if (not gadgetHandler:IsSyncedCode()) then
  return
end

function gadget:Initialize()
    --AllUnitCollections = {}
    for _, teamID in pairs(Spring.GetTeamList()) do
        AllUnitCollections[teamID] = UnitCollection:new(teamID)
    end
    --_G.AllUnitCollections = AllUnitCollections
end

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
    AllUnitCollections[teamID]:AddUnit(UnitFactory:CreateUnit(unitID, unitDefID, teamID))
    Spring.Echo('unit created')
end

-- An example of how to add XP ... this just adds it after any command is complete
function gadget:UnitCmdDone(unitID, unitDefID, teamID, cmdID, cmdTag)
    AllUnitCollections[teamID].units[unitID]:AddXP(1)
end
