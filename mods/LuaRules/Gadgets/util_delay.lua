
function gadget:GetInfo()
    return {
        name = "Delay",
        desc = "Gadget to handle call delays",
        author = "cam",
        date = "2012-02-12",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

GG.Delay = {}
local delayed_calls = {}

local function CallLater(time, f, args)
    table.insert(delayed_calls, {time, f, args})
end

local function DelayCall(f, args)
    CallLater(1, f, args)
end

GG.Delay.DelayCall = DelayCall
GG.Delay.CallLater = CallLater

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

function gadget:GameFrame(n)
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

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
return false

end
