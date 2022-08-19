local mod = get_mod("pusfume")


--rpcs to spawn pusfume and attachments in keep
mod:network_register("rpc_request_pusfume_inn", function(sender, unit_mark)
    local world = Managers.world:world("level_world")
    local position = Vector3(25.4691+0.5, 33.7466, 7.013)
    local rotation = Quaternion.from_elements(0,0,-0.77054,0.637392)    
    local unit_spawner = Managers.state.unit_spawner
    local unit_template_name = "interaction_unit"
    local extension_init_data = {}
    local unit, go_id = unit_spawner:spawn_network_unit("units/pusfume/collision", unit_template_name, extension_init_data, position, rotation)
    local unit2 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn", position, rotation)
    local unit3 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn_fur", position, rotation)
    Unit.disable_animation_state_machine(unit3)
    Unit.set_data(unit, "unit_marker", unit_mark)

    mod.pusfume_unit['unit'] = unit
    
    World.link_unit(world, unit, Unit.node(unit, "collision"), unit2, Unit.node(unit2, "collision"))

    mod.attached_units[unit_mark] = {
        source = unit,
        target = unit2, 
    }

    mod:echo(position)
    mod:echo(rotation)
    -- mod:echo(Unit.get_data(unit, "unique_id"))
    AttachmentUtils.link(world, unit2, unit3, AttachmentNodeLinking.pusfume)
end)

--rpc to animate pusfume
mod:network_register("rpc_send_pusfume_anim", function(sender, unit_mark, anim_event_id)
    if mod.attached_units[unit_mark] then
        local unit = mod.attached_units[unit_mark].source
        local anim_event = NetworkLookup.anims[anim_event_id]
        Unit.animation_event(unit, anim_event)
    end
end)

--rpc to send pusfume related sounds
mod:network_register("rpc_send_pusfume_sound", function(sender, unit_mark, sound_event_id)
    local unit_storage = Managers.state.unit_storage
    local world = Managers.world:world("level_world")
    local wwise_world = Wwise.wwise_world(world)
    if mod.attached_units[unit_mark] then
        local unit = mod.attached_units[unit_mark].source
        local sound_event = NetworkLookup.sound_events[sound_event_id]
        local sound = WwiseWorld.trigger_event(wwise_world, sound_event, unit)
        mod.current_sound = sound
    else
        local unit = unit_storage:unit(unit_mark)
        local sound_event = NetworkLookup.sound_events[sound_event_id]
        local sound = WwiseWorld.trigger_event(wwise_world, sound_event, unit)
        mod.current_sound = sound
    end

end)