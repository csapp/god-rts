local function GetInfo()
    return {
        name = "Base power",
        desc = "Base class from which all god powers are derived",
        tickets = "#112",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end


-- Power functions are synced code
include("LuaUI/Headers/customcmds.h.lua")

POWERS = {
    TYPES = {
        OFFENSIVE = "Offensive",
        DEFENSIVE = "Defensive",
        PASSIVE = "Passive",
    },
    FULL_CHARGE = 1,
}

Power = Object:Inherit{
    classname = "Power",
    id = 0,
    powerName = "",
    powerType = "",
    teamID = -1,
    godID = -1,
}

local this = Power
local inherited = this.inherited

function Power:New(teamID)
    obj = inherited.New(self, {teamID=teamID})
    return obj
end

function Power:SetUp()
    -- Sets up any class stuff
end

function Power:Initialize()
    -- Initializes any object stuff
end

function Power:GetID() return self.id end
function Power:GetName() return self.powerName end
function Power:GetType() return self.powerType end

function Power:GetTeamID()
    return self.teamID
end

function Power:GetGodID()
    return self.godID
end

function Power:SetGodID(id)
    self.godID = id
end

--function Power:Use()
--end
