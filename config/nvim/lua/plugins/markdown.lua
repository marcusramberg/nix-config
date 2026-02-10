return {
  {
    "bngarren/checkmate.nvim",
    ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
    opts = {
      files = { "*.md" }, -- any .md file (instead of defaults)
      keys = {
        ["<leader>mm"] = {
          rhs = "<cmd>Checkmate toggle<CR>",
          desc = "Toggle todo item",
          modes = { "n", "v" },
        },
        ["<leader>mc"] = {
          rhs = "<cmd>Checkmate check<CR>",
          desc = "Set todo item as checked (done)",
          modes = { "n", "v" },
        },
        ["<leader>mu"] = {
          rhs = "<cmd>Checkmate uncheck<CR>",
          desc = "Set todo item as unchecked (not done)",
          modes = { "n", "v" },
        },
        ["<leader>m="] = {
          rhs = "<cmd>Checkmate cycle_next<CR>",
          desc = "Cycle todo item(s) to the next state",
          modes = { "n", "v" },
        },
        ["<leader>m-"] = {
          rhs = "<cmd>Checkmate cycle_previous<CR>",
          desc = "Cycle todo item(s) to the previous state",
          modes = { "n", "v" },
        },
        ["<leader>mn"] = {
          rhs = "<cmd>Checkmate create<CR>",
          desc = "Create todo item",
          modes = { "n", "v" },
        },
        ["<C-Enter>"] = {
          rhs = "<cmd>Checkmate create<CR>",
          desc = "Create todo item",
          modes = { "n", "v" },
        },
        ["<leader>mr"] = {
          rhs = "<cmd>Checkmate remove<CR>",
          desc = "Remove todo marker (convert to text)",
          modes = { "n", "v" },
        },
        ["<leader>mR"] = {
          rhs = "<cmd>Checkmate remove_all_metadata<CR>",
          desc = "Remove all metadata from a todo item",
          modes = { "n", "v" },
        },
        ["<leader>ma"] = {
          rhs = "<cmd>Checkmate archive<CR>",
          desc = "Archive checked/completed todo items (move to bottom section)",
          modes = { "n" },
        },
        ["<leader>mF"] = {
          rhs = "<cmd>Checkmate select_todo<CR>",
          desc = "Open a picker to select a todo from the current buffer",
          modes = { "n" },
        },
        ["<leader>mv"] = {
          rhs = "<cmd>Checkmate metadata select_value<CR>",
          desc = "Update the value of a metadata tag under the cursor",
          modes = { "n" },
        },
        ["<leader>m]"] = {
          rhs = "<cmd>Checkmate metadata jump_next<CR>",
          desc = "Move cursor to next metadata tag",
          modes = { "n" },
        },
        ["<leader>m["] = {
          rhs = "<cmd>Checkmate metadata jump_previous<CR>",
          desc = "Move cursor to previous metadata tag",
          modes = { "n" },
        },
      },
      metadata = {
        done = {
          key = "<leder>md",
        },
        started = {
          key = "<leader>ms",
        },
        priority = {
          key = "<leader>mp",
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "markdown-oxide" } },
    handlers = {
      markdown_oxide = function()
        vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
        require("lspconfig").markdown_oxide.setup({
          -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
          -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
          -- 		capabilities = vim.tbl_deep_extend("force", capabilities, {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
          on_attach = function(client, bufnr)
            -- your on_attach code here
            vim.api.nvim_create_user_command("Daily", function(args)
              local input = args.args

              vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
            end, { desc = "Open daily note", nargs = "*" })
          end,
        })
      end,
    },
  },
}
