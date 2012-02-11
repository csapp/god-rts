local buildspot = piece "grid3"

function script.QueryBuildInfo() 
    return buildspot 
end

function script.Create()
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

--function script.StartBuilding()
--end

--function script.StopBuilding()
--end
