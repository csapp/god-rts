local Sounds = {
	SoundItems = {
		--- RESERVED FOR SPRING, DON'T REMOVE
		IncomingChat = {
			file = "sounds/incoming_chat.wav",
			 rolloff = 0.1, 
			maxdist = 10000,
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		MultiSelect = {
			file = "sounds/multiselect.wav",
			 rolloff = 0.1, 
			maxdist = 10000,
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		MapPoint = {
			file = "sounds/mappoint.wav",
			rolloff = 0.1,
			maxdist = 10000,
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		--- END RESERVED

        archery_arrowflyby = {
            file = "sounds/archery-arrowflyby.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        archery_arrowimpact = {
            file = "sounds/archery-arrowimpact.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        archery_arrowrelease = {
            file = "sounds/archery-arrowrelease.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        avalanche = {
            file = "sounds/avalanche.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        birdchirp = {
            file = "sounds/birdchirp.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        birdjunglebirds = {
            file = "sounds/birdjunglebirds.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        birds canary = {
            file = "sounds/birds canary.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        birdsmacaw = {
            file = "sounds/birdsmacaw.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        birdsong = {
            file = "sounds/birdsong.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        birdsongmorning = {
            file = "sounds/birdsongmorning.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        birdtrill = {
            file = "sounds/birdtrill.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        bonecrack = {
            file = "sounds/bonecrack.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        brook = {
            file = "sounds/brook.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        bugle = {
            file = "sounds/bugle.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        burp = {
            file = "sounds/burp.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        cannonshot = {
            file = "sounds/cannonshot.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        chicken = {
            file = "sounds/chicken.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        coughing = {
            file = "sounds/coughing.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        crowcaying = {
            file = "sounds/crowcaying.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        crowdtalking1 = {
            file = "sounds/crowdtalking1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        crows = {
            file = "sounds/crows.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        dogdrinking = {
            file = "sounds/dogdrinking.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        dogsbarking = {
            file = "sounds/dogsbarking.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        doorslamming = {
            file = "sounds/doorslamming.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        doorsqueak = {
            file = "sounds/doorsqueak.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        drawerclosing = {
            file = "sounds/drawerclosing.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        earthquake = {
            file = "sounds/earthquake.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        fir3 = {
            file = "sounds/fir3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        fire1 = {
            file = "sounds/fire1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        fire2 = {
            file = "sounds/fire2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        footsteps1 = {
            file = "sounds/footsteps1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        footsteps2 = {
            file = "sounds/footsteps2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        footsteps3 = {
            file = "sounds/footsteps3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        glassbreaking = {
            file = "sounds/glassbreaking.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        glasscrash = {
            file = "sounds/glasscrash.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        gong = {
            file = "sounds/gong.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        grindmetal = {
            file = "sounds/grindmetal.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        hammermetal = {
            file = "sounds/hammermetal.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        icecracking = {
            file = "sounds/icecracking.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        icefootsteps = {
            file = "sounds/icefootsteps.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        incehitground = {
            file = "sounds/incehitground.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        locustsingle = {
            file = "sounds/locustsingle.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        marching = {
            file = "sounds/marching.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        massacre = {
            file = "sounds/massacre.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        moo = {
            file = "sounds/moo.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        nighttimecricket = {
            file = "sounds/nighttimecricket.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        rain1 = {
            file = "sounds/rain1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        rain2 = {
            file = "sounds/rain2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        rain3 = {
            file = "sounds/rain3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        rattlesnake = {
            file = "sounds/rattlesnake.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        river1 = {
            file = "sounds/river1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        river2 = {
            file = "sounds/river2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        river3 = {
            file = "sounds/river3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        river4 = {
            file = "sounds/river4.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        rockslide = {
            file = "sounds/rockslide.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        rooster = {
            file = "sounds/rooster.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        running = {
            file = "sounds/running.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        splash1 = {
            file = "sounds/splash1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        splash2 = {
            file = "sounds/splash2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        splash3 = {
            file = "sounds/splash3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        springambient = {
            file = "sounds/springambient.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        stream = {
            file = "sounds/stream.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        swamp = {
            file = "sounds/swamp.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        swarmofbees = {
            file = "sounds/swarmofbees.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        swordfight = {
            file = "sounds/swordfight.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        thunder = {
            file = "sounds/thunder.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        thunder2 = {
            file = "sounds/thunder2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        thunder3 = {
            file = "sounds/thunder3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        treefalling = {
            file = "sounds/treefalling.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        walking snow = {
            file = "sounds/walking snow.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        waterdripping = {
            file = "sounds/waterdripping.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        wave = {
            file = "sounds/wave.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        wave2 = {
            file = "sounds/wave2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        wave3 = {
            file = "sounds/wave3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        wave4 = {
            file = "sounds/wave4.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        whistle = {
            file = "sounds/whistle.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        womancrying = {
            file = "sounds/womancrying.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

--WEAPONS
--[[
		gclaser2_fire = { 
            file = "sounds/gclaser2_fire.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 6000,


			priority = 10, --- higher numbers = less chance of cutoff
			maxconcurrent = 2, ---how many maximum can we hear?
		},
]]--
		--[[DefaultsForSounds = { -- this are default settings
			file = "ThisEntryMustBePresent.wav",
			gain = 1.0,
			pitch = 1.0,
			priority = 0,
			maxconcurrent = 16, --- some reasonable limits
			--maxdist = FLT_MAX, --- no cutoff at all
		},
		--- EXAMPLE ONLY!
		MyAwesomeSound = {			
			file = "sounds/booooom.wav",
			preload, -- put in memory!
			loop,  -- loop me!
			looptime=1000, --- milliseconds!
			gain = 2.0, --- for uber-loudness
			pitch = 0.2, --- bass-test
			priority = 15, --- very high
			maxconcurrent = 1, ---only once
			--maxdist = 500, --- only when near
		},]]
	},
}

return Sounds
