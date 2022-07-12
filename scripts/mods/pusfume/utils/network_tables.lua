local mod = get_mod("pusfume")

local unit_path = "units/pusfume/pusfume_inn"
local num_inv = #NetworkLookup.inventory_packages
local num_husk = #NetworkLookup.husks
local num_interacts = #NetworkLookup.interactions

NetworkLookup.inventory_packages[num_inv +1] = unit_path
NetworkLookup.inventory_packages[unit_path] = num_inv +1
NetworkLookup.husks[num_husk +1] = unit_path
NetworkLookup.husks[unit_path] = num_husk +1
NetworkLookup.interactions["pusfume_interaction"] = num_interacts+1
NetworkLookup.interactions[num_interacts + 1] = "pusfume_interaction"


NetworkLookup.husks[num_husk +2] = "units/pusfume/collision"
NetworkLookup.husks["units/pusfume/collision"] = num_husk +2
NetworkLookup.inventory_packages[num_inv +2] = "units/pusfume/collision"
NetworkLookup.inventory_packages["units/pusfume/collision"] = num_inv +2


NetworkLookup.husks[num_husk +3] = "units/pusfume_weapons/pusfume_fp_spear"
NetworkLookup.husks["units/pusfume_weapons/pusfume_fp_spear"] = num_husk +3
NetworkLookup.inventory_packages[num_inv +3] = "units/pusfume_weapons/pusfume_fp_spear"
NetworkLookup.inventory_packages["units/pusfume_weapons/pusfume_fp_spear"] = num_inv +3

NetworkLookup.husks[num_husk +4] = "units/pusfume_weapons/pusfume_fp_spear_3p"
NetworkLookup.husks["units/pusfume_weapons/pusfume_fp_spear_3p"] = num_husk +4
NetworkLookup.inventory_packages[num_inv +4] = "units/pusfume_weapons/pusfume_fp_spear_3p"
NetworkLookup.inventory_packages["units/pusfume_weapons/pusfume_fp_spear_3p"] = num_inv +4



NetworkLookup.husks[num_husk +5] = "units/pusfume_1p/pusfume_fp_bod"
NetworkLookup.husks["units/pusfume_1p/pusfume_fp_bod"] = num_husk +5
NetworkLookup.inventory_packages[num_inv +5] = "units/pusfume_1p/pusfume_fp_bod"
NetworkLookup.inventory_packages["units/pusfume_1p/pusfume_fp_bod"] = num_inv +5