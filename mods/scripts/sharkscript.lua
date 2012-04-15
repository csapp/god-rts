local shark = piece "Shark"
local emit = piece "emit"

local SIG_AIM = 2

function script.QueryWeapon1 ()
	return emit
end


function script.AimFromWeapon1()
	return shark
end

function script.AimWeapon1(heading, pitch)
	Sleep(50)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	return true
end

function script.Shot1()

end