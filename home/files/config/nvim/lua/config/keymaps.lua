-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -- Add any additional keymaps here
--
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>pp", "<cmd>Telescope project<cr>", { desc = "Switch Project" })
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
vim.keymap.set("n", "<leader>gG", "<cmd>Neogit cwd=.<cr>", { desc = "Neogit (cwd)" })
