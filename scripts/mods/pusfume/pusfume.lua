local mod = get_mod("pusfume")
mod:dofile("scripts/mods/pusfume/utils/network_tables")
mod:dofile("scripts/mods/pusfume/utils/hooks")
mod:dofile("scripts/mods/pusfume/utils/conversation")
mod:dofile("scripts/mods/pusfume/utils/interaction")
mod:dofile("scripts/mods/pusfume/pusfume_attachment_node")
-- Your mod code goes here.
-- https://vmf-docs.verminti.de

Wwise.load_bank("wwise/pusfume")

mod.player_list = nil
mod.current_sound = nil
mod.time = -1
local i = 0

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

local k = 1
local j = 1
function mod.update()
    mod.interactable_unit = interactable_unit
    mod.interactor_unit = interactor_unit
    local event = nil
    if mod.play_dialouge and not mod.current_sound then
        local world = Managers.world:world("level_world")
        local wwise_world = Wwise.wwise_world(world)
        local char_key = mod.convo_tisch['order'][k]
        mod:echo(char_key)
        
        if char_key then 
            event = mod.convo_tisch['lines'][k]
        end
        k = k + 1

        local world = Managers.world:world("level_world")
        local wwise_world = Wwise.wwise_world(world)
        if event then 
            local unit = nil
            if char_key == 'pusfume' then
                unit = mod.interaction_units["interactable_unit"]
            else 
                unit = mod.interaction_units["interactor_unit"]
            end
            mod:echo(unit)
            local sound = WwiseWorld.trigger_event(wwise_world, event, unit)
            mod.current_sound = sound
            mod.time = os.time()
        else 
            mod.play_dialouge = false
            mod.current_sound = nil
            mod.time = -1
            k = 1
            j = 1
        end
    elseif mod.play_dialouge and mod.current_sound then
        local world = Managers.world:world("level_world")
        local wwise_world = Wwise.wwise_world(world)
        if not WwiseWorld.is_playing(wwise_world, mod.current_sound) then
            local world = Managers.world:world("level_world")
            local wwise_world = Wwise.wwise_world(world)
            local char_key = mod.convo_tisch['order'][k]
            mod:echo(char_key)
            
            if char_key then
                event = mod.convo_tisch['lines'][k]
            end
            k = k + 1

            local world = Managers.world:world("level_world")
            local wwise_world = Wwise.wwise_world(world)
            if event then 
                local unit = nil
                if char_key == 'pusfume' then
                    unit = mod.interaction_units["interactable_unit"]
                else 
                    unit = mod.interaction_units["interactor_unit"]
                end
                local sound = WwiseWorld.trigger_event(wwise_world, event, unit)
                mod.current_sound = sound
                mod.time = os.time()
            else 
                mod.play_dialouge = false
                mod.time = -1
                k = 1
                j = 1
            end
        end
    end
end

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