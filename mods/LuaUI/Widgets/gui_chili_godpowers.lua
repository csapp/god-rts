
function widget:GetInfo()
    return {
        name = "God powers",
        desc = "Displays the God power charges",
        author = "cam",
        date = "2011-06-15",
        license = "GNU GPL v2",
        layer = math.huge,
        enabled = true,
        handler = true,
    }
end

-- INCLUDES
include("managers.h.lua")
include("customcmds.h.lua")
include("msgs.h.lua")

-- speed ups
local GetMyTeamID = Spring.GetMyTeamID

local Chili
local window
local noPowerLabel
local MY_PLAYER_ID = Spring.GetMyPlayerID()

local powerBars = {}
local powerImages = {}
local imageDir = "bitmaps/icons/powers/"
local CMD_ICON_MAP = {
    [CMD_VOLCANIC_BLAST] = imageDir.."volcanic_blast.png",
    [CMD_ZOMBIE] = imageDir.."zombie_apocalypse.png",
	[CMD_BFB] = imageDir.."bfb.png",
	[CMD_TELEPORT] = imageDir.."teleport.png",
	[CMD_LOVE] = imageDir.."heart.png",
	[CMD_POSSESSION] = imageDir.."possession.png",
}

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    Chili = WG.Chili
    local screen0 = Chili.Screen0
    local screenw, screenh = Spring.GetWindowGeometry()
    local winh = 100
    local winw = 350

    window = Chili.Window:New{
        parent = screen0,
        y = screenh-250-winh,
        height = winh,
        width = winw,
        right = 0,
        draggable = true,
        resizable = false,
        dragUseGrip = true,        
        children = {},
    }

    noPowerLabel = Chili.Label:New{
        parent = window,
        y="40%",
        x=winw*0.2,
        fontsize = 14,
        caption = "No God powers selected yet.",
    }

end

local function PopulatePowerWindow(initialCharges)
    local function p(a) return tostring(a).."%" end

    local bars = 2
    local barwidth = "85%"
    local barheight = p(80/bars)
    local count = 0
    local y
    for k, charge in pairs(initialCharges) do
        y = p(100/bars*count+5)
        powerImages[k] = Chili.Image:New{
            parent = window,
            width = 25,
            height = 25,
            x = 40,
            y = y,
            file = CMD_ICON_MAP[k],
        }

        powerBars[k] = Chili.DynamicProgressbar:New{
            parent = window,
            height = barheight,
            value  = 100,
            width = barwidth,
            right  = 40,
            x      = 100,
            value = math.floor((tonumber(charge) or 1)*100),
            y = y,
            font   = {color = {1,1,1,1}, outlineColor = {0,0,0,0.7}, },
        }

        powerBars[k]:SetCaption("100%")
        count = count + 1
    end
end

local function UpdatePowerBar(id, value)
    powerBars[id]:SetValue(value)
    powerBars[id]:SetCaption(math.floor(value).."%")
end

local function QueryPowerCharge(id)
    WG.GadgetQuery.CallManagerElementFunction(
       function(value) UpdatePowerBar(id, tonumber(value)*100) end,
       Managers.TYPES.POWER, id, "GetCharge")
end

function widget:GameFrame(n)
    if n % 30 ~= 13 then return end
    for id, bar in pairs(powerBars) do
        if bar.value < 100 then
            QueryPowerCharge(id)
        end
    end
end

function widget:RecvLuaMsg(msg, playerID)
    if playerID ~= MY_PLAYER_ID then return end
    local msg_type, params = LuaMessages.deserialize(msg)
    if msg_type == MSG_TYPES.GOD_CREATED and Spring.GetUnitTeam(params[1]) == Spring.GetLocalTeamID() then
        window:RemoveChild(noPowerLabel)
        WG.GadgetQuery.CallManagerFunctionOnAll(
                PopulatePowerWindow, Managers.TYPES.POWER, "GetCharge")
    elseif msg_type == MSG_TYPES.GOD_POWER_USED then
        powerID, teamID = tonumber(params[1]), tonumber(params[2])
        if teamID == GetMyTeamID() then
            QueryPowerCharge(powerID)
        end
    end
end

function widget:Shutdown()
    window:Dispose()
end
