local body = piece "body"
local head = piece "head"
local larm = piece "leftarm"
local rarm = piece "rightarm"
local lleg = piece "leftleg"
local rleg = piece "rightleg"

-- declares all the pieces we'll use in the script.

local SIG_WALK = 1	--signal for the walk animation thread
local SIG_AIM = 2  --signal for the weapon aiming thread
local leg_movespeed = 10
local leg_movedistance = 5
local arm_turndistance = 0.5
local arm_movespeed = 3
local attacking = false
--local atkAnimCounter = 0
local pi = 3.1415
local chosenWeapon

local RESTORE_DELAY = Spring.UnitScript.GetLongestReloadTime(unitID) * 2
-- picks a sensible time to wait before trying to turn the turret back to default.


function script.Changeweapon(weaponDef)
	Spring.Echo("Changeweapon was called")
	if weaponDef == "ARM" then 
		chosenWeapon = "ARM"
	elseif weaponDef == "VOLCANIC_BLAST" then
		chosenWeapon = "VOLCANIC_BLAST"
	end
end
---WALKING---
local function walk()
	Signal(SIG_WALK)
	SetSignalMask(SIG_WALK)
	while (true) do
		--left leg up, right leg down
		Move (lleg, y_axis, leg_movedistance, leg_movespeed)
		Turn (rarm, x_axis, arm_turndistance, arm_movespeed)
		Move (rleg, y_axis, 0, leg_movespeed)
		Turn (larm, x_axis, -arm_turndistance, arm_movespeed)
		WaitForMove (lleg, y_axis)
		WaitForTurn (rarm, x_axis)
		WaitForMove (lleg, y_axis)	
		WaitForTurn (larm, x_axis)
		Sleep (50)
		--left leg down, right leg up
		Move (lleg, y_axis, 0, leg_movespeed)
		Turn (rarm, x_axis, -arm_turndistance, arm_movespeed)
		Move (rleg, y_axis, leg_movedistance, leg_movespeed)
		Turn (larm, x_axis, arm_turndistance, arm_movespeed)
		WaitForMove (lleg, y_axis)
		WaitForTurn (rarm, x_axis)
		WaitForMove (lleg, y_axis)
		WaitForTurn (larm, x_axis)
		Sleep (50)
	end
end


function script.Create()
	chosenWeapon = "ARM"
    return 0
end

local function legs_down ()
	Move (lleg, y_axis, 0, leg_movespeed)
	Move (rleg, y_axis, 0, leg_movespeed)
end

local function arms_down ()
	Turn (rarm, x_axis, 0, 3)
	Turn (larm, x_axis, 0, 3)
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

--- Weapon 1 ---
function script.QueryWeapon1 ()
	return rarm
end


function script.AimFromWeapon1()
	return body
end

function script.AimWeapon1(heading, pitch)
	Spring.Echo("ARM AIMING")
	if chosenWeapon ~= "ARM" then
		return false
	end
	Spring.Echo("Aiming with weapon 1")
	Sleep(50)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	return true
end

function script.Shot1()
	attacking = true
	StartThread(MeleeAnimations)
end

function MeleeAnimations()
	if attacking then
		--vertical slash
			Turn (rarm, x_axis, -pi, arm_movespeed)
			WaitForTurn (rarm, x_axis)
			Sleep(50)
			Turn (rarm, x_axis, 0, arm_movespeed)
			WaitForTurn (rarm, x_axis)
			Sleep(50)
	end
	
	Sleep(300)	
	attacking=false
	return(1)
end

--- Weapon 2 ---

function script.QueryWeapon2()
	return rarm
end
	
function script.AimFromWeapon2()
	return body
end

function script.AimWeapon2(heading, pitch)
	Spring.Echo("VOLCANIC BLAST AIMING")
	if chosenWeapon ~= "VOLCANIC_BLAST" then
		return false
	end
	Spring.Echo("Aiming with weapon 2")
	Sleep(50)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	return true
end

function script.Shot2()
	attacking = true
	StartThread(MeleeAnimations)
end

---------------

	
function script.Killed(damage, health)
	
	Turn (body, x_axis, -pi/2, arm_movespeed)
	Move (body, y_axis, -30, leg_movespeed)
	Sleep(1000)
	return(1)
end	
	