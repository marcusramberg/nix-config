return {
	"nomnivore/ollama.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	-- All the user commands added by the plugin
	cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

	-- Sample key binding for prompting. Note that the <c-u> is important for selections to work properly.
	keys = {
		{
			"<leader>oo",
			":<c-u>lua require('ollama').prompt()<cr>",
			desc = "ollama prompt",
			mode = { "n", "v" },
		},
	},

	---@type Ollama.Config
	opts = {
		-- your configuration overrides
		url = "http://mbox:11434",
	},
}
