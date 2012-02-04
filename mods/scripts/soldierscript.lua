local body = piece "body"
local head = piece "head"
local larm = piece "leftarm"
local rarm = piece "rightarm"
local lleg = piece "leftleg"
local rleg = piece "rightleg"
local sword = piece "sword"

-- declares all the pieces we'll use in the script.

local SIG_WALK = 1	--signal for the walk animation thread
local SIG_AIM = 2  --signal for the weapon aiming thread
local leg_movespeed = 20
local leg_movedistance = 1


local RESTORE_DELAY = Spring.UnitScript.GetLongestReloadTime(unitID) * 2
-- picks a sensible time to wait before trying to turn the turret back to default.

---WALKING---
local function walk()
	Signal(SIG_WALK)
	SetSignalMask(SIG_WALK)
	while (true) do
		--left leg up, right leg down
		Move (lleg, y_axis, leg_movedistance, leg_movespeed)
		Move (rleg, y_axis, 0, leg_movespeed)
		WaitForMove (lleg, y_axis)
		WaitForMove (lleg, y_axis)	
		Sleep (50)
		--left leg down, right leg up
		Move (lleg, y_axis, 0, leg_movespeed)
		Move (rleg, y_axis, leg_movedistance, leg_movespeed)
		WaitForMove (lleg, y_axis)
		WaitForMove (lleg, y_axis)
		Sleep (50)
	end
end


function script.Create()
    return 0
end

local function legs_down ()
	Move (lleg, y_axis, 0, leg_movespeed)
	Move (rleg, y_axis, 0, leg_movespeed)
end

function script.StartMoving()
--    Spring.Echo ("starting to walk!")
	StartThread (walk)
end

function script.StopMoving()
--    Spring.Echo ("stopped walking!")
		Signal(SIG_WALK)
		legs_down ()
end