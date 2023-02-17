-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "nix", "terraform" },
  callback = function()
    vim.opt.commentstring = "# %s"
  end,
})
