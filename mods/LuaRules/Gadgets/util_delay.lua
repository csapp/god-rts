
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

local function DelayCall(f, args)
    table.insert(delayed_calls, {f, args})
end

GG.Delay.DelayCall = DelayCall

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

function gadget:GameFrame(n)
    if n % 30 ~= 0 then return end
    for i, delayed_call in ipairs(delayed_calls) do
        f, args = delayed_call[1], delayed_call[2]
        f(unpack(args))
        delayed_calls[i] = nil
    end
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
return false

end
