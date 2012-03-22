local function GetInfo()
    return {
        name = "Village Manager",
        desc = "Manager to keep track of custom village units",
        tickets = "#162",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

VillageManager = Manager:Inherit{
    classname = "VillageManager",
}

local this = VillageManager
local inherited = this.inherited

