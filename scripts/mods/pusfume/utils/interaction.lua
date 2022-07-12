local mod = get_mod("pusfume")

local function find_interactor_convo(interactor, character, convo_table)
    local convo = nil
    if string.find(interactor, character) then 
        convo = convo_table[math.random(1, #convo_table)]
        while (not convo[character]) do
            convo = convo_table[math.random(1, #convo_table)]
        end
    end
    return convo
end

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

    return (Unit.alive(interactable_unit) and Unit.alive(interactor_unit) and not mod.play_dialouge)
end

InteractionDefinitions.pusfume_interaction.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
	data.start_time = nil

	if result == InteractionResult.SUCCESS and not data.is_husk then
	    if interactable_unit then
            -- local world = Managers.world:world("level_world")
            -- local wwise_world = Managers.world:wwise_world(world)
            -- WwiseWorld.trigger_event(wwise_world, "pan_melee_new01", interactable_unit)
            mod.play_dialouge = true
            mod:echo(Unit.get_data(interactor_unit, "unit_name"))
            local unit_name = Unit.get_data(interactor_unit, "unit_name")
            local salt = string.find(unit_name, "witch_hunter")
            local wiz = string.find(unit_name, "bright_wizard")
            local krub = string.find(unit_name, "empire_soldier")
            local bard = string.find(unit_name, "dwarf_ranger")
            local elf = string.find(unit_name, "way_watcher")

            -- mod.play_convo(salt, wiz, krub, bard, elf, interactable_unit, interactor_unit)
            
            -- mod.player_string = salt or wiz or krub or bard or elf or nil
            -- mod:echo(mod.player_string)
            local convo_table = mod.pusfume_conversations
            local conversation = find_interactor_convo(unit_name, "witch_hunter", convo_table) or find_interactor_convo(unit_name, "bright_wizard", convo_table) or find_interactor_convo(unit_name, "empire_soldier", convo_table) or find_interactor_convo(unit_name, "dwarf_ranger", convo_table) or find_interactor_convo(unit_name, "way_watcher", convo_table)
            mod.convo_tisch = conversation
            mod.play_dialouge = true
            mod.current_interactor = unit_name--salt or wiz or krub or bard or elf
            mod:echo(interactable_unit)
            mod:echo(interactor_unit)
            mod.interaction_units = {
                interactable_unit = interactable_unit,
                interactor_unit = interactor_unit,
            }
            for _,char_key in ipairs(mod.convo_tisch) do
                char_key["current_index"] = 1
            end
            Unit.animation_event(interactable_unit, "talk_pus")
        end

	end
end

InteractionDefinitions.pusfume_interaction.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
    return Unit.get_data(interactable_unit, "interaction_data", "interaction_type"), Unit.get_data(interactable_unit, "interaction_data", "hud_description")
end