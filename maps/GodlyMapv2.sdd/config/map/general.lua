local generalcfg = {
	--------------------------------------------------------------------------------------------------------
	--			general  settings
	--------------------------------------------------------------------------------------------------------
	
	minheight			= -140,
	maxheight			= 1200,
	minwind				= 2,
	maxwind				= 20,
	tidalstrength		= 20,
	gravity				= 125,
	maxmetal			= 0.63,
	extractorradius		= 95,
	hardness			= 600,
	autoshowMetal		= true,
	
	resources = {
    	detailTex 			 ='zeusDET2.bmp',
	},

	weather = {
		clear = {
			cloudcolor					= { 0.55, 0.86, 0.92 },
			suncolor					= { 1, 1, 1 },
			sundir						= { -0.7, 0.77, 0.5 },
			clouddensity				= 0.65,
			skycolor					= { 0.82, 0.66, 0.79 },
			fogcolor					= { 0.65, 0.72, 0.82 },
			fogstart					= 0.72,
			groundambientcolor			= { 0.6, 0.6, 0.6 },
			grounddiffusecolor 			= { 1, 0.92, 0.85 },
    		groundspecularcolor 		= { 0.1, 0.1, 0.1 },
			groundshadowdensity			= 0.75,
			unitambientcolor			= { 0.5, 0.5, 0.5  },
			unitdiffusecolor  			= { 0.98, 0.89, 0.75 },
    		unitspecularcolor 			= { 0.1, 0.1, 0.1 }, -- tracks unitDiffuseColor
			unitshadowdensity			= 0.75,
			},

		rain = {
			cloudcolor					= { 0.61, 0.66, 0.7 },
			suncolor					= { 1, 1, .8 },
			sundir						= { -0.7, 0.77, 0.5 },
			clouddensity				= 0.75,
			skycolor					= { 0.26, 0.28, 0.32 },
			fogcolor					= { 0.7, 0.7, 0.75 },
			fogstart					= 0.2,
			groundambientcolor			= { 0.7, 0.7, 0.7 },
			grounddiffusecolor			= { 0.05, 0.05, 0.05 },
			groundshadowdensity			= 0.75,
			unitambientcolor			= { 0.4, 0.4, 0.4 },
			unitdiffusecolor			= { 0.5, 0.45, 0.42  },
			unitshadowdensity			= 0.75,
			specularsuncolor			= { 0.1, 0.1, 0.1 },
			
			water ={

				absorb					= { 0.022, 0.0060, 0.0045 },
				basecolor				= { 0.60, 0.70, 0.75 },
				mincolor				= { 0.2, 0.2, 0.25 },
				surfacecolor			= { 0.61, 0.70, 0.75 },
				planecolor				= { 0.51, 0.56, 0.6  },

				},
			},
		},
							
	water ={
		
		absorb					= { 0.022, 0.0060, 0.0045 },
		basecolor				= { 0.80, 1, 1 },
		mincolor				= { 0, 0, 0.05 },
		planecolor				= { 0.61, 0.84, 0.95 },
		specularcolor			= { 0.2, 0.25, 0.5 },
		surfacecolor			= { 0.61, 0.84, 0.95 },

		},

	terraintypes0 = {	
		name = 'Default terrain',
    		hardness = 1.0,
    		movespeeds = {
      		tank  = 1.0,
      		kbot  = 1.0,
      		hover = 1.0,
      		ship  = 1.0,
		},
  
	},  	
	
	terraintypes255 = {
		name = 'Roads&Dam',
    		hardness = 1.0,
    		movespeeds = {
      		tank  = 1.0,
      		kbot  = 1.0,
      		hover = 1.0,
      		ship  = 1.0,
		},    	
	},

	terraintypes200 = {
		name = 'Sand',
    		hardness = 1.0,
    		movespeeds = {
      		tank  = 1.0,
      		kbot  = 1.0,
      		hover = 1.0,
      		ship  = 1.0,
		},    	

	},

	terraintypes100 = {
		name = 'Mountains',
    		hardness = 1.0,
    		movespeeds = {
      		tank  = 1.0,
      		kbot  = 1.0,
      		hover = 1.0,
      		ship  = 1.0,
		},    	
	},
}
return generalcfg
