return {
  ["dust"] = {
    clouds0 = {
      air                = false,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      underwater         = 0,
      water              = false,
      properties = {
        airdrag            = 0.99,
        colormap           = [[0 0 0 0.001 0.04 0.04 0.04 0.18    0 0 0 0.001]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 5,
        particlelife       = 20,
        particlelifespread = 20,
        particlesize       = 8,
        particlesizespread = 4,
        particlespeed      = 0.7,
        particlespeedspread = 1.1,
        pos                = [[0, 1.75, 0]],
        sizegrowth         = -0.005,
        sizemod            = 1.0,
        texture            = [[blackfire]],
		useAirLos		   = false,
      },
    },
  },

 
}