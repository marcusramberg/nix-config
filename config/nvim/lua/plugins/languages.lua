return {

	-- add any tools you want to have installed below
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {},
		},
	},
	{
		"dundalek/lazy-lsp.nvim",
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
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			servers = {
				html = {},
				nim_langserver = {},
				denols = {},
				jsonls = {
					settings = {
						schemas = {
							description = "TypeScript compiler configuration file",
							fileMatch = { "tsconfig.json", "tsconfig.*.json" },
							url = "http://json.schemastore.org/tsconfig",
						},
						{
							description = "Lerna config",
							fileMatch = { "lerna.json" },
							url = "http://json.schemastore.org/lerna",
						},
						{
							description = "Babel configuration",
							fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
							url = "http://json.schemastore.org/lerna",
						},
						{
							description = "ESLint config",
							fileMatch = { ".eslintrc.json", ".eslintrc" },
							url = "http://json.schemastore.org/eslintrc",
						},
						{
							description = "Bucklescript config",
							fileMatch = { "bsconfig.json" },
							url = "https://bucklescript.github.io/bucklescript/docson/build-schema.json",
						},
						{
							description = "Prettier config",
							fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
							url = "http://json.schemastore.org/prettierrc",
						},
						{
							description = "Vercel Now config",
							fileMatch = { "now.json" },
							url = "http://json.schemastore.org/now",
						},
						{
							description = "Stylelint config",
							fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
							url = "http://json.schemastore.org/stylelintrc",
						},
						{
							description = "Manifest v3",
							fileMatch = { "manifest.json" },
							url = "https://json.schemastore.org/chrome-manifest",
						},
					},
				},
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
		enabled = false,
		opts = {
			automatic_installation = { exclude = { "nimls", "nimlsp" } },
		},
	},

	{ "aMOPel/nvim-treesitter-nim" },
	-- add more treesitter parsers
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
				-- Commented out as we have to do it by hand for now
				-- "nim",
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
				excluded_servers = { "sqls", "terraform_lsp" },
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
			})
		end,
	},
}
