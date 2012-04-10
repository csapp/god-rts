
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

local Chili
local window
local noPowerLabel
local MY_PLAYER_ID = Spring.GetMyPlayerID()
local powerNames = {}

local powerBars = {}
local powerImages = {}
local imageDir = "bitmaps/icons/powers/"
local CMD_ICON_MAP = {
    [CMD_VOLCANIC_BLAST] = imageDir.."volcanic_blast.png",
    [CMD_TELEPORT] = imageDir.."teleport.png",
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

local function PopulatePowerWindow()
    local function p(a) return tostring(a).."%" end

    local bars = 2
    local barwidth = "85%"
    local barheight = p(80/bars)
    local count = 0
    local y
    for k,_ in pairs(powerNames) do
        y = p(100/bars*count+5)
        powerImages[k] = Chili.Image:New{
            parent = window,
            --width = barheight,
            --height = barheight,
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
            y = y,
            font   = {color = {1,1,1,1}, outlineColor = {0,0,0,0.7}, },
        }

        powerBars[k]:SetCaption("100%")
        count = count + 1
    end
end

local function getPowerNames()
    local function getNames(names) 
        for k,v in pairs(names) do
            powerNames[tonumber(k)]=v
        end
        PopulatePowerWindow()
    end
	WG.GadgetQuery.CallManagerFunctionOnAll(getNames, Managers.TYPES.POWER, "GetName")
end

function widget:RecvLuaMsg(msg, playerID)
    if playerID ~= MY_PLAYER_ID then return end
    local msg_type, params = LuaMessages.deserialize(msg)
    if msg_type == MSG_TYPES.GOD_CREATED then
        window:RemoveChild(noPowerLabel)
        getPowerNames()
    end
end

function widget:Shutdown()
    window:Dispose()
end
