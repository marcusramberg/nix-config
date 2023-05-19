-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "nix", "terraform" },
	callback = function()
		vim.opt.commentstring = "# %s"
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = vim.fn.expand("~") .. "/Source/{nimdow,nixpkgs}/*",
	callback = function()
		vim.b.autoformat = false
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*",
	callback = function()
		if vim.fn.search([[{{.\+}}]], "nw") ~= 0 then
			vim.bo.ft = "gotmpl"
		end
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt.textwidth = 120
	end,
})
