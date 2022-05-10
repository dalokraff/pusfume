local mod = get_mod("pusfume")


--this defines the custom interaction that is called when interacting with the disc
InteractionHelper = InteractionHelper or {}
InteractionHelper.interactions.pusfume_interaction = {}
for _, config_table in pairs(InteractionHelper.interactions) do
	config_table.request_rpc = config_table.request_rpc or "rpc_generic_interaction_request"
end

InteractionDefinitions["pusfume_interaction"] = InteractionDefinitions.pusfume_interaction or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.pusfume_interaction.config.swap_to_3p = false
InteractionDefinitions.pusfume_interaction.config.request_rpc = "rpc_generic_interaction_request" --"rpc_request_spawn_network_unit"

InteractionDefinitions.pusfume_interaction.server.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
    if result == InteractionResult.SUCCESS then
        local interactable_system = ScriptUnit.extension(interactable_unit, "interactable_system")
        interactable_system.num_times_successfully_completed = interactable_system.num_times_successfully_completed + 1

    end
end

InteractionDefinitions.pusfume_interaction.client.can_interact = function (interactor_unit, interactable_unit, data, config)

    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
end

InteractionDefinitions.pusfume_interaction.server.can_interact = function (interactor_unit, interactable_unit)

    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit))
end

InteractionDefinitions.pusfume_interaction.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
	data.start_time = nil

	if result == InteractionResult.SUCCESS and not data.is_husk then
	    if interactable_unit then
            local world = Managers.world:world("level_world")
            local wwise_world = Managers.world:wwise_world(world)
            WwiseWorld.trigger_event(wwise_world, "pan_melee_new01", interactable_unit)
                        
        end

	end
end

InteractionDefinitions.pusfume_interaction.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
    return Unit.get_data(interactable_unit, "interaction_data", "interaction_type"), Unit.get_data(interactable_unit, "interaction_data", "hud_description")
end