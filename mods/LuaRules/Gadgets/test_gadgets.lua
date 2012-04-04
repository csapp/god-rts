
function gadget:GetInfo()
    return {
        name = "Test runner",
        desc = "Gadget to run 'unit tests' in game",
        author = "cam",
        date = "2012-04-03",
        license = "Public Domain",
        layer = math.huge,
        enabled = false,
    }
end

if (not gadgetHandler:IsSyncedCode()) then
    return false
end

function gadget:GameStart()
    local testrunner = VFS.Include("LuaRules/Tests/testsuite.lua")
    testrunner()
end

