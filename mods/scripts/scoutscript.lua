local body = piece "body"
local head = piece "head"
local larm = piece "leftarm"
local rarm = piece "rightarm"
local lleg = piece "leftleg"
local rleg = piece "rightleg"
local lance = piece "lance"

local hbody = piece "horsebody"
local hflleg = piece "horsefrontleftleg"
local hfrleg = piece "horsefrontrightleg"
local hhead = piece "horsehead"
local hbrleg = piece "horsebackrightleg"
local hblleg = piece "horsebackleftleg"
local hneck = piece "horseneck"
local htail = piece "horsetail"
-- declares all the pieces we'll use in the script.

local SIG_WALK = 1	--signal for the walk animation thread
local SIG_AIM = 2  --signal for the weapon aiming thread
local leg_movespeed = 10
local leg_movedistance = 2
local arm_turndistance = 0.5
local arm_movespeed = 3
local attacking = false
local atkAnimCounter = 0
local pi = 3.1415

local RESTORE_DELAY = Spring.UnitScript.GetLongestReloadTime(unitID) * 2
-- picks a sensible time to wait before trying to turn the turret back to default.

---WALKING---
local function walk()
	Signal(SIG_WALK)
	SetSignalMask(SIG_WALK)
	while (true) do
		--left leg up, right leg down
		--[[Move (hflleg, y_axis, leg_movedistance, leg_movespeed)
		Move (hbrleg, y_axis, leg_movedistance, leg_movespeed)
		Move (hfrleg, y_axis, 0, leg_movespeed)
		Move (hblleg, y_axis, 0, leg_movespeed)
		Move (body, y_axis, leg_movedistance, leg_movespeed)
		Move (hneck, z_axis, 1, leg_movespeed)
		Move (hhead, z_axis, 1, leg_movespeed)
		Turn (rarm, x_axis, 0.5, leg_movespeed)
		Turn (larm, x_axis, 0.5, leg_movespeed)
		
		WaitForMove (hflleg, y_axis)
		WaitForMove (hbrleg, y_axis)
		WaitForMove (hfrleg, y_axis)
		WaitForMove (hblleg, y_axis)
		WaitForMove (body, y_axis)
		WaitForMove (hneck, z_axis)
		WaitForMove (hhead, z_axis)
		WaitForTurn(rarm, x_axis)
		WaitForTurn(larm, x_axis)]]--
		
		Turn (hflleg, x_axis, -pi/8, leg_movespeed)
		Turn (hblleg, x_axis, pi/8, leg_movespeed)
		WaitForTurn(hflleg, x_axis)
		WaitForTurn(hblleg, x_axis)
		Sleep (30)
		
		Move (hneck, z_axis, -1, leg_movespeed)
		Move (hhead, z_axis, -1, leg_movespeed)
		Turn (rarm, x_axis, 0.5, 8)
		Turn (larm, x_axis, 0.5, 8)
		Turn (hbrleg, x_axis, -pi/8, leg_movespeed)
		Turn (hflleg, x_axis, pi/8, leg_movespeed)
		
		WaitForMove (hneck, z_axis)
		WaitForMove (hhead, z_axis)
		WaitForTurn(rarm, x_axis)
		WaitForTurn(larm, x_axis)
		WaitForTurn(hbrleg, x_axis)
		WaitForTurn(hflleg, x_axis)
		Sleep (30)
		
		Turn (hfrleg, x_axis, -pi/8, leg_movespeed)
		Turn (hbrleg, x_axis, pi/8, leg_movespeed)
		WaitForTurn(hfrleg, x_axis)	
		WaitForTurn(hbrleg, x_axis)
		Sleep (30)
		
		Move (hneck, z_axis, 1, leg_movespeed)
		Move (hhead, z_axis, 1, leg_movespeed)
		Turn (rarm, x_axis, 0, 8)
		Turn (larm, x_axis, 0, 8)
		Turn (hblleg, x_axis, -pi/8, leg_movespeed)
		Turn (hfrleg, x_axis, pi/8, leg_movespeed)
		
		WaitForMove (hneck, z_axis)
		WaitForMove (hhead, z_axis)
		WaitForTurn(rarm, x_axis)
		WaitForTurn(larm, x_axis)
		WaitForTurn(hblleg, x_axis)
		WaitForTurn(hfrleg, x_axis)
		Sleep (30)
		

		
		

		
	
		
		--[[Sleep (50)
		
		Turn (hflleg, x_axis, pi/8, leg_movespeed)
		Turn (hbrleg, x_axis, pi/8, leg_movespeed)
		Turn (hfrleg, x_axis, -pi/8, leg_movespeed)
		Turn (hblleg, x_axis, -pi/8, leg_movespeed)
		WaitForTurn(hflleg, x_axis)
		WaitForTurn(hbrleg, x_axis)
		WaitForTurn(hfrleg, x_axis)
		WaitForTurn(hblleg, x_axis)
		--left leg down, right leg up
		Move (hflleg, y_axis, 0, leg_movespeed)
		Move (hbrleg, y_axis, 0, leg_movespeed)
		Move (hfrleg, y_axis, leg_movedistance, leg_movespeed)
		Move (hblleg, y_axis, leg_movedistance, leg_movespeed)
		Move (body, y_axis, 0, leg_movespeed)
		Move (hneck, z_axis, 0, leg_movespeed)
		Move (hhead, z_axis, 0, leg_movespeed)
		Turn (rarm, x_axis, 0, leg_movespeed)
		Turn (larm, x_axis, 0, leg_movespeed)
		
		WaitForMove (hflleg, y_axis)
		WaitForMove (hbrleg, y_axis)
		WaitForMove (hfrleg, y_axis)
		WaitForMove (hblleg, y_axis)
		WaitForMove (body, y_axis)
		WaitForMove (hneck, z_axis)
		WaitForMove (hhead, z_axis)
		WaitForTurn(rarm, x_axis)
		WaitForTurn(larm, x_axis)
		Sleep (50)
		]]--
	end
end


function script.Create()
    return 0
end

local function legs_down ()
		Turn (hflleg, x_axis, 0, leg_movespeed)
		Turn (hbrleg, x_axis, 0, leg_movespeed)
		Turn (hfrleg, x_axis, 0, leg_movespeed)
		Turn (hblleg, x_axis, 0, leg_movespeed)

		Move (hneck, z_axis, 0, leg_movespeed)
		Move (hhead, z_axis, 0, leg_movespeed)
		Turn (rarm, x_axis, 0, 5)
		Turn (larm, x_axis, 0, 5)
		
		--[[Move (body, y_axis, 0, leg_movespeed)
		Move (hflleg, y_axis, 0, leg_movespeed)
		Move (hbrleg, y_axis, 0, leg_movespeed)
		Move (hfrleg, y_axis, 0, leg_movespeed)
		Move (hblleg, y_axis, 0, leg_movespeed)
		Move (hneck, z_axis, 0, leg_movespeed)
		Move (hhead, z_axis, 0, leg_movespeed)--]]
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


function script.QueryWeapon1 ()
	return lance
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
	attacking = true
	StartThread(MeleeAnimations)
end

function MeleeAnimations()
	if attacking then
		atkAnimCounter = math.random(2)
		if atkAnimCounter == 1 then --thrust forward
			Turn (rarm, x_axis, pi/4, arm_movespeed)
			WaitForTurn (rarm, x_axis)
			Sleep(50)
			Turn (rarm, x_axis, -pi/4, arm_movespeed)
			WaitForTurn (rarm, x_axis)
			Sleep(50)
		elseif atkAnimCounter == 2 then
			--Turn bodies backward and back legs forward
			Turn(hbody, x_axis, -(3*pi)/8, arm_movespeed)
			Turn(body, x_axis, -(3*pi)/8, arm_movespeed)
			Turn(hblleg, x_axis, (3*pi)/8, arm_movespeed)
			Turn(hbrleg, x_axis, (3*pi)/8, arm_movespeed)
			WaitForTurn (hbody, x_axis)
			WaitForTurn (body, x_axis)
			WaitForTurn (hblleg, x_axis)
			WaitForTurn (hbrleg, x_axis)
			
			--Turn front legs back and forth
			Turn(hflleg, x_axis, pi/4, 10)
			Turn(hfrleg, x_axis, -pi/4, 10)
			WaitForTurn (hflleg, x_axis)
			WaitForTurn (hfrleg, x_axis)
			Sleep(50)
			Turn(hflleg, x_axis, -pi/4, 10)
			Turn(hfrleg, x_axis, pi/4, 10)
			WaitForTurn (hflleg, x_axis)
			WaitForTurn (hfrleg, x_axis)
			Sleep(200) --hold position for a bit

			--Return all pieces to original position
			Turn(hflleg, x_axis, 0, arm_movespeed)
			Turn(hfrleg, x_axis, 0, arm_movespeed)
			Turn(hbody, x_axis, 0, arm_movespeed)
			Turn(body, x_axis, 0, arm_movespeed)
			Turn(hblleg, x_axis, 0, arm_movespeed)
			Turn(hbrleg, x_axis, 0, arm_movespeed)
			
			WaitForTurn (hbody, x_axis)
			WaitForTurn (body, x_axis)
			WaitForTurn (hblleg, x_axis)
			WaitForTurn (hbrleg, x_axis)
			Sleep(50)
		end	
			
		--[[	Turn (lance, x_axis, (3*pi)/4, arm_movespeed)
			Turn (rarm, x_axis, -pi/2, arm_movespeed)
			WaitForTurn (lance, x_axis)
			WaitForTurn (rarm, x_axis)
			Sleep(500)
			Turn (rarm, x_axis, 0, 5)
			WaitForTurn (rarm, x_axis)
			Sleep(500)
			Turn (rarm, x_axis, -pi/2, 5)
			WaitForTurn (rarm, x_axis)
			Sleep(500)
			Turn (lance, x_axis, 0, arm_movespeed)
			Turn (rarm, x_axis, 0, arm_movespeed)
			WaitForTurn (lance, x_axis)
			WaitForTurn (rarm, x_axis)						
			Sleep(500)]]--
		

	Sleep(300)	
	attacking=false
	return(1)
	end
end
	
function script.Killed(damage, health)
	
	Turn (body, x_axis, -pi/2, arm_movespeed)
	Move (body, y_axis, -100, leg_movespeed)
	Sleep(1000)
	return(1)
end	
	