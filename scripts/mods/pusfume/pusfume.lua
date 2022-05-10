local mod = get_mod("pusfume")
mod:dofile("scripts/mods/pusfume/utils/network_tables")
mod:dofile("scripts/mods/pusfume/utils/hooks")
mod:dofile("scripts/mods/pusfume/utils/interaction")
-- Your mod code goes here.
-- https://vmf-docs.verminti.de

Wwise.load_bank("wwise/pusfume_sounds")


mod:command("spawn_pusfume", "", function() 
    local world = Managers.world:world("level_world")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) 
    local rotation = Unit.local_rotation(player_unit, 0)
    local unit_spawner = Managers.state.unit_spawner
    local unit_template_name = "interaction_unit"
    local extension_init_data = {}
    local unit, go_id = unit_spawner:spawn_network_unit("units/pusfume/dummy_pusfume", unit_template_name, extension_init_data, position, rotation)
end)

