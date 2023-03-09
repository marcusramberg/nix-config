return {

	-- add any tools you want to have installed below
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"flake8",
				"gopls",
				"perlnavigator",
				"pyright",
				"rnix-lsp",
				"ruff-lsp",
				"shellcheck",
				"shfmt",
				"stylua",
				"terraform-ls",
				"typescript-language-server",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				-- pyright will be automatically installed with mason and loaded with lspconfig
				html = {},
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					linksInHover = false,
					codelenses = {
						generate = true,
						gc_details = true,
						regenerate_cgo = true,
						tidy = true,
						upgrade_depdendency = true,
						vendor = true,
					},
					usePlaceholders = true,
				},
				perlnavigator = {},
				pyright = {},
				rnix = {},
				terraformls = {},
				tflint = {},
				yamlls = {},
			},
		},
	},

	-- add more treesitter parsers
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"gitcommit",
				"go",
				"gotmpl",
				"help",
				"html",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"hcl",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"query",
				"regex",
				"tsx",
				"terraform",
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
	{
		"ray-x/go.nvim",
		requires = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
}
