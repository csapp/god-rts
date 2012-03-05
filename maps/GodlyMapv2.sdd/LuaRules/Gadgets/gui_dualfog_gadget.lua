--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_dualfog_gadget.lua
--  brief:   fog drawing gadget both with and without shader(s)
--  author:  Dave Rodgers, user, aegis
--
--  Copyright (C) 2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "DualFog",
    desc      = "Fog Drawing Gadget",
    author    = "trepan, user, aegis",
    date      = "Jul 22, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 9,     --  draw early
    enabled   = true  --  loaded by default?
  }
end

if (gadgetHandler:IsSyncedCode()) then
else


local enabled = true -- Spring.GetMapOptions("fogeffect",true)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----edit GLSL renderer settings here:
local fogHeight = 600
local fogColor  = { 0.7, 0.7, 0.78 }
local fogAtten  = 0.0005 --0.08
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local GroundFogDefs = {
      Color = { 0.7, 0.7, 0.78, 0.05},
      Height = 300,
      Layers = 80,
      LayerSpacing = 10,
      MapSized=0,
      FogMaxStrength = 0.3,
      FogLowHeight = 10,
}

local forceNonGLSL = false -- force using the non-GLSL renderer

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----"global" variable list
----no need to edit this. 

local height				= GroundFogDefs["Height"]
local foglayers				= GroundFogDefs["Layers"]
local lsp				= GroundFogDefs["LayerSpacing"]
local mapsized				= GroundFogDefs["MapSized"]
local tex				= GroundFogDefs["Texture"]
local fr,fg,fb,fa			= unpack(GroundFogDefs.Color)
local mapy				= Game.mapY
local mapx				= Game.mapX
local mx				= Game.mapSizeX
local mz				= Game.mapSizeZ
local e					= Spring.Echo
local fog
local FogLowStrength			= GroundFogDefs["FogMaxStrength"]
local FogLowHeight			= GroundFogDefs["FogLowHeight"]
local x,y
local CurrentCameraY
local timeNow, timeThen = 0,0


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (adh == 1) then
   local a,b = Spring.GetGroundExtremes() 
   height = b
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local GL_MODELVIEW           = GL.MODELVIEW
local GL_NEAREST             = GL.NEAREST
local GL_ONE                 = GL.ONE
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_PROJECTION          = GL.PROJECTION
local GL_QUADS               = GL.QUADS
local GL_SRC_ALPHA           = GL.SRC_ALPHA
local glBeginEnd             = gl.BeginEnd
local glBlending             = gl.Blending
local glCallList             = gl.CallList
local glColor                = gl.Color
local glColorMask            = gl.ColorMask
local glCopyToTexture        = gl.CopyToTexture
local glCreateList           = gl.CreateList
local glCreateShader         = gl.CreateShader
local glCreateTexture        = gl.CreateTexture
local glDeleteShader         = gl.DeleteShader
local glDeleteTexture        = gl.DeleteTexture
local glDepthMask            = gl.DepthMask
local glDepthTest            = gl.DepthTest
local glGetMatrixData        = gl.GetMatrixData
local glGetNumber            = gl.GetNumber
local glGetShaderLog         = gl.GetShaderLog
local glGetUniformLocation   = gl.GetUniformLocation
local glGetViewSizes         = gl.GetViewSizes
local glLoadIdentity         = gl.LoadIdentity
local glLoadMatrix           = gl.LoadMatrix
local glMatrixMode           = gl.MatrixMode
local glMultiTexCoord        = gl.MultiTexCoord
local glPopMatrix            = gl.PopMatrix
local glPushMatrix           = gl.PushMatrix
local glResetMatrices        = gl.ResetMatrices
local glTexCoord             = gl.TexCoord
local glTexture              = gl.Texture
local glTexRect              = gl.TexRect
local glUniform              = gl.Uniform
local glUseShader            = gl.UseShader
local glVertex               = gl.Vertex
local glTranslate			 = gl.Translate
local spEcho                 = Spring.Echo
local spGetCameraPosition    = Spring.GetCameraPosition
local spGetCameraVectors     = Spring.GetCameraVectors
local time = Spring.GetGameSeconds


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Extra GL constants
--

local GL_DEPTH_BITS = 0x0D56

local GL_DEPTH_COMPONENT   = 0x1902
local GL_DEPTH_COMPONENT16 = 0x81A5
local GL_DEPTH_COMPONENT24 = 0x81A6
local GL_DEPTH_COMPONENT32 = 0x81A7

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local depthBits = glGetNumber(GL_DEPTH_BITS)
if ((not depthBits) or (depthBits < 24)) then
  spEcho("Ground Fog disabled, needs at least 24 bit depth buffer")
  return false
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local worldPass = false  -- let's other DrawWorld() gadgets be unfogged
local gndMin, gndMax = Spring.GetGroundExtremes()
local debugGfx = false

local GLSLRenderer = true

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local depthShader
local depthTexture

local uniformEyePos
local uniformWP11
local uniformWP15

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----a simple plane, very complete, would look good with shadows, reflex and stuff.

local function DrawPlaneModel()
	height=GroundFogDefs["Height"]
 	height=height+10*(math.sin(time()/1))  + 30*(math.sin(time()/7.3))
Spring.Echo('height:'..height)
   glBeginEnd(GL_QUADS,function()
      for i = 0,foglayers,1 do
         if (mapsized == 0) then
            glVertex(-mapx*4096,height-(i*lsp),-mapy*4096)
            glVertex((mapx*4096)+mapx*512,height-(i*lsp),-mapy*4096)
            glVertex((mapx*4096)+mapx*512,height-(i*lsp),(mapy*4096)+mapy*512)
            glVertex(-mapx*512,height-(i*lsp),(mapy*4096)+mapy*512)
         elseif (mapsized == 1) then
            glVertex(0,height-(i*lsp),0)
            glVertex(mx,height-(i*lsp),0)
            glVertex(mx,height-(i*lsp),mz)
            glVertex(0,height-(i*lsp),mz)
         end
      end
   end)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----fog rendering 
local worldPass = false  -- let's other DrawWorld() gadgets be unfogged

local gndMin, gndMax = Spring.GetGroundExtremes()

local debugGfx = falsepass

local function Fog()
 	h=8*(math.sin(time()/1.2))  + 30*(math.sin(time()/7.3)) -30
--Spring.Echo('height:'..(height+h))
	glResetMatrices()

	glColor(fr,fg,fb,fa)
	glDepthTest(true)
	glBlending(true)

	glPushMatrix()
    glTranslate(0,h,0)
	glCallList(fog)
	glPopMatrix()

	glResetMatrices()
	glDepthTest(false)
	glColor(1,1,1,1)
	glTexture(false)
	glBlending(false)
end

local function FogLow()
    x,y = glGetViewSizes()
    glColor(fr,fg,fb,FogLowStrength)
    glTexRect(0,0,x,y)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



-----------------------------------------------------------
-- Springs default gadget:ViewResize(viewSizeX, viewSizeY)
-- IS BROKEN!
-- Also, dual screen with minimap on left is wierd, using non glsl fog for it.
-----------------------------------------------------------


local vsx, vsy
function gadget:ViewResize(viewSizeX, viewSizeY)
  --vsx = viewSizeX
  --vsy = viewSizeY	
  vsx, vsy,_,_ = Spring.GetWindowGeometry()
  if (Spring.GetMiniMapDualScreen()=='left') then
	vsx=vsx/2;
  end
  if (Spring.GetMiniMapDualScreen()=='right') then
	vsx=vsx/2
  end
	
  if (depthTexture) then
    glDeleteTexture(depthTexture)
  end
		if(type(vsx)~='number') then
		--	Spring.Echo('not number:',vsy,'more:',vsy[2]);
		else

		  depthTexture = glCreateTexture(vsx, vsy, {
		    format = GL_DEPTH_COMPONENT24,
		    min_filter = GL_NEAREST,
		    mag_filter = GL_NEAREST,
		  })
		end
	--end


	
  if (depthTexture == nil) then
    spEcho("Removing fog gadget, bad depth texture")
    gadgetHandler:Removegadget()
    return
  end
end

gadget:ViewResize(glGetViewSizes())


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local vertSrc = [[
  varying vec3 eyeDir;

  void main(void)
  {	
    gl_TexCoord[0] = gl_MultiTexCoord0;
    eyeDir = gl_MultiTexCoord1.xyz;
    gl_Position = ftransform();
  }
]]

print ("dualfog vertex shader")
print (vertSrc)
	--fogHeight=(GroundFogDefs["Height"])*(Spring.GetGameSeconds()%5+1)
	--Spring.Echo(fogHeight)

local fragSrc = ''
fragSrc = fragSrc .. 'const float fogAtten  = ' .. fogAtten .. ';'
fragSrc = fragSrc .. 'float fogHeight = ' .. fogHeight .. ';'
fragSrc = fragSrc .. 'const vec3  fogColor = vec3('
                  .. fogColor[1]..','..fogColor[2]..','..fogColor[3]..');'

fragSrc = fragSrc .. [[
  uniform sampler2D tex0;
  uniform float wp11;
  uniform float wp15;
  uniform vec3 eyePos;
  varying vec3 eyeDir;
	

  void main(void)
  {
    vec2 txcd = vec2(gl_TexCoord[0]);

    float z    = texture2D(tex0, txcd).x;

    float d = wp15 / (((z * 2.0) - 1.0) + wp11);

    vec3 toPoint = (d * eyeDir);
    vec3 worldPos = eyePos + toPoint;

#ifdef DEBUG_GFX // world position debugging
    const float k  = 100.0;
    vec3 debugColor = pow(2.0 * abs(0.5 - fract(worldPos / k)), 6.0);
    gl_FragColor = vec4(debugColor, 1.0);
    return; // BAIL
#endif

//	fogHeight= 255*(time()%5);

    float h0 = clamp(worldPos.y, 0.0, fogHeight);
    float h1 = clamp(eyePos.y,   0.0, fogHeight); // FIXME: uniform ...
    float attenFactor = 1.0 - (0.5 * (h0 + h1) / fogHeight);

    float len = length(toPoint);
    float dist = len * abs((h1 - h0) / toPoint.y); // div-by-zero prob?
    float atten = clamp(1.0 - exp(-dist * attenFactor * fogAtten), 0.0, 1.0);

    gl_FragColor = vec4(fogColor, atten);

    return;
  }
]]


if (debugGfx) then
  fragSrc = '#define DEBUG_GFX 1\n' .. fragSrc
end
print('dualfog fragment shader:')
print(fragSrc)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:Initialize()
	if (Spring.GetMapOptions().wc ~= "1") then 
		gadgetHandler:RemoveGadget()
		return
	end

	if (enabled==true) then
	  if (forceNonGLSL == false and Spring.GetMiniMapDualScreen()~='left') then
	    if (glCreateShader == nil) then
	      spEcho("Shaders not found, reverting to non-GLSL gadget")
	      GLSLRenderer = false
	    else
		
	      depthShader = glCreateShader({
	        vertex = vertSrc,
	        fragment = fragSrc,
	        uniformInt = {
	          tex0 = 0,
	        },
	      })

	      if (depthShader == nil) then
	        spEcho(glGetShaderLog())
	        spEcho("Bad shader, reverting to non-GLSL gadget.")
	        GLSLRenderer = false
	      else
	      	uniformEyePos = glGetUniformLocation(depthShader, 'eyePos')
	      	uniformWP11   = glGetUniformLocation(depthShader, 'wp11')
	      	uniformWP15   = glGetUniformLocation(depthShader, 'wp15')
		  end
	    end
	  else
	     GLSLRenderer = false
	  end
	  if (GLSLRenderer == false) then
	    fog = glCreateList(DrawPlaneModel)
	  end
	else
	  	gadgetHandler:RemoveGadget()
	end
end


function gadget:Shutdown()
  if (GLSLRenderer == true) then
    glDeleteTexture(depthTexture)
    if (glDeleteShader) then
      glDeleteShader(depthShader)
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Vector Math
--

local function cross(a, b)
  return {
    (a[2] * b[3]) - (a[3] * b[2]),
    (a[3] * b[1]) - (a[1] * b[3]),
    (a[1] * b[2]) - (a[2] * b[1])
  }
end


local function dot(a, b)
  return (a[1] * b[1]) + (a[2] * b[2]) + (a[3] * b[3])
end


local function normalize(a)
  local len = math.sqrt((a[1] * a[1]) + (a[2] * a[2]) + (a[3] * a[3]))
  if (len == 0.0) then
    return a
  end
  a[1] = a[1] / len
  a[2] = a[2] / len
  a[3] = a[3] / len
  return { a[1], a[2], a[3] }
end


local function scale(a, s)
  a[1] = a[1] * s
  a[2] = a[2] * s
  a[3] = a[3] * s
  return { a[1], a[2], a[3] }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local worldProjection = {}
local worldModelview  = {}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (worldPass) then
  function gadget:DrawWorld()
    if (GLSLRenderer == true) then
      worldModelview  = { glGetMatrixData(GL_MODELVIEW) }
      worldProjection = { glGetMatrixData(GL_PROJECTION) }
	  DrawFog()
    else
      
    end
  end
else
  function gadget:DrawWorld()
    if (GLSLRenderer == true) then
      worldModelview  = { glGetMatrixData(GL_MODELVIEW) }
      worldProjection = { glGetMatrixData(GL_PROJECTION) }
	   --Spring.Echo(fogHeight)
    else
      Fog()
    end
  end

  function gadget:DrawScreenEffects()
    if (GLSLRenderer == true) then
      DrawFog()
    else
      _, CurrentCameraY, _ = spGetCameraPosition()
      if (CurrentCameraY < FogLowHeight) then
        FogLow()
      end
    end
  end
end


function DrawFog()
  if (worldProjection == nil) then
    return
  end

  local cpx, cpy, cpz = spGetCameraPosition()
  local cv = spGetCameraVectors()
  local f  = cv.forward
  local ts = cv.top
  local bs = cv.bottom
  local ls = cv.leftside
  local rs = cv.rightside
  local vtl = normalize(cross(ls, ts))
  local vtr = normalize(cross(ts, rs))
  local vbr = normalize(cross(rs, bs))
  local vbl = normalize(cross(bs, ls))

  local s = 1 / dot(normalize(f), vtl)
  vtl = scale(vtl, s)
  vtr = scale(vtr, s)
  vbr = scale(vbr, s)
  vbl = scale(vbl, s)

  -- copy the depth buffer
  glCopyToTexture(depthTexture, 0, 0, 0, 0, vsx, vsy)

  -- setup the shader and its uniform values
  glUseShader(depthShader)
  cpy=cpy+10*(math.sin(time()/1))  + 30*(math.sin(time()/7.3))
--  Spring.Echo(cpy)

 glUniform(uniformEyePos, cpx, cpy, cpz)
  glUniform(uniformWP11, worldProjection[11])
  glUniform(uniformWP15, worldProjection[15])

  if (debugGfx) then
    glBlending(GL_SRC_ALPHA, GL_ONE)
  end

  -- easy way to setup the vertex coords
  glMatrixMode(GL_PROJECTION); glPushMatrix(); glLoadIdentity()
  glMatrixMode(GL_MODELVIEW);  glPushMatrix(); glLoadIdentity()

  -- render a full screen quad  (could also use a tailored shape)
  glTexture(depthTexture)
  glBeginEnd(GL_QUADS, function()
    glTexCoord(0, 0); glMultiTexCoord(1, vbl); glVertex(-1, -1);
    glTexCoord(1, 0); glMultiTexCoord(1, vbr); glVertex( 1, -1);
    glTexCoord(1, 1); glMultiTexCoord(1, vtr); glVertex( 1,  1);
    glTexCoord(0, 1); glMultiTexCoord(1, vtl); glVertex(-1,  1);
--    glTexCoord(0, 0); glMultiTexCoord(1, vbl); glVertex(  0,   0);
--    glTexCoord(1, 0); glMultiTexCoord(1, vbr); glVertex(vsx,   0);
--    glTexCoord(1, 1); glMultiTexCoord(1, vtr); glVertex(vsx, vsy);
--    glTexCoord(0, 1); glMultiTexCoord(1, vtl); glVertex(  0, vsy);
  end)
  glTexture(false)

  glMatrixMode(GL_PROJECTION); glPopMatrix()
  glMatrixMode(GL_MODELVIEW);  glPopMatrix()

  glUseShader(0)
  cpx, cpy, cpz = spGetCameraPosition()
  if (debugGfx) then
    glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end