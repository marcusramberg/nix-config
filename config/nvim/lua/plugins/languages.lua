return {

	-- add any tools you want to have installed below
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		enabled = false,
		opts = {
			automatic_installation = { exclude = { "nimls", "nimlsp" } },
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
	{
		"marcusramberg/lazy-lsp.nvim",
		config = function(_, _)
			require("lazy-lsp").setup({
				prefer_local = true,
				excluded_servers = {
					"ccls", -- using clangd instead
					"sourcekit", -- Might have to figure out how to get this for swift only
					"sqls",
					"terraform_lsp",
				},
				preferred_servers = {
					nix = { "nixd" },
					helm = { "helm_ls" },
					python = { "ruff_lsp", "pyright" },
					javascript = { "eslint", "tsserver" },
					javascriptreact = { "eslint", "tsserver" },
					typescript = { "eslint", "tsserver", "denols" },
					typescriptreact = { "eslint", "tsserver" },
					markdown = { "marksman" },
				},
				default_config = {
					flags = { debounce_text_changes = 150 },
				},
				configs = {
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
			})
		end,
	},
	{
		"symphorien/vim-nixhash",
	},
}
