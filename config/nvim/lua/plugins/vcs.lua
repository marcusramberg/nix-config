return {
  {
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup({
        use_magit_keybindings = true,
        integrations = {
          diffview = true,
        },
      })
    end,
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
  },
  { "akinsho/git-conflict.nvim", config = true },
  "f-person/git-blame.nvim",
  {
    "pwntester/octo.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
    config = true,
  },
}