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
}


-- local world = Managers.world:world("level_world")
-- local wwise_world = Wwise.wwise_world(world)
-- local event = "pes_we_future_two_03"
-- local sound = WwiseWorld.trigger_event(wwise_world, event)

-- mod:echo(WwiseWorld.is_playing(wwise_world, sound))