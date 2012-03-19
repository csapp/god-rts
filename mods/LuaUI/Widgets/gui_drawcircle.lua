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

include("customcmds.h.lua")

local drawState = false

function widget:GameFrame(n) 
	local index, cmdID = Spring.GetActiveCommand()
	if cmdID == CMD_BFB then 
		drawState = true
	else
		drawState = false
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
	if drawState == true then
		local mouseX, mouseZ = getMouseCursorLocation()
		if (mouseX ~= nil and mouseZ ~= nil) then
			gl.DrawGroundCircle(mouseX,0, mouseZ, 200, 100)
		end
	end
end