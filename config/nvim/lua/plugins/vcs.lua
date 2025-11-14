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
          snack = true,
        },
        graph_style = "unicode",
        git_services = {
          ["code.bas.es"] = {
            pull_request = "https://${host}/${owner}/${repository}/compare/${branch_name}",
            commit = "https://${host}/${owner}/${repository}/commit/${oid}",
            tree = "https://${host}/${owner}/${repository}/src/branch/${branch_name}",
          },
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
