function widget:GetInfo()
	return {
		name		= "DrawCircle",
		desc		= "Draw circle on map based on mouse position.",
		author		= "Mani",
		date		= "2012-03-12",
		license     = "GNU GPL v2",
		layer		= 1,
		enabled   	= true,
	}
end

local GetMyTeamID = Spring.GetMyTeamID

include("Headers/utilities.lua")
include("customcmds.h.lua")

local radius = 0
local circleOn = false
local circleCmds = {CMD_BFB, CMD_LOVE, CMD_POSSESSION}

local function SetRadius(r_as_string)
    radius = tonumber(r_as_string)
end

function widget:GameFrame(n) 
	local index, cmdID = Spring.GetActiveCommand()
	--if cmdID == CMD_BFB then
    if table.contains(circleCmds, cmdID) then
        if not circleOn then 
            local q = "_G.TeamManagers["..GetMyTeamID().."]:GetPowerManager():GetElement("..cmdID.."):GetRadius()"
            WG.GadgetQuery.QueryGadgetState(q, SetRadius)
            circleOn = true
        end
	else
        circleOn = false
        radius = 0
	end
end

function getMouseCursorLocation()
	local x, y = Spring.GetMouseState()
	local _, pos = Spring.TraceScreenRay(x,y,true)
	if (pos ~= nil) then
		return pos[1], pos[3]
	end
end

function widget:DrawWorld()
	if circleOn then
		local mouseX, mouseZ = getMouseCursorLocation()
		if (mouseX ~= nil and mouseZ ~= nil) then
			gl.DrawGroundCircle(mouseX,0, mouseZ, radius, 100)
		end
	end
end
