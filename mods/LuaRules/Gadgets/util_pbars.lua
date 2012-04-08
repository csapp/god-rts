
function gadget:GetInfo()
    return {
        name = "Progress bars",
        desc = "Gadget to handle progress bars",
        author = "cam",
        date = "2012-02-12",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

------------------------------------------------------------
-- SYNCED
------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then

local progress_bars = {}
include("LuaUI/Headers/msgs.h.lua")

local GetGameSeconds = Spring.GetGameSeconds
local GetUnitTeam = Spring.GetUnitTeam

GG.ProgressBars = {}

local function AddProgressBar(unitID, caption, duration, callback, cancel_callback)
    progress_bars[unitID] = {GetGameSeconds(), duration, callback, cancel_callback}
    LuaMessages.SendLuaUIMsg(MSG_TYPES.PBAR_CREATE, {unitID, GetUnitTeam(unitID), caption, duration})
end

local function CancelProgressBar(unitID)
    LuaMessages.SendLuaUIMsg(MSG_TYPES.PBAR_DESTROY, {unitID})
    local callback = progress_bars[unitID][4]
    if callback then callback(unitID) end
    progress_bars[unitID] = nil
end

GG.ProgressBars.AddProgressBar = AddProgressBar
GG.ProgressBars.CancelProgressBar = CancelProgressBar

local function FinishProgressBar(unitID)
    local callback = progress_bars[unitID][3]
    if callback then 
        callback(unitID)
    end
    progress_bars[unitID] = nil
end

function gadget:RecvLuaMsg(msg, playerID)
    msgtype, params = LuaMessages.deserialize(msg)
    if msgtype == MSG_TYPES.PBAR_FINISHED then
        unitID = tonumber(params[1])
        GG.Delay.DelayCall(FinishProgressBar, {unitID})
    end
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
return false

end
