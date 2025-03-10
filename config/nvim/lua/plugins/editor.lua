return {

  { "wakatime/vim-wakatime", lazy = false },
  -- open with line (from syntax output and such)
  "wsdjeg/vim-fetch",
  -- return where you came from
  "farmergreg/vim-lastplace",
  -- multi cursors
  "mg979/vim-visual-multi",
  -- Better scrolling
  "karb94/neoscroll.nvim",
  -- Improved url opener
  "gabebw/vim-github-link-opener",
  -- Smart sort that supports yaml dicts
  { "sQVe/sort.nvim", config = true },
  -- Extend % to support words
  "andymass/vim-matchup",
  -- Simplify the macro syntax
  { "chrisgrieser/nvim-recorder", config = true },
  { "metakirby5/codi.vim" },
  {
    "okuuva/auto-save.nvim",
    version = "*", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {},
  },
  {
    "ibhagwan/smartyank.nvim",
    config = function()
      require("smartyank").setup({ osc52 = { silent = true } })
    end,
  },
}
