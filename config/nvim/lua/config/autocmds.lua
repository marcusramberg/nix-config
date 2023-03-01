-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "nix", "terraform" },
	callback = function()
		vim.opt.commentstring = "# %s"
	end,
})
vim.cmd([[autocmd BufNewFile,BufRead * if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl | endif]])
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--  callback = function()
--    vim.opt.filetype = "gotmpl"
--  end,
--})
