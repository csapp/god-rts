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

        birdsong = {
            file = "sounds/birdsong.wav",
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

        rain2 = {
            file = "sounds/rain2.wav",
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

        aahhh = {
            file = "sounds/aahhh.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        bottle_pop_1 = {
            file = "sounds/bottle_pop_1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        bottle_pop_2 = {
            file = "sounds/bottle_pop_2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        bottle_pop_3 = {
            file = "sounds/bottle_pop_3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        come_on_2 = {
            file = "sounds/come_on_2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        come_on_3 = {
            file = "sounds/come_on_3.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        here-i-come = {
            file = "sounds/here-i-come.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        hmmm1 = {
            file = "sounds/hmmm1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        horse_1 = {
            file = "sounds/horse_1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        huh_1 = {
            file = "sounds/huh_1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        huh_2 = {
            file = "sounds/huh_2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        sawing-2 = {
            file = "sounds/sawing-2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        sharpening-knife-1 = {
            file = "sounds/sharpening-knife-1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        whooosh = {
            file = "sounds/whoosh.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        wine-glass-clink-1 = {
            file = "sounds/wine-glass-clink-1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        wine-glass-clink-2 = {
            file = "sounds/wine-glass-clink-2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        yes_1 = {
            file = "sounds/yes_1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        yes_2 = {
            file = "sounds/yes_2.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        you_got_it_1 = {
            file = "sounds/you_got_it_1.wav",
            gain = 1.0,
            pitch = 1.0,
            priority = 0,
            maxconcurrent = 1,
        },

        you_got_it_2 = {
            file = "sounds/you_got_it_2.wav",
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
