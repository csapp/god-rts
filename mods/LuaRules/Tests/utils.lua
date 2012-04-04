include("LuaUI/Headers/utilities.lua")

function assert_equal(expected, actual, msg)
    status, results = pcall(assert, expected==actual)
    if not status then
        error(msg or "Assertion failed! expected="..utils.to_string(expected)..
              ", actual="..utils.to_string(actual), 2)
    else
        return results
    end
end
