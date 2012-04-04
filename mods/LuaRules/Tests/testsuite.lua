
-- FIXME is there a better way to do this?
-- Maybe with fancy module() stuff like lunit does?
--
local TEST_DIR = "LuaRules/Tests/"
local TESTS = {
    "test_manager.lua",
    "test_supplymgr.lua",
}

local function RunTestSuite()
    local unittest, p, f
    local passes = 0
    local fails = 0
    for i,v in ipairs(TESTS) do
        unittest = VFS.Include(TEST_DIR..v)
        p, f = unittest:Run()
        passes = passes + p
        fails = fails + f
    end
    Spring.Echo((passes+fails).." tests run.")
    Spring.Echo(passes.." passed. "..fails.." failed.")
end

return RunTestSuite
