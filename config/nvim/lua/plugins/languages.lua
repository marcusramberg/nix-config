return {

	-- add any tools you want to have installed below

	{ "aMOPel/nvim-treesitter-nim" },
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"gitcommit",
				"hjson",
				"html",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"nim",
				"qmljs",
				"query",
				"regex",
				"svelte",
				"typescript",
				"vim",
				"yaml",
			},
		},
	},
	{ "ray-x/guihua.lua" },
	{ "alaviss/nim.nvim" },
	{ "joshglendenning/vim-caddyfile" },
	{ "symphorien/vim-nixhash" },
}
