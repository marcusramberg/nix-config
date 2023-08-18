return {
	"epwalsh/obsidian.nvim",
	lazy = true,
	-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
	event = { "BufReadPre " .. vim.fn.expand("~") .. "/Notes/**.md" },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		dir = "~/Notes", -- no need to call 'vim.fn.expand' here
		-- mappings = {
		--   -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
		--   ["gf"] = require("obsidian.mapping").gf_passthrough(),
		-- },
		completion = {
			nvim_cmp = true, -- set to false if you don't want to use nvim-cmp
			new_notes_location = "~/Notes/Notes",
		},
		templates = {
			subdir = "Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},

		-- see below for full list of options 👇
	},
}
