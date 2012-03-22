local function GetInfo()
    return {
        name = "Power Manager",
        desc = "Manager to keep track of god powers",
        tickets = "#112",
        author = "cam",
        date = "2012-03-21",
        license = "Public Domain",
    }
end

PowerManager = Manager:Inherit{
    classname = "PowerManager",
}

local this = PowerManager
local inherited = this.inherited

