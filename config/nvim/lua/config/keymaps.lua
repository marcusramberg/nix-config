-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -- Add any additional keymaps here
--
local keymap = vim.keymap.set
local cmp = require("cmp")
keymap({ "n", "v", "i" }, "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
keymap("n", "U", "<C-r>", { desc = "Redo" })
keymap("n", "<C-r>", "<cmd>Telescope oldfiles<cr>", { desc = "Find Files" })
keymap("n", "<leader>pp", "<cmd>Telescope project<cr>", { desc = "Switch Project" })
keymap("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
keymap("n", "<leader>gG", "<cmd>Neogit cwd=.<cr>", { desc = "Neogit (cwd)" })
keymap("i", "<C-CR>", function()
	cmp.complete()
end, { desc = "Complete" })
