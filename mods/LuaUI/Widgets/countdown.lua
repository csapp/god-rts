-- This widget is based on Beherith's "UI plus" widget (http://widgets.springrts.de/index.php#147)

function widget:GetInfo()
  return {
    name      = "Countdown",
    desc      = "Displays a countdown clock.",
    author    = "Kaitlin",
    date      = "November 20, 2011",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end

include("colors.h.lua")
local gl_Color = gl.Color
local gl_Texture = gl.Texture
local gl_TexRect = gl.TexRect

local floor = math.floor


local vsx, vsy = widgetHandler:GetViewSizes()

-- the 'f' suffixes are fractions  (and can be nil)
local xposf  = 1
local xpos   = xposf * vsx
local yposf  = 0.9
local ypos   = yposf-128
local size   = 16
local font   = "LuaUI/Fonts/FreeSansBold_14"
local font   = "LuaUI/Fonts/Abaddon_30"
local format = "rn"
local clockoffx = -21
local clockoffy = 46
local fh = (font ~= nil)


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Default GUI override
--

local defaultClockUsed = 0

function widget:Initialize()
  defaultClockUsed = Spring.GetConfigInt("ShowClock", 1)
  -- Hides the default countdown clock, change "0" to "1" to show it
  Spring.SendCommands({"clock 0"})
end


function widget:Shutdown()
  Spring.SendCommands({"clock " .. defaultClockUsed})
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Rendering
--

--[[
local function GetTimeString()
  local secs = math.floor(Spring.GetGameSeconds())
  if (timeSecs ~= secs) then
    timeSecs = secs
	secsRemain = 1200 - secs -- There are 1200 seconds in 20 minutes
    local h = math.floor(secsRemain / 3600)
    local m = math.floor(math.fmod(secsRemain, 3600) / 60)
    local s = math.floor(math.fmod(secsRemain, 60))
    if (h > 0) then
      timeString = string.format('%01i:%02i:%02i', h, m, s)
    else
      timeString = string.format('0:%02i:%02i', m, s)
    end
  end
  return timeString
end


function widget:DrawScreen()
  xpos   = xposf * vsx
  ypos   = vsy -128
  gl_Color(1,1,1,1)
  gl_Texture('LuaUI/Images/countdown.png')	
  gl_TexRect(xpos-127,ypos+128,xpos+1,ypos,0,0,1,1)
 -- Spring.Echo("drawing:"..xpos.." "..ypos.." fract:".."xposf".." ".."yposf")
  if false then--(fh) then
    fh = fontHandler.UseFont(font)
    fontHandler.DisableCache()
	fontHandler.DrawRight(GetTimeString(), floor(xpos)+clockoffx, floor(ypos)+clockoffy)
    fontHandler.EnableCache()
  else
	gl_Color(1,1,1,1)
	gl.Text(GetTimeString(), xpos+clockoffx, ypos+clockoffy, size, format)
  end

end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Geometry Management
--

local function UpdateGeometry()
  -- use the fractions if available
  xpos = (xposf and (xposf * vsx)) or xpos
  ypos = (yposf and (yposf * vsy)) or ypos
  
  -- negative values reference the right/top edges
  xpos = (xpos < 0) and (vsx + xpos) or xpos
  ypos = (ypos < 0) and (vsy + ypos) or ypos
end
UpdateGeometry()


function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
  UpdateGeometry()
end

]]



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
