
function widget:GetInfo()
    return {
        name = "Delay",
        desc = "widget to handle call delays",
        author = "cam",
        date = "2012-02-12",
        license = "Public Domain",
        layer = -math.huge,
        enabled = true
    }
end

WG.Delay = {}
local delayed_calls = {}

local function CallLater(time, f, args)
    args = args or {}
    table.insert(delayed_calls, {time, f, args})
end

local function DelayCall(f, args)
    CallLater(1, f, args)
end

WG.Delay.DelayCall = DelayCall
WG.Delay.CallLater = CallLater

function widget:GameFrame(n)
    if n % 30 ~= 10 then return end
    for i, delayed_call in ipairs(delayed_calls) do
        time, f, args = unpack(delayed_call)
        time = time - 1
        if time == 0 then
            f(unpack(args))
            table.remove(delayed_calls, i)
        else
            delayed_call[1] = time
        end
    end
end
