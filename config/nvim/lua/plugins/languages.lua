return {

  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        markdown = true,
        yaml = true,
        json = true,
        help = true,
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      PATH = "append",
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        yaml = { "yamlfmt" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--offset-encoding=utf-16",
          },
          mason = false,
        },
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
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
        "go",
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
      ignore_install = { "ipk", "ipkg" },
    },
  },
  { "alaviss/nim.nvim" },
  { "joshglendenning/vim-caddyfile" },
  { "symphorien/vim-nixhash" },
  {
    "fredrikaverpil/godoc.nvim",
    version = "*",
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" }, -- optional
    opts = {}, -- see further down below for configuration
  },
}
