local buildspot = piece "village"
local emit = piece "emit"

local SIG_AIM = 2  --signal for the weapon aiming thread

local upgraded = false

function Upgrade()
    upgraded = true
end

function Downgrade()
    upgraded = false
end

function script.QueryBuildInfo() 
    return buildspot 
end

function script.Create()
	return 0
end

function script.Activate()
    SetUnitValue(COB.YARD_OPEN, 1)
	SetUnitValue(COB.INBUILDSTANCE, 1)
	SetUnitValue(COB.BUGGER_OFF, 1)
	return 1
end

function script.Deactivate()
    SetUnitValue(COB.YARD_OPEN, 0)
	SetUnitValue(COB.INBUILDSTANCE, 0)
	SetUnitValue(COB.BUGGER_OFF, 0)
	return 0
end

function script.QueryNanoPiece()
    return buildspot
end

function script.QueryWeapon1 ()
	return emit
end

function script.AimFromWeapon1()
	return buildspot
end

function script.AimWeapon1(heading, pitch)
    if not upgraded then
        return false
    end
    Sleep(50)
    Signal(SIG_AIM)
    SetSignalMask(SIG_AIM)
    return true
end
--function script.StartBuilding()
--end

--function script.StopBuilding()
--end
