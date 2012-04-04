include("LuaRules/Classes/object.lua")

UnitTest = Object:Inherit{
    classname = "UnitTest",
}

function UnitTest:Setup()
end

function UnitTest:Teardown()
end

function UnitTest:Run()
    local err, result
    local passes = 0
    local fails = 0
    for k,v in pairs(self) do
        if type(v) == "function" and k:lower():sub(1, 4) == "test" then
            self:Setup()
            err, result = pcall(v)
            if err then
                Spring.Echo(self.classname.."::"..k..": PASS")
                passes = passes + 1
            else
                Spring.Echo(self.classname.."::"..k..": FAIL. "..result)
                fails = fails + 1
            end
            self:Teardown()
        end
    end
    return passes, fails
end

