--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    mapinfo.lua
--  brief:   map configuration loader
--  author:  Dave Rodgers, Lurker, Smoth, SirArtturi
--
--  Copyright (C) 2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Special table for map config files
--
--   Map.fileName
--   Map.fullName
--   Map.configFile


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function IsTdf(text)
  local s, e, c = text:find('(%S)') -- first non-space character
  -- TDF files should start with:
  --   '[name]' - section header
  --   '/*'     - comment
  --   '//      - comment
  return ((c == '[') or (c == '/'))
end


--------------------------------------------------------------------------------

local configFile = Map.configFile
local mapcfg

if VFS.FileExists("config/mapconfig.lua") then
	mapcfg = VFS.Include("config/mapconfig.lua")
else
	error("missing file: config/mapconfig.lua")
end

local configSource, err = VFS.LoadFile(configFile)
if (configSource == nil) then
	error(configFile .. ': ' .. err)
end


--------------------------------------------------------------------------------

local mapInfo, err

if (IsTdf(configSource)) then
	local mapTdfParser = VFS.Include('maphelper/parse_tdf_map.lua')
	mapInfo, err = mapTdfParser(configSource)
	if (mapInfo == nil) then
		error(configFile .. ': ' .. err)
	end
else
	local chunk, err = loadstring(configSource, configFile)
	if (chunk == nil) then
		error(configFile .. ': ' .. err)
	end
	mapInfo = chunk()
end


--------------------------------------------------------------------------------

if (Spring.GetMapOptions) then
  local optsFunc = VFS.Include('maphelper/applyopts.lua')
  optsFunc(mapInfo)
end

if ( Spring.GetMapOptions and Spring.GetMapOptions().wc ~= nil) then

	if (Spring.GetMapOptions().wc == "1")	then
		AtmoSDefs = mapcfg.weather.rain
		WaterDefs = mapcfg.weather.rain.water
	else	-- clear skies
		AtmoSDefs = mapcfg.weather.clear
		WaterDefs = mapcfg.water
	end

	mapInfo.atmosphere.minwind			=  	mapcfg.minwind
	mapInfo.atmosphere.maxwind			=  	mapcfg.maxwind
	mapInfo.tidalstrength				=  	mapcfg.tidalstrength
	mapInfo.gravity					=  	mapcfg.gravity
	mapInfo.maxmetal				=  	mapcfg.maxmetal
	mapInfo.extractorradius				=  	mapcfg.extractorradius
	mapInfo.maphardness				=  	mapcfg.hardness
	mapInfo.autoshowmetal				=  	mapcfg.autoshowmetal
	
	mapInfo.atmosphere.cloudcolor			=	AtmoSDefs.cloudcolor
	mapInfo.atmosphere.suncolor			=	AtmoSDefs.suncolor
	mapInfo.atmosphere.clouddensity			=	AtmoSDefs.clouddensity
	mapInfo.atmosphere.skycolor			=	AtmoSDefs.skycolor
	mapInfo.atmosphere.fogcolor			=	AtmoSDefs.fogcolor
	mapInfo.atmosphere.fogstart			=	AtmoSDefs.fogstart
	
	mapInfo.lighting.sundir				=	AtmoSDefs.sundir	
	mapInfo.lighting.groundambientcolor		=	AtmoSDefs.groundambientcolor	
	mapInfo.lighting.grounddiffusecolor		=	AtmoSDefs.grounddiffusecolor
	mapInfo.lighting.groundshadowdensity		=	AtmoSDefs.groundshadowdensity

	mapInfo.lighting.unitambientcolor		=	AtmoSDefs.unitambientcolor
	mapInfo.lighting.unitdiffusecolor		=	AtmoSDefs.unitdiffusecolor
	mapInfo.lighting.unitshadowdensity		=	AtmoSDefs.unitshadowdensity
			
	mapInfo.voidwater				=	false		
		
	mapInfo.water.shorewaves 			= 	WaterDefs.shorewaves
	mapInfo.water.forcerendering 			= 	WaterDefs.forcerendering
	mapInfo.water.absorb				= 	WaterDefs.absorb
	mapInfo.water.ambientfactor 			= 	WaterDefs.ambientfactor
	mapInfo.water.basecolor				= 	WaterDefs.basecolor
	mapInfo.water.blurbase 				= 	WaterDefs.blurbase
	mapInfo.water.blurexponent 			= 	WaterDefs.blurexponent
	mapInfo.water.diffusecolor 			= 	WaterDefs.diffusecolor
	mapInfo.water.diffusefactor 			= 	WaterDefs.diffusefactor
	mapInfo.water.fresnelmin 			= 	WaterDefs.fresnelmin
	mapInfo.water.fresnelmax 			= 	WaterDefs.fresnelmax
	mapInfo.water.fresnelpower 			= 	WaterDefs.fresnelpower
	mapInfo.water.mincolor				= 	WaterDefs.mincolor
	mapInfo.water.perlinstartfreq 			= 	WaterDefs.perlinstartfreq
	mapInfo.water.perlinlacunarity 			= 	WaterDefs.perlinlacunarity
	mapInfo.water.perlinamplitude 			= 	WaterDefs.perlinamplitude		
	mapInfo.water.planecolor			= 	WaterDefs.planecolor
	mapInfo.water.reflectiondistortion 		= 	WaterDefs.reflectiondistortion
	mapInfo.water.specularcolor 			= 	WaterDefs.specularcolor
	mapInfo.water.specularfactor 			= 	WaterDefs.specularfactor
	mapInfo.water.specularpower 			= 	WaterDefs.specularpower
	mapInfo.water.surfacecolor			= 	WaterDefs.surfacecolor
	mapInfo.water.surfacealpha			= 	WaterDefs.surfacealpha
	
	mapInfo.terraintypes[255].movespeeds.tank	=	mapcfg.terraintypes255.movespeeds.tank
	mapInfo.terraintypes[200].movespeeds.tank	=	mapcfg.terraintypes200.movespeeds.tank

	mapInfo.terraintypes[255].movespeeds.kbot	=	mapcfg.terraintypes255.movespeeds.kbot
	mapInfo.terraintypes[200].movespeeds.kbot	=	mapcfg.terraintypes200.movespeeds.kbot

	if (Spring.GetMapOptions().hardness) then
		mapInfo.maphardness			=  	Spring.GetMapOptions().hardness
	else
		mapInfo.maphardness			=  	mapcfg.hardness
	end
	
	if (Spring.GetMapOptions().typemap == "1" ) then
		mapInfo.terraintypes[255].movespeeds.tank = "1.1"
		mapInfo.terraintypes[200].movespeeds.kbot = "1.1"
	else
		mapInfo.terraintypes[255].movespeeds.tank = mapcfg.terraintypes255.movespeeds.tank
		mapInfo.terraintypes[200].movespeeds.kbot = mapcfg.terraintypes200.movespeeds.kbot				
	end

	if (Spring.GetMapOptions().metal == "0" ) then
		mapInfo.maxmetal = 0.55
	elseif (Spring.GetMapOptions().metal == "2" ) then
		mapInfo.maxmetal = 0.7
	else
		mapInfo.maxmetal = mapcfg.maxmetal
	end
	

	if (Spring.GetMapOptions().wind == "0" ) then
		mapInfo.atmosphere.maxwind = 18
		mapInfo.atmosphere.minwind = 2
	elseif (Spring.GetMapOptions().wind == "2" ) then
		mapInfo.atmosphere.maxwind = 22
		mapInfo.atmosphere.minwind = 2
	else
		mapInfo.atmosphere.maxwind = mapcfg.maxwind
		mapInfo.atmosphere.minwind = mapcfg.minwind
	end
	
	if (Spring.GetMapOptions().tidal == "0" ) then
		mapInfo.tidalstrength = 18
	elseif (Spring.GetMapOptions().tidal == "2" ) then
		mapInfo.tidalstrength = 22
	else
		mapInfo.tidalstrength = mapcfg.tidalstrength
	end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return mapInfo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------