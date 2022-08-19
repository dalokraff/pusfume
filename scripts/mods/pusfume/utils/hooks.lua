local mod = get_mod("pusfume")

local pacakge_tisch = {}

pacakge_tisch["units/pusfume/dummy_pusfume"] = "units/pusfume/dummy_pusfume"
pacakge_tisch["units/pusfume/pusfume_inn"] = "units/pusfume/pusfume_inn"
pacakge_tisch["units/pusfume/pusfume_inn_fur"] = "units/pusfume/pusfume_inn_fur"
pacakge_tisch["units/pusfume_weapons/pusfume_fp_spear"] = "units/pusfume_weapons/pusfume_fp_spear"
pacakge_tisch["units/pusfume_weapons/pusfume_fp_spear_3p"] = "units/pusfume_weapons/pusfume_fp_spear_3p"
pacakge_tisch["units/pusfume_1p/pusfume_fp_bod"] = "units/pusfume_1p/pusfume_fp_bod"

mod:hook(PackageManager, "load",
         function(func, self, package_name, reference_name, callback,
                  asynchronous, prioritize)
    if package_name ~= pacakge_tisch[package_name] and package_name ~= pacakge_tisch[package_name.."_3p"] then
        func(self, package_name, reference_name, callback, asynchronous,
             prioritize)
    end
	
end)

mod:hook(PackageManager, "unload",
         function(func, self, package_name, reference_name)
    if package_name ~= pacakge_tisch[package_name] and package_name ~= pacakge_tisch[package_name.."_3p"] then
        func(self, package_name, reference_name)
    end
	
end)

mod:hook(PackageManager, "has_loaded",
         function(func, self, package, reference_name)
    if package == pacakge_tisch[package] or package == pacakge_tisch[package.."_3p"] then
        return true
    end
	
    return func(self, package, reference_name)
end)

mod:hook(LocalizationManager, "_base_lookup", function (func, self, text_id)
    if not string.find(mod:localize(text_id), "<") then
        return mod:localize(text_id)
    end

	return func(self, text_id)
end)




--makes sure that the disc's extension data is applied to the unit; prevents crashing when of other clients/host when interacting with the disc
mod:hook(ScriptUnit, "extension", function(func, unit_1, system_name)
    local Entities = rawget(_G, "G_Entities")

    local unit_extensions = Entities[unit_1]
	local extension = unit_extensions and unit_extensions[system_name]

    if extension == nil then 
        extension = {
            _is_level_object = false,
            unit = unit_1,
            num_times_successfully_completed = 0,
            interactable_type = "pusfume_interaction",
            interaction_result = "2",
            _enabled = true
        }
        extension.destroy = function (self)
            return
        end
        extension.interaction_type = function (self)
            return self.interactable_type
        end
        extension.set_is_being_interacted_with = function (self, interactor_unit, interaction_result)
            local unit = self.unit
            local interaction_type = self.interactable_type
            self.interactor_unit = interactor_unit
            self.interaction_result = interaction_result
        end
        extension.is_being_interacted_with = function (self)
            return self.interactor_unit
        end
        extension.is_enabled = function (self)
            return self._enabled
        end
        extension.set_enabled = function (self, enabled)
            self._enabled = enabled
        end        
    end
	return extension
end)


--adding the new interaction to the list of unit extensions
local unit_templates_to_add = {
    pusfume_interaction = {
        go_type = "",
        self_owned_extensions = {
            "UnitSynchronizationExtension",
            "GenericUnitInteractableExtension"
        },
        husk_extensions = {
            "UnitSynchronizationExtension",
            "GenericUnitInteractableExtension"
        }

    }
}

local unit_templates = require("scripts/network/unit_extension_templates")
table.merge(unit_templates, unit_templates_to_add)

--makes sure the disc's extensions gets added to the "unit_templates" table used by the unit_templates class
mod:hook(unit_templates, "get_extensions", function (func, unit_template_name, is_husk, is_server)
    local extensions, num_extensions = nil
	local template = unit_templates[unit_template_name]

	if is_husk then
		if is_server and template.husk_extensions_server then
			num_extensions = template.num_husk_extensions_server
			extensions = template.husk_extensions_server
		else
			num_extensions = template.num_husk_extensions
			extensions = template.husk_extensions
		end
	elseif is_server and template.self_owned_extensions_server then
		num_extensions = template.num_self_owned_extensions_server
		extensions = template.self_owned_extensions_server
	else
		num_extensions = template.num_self_owned_extensions
		extensions = template.self_owned_extensions
	end

	return extensions, num_extensions
end)

mod:hook(unit_templates, "extensions_to_remove_on_death", function (func, unit_template_name, is_husk, is_server)
    local extensions, num_extensions = nil
	local remove_when_killed = unit_templates[unit_template_name].remove_when_killed

	if remove_when_killed == nil then
		return nil
	end

	if is_husk then
		if is_server and remove_when_killed.husk_extensions_server then
			num_extensions = remove_when_killed.num_husk_extensions_server
			extensions = remove_when_killed.husk_extensions_server
		else
			num_extensions = remove_when_killed.num_husk_extensions
			extensions = remove_when_killed.husk_extensions
		end
	elseif is_server and remove_when_killed.self_owned_extensions_server then
		num_extensions = remove_when_killed.num_self_owned_extensions_server
		extensions = remove_when_killed.self_owned_extensions_server
	else
		num_extensions = remove_when_killed.num_self_owned_extensions
		extensions = remove_when_killed.self_owned_extensions
	end

	return extensions, num_extensions
end)

-- idle walk move

mod:hook(Unit, "animation_event", function (func, unit, event)
    local world = Managers.world:world("level_world")
    local player = Managers.player:local_player()
    local player_unit = player.player_unit
    local current_time = os.time()

    if Unit.has_data(unit, "unit_marker") then
        
        local unit_marker = Unit.get_data(unit, "unit_marker")
        -- mod:echo(unique_id)
        if mod.attached_units[unit_marker] then
            local attached_unit = mod.attached_units[unit_marker]["target"]
            -- mod:echo(attached_unit)
            if Unit.has_animation_event(attached_unit, event) then
                return func(attached_unit, event)
            end
        end
    end
    
    
    if unit == player_unit then

        local player_position = Unit.local_position(player_unit, 0)
        local pusfume_position = Vector3(-9999,0,0)

        if Unit.alive(mod.pusfume_unit['unit']) then
            pusfume_position = Unit.local_position(mod.pusfume_unit['unit'], 0)
            local dif_vec = player_position - pusfume_position 
            local plane_dist = math.sqrt(math.pow(dif_vec['x'], 2) + math.pow(dif_vec['z'], 2))
            if plane_dist < 2 then
                local last_time = Unit.get_data(unit, 'startled_pusfume') or 1
                if not Unit.get_data(unit, 'startled_pusfume') then
                    Unit.set_data(unit, 'startled_pusfume', true)
                    local unit_marker = Unit.get_data(mod.pusfume_unit['unit'], "unit_marker")
                    local anim_id = NetworkLookup.anims["interact"]
                    mod:network_send("rpc_send_pusfume_anim","all", unit_marker, anim_id)
                    -- Unit.animation_event(mod.pusfume_unit['unit'], 'interact')
                end
            elseif plane_dist > 4 then
                Unit.set_data(unit, 'startled_pusfume', false)
            end
        end
    end

    return func(unit, event)
end)


-- mod:hook(Unit, "animation_event", function(func, unit, event)
--     if Unit.has_data(unit, "unique_id") then
        
--         local unique_id = Unit.get_data(unit, "unique_id")
--         -- mod:echo(unique_id)
--         if mod.attached_units[unique_id] then
--             local attached_unit = mod.attached_units[unique_id]["target"]
--             -- mod:echo(attached_unit)
--             if Unit.has_animation_event(attached_unit, event) then
--                 return func(attached_unit, event)
--             end
--         end
--     end
--     return func(unit, event)
-- end)

-- mod:echo(os.time())

--bypasses the local error function, removing the "<>" for this mod's localized text
mod:hook(LocalizationManager, "_base_lookup", function (func, self, text_id)
    if not string.find(mod:localize(text_id), "<") then
        return mod:localize(text_id)
    end

	return func(self, text_id)
end)