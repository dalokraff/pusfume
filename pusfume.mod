return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`pusfume` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("pusfume", {
			mod_script       = "scripts/mods/pusfume/pusfume",
			mod_data         = "scripts/mods/pusfume/pusfume_data",
			mod_localization = "scripts/mods/pusfume/pusfume_localization",
		})
	end,
	packages = {
		"resource_packages/pusfume/pusfume",
	},
}
