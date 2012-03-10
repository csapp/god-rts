local body = piece "body"
local head = piece "head"
local larm = piece "leftarm"
local rarm = piece "rightarm"
local lleg = piece "leftleg"
local rleg = piece "rightleg"

-- declares all the pieces we'll use in the script.

local SIG_WALK = 1	--signal for the walk animation thread
local SIG_AIM = 2  --signal for the weapon aiming thread
local pi = 3.1415
local leg_movespeed = 1
local leg_movedistance = 3
local arm_turndistance = pi/8
local arm_movespeed = 1
local spawnmovespeed = 10
local spawnturnspeed = 3
local attacking = false
local atkAnimCounter = 0


local RESTORE_DELAY = Spring.UnitScript.GetLongestReloadTime(unitID) * 2
-- picks a sensible time to wait before trying to turn the turret back to default.

---WALKING---
local function walk()
	Signal(SIG_WALK)
	SetSignalMask(SIG_WALK)
	while (true) do
		--left leg up, right leg down
		Turn (rleg, x_axis, pi/8, leg_movespeed)
		Turn (lleg, x_axis, -pi/8, leg_movespeed)
		Turn (rarm, x_axis, -pi/2+arm_turndistance, arm_movespeed)
		Turn (larm, x_axis, -pi/2-arm_turndistance, arm_movespeed)
		WaitForTurn (lleg, x_axis)
		WaitForTurn (rarm, x_axis)
		WaitForTurn (larm, x_axis)
		Sleep (50)
		--left leg down, right leg up
		Turn (rleg, x_axis, pi/16, leg_movespeed)
		Turn (lleg, x_axis, 0, leg_movespeed)
		Turn (rarm, x_axis, -pi/2-arm_turndistance, arm_movespeed)
		Turn (larm, x_axis, -pi/2+arm_turndistance, arm_movespeed)
		WaitForTurn (lleg, x_axis)
		WaitForTurn (rarm, x_axis)
		WaitForTurn (larm, x_axis)
		Sleep (50)
	end
end

local function hideBody()
	Hide(body)
	Hide(head)
	Hide(larm)
	Hide(rarm)
	Hide(lleg)
	Hide(rleg)
end

local function showBody()
	Show(body)
	Show(head)
	Show(larm)
	Show(rarm)
	Show(lleg)
	Show(rleg)
end	

function script.Create()
	hideBody()
	Move(body, y_axis, -50, 100)	--spawn underground
	WaitForMove(body, y_axis)
	showBody()
	Turn (larm, x_axis, -pi, 100)	--move arm upward
	Move (body, y_axis, -17, spawnmovespeed)	--move body up
	WaitForMove(body, y_axis)
	Turn (larm, x_axis, -pi/2, spawnturnspeed)	--tilt leftarm to ground level
	Turn (rarm, x_axis, -pi/2, spawnturnspeed)	--tilt rightarm to ground level
	--WaitForTurn(larm, x_axis)
	WaitForTurn(rarm, x_axis)
	Turn (larm, x_axis, 0, spawnturnspeed)	--tilt leftarm to ground level
	Turn (rarm, x_axis, 0, spawnturnspeed)	--tilt rightarm to ground level
	--WaitForTurn(larm, x_axis)
	WaitForTurn(rarm, x_axis)
	Move (body, y_axis, 0, spawnmovespeed)
	Turn (larm, x_axis, -pi/2, spawnturnspeed)	--tilt leftarm to front of body
	Turn (rarm, x_axis, -pi/2, spawnturnspeed)	--tilt rightarm to from of body
	
	WaitForTurn(larm, x_axis)
	WaitForTurn(rarm, x_axis)
	WaitForMove(body, y_axis)
    return 0
end

local function legs_down ()
	Turn (lleg, x_axis, 0, leg_movespeed)
	Turn (rleg, x_axis, pi/8, leg_movespeed)
end

local function arms_down ()
	Turn (rarm, x_axis, -pi/2, arm_movespeed)
	Turn (larm, x_axis, -pi/2, arm_movespeed)
end

function script.StartMoving()
--    Spring.Echo ("starting to walk!")
	StartThread (walk)
end

function script.StopMoving()
--    Spring.Echo ("stopped walking!")
		Signal(SIG_WALK)
		legs_down ()
		arms_down ()
end


function script.QueryWeapon1 ()
	return rarm
end


function script.AimFromWeapon1()
	return body
end

function script.AimWeapon1(heading, pitch)
	Sleep(50)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	return true
end

function script.Shot1()
	StartThread(MeleeAnimations)
end

function MeleeAnimations()
			Turn (rarm, x_axis, -((3*pi)/4), arm_movespeed)
			Turn (larm, x_axis, -pi/4, arm_movespeed)
			WaitForTurn (rarm, x_axis)
			WaitForTurn (larm, x_axis)
			Sleep(50)
			Turn (rarm, x_axis, -pi/4, arm_movespeed)
			Turn (larm, x_axis, -((3*pi)/4), arm_movespeed)
			WaitForTurn (rarm, x_axis)
			WaitForTurn (larm, x_axis)
			Sleep(50)
	return(1)
end
	
function script.Killed(damage, health)
	
	Turn (body, x_axis, -pi/2, arm_movespeed)
	Move (body, y_axis, -30, leg_movespeed)
	Sleep(1000)
	return(1)
end	
	