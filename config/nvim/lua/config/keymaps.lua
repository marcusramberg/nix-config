-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -- Add any additional keymaps here
--
local keymap = vim.keymap.set
keymap({ "n", "v", "i" }, "<C-p>", function()
  require("snacks.picker").files({ cwd = require("lazyvim.util").root() })
end, { desc = "Open File Explorer (Git Root)" })
keymap("n", "U", "<C-r>", { desc = "Redo" })
keymap("n", "<leader>pp", function()
  Snacks.picker.projects({ dev = { "~/Source/reMarkable", "~/Source/" } })
end, { desc = "Switch Project" })
keymap("n", "<leader>gg", function()
  require("neogit").open({ cwd = require("lazyvim.util").root() })
end, { desc = "Neogit (Root Dir)" })
keymap("n", "<leader>gl", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })
keymap("n", "<leader>gG", "<cmd>Neogit cwd=.<cr>", { desc = "Neogit (cwd)" })
keymap("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Git Blame" })
keymap("n", "<leader>ot", "<cmd>Task<cr>", { desc = "Run task" })
vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- Octo nvim ideas
-- https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
keymap(
  "n",
  "<Leader>Gi",
  "<cmd>Octo search is:pr involves:@me state:open<cr>",
  { desc = "Octo » PRs involving me", silent = true }
)
keymap(
  "n",
  "<Leader>Gr",
  "<cmd>Octo search is:pr review:required state:open review-requested:@me<cr>",
  { desc = "Octo » PRs involving me", silent = true }
)
