local mod = get_mod("pusfume")

mod.pusfume_conversations = {
    { 
        witch_hunter = {},
        bright_wizard = {},
        empire_soldier = {},
        dwarf_ranger = {},
        way_watcher = {},
        pusfume = {},
        lines = {
            "psf_hello",
        },
        order = {
            "pusfume",
        }
    },
    { 
        empire_soldier = {},
        pusfume = {},
        lines = {
            "pes_we_backstory_three_01",
            "psf_kruber_03_1",
            "pes_we_future_two_03",
            "psf_kruber_03_2",
        },
        order = {
            "empire_soldier", 
            "pusfume",
            "empire_soldier", 
            "pusfume",
        }
    },
    { 
        empire_soldier = {},
        pusfume = {
            "psf_kruber_04_1",
            current_index = 1,
        },
        lines = {
            "psf_kruber_04_1",
        },
        order = {
            "pusfume",
        }
    },
    {  
        empire_soldier = {},
        pusfume = {},
        lines = {
            "psf_kr_01_1",
			"pes_woods_conversation_seven_02",
			"psf_kr_01_2",
			"pes_cog_conversation_twentysix_02",
			"psf_kr_01_3",
        },
        order = {
            "pusfume",
            "empire_soldier",
            "pusfume",
            "empire_soldier",
            "pusfume",
        }
    },
    {  
        empire_soldier = {},
        pusfume = {},
        lines = {
            "psf_kr_02_1",
			"pes_wh_future_one_03",
			"psf_kr_02_2",
        },
        order = {
            "pusfume",
            "empire_soldier",
            "pusfume",
        }
    },
    
}


-- local world = Managers.world:world("level_world")
-- local wwise_world = Wwise.wwise_world(world)
-- local event = "pes_we_future_two_03"
-- local sound = WwiseWorld.trigger_event(wwise_world, event)

-- mod:echo(WwiseWorld.is_playing(wwise_world, sound))