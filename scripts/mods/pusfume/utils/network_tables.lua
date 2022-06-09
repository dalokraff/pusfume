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