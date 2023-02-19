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
        "go",
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
  },
}
