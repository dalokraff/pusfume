local mod = get_mod("pusfume")
mod:dofile("scripts/mods/pusfume/utils/network_tables")
mod:dofile("scripts/mods/pusfume/utils/hooks")
mod:dofile("scripts/mods/pusfume/utils/interaction")
mod:dofile("scripts/mods/pusfume/pusfume_attachment_node")
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
    local unit, go_id = unit_spawner:spawn_network_unit("units/pusfume/pusfume_inn", unit_template_name, extension_init_data, position, rotation)
    local unit2 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn_fur", position, rotation)
    Unit.disable_animation_state_machine(unit2)
    AttachmentUtils.link(world, unit, unit2, AttachmentNodeLinking.pusfume)
end)

mod:command("spawn_pusfume_no_extension", "", function() 
    local world = Managers.world:world("level_world")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0) 
    local rotation = Unit.local_rotation(player_unit, 0)
    local unit_spawner = Managers.state.unit_spawner
    local unit_template_name = "interaction_unit"
    local extension_init_data = {}
    local unit, go_id = unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn", position, rotation)
    local unit2 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn_fur", position, rotation)
    Unit.disable_animation_state_machine(unit2)
    AttachmentUtils.link(world, unit, unit2, AttachmentNodeLinking.pusfume)
end)


-- local world = Managers.world:world("level_world")
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) 
-- local rotation = Unit.local_rotation(player_unit, 0)
-- local unit1 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn", position, rotation)
-- local unit2 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn_fur", position, rotation)
-- Unit.disable_animation_state_machine(unit2)
-- AttachmentUtils.link(world, unit1, unit2, AttachmentNodeLinking.pusfume)