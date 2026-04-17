return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
    },
  },

  -- Scope buffers to tabs
  { "tiagovla/scope.nvim", config = true },
  {
    "folke/snacks.nvim",
    event = "VimEnter",
    opts = {
      layout = { preset = "bottom" },
      picker = {
        layout = { preset = "bottom" },
        matcher = {
          frecency = true,
        },
      },
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
        preset = {
          header = [[
        SSSSS                                       .sSSS s.                                       
        SSSSS      .sSSSSs.   SSSSSSSSSs..sSSS SSSSSSSSSS SSSs.SSSSS.sSSSsSS SSsSSSSS              
        S  SS      S  SS SSSSS    S  SS  S  SS SSSSSS  SS SSSSSS  SSS  SS   S   SSSSS             Z
        S SSS      S SSSSSSSs.SSSSSS SSS'S SSS SSSSSS SSS SSSSSS SSSS SSS  SSS  SSSSS         Z    
        S..SS      S..SSsSSSSS   S..SS   `..SSsSSSS'S..SS SSSSSS..SSS..SS       SSSSS      z       
        S;;;S      S;;;S SSSSS S;;;S        S;;;S     S;S SSS  S;;;SS;;;S       SSSSS    z         
        S:::S      S:::S SSSSS  S:::S       S:::S    S::S SSSS S:::SS:::S       SSSSS              
        S%%%S SSSSSS%%%S SSSSSS%%%SSSSSSS   S%%%S      SS SS   S%%%SS%%%S       SSSSS              
        SSSSSsSS;:'SSSSS SSSSSSSSSSSSSSSS   SSSSS       SsS    SSSSSSSSSS       SSSSS              
]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      image = {},
    },
  },
}
