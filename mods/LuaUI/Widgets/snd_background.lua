function widget:GetInfo()
	return {
		name	= "Music Player",
		desc	= "Plays music based on situation",
		author	= "cake, trepan, Smoth, Licho, xponen",
        tickets = "#48",
		date	= "Mar 01, 2008, Aug 20 2009, Nov 23 2011",
		license	= "GNU GPL, v2 or later",
		layer	= 0,
		enabled	= true	--	loaded by default?
	}
end

--------------------------------------------------------------------------------
------------------------------------------------------------------

local windows = {}

local WAR_THRESHOLD = 5000
local PEACE_THRESHOLD = 1000

local musicType = 'peace'
local dethklok = {} -- keeps track of the number of doods killed in each time frame
local timeframetimer = 0
local previousTrack = ''
local previousTrackType = ''
local newTrackWait = 1000
local numVisibleEnemy = 0
local fadeVol
local curTrack	= "no name"
local songText	= "no name"

local warTracks		=	VFS.DirList('sounds/music/war/', '*.ogg')
local peaceTracks	=	VFS.DirList('sounds/music/peace/', '*.ogg')
local victoryTracks	=	VFS.DirList('sounds/music/victory/', '*.ogg')
local defeatTracks	=	VFS.DirList('sounds/music/defeat/', '*.ogg')

local firstTime = false
local wasPaused = false
local firstFade = true
local initSeed = 0
local seedInitialized = false
local gameOver = false

local myTeam = Spring.GetMyTeamID()
local isSpec = Spring.GetSpectatingState() or Spring.IsReplay()

options_path = 'Settings/Interface/Pause Screen'

options = { 
	pausemusic = {name='Pause Music', type='bool', value=false},
}
	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
	-- Spring.Echo(math.random(), math.random())
	-- Spring.Echo(os.clock())
 
	-- for TrackName,TrackDef in pairs(peaceTracks) do
		-- Spring.Echo("Track: " .. TrackDef)	
	-- end
	--math.randomseed(os.clock()* 101.01)--lurker wants you to burn in hell rgn
	-- for i=1,20 do Spring.Echo(math.random()) end
end


function widget:Shutdown()
	Spring.StopSoundStream()
	
	for i=1,#windows do
		(windows[i]):Dispose()
	end
end

local function PlayNewTrack()
	Spring.StopSoundStream()
	local newTrack = previousTrack
    newTrack = 'music/Dogma.ogg'
	
	--XXXXIf God health less than 10% then
	--	newTrack = 'music/Strategy.ogg'
	--end
	
	-- for key, val in pairs(oggInfo) do
		-- Spring.Echo(key, val)	
	-- end
	firstFade = false
	previousTrack = newTrack
	
	-- if (oggInfo.comments.TITLE and oggInfo.comments.TITLE) then
		-- Spring.Echo("Song changed to: " .. oggInfo.comments.TITLE .. " By: " .. oggInfo.comments.ARTIST)
	-- else
		-- Spring.Echo("Song changed but unable to get the artist and title info")
	-- end
	curTrack = newTrack
	Spring.PlaySoundStream(newTrack,WG.music_volume or 0.5)
	playing = true
	
	WG.music_start_volume = WG.music_volume
end

function widget:Update(dt)
	if (Spring.GetGameSeconds()>0) then
		if not seedInitialized then
			math.randomseed(os.clock()* 100)
			seedInitialized=true
		end
		timeframetimer = timeframetimer + dt
		if (timeframetimer > 0.01) then	-- every second
			timeframetimer = 0
			newTrackWait = newTrackWait + 0.01
			
			if (not firstTime) then
				PlayNewTrack()
				firstTime = true -- pop this cherry	
			end
			
			local playedTime, totalTime = Spring.GetSoundStreamTime()
			playedTime = math.floor(playedTime)
			totalTime = math.floor(totalTime)

			if ( (playedTime >= totalTime)) then	-- both zero means track stopped in 8
				previousTrackType = musicType
				PlayNewTrack()
				newTrackWait = 0
			end
		end
       
	end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
