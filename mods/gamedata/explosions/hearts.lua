--a smaller smoke cloud by knorke
return {
  ["hearts"] = {
    tpsmallsmoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      useairlos          = true,
      water              = true,
      alwaysVisible = 0,
	  properties = {
        alwaysVisible = 0,
        explosiongenerator = [[custom:hearts]],
		airdrag            = 1,
        --colormap           = [[0 0 0 1   0.4 0.4 0.4 1]], --fade out to a lighter grey but stay full opaque
        colormap           = [[0.9 0.9 0.9 1   0.4 0.4 0.4 1]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 10,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1 r0.1, 0]],
        numparticles       = 4,
        particlelife       = 30,
        particlelifespread = 30,
        particlesize       = -6,
        particlesizespread = 3,
        particlespeed      =  1.5,
        particlespeedspread = 2.5,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[hearts]],
      },
    },
  },

}
