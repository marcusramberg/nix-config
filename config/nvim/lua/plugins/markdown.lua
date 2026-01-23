return {
  {
    "bngarren/checkmate.nvim",
    ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
    opts = {
      files = { "*.md" }, -- any .md file (instead of defaults)
    },
  },
}
