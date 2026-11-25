return {
  "xheisenbugx/org.nvim",
  main = "org",
  lazy = false, -- startup cost is small: heavy modules load on first use
  opts = {
    org_directory = "~/org",
    agenda_files = { "~/org/**/*.org" },
    default_notes_file = "~/org/refile.org",
  },
  -- {
  --   "nvim-orgmode/orgmode",
  --   dependencies = {
  --     { "akinsho/org-bullets.nvim" },
  --   },
  --   event = "VeryLazy",
  --   ft = { "org" },
  --   config = function()
  --     -- Setup orgmode
  --     require("orgmode").setup({
  --       org_agenda_files = "~/org/**/*",
  --       org_default_notes_file = "~/org/refile.org",
  --     })
  --
  --     require("org-bullets").setup()
  --   end,
  -- },
}
