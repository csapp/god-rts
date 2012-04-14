return {
 ["dust"] = {
    land = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 5,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0 0 0 1   0.4 0.4 0.4 1]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 4,
        particlelife       = 30,
        particlelifespread = 10,
        particlesize       = 4,
        particlesizespread = 4,
        particlespeed      = 1,
        particlespeedspread = 0.5,
        pos                = [[0, 0, 0]],
        sizegrowth         = 16,
        sizemod            = 0.75,
        texture            = [[bombsmoke]],
      },
    },
  },
 
}