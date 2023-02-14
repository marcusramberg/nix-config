return {

  -- open with line (from syntax output and such)
  "wsdjeg/vim-fetch",
  -- return where you came from
  "farmergreg/vim-lastplace",
  -- multi cursors
  "mg979/vim-visual-multi",
  -- Better scrolling
  "karb94/neoscroll.nvim",
  -- Better f
  "rhysd/clever-f.vim",
  -- Improved url opener
  "gabebw/vim-github-link-opener",
  -- Smart sort that supports yaml dicts
  { "sQVe/sort.nvim", config = true },
  -- Extend % to support words
  "andymass/vim-matchup",
  -- Simplify the macro syntax
  { "chrisgrieser/nvim-recorder", config = true },
  -- Disable mini.pairs for now, it's drivin' me nuts
  -- { "echasnovski/mini.pairs", enabled = false },
  -- I'm old and cranky, and leap stealing x in visual mode is driving me nuts.
  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
}
