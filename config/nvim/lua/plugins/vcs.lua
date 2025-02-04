return {
  {
    "Neogitorg/neogit",
    config = function()
      require("neogit").setup({
        use_magit_keybindings = true,
        disable_builtin_notifications = true,
        disable_commit_confirmation = true,
        kind = "vsplit",
        integrations = {
          diffview = true,
        },
      })
    end,
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
  },
  { "akinsho/git-conflict.nvim", config = true },
  "APZelos/blamer.nvim",
  {
    "pwntester/octo.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("octo").setup({
        suppress_missing_scope = { projects_v2 = true },
      })
    end,
  },
}
