return {
  -- change trouble config
  --
  {
    "shaunsingh/nord.nvim",
    setup = function()
      require("nord").set()
    end,
  },
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "olacin/telescope-gitmoji.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    -- change some options
    opts = {
      pickers = {
        buffers = { theme = "ivy" },
        find_files = { theme = "ivy" },
        live_grep = { theme = "ivy" },
        spell_suggest = { theme = "ivy" },
      },
      extensions = {
        project = {
          theme = "dropdown",
          base_dirs = {
            "~/Source",
            { path = "~/.dotfiles" },
            { path = "~/org" },
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("project")
    end,
  },
  -- Scope buffers to tabs
  { "tiagovla/scope.nvim", config = true },
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      local logo = [[
SSSSS                                       .sSSS s.
SSSSS      .sSSSSs.   SSSSSSSSSs..sSSS SSSSSSSSSS SSSs.SSSSS.sSSSsSS SSsSSSSS
S  SS      S  SS SSSSS    S  SS  S  SS SSSSSS  SS SSSSSS  SSS  SS   S   SSSSS             Z
S SSS      S SSSSSSSs.SSSSSS SSS'S SSS SSSSSS SSS SSSSSS SSSS SSS  SSS  SSSSS         Z
S..SS      S..SSsSSSSS   S..SS   `..SSsSSSS'S..SS SSSSSS..SSS..SS       SSSSS      z
S;;;S      S;;;S SSSSS S;;;S        S;;;S     S;S SSS  S;;;SS;;;S       SSSSS    z
S:::S      S:::S SSSSS  S:::S       S:::S    S::S SSSS S:::SS:::S       SSSSS   
S%%%S SSSSSS%%%S SSSSSS%%%SSSSSSS   S%%%S      SS SS   S%%%SS%%%S       SSSSS
SSSSSsSS;:'SSSSS SSSSSSSSSSSSSSSS   SSSSS       SsS    SSSSSSSSSS       SSSSS
]]

      local dash = opts
      dash.section.header.val = vim.split(logo, "\n")
      return opts
    end,
  },
}
