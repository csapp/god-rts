function widget:GetInfo()
  return {
    name      = "Chili Clergy Convert Bars",
    desc      = "",
    author    = "Mani",
    date      = "2012",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    experimental = false,
    enabled   = true
  }
end
-- XXX we need one location for these message constants
include("msgs.h.lua")
local clergyID, villageID, convertProgress = 0,0,0
local msg_type = ""
local window 
local bar_convert


function createBar()

	local bars = 2
	local function p(a)
        return tostring(a).."%"
    end
	
	window = Chili.Window:New{
                color = {1,1,1,1},
                parent = Chili.Screen0,
                dockable = true,
                name="Conversion Bars",
                padding = {0,0,0,0},
                right = 0,
                y = 0,
                clientWidth  = 100,
                clientHeight = 10,
                draggable = true,
                resizable = false,
                tweakDraggable = true,
                tweakResizable = true,
        minimizable = false,
        }
	
	bar_convert = Chili.Progressbar:New{
                parent = window,
                color  = {0,0,1,1},
                height = p(100/bars),
                right  = 0,
				min = 0,
				max = 100,
                x      = 0,
                y      = p(100/bars),
				value = convertProgress,
                tooltip = "This shows your current conversion progress.",
                font   = {color = {1,1,1,1}, outlineColor = {0,0,0,0.7}, },
        }
	
	lbl_convert = Chili.Label:New{
		parent = window,
		height = p(100/bars),
		right  = 26,
		width  = 40,
        x      = 0,
		caption = "Converting...",
		valign  = "center",
		align   = "center",
		autosize = false,
		font   = {size = 12, outline = true, color = {0,1,0,1}},
		tooltip = "Amount of time until conversion is complete.",
	}
		
end

function destroyBar()
	window:Dispose()
	window = nil
end

function widget:Initialize()
	Chili = WG.Chili	
end



function widget:Update(dt)
	if msg_type == MSG_TYPES.CONVERT_PROGRESS then
		bar_convert:SetValue(tonumber(convertProgress)*100)
	end
end


function widget:RecvLuaMsg(msg, playerID)
    msg = LuaMessages.deserialize(msg)
    msg_type = msg[1]
    if msg_type == MSG_TYPES.CONVERT_PROGRESS then
        clergyID, villageID, convertProgress = msg[2], msg[3], msg[4]
    elseif msg_type == MSG_TYPES.CONVERT_STARTED then
        clergyID, villageID = msg[2], msg[3]
		createBar()
    elseif msg_type == MSG_TYPES.CONVERT_FINISHED then
        clergyID, villageID = msg[2], msg[3]
		destroyBar()
    elseif msg_type == MSG_TYPES.CONVERT_CANCELLED then
        clergyID, villageID = msg[2], msg[3]
		destroyBar()
    end
end