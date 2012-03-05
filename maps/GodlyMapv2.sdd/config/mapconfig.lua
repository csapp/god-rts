local cfg = {}
	
	--------------------------------------------------------------------------------------------------------
	--			general  settings
	--------------------------------------------------------------------------------------------------------
	if VFS.FileExists("config/map/general.lua") then
		cfg = VFS.Include("config/map/general.lua")
	else
		error("missing file: config/map/general.lua")
	end

return cfg