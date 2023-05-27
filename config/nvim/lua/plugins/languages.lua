return {

	-- add any tools you want to have installed below
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"cmake-language-server",
				"flake8",
				"gopls",
				"html-lsp",
				"jq-lsp",
				"json-lsp",
				"jsonnet-language-server",
				"lua-language-server",
				"nil",
				"perlnavigator",
				"pyright",
				"ruff-lsp",
				"shellcheck",
				"shfmt",
				"stylua",
				"terraform-ls",
				"typescript-language-server",
				"yaml-language-server",
			},
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.sources = {
				nls.builtins.formatting.nimpretty,
				nls.builtins.formatting.stylua,
				nls.builtins.formatting.shfmt,
				nls.builtins.formatting.prettier,
				nls.builtins.formatting.black,
				nls.builtins.formatting.isort,
				nls.builtins.formatting.rustfmt,
				nls.builtins.diagnostics.shellcheck,
				nls.builtins.diagnostics.markdownlint,
			}

			return opts
		end,
	},
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				-- pyright will be automatically installed with mason and loaded with lspconfig
				html = {},
				nim_langserver = {},
				gopls = {
					unusedparams = true,
					analyses = {},
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
				nil_ls = {},
				terraformls = {},
				tflint = {},
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
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			automatic_installation = { exclude = { "nimls", "nimlsp" } },
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
				"toml",
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
	{
		"ray-x/go.nvim",
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	{ "alaviss/nim.nvim" },
}
