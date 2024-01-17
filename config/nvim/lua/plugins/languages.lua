return {

	-- add any tools you want to have installed below
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {},
		},
	},
	{
		"nvimtools/none-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.sources = {
				nls.builtins.formatting.nimpretty,
				nls.builtins.formatting.shfmt,
				nls.builtins.formatting.prettier,
				nls.builtins.formatting.black,
				nls.builtins.formatting.isort,
				nls.builtins.diagnostics.shellcheck,
				nls.builtins.diagnostics.markdownlint,
			}

			return opts
		end,
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
				"gotmpl",
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
		config = function(_, opts)
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.gotmpl = {
				install_info = {
					url = "https://github.com/ngalaiko/tree-sitter-go-template",
					files = { "src/parser.c" },
				},
				filetype = "gotmpl",
				used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
			}
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{ "ray-x/guihua.lua" },
	{ "alaviss/nim.nvim" },
	{ "joshglendenning/vim-caddyfile" },
	{
		"dundalek/lazy-lsp.nvim",
		config = function(_, _)
			require("lazy-lsp").setup({
				excluded_servers = {
					"ccls", -- using clangd instead
					"sourcekit", -- Might have to figure out how to get this for swift only
					"sqls",
					"terraform_lsp",
				},
				preferred_servers = {
					nix = { "nil_ls", "rnix" },
					javascript = { "eslint", "tsserver" },
					javascriptreact = { "eslint", "tsserver" },
					typescript = { "eslint", "tsserver", "denols" },
					typescriptreact = { "eslint", "tsserver" },
					markdown = { "marksman", "ltex" },
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
}
