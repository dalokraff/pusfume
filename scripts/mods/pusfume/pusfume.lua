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


mod.attached_units = {}

mod:command("spawn_pusfume", "", function() 
    local world = Managers.world:world("level_world")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    -- local position = Unit.local_position(player_unit, 0)
    local position = Vector3(25.4691+0.5, 33.7466, 7.013)
    -- local rotation = Unit.local_rotation(player_unit, 0)
    -- local rotation = Quaternion.from_elements(0,0,-0.637392,-0.77054)
    local rotation = Quaternion.from_elements(0,0,-0.77054,0.637392)    
    local unit_spawner = Managers.state.unit_spawner
    local unit_template_name = "interaction_unit"
    local extension_init_data = {}
    local unit, go_id = unit_spawner:spawn_network_unit("units/pusfume/collision", unit_template_name, extension_init_data, position, rotation)
    local unit2 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn", position, rotation)
    local unit3 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn_fur", position, rotation)
    Unit.disable_animation_state_machine(unit3)
    
    World.link_unit(world, unit, Unit.node(unit, "collision"), unit2, Unit.node(unit2, "collision"))
    -- Unit.set_data(unit, 'attached_unit', Unit.get_data(unit2, 'unit_name'))
    mod.attached_units[Unit.get_data(unit, "unique_id")] = {
        source = unit,
        target = unit2, 
    }
    mod:echo(position)
    mod:echo(rotation)
    AttachmentUtils.link(world, unit2, unit3, AttachmentNodeLinking.pusfume)
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

mod:hook(Unit, "animation_event", function(func, unit, event)
    if Unit.has_data(unit, "unique_id") then
        
        local unique_id = Unit.get_data(unit, "unique_id")
        -- mod:echo(unique_id)
        if mod.attached_units[unique_id] then
            local attached_unit = mod.attached_units[unique_id]["target"]
            -- mod:echo(attached_unit)
            if Unit.has_animation_event(attached_unit, event) then
                return func(attached_unit, event)
            end
        end
    end
    return func(unit, event)
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






-- local world = Managers.world:world("level_world")
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0)
-- local rotation = Unit.local_rotation(player_unit, 0) 
-- local unit_spawner = Managers.state.unit_spawner
-- local unit_template_name = "interaction_unit"
-- local extension_init_data = {}
-- local unit, go_id = unit_spawner:spawn_network_unit("units/pusfume/collision", unit_template_name, extension_init_data, position, rotation)
-- local unit2 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn", position, rotation)
-- local unit3 = Managers.state.unit_spawner:spawn_local_unit("units/pusfume/pusfume_inn_fur", position, rotation)
-- Unit.disable_animation_state_machine(unit3)
-- World.link_unit(world, unit, Unit.node(unit, "collision"), unit2, Unit.node(unit2, "collision"))
-- AttachmentUtils.link(world, unit2, unit3, AttachmentNodeLinking.pusfume)
-- for k,v in pairs(SteamVoipClient) do 
--     mod:echo(k)
--     mod:echo(v)
-- end

-- for k,v in pairs(SteamVoipClient['__index']) do 
--     mod:echo(k)
--     mod:echo(v)
-- end
-- mod:echo(SteamVoipClient.audio_level(SteamVoipClient))

-- AttachmentNodeLinking.pusfume_third_person = {
--     {
--         target = 0,
--         source = "root_point",
--     }
-- }

-- Cosmetics.skin_dr_ironbreaker_black_and_gold.third_person_attachment.unit = "units/pusfume/pusfume_inn"
-- Cosmetics.skin_dr_ironbreaker_black_and_gold.third_person_attachment.attachment_node_linking = AttachmentNodeLinking.pusfume_third_person

-- mod:echo(Weapons.speed_boost_potion.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff")

-- local unit_path = "units/weapons/player/wpn_potion_buff/wpn_potion_buff_3p"
-- local num_husk = #NetworkLookup.husks

-- NetworkLookup.husks[num_husk +1] = unit_path
-- NetworkLookup.husks[unit_path] = num_husk +1
-- Pickups.potions.speed_boost_potion.unit_name = unit_path

-- ItemMasterList.potion_speed_boost_01.left_hand_unit = "units/weapons/player/wpn_potion_buff/wpn_potion_buff"

-- local world = Managers.world:world("level_world")
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)
-- local rotation = Unit.local_rotation(player_unit, 0)
-- local unit_spawner = Managers.state.unit_spawner
-- local unit_template_name = "interaction_unit"
-- local extension_init_data = {}
-- local unit, go_id = unit_spawner:spawn_local_unit("units/weapons/player/wpn_potion_buff/wpn_potion_buff_3p", position, rotation)

-- local world = Managers.world:world("level_world")
-- local player = Managers.player:local_player()
-- local player_unit = player.player_unit
-- local position = Unit.local_position(player_unit, 0) + Vector3(0,0,1)
-- local rotation = Unit.local_rotation(player_unit, 0) 
-- local unit_spawner = Managers.state.unit_spawner
-- local unit_template_name = "interaction_unit"
-- local extension_init_data = {}
-- local unit, go_id = unit_spawner:spawn_local_unit("units/architecture/town/town_walkway_02", position, rotation)

-- local nav_gen = GwNavGeneration.create(world)
-- -- GwNavGeneration.enable_write_files(nav_gen, true)
-- 		-- for _, unit in pairs(World.units_by_resource(world, "core/gwnav/units/seedpoint/seedpoint")) do
-- 		-- 	GwNavGeneration.push_seed_point(nav_gen, Unit.local_position(unit, 0))
-- 		-- end
-- 		-- if not Unit.alive(unit) then goto continue end
-- 		-- if (
-- 		-- 	Unit.has_data(unit, "gwnavseedpoint") or
-- 		-- 	Unit.has_data(unit, "GwNavBoxObstacle") or
-- 		-- 	Unit.has_data(unit, "GwNavCylinderObstacle") or
-- 		-- 	Unit.has_data(unit, "GwNavTagBox")
-- 		-- ) then goto continue end
-- 		-- if Unit.get_data(unit, "gwnavgenexcluded") then goto continue end
-- 		-- for i=0, Unit.num_actors(unit)-1 do
-- 		-- 	local actor = Unit.actor(unit, i)
-- 		-- 	if actor and not Actor.is_static(actor) then
-- 		-- 		goto continue
-- 		-- 	end
-- 		-- end

-- 		GwNavGeneration.push_meshes_fromunit(nav_gen, unit, true, false) -- consume_physics_mesh, consume_render_mesh
-- 		::continue::
		
-- 		local absolute_output_base_dir = "D:\\navmesh"
-- 		local relative_output_dir = "level01"
-- 		local sector_name = "sector01"
-- 		local database_index = 1
-- 		-- Generation.
-- 		local ok = GwNavGeneration.generate(nav_gen,
-- 			absolute_output_base_dir,
-- 			relative_output_dir,
-- 			sector_name,
-- 			database_index,
-- 			0.38, -- entity_radius
-- 			1.6, -- entity_height
-- 			60, -- slope_max
-- 			0.5, -- step_max
-- 			0.5, -- min_navigable_surface
-- 			0.5, -- altitude_tolerance
-- 			0.1, -- raster_precision
-- 			0.31, -- cell_size
-- 			1, -- height_field_sampling
-- 			false -- consume_terrain
-- 		)
-- 		--print("Generate result", ok)
-- 		mod:echo(ok)
-- 		if ok then
-- 			local absolute_path = absolute_output_base_dir.."/"..relative_output_dir.."/"..sector_name..".navdata"
-- 			GwNavGeneration.add_navdata_to_world(GLOBAL_AI_NAVWORLD, absolute_path, database_index)
-- 		end