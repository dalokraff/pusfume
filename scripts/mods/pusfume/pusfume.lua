local mod = get_mod("pusfume")
mod:dofile("scripts/mods/pusfume/utils/mod_rpcs")
mod:dofile("scripts/mods/pusfume/utils/conversation")
mod:dofile("scripts/mods/pusfume/utils/network_tables") --this must be done after conversations
mod:dofile("scripts/mods/pusfume/utils/hooks")

mod:dofile("scripts/mods/pusfume/utils/interaction")
mod:dofile("scripts/mods/pusfume/pusfume_attachment_node")
-- Your mod code goes here.
-- https://vmf-docs.verminti.de

Wwise.load_bank("wwise/pusfume")

mod.refreshed_convos = table.clone(mod.pusfume_conversations)
mod.previous_convos = {}
mod.attached_units = {}
mod.pusfume_unit = {}
mod.player_list = nil
mod.current_sound = nil
mod.player_hot_join = false
mod.pusfumed_spawned = false
mod.time = -1
math.randomseed(1)
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
    if Managers.world:has_world("level_world") then
        mod.interactable_unit = interactable_unit
        mod.interactor_unit = interactor_unit
        local event = nil
        local world = Managers.world:world("level_world")
        local wwise_world = Wwise.wwise_world(world)
        if mod.play_dialouge and not mod.current_sound then
        
            local char_key = mod.convo_tisch['order'][k]
            mod:echo(char_key)
            
            if char_key then 
                event = mod.convo_tisch['lines'][k]
            end
            k = k + 1

            if event then 
                local unit = nil
                if char_key == 'pusfume' and Unit.alive(mod.interaction_units["interactable_unit"]) and Unit.alive(mod.interaction_units["interactor_unit"]) then
                    unit = mod.interaction_units["interactable_unit"]
                elseif Unit.alive(mod.interaction_units["interactor_unit"]) then
                    unit = mod.interaction_units["interactor_unit"]
                else
                    goto unit_dead
                end
                mod:echo(unit)
                local sound_event_id = NetworkLookup.sound_events[event]
                local unit_storage = Managers.state.unit_storage
                local unit_marker = unit_storage:go_id(unit)
                if Unit.has_data(unit, "unit_marker") then
                    unit_marker = Unit.get_data(unit, "unit_marker")
                end
                mod:network_send("rpc_send_pusfume_sound","all", unit_marker, sound_event_id)
                mod.time = os.time()
            else 
                mod.play_dialouge = false
                mod.current_sound = nil
                mod.time = -1
                k = 1
                j = 1
            end
        elseif mod.play_dialouge and mod.current_sound then
            if not WwiseWorld.is_playing(wwise_world, mod.current_sound) then
                local char_key = mod.convo_tisch['order'][k]
                mod:echo(char_key)
                
                if char_key then
                    event = mod.convo_tisch['lines'][k]
                end
                k = k + 1

                if event then 
                    local unit = nil
                    if char_key == 'pusfume' and Unit.alive(mod.interaction_units["interactable_unit"]) and Unit.alive(mod.interaction_units["interactor_unit"]) then
                        unit = mod.interaction_units["interactable_unit"]
                    elseif Unit.alive(mod.interaction_units["interactor_unit"]) then
                        unit = mod.interaction_units["interactor_unit"]
                    else
                        goto unit_dead
                    end
                    local sound_event_id = NetworkLookup.sound_events[event]
                    local unit_storage = Managers.state.unit_storage
                    local unit_marker = unit_storage:go_id(unit)
                    if Unit.has_data(unit, "unit_marker") then
                        unit_marker = Unit.get_data(unit, "unit_marker")
                    end
                    mod:network_send("rpc_send_pusfume_sound","all", unit_marker, sound_event_id)
                    mod.time = os.time()
                else 
                    mod.play_dialouge = false
                    mod.time = -1
                    k = 1
                    j = 1
                end
            end
        end
        ::unit_dead::
    end
end




mod:command("spawn_pusfume", "", function() 
    local unit_marker = math.random(10000)
    mod:network_send("rpc_request_pusfume_inn","all", unit_marker)
end)

mod:command("attached_units", "", function() 
    local unit = nil
    for k,v in pairs(mod.attached_units) do
        mod:echo(k)
        for i,j in pairs(v) do 
            mod:echo(i)
            mod:echo(j)
            if Unit.has_data(j, "unique_id") then
                local unique_id = Unit.get_data(j, "unique_id")
                mod:echo(unique_id)
                if mod.attached_units[unique_id] then
                    local attached_unit = mod.attached_units[unique_id]["target"]
                    if Unit.has_animation_event(attached_unit, "event") then
                        mod:echo(attached_unit)
                    end
                end
            end
        end
    end

end)





mod:command("spawn_pusfume_by_player", "", function() 
    local world = Managers.world:world("level_world")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local position = Unit.local_position(player_unit, 0)    
    local rotation = Unit.local_rotation(player_unit, 0)
    local unit_spawner = Managers.state.unit_spawner
    local unit_template_name = "interaction_unit"
    local extension_init_data = {}
    local unit, go_id = unit_spawner:spawn_network_unit("units/pusfume/pusfume_inn", unit_template_name, extension_init_data, position, rotation)
    -- local unit2 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn", position, rotation)
    local unit3 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn_fur", position, rotation)
    Unit.disable_animation_state_machine(unit3) 
    
    -- World.link_unit(world, unit, Unit.node(unit, "collision"), unit2, Unit.node(unit2, "collision"))
    mod:echo(position)
    mod:echo(rotation)
    AttachmentUtils.link(world, unit, unit3, AttachmentNodeLinking.pusfume)
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

-- ItemMasterList.es_2h_heavy_spear.right_hand_unit = "units/pusfume_weapons/pusfume_fp_spear"

-- Cosmetics.skin_dr_ranger.first_person_attachment.unit = "units/pusfume_1p/pusfume_fp_bod"
-- Cosmetics.skin_dr_ranger.first_person_attachment.attachment_node_linking = AttachmentNodeLinking.pusfume_first_person



-- local world = Managers.world:world("level_world")
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) 
-- local rotation = Unit.local_rotation(player_unit, 0)
-- local unit_spawner = Managers.state.unit_spawner
-- local unit_template_name = "interaction_unit"
-- local extension_init_data = {}
-- local unit, go_id = unit_spawner:spawn_local_unit("units/pusfume_1p/pusfume_fp_bod", position, rotation)
-- Unit.animation_event(unit, "idle_spear")
-- mod:echo(Unit.node(unit, "DEF-spine"))
-- local pusfume_first_person = {
--     {
--         target = 0,
--         source = 0,
--     },
    
-- }
-- local unit2, go_id2 = unit_spawner:spawn_local_unit("units/beings/player/dwarf_ranger_upgraded/first_person_base/chr_first_person_mesh", position, rotation)
-- AttachmentUtils.link(world, player_unit, unit, pusfume_first_person)