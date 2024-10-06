return {

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				clangd = {
					cmd = {
						"clangd",
						"--offset-encoding=utf-16",
					},
				},
				helm_ls = {
					yamlls = {
						diagnosticsLimit = 0,
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "hs", "vim" },
							},
						},
					},
				},
				nil_ls = {
					settings = {
						nix = {
							flake = {
								autoArchive = true,
							},
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
			},
		},
	},

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
