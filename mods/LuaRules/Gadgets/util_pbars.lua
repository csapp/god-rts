
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

include("LuaUI/Headers/msgs.h.lua")

local GetGameSeconds = Spring.GetGameSeconds

GG.ProgressBars = {}

local progress_bars = {}

local function AddProgressBar(unitID, caption, duration, callback, cancel_callback)
    progress_bars[unitID] = {GetGameSeconds(), duration, callback, cancel_callback}
    LuaMessages.SendLuaUIMsg(MSG_TYPES.PBAR_CREATE, {unitID, caption})
end

local function UpdateProgressBar(unitID, progress)
    LuaMessages.SendLuaUIMsg(MSG_TYPES.PBAR_PROGRESS, {unitID, progress})
end

local function FinishProgressBar(unitID)
    LuaMessages.SendLuaUIMsg(MSG_TYPES.PBAR_DESTROY, {unitID})
    local callback = progress_bars[unitID][3]
    if callback then callback(unitID) end
    progress_bars[unitID] = nil
end

local function CancelProgressBar(unitID)
    LuaMessages.SendLuaUIMsg(MSG_TYPES.PBAR_DESTROY, {unitID})
    local callback = progress_bars[unitID][4]
    if callback then callback(unitID) end
    progress_bars[unitID] = nil
end

GG.ProgressBars.AddProgressBar = AddProgressBar
GG.ProgressBars.CancelProgressBar = CancelProgressBar

function gadget:GameFrame(n)
    if n % 30 ~= 5 then return end
    local cur_time = GetGameSeconds()
    for unitID, pbar_info in pairs(progress_bars) do
        local start_time, duration = pbar_info[1], pbar_info[2] 
        if cur_time - start_time >= duration then
            FinishProgressBar(unitID)
        else
            UpdateProgressBar(unitID, (cur_time-start_time)/duration)
        end
    end
end

else
------------------------------------------------------------
-- UNSYNCED
------------------------------------------------------------
return false

end
