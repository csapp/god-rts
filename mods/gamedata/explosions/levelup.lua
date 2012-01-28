--the logo of the spring engine flashing in various colors
return {
  ["levelup"] = {
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
        explosiongenerator = [[custom:levelup]],
		airdrag            = 0.9,
        colormap           = [[0 1 0 1  0 0.5 0 1]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1 r0.1, 0]],
        numparticles       = 1,
        particlelife       = 50,
        particlelifespread = 0,
        particlesize       = -50,	--negative side: turn the texture upside down
        particlesizespread = 0,
        particlespeed      = 2.5,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[levelup]],
      },
    },
  },
}
