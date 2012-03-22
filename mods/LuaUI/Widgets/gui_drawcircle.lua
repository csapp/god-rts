function widget:GetInfo()
	return {
		name		= "DrawCircle",
		desc		= "Draw circle on map based on mouse position.",
		author		= "Mani",
        tickets     = "#82",
		date		= "2012-03-12",
		license     = "GNU GPL v2",
		layer		= 1,
		enabled   	= true,
	}
end

local GetMyTeamID = Spring.GetMyTeamID

include("Headers/utilities.lua")
include("customcmds.h.lua")
include("managers.h.lua")

local radius = 0
local circleOn = false
local circleCmds = {CMD_BFB, CMD_LOVE, CMD_POSSESSION}
local currentCmd

function widget:GameFrame(n) 
	local index, cmdID = Spring.GetActiveCommand()
    if currentCmd == cmdID then return end
    currentCmd = cmdID
    if table.contains(circleCmds, cmdID) then
        WG.GadgetQuery.CallManagerElementFunction(
            function (r) radius = r end, 
            Managers.TYPES.POWER, cmdID, "GetRadius")
        circleOn = true
	elseif cmdID == CMD_RESURRECT then	
		--needs special case because resurrect isn't defined 
		--as a god power, can't access radius unless we go through params
		local cmdDesc = Spring.GetActiveCmdDesc(index)
		if cmdDesc ~= nil then
			radius = cmdDesc.params[1]
		end
		circleOn = true
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
