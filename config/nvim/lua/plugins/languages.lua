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
