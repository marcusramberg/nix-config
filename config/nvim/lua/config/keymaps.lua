-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -- Add any additional keymaps here
--
local keymap = vim.keymap.set
keymap({ "n", "v", "i" }, "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Open File Explorer" })
keymap("n", "U", "<C-r>", { desc = "Redo" })
keymap("n", "<leader>pp", function()
  Snacks.picker.projects({ dev = { "~/Source/reMarkable", "~/Source/" } })
end, { desc = "Switch Project" })
keymap("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
keymap("n", "<leader>gl", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })
keymap("n", "<leader>gG", "<cmd>Neogit cwd=.<cr>", { desc = "Neogit (cwd)" })
keymap("n", "<leader>gb", "<cmd>BlamerToggle<cr>", { desc = "Toggle Blame" })
keymap("n", "<leader>ot", "<cmd>Task<cr>", { desc = "Run task" })
keymap("n", "<leader>ut", function()
  if vim.g.colors_name == "catppuccin-mocha" then
    vim.cmd.colorscheme("catppuccin-latte")
  else
    vim.cmd.colorscheme("catppuccin-mocha")
  end
end, { desc = "Toggle Light Theme" })
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
