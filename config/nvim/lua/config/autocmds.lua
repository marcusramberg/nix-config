-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "nix", "terraform", "helm" },
  callback = function()
    vim.opt.commentstring = "# %s"
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = vim.fn.expand("~") .. "/Source/{nimdow,nixpkgs,github_exporter}/*",
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.qml",
  callback = function()
    vim.bo.ft = "qml"
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt.textwidth = 80
    vim.opt.formatoptions:append("a")
  end,
})
