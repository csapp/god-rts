local volcano = piece "volcano"
local emit = piece "emit"
local emit2 = piece "emit2"
local emit3 = piece "emit3"

-- declares all the pieces we'll use in the script.

local SIG_WALK = 1	--signal for the walk animation thread
local SIG_AIM = 2  --signal for the weapon aiming thread
local leg_movespeed = 10
local leg_movedistance = 3
local arm_turndistance = 0.5
local arm_movespeed = 3
local attacking = false
local atkAnimCounter = 0
local pi = 3.1415

local RESTORE_DELAY = Spring.UnitScript.GetLongestReloadTime(unitID) * 2
-- picks a sensible time to wait before trying to turn the turret back to default.

function script.Create()
	Hide(volcano)
	Move(volcano, y_axis, -50, 100)
	WaitForMove(volcano, y_axis)
	Show(volcano)
	Move(volcano, y_axis, 0, 10)
	WaitForMove(volcano, y_axis)
    return 0
end

--- Emit: Weapon 1 ---
function script.QueryWeapon1 ()
	return emit
end


function script.AimFromWeapon1()
	return volcano
end

function script.AimWeapon1(heading, pitch)
	Sleep(50)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	return true
end

function script.Shot1()

end

--- Emit2: Weapon 2 ---

function script.QueryWeapon2()
	return emit2
end


function script.AimFromWeapon2()
	return volcano
end

function script.AimWeapon2(heading, pitch)
	Sleep(50)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	return true
end

function script.Shot2()

end

--- Emit3: Weapon 3 ---

function script.QueryWeapon3 ()
	return emit3
end


function script.AimFromWeapon3()
	return volcano
end

function script.AimWeapon3(heading, pitch)
	Sleep(50)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	return true
end

function script.Shot3()

end

function script.Killed(damage, health)
	Move(volcano, y_axis, -50, 50)
	WaitForMove(volcano, y_axis)
	Sleep(100)
	return(1)
end