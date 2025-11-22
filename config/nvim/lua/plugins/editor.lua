return {

  -- open with line (from syntax output and such)
  "wsdjeg/vim-fetch",
  -- return where you came from
  "farmergreg/vim-lastplace",
  -- Smart sort that supports yaml dicts
  { "sQVe/sort.nvim", config = true },
  -- Extend % to support words
  {
    "andymass/vim-matchup",
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
  },
  -- Simplify the macro syntax
  { "chrisgrieser/nvim-recorder", config = true },
  { "metakirby5/codi.vim" },
  {
    "chrishrb/gx.nvim",
    opts = {
      -- default browser to use, can be a string or a function that returns a string
      browser = "firefox",
      -- whether to open links in a new tab
      new_tab = true,
      -- whether to open links in a new window
      new_window = false,
      -- whether to open links in the background
      background = false,
      keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
      cmd = { "Browse" },
      init = function()
        vim.g.netrw_nogx = 1 -- disable netrw gx
      end,
    },
    enabled = true,
    config = true,
  },
  -- Autosave after a delay
  {
    "okuuva/auto-save.nvim",
    version = "*", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {},
  },
  {
    "ibhagwan/smartyank.nvim",
    config = function()
      require("smartyank").setup({ osc52 = { silent = true } })
    end,
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   dependencies = {
  --     { "ravitemer/mcphub.nvim" },
  --   },
  --   opts = function()
  --     local user = vim.env.USER or "User"
  --     user = user:sub(1, 1):upper() .. user:sub(2)
  --     return {
  --       auto_insert_mode = true,
  --       question_header = "  " .. user .. " ",
  --       answer_header = "  Copilot ",
  --       prompts = {
  --         GoPrompt = {
  --           system_prompt = "You are a go programmer, and need to resolve my requests with code. We're using the latest version of go. Be concise and to the point.",
  --           mapping = "<leader>acg",
  --           description = "Go Coder",
  --         },
  --         DevOpsPrompt = {
  --           system_prompt = "You are a DevOps engineer. Answer requests with concise, actionable solutions for automation, CI/CD, cloud infrastructure, and Linux systems.",
  --           mapping = "<leader>acd",
  --           description = "DevOps Expert",
  --         },
  --       },
  --       window = {
  --         width = 0.4,
  --       },
  --     }
  --   end,
  -- },
  {
    "ravitemer/mcphub.nvim",
    opts = {
      extensions = {
        copilotchat = {
          enabled = true,
          convert_tools_to_functions = true,
          convert_resources_to_functions = true,
          add_mcp_prefix = false,
        },
      },
    },
  },
  {
    "ducks/vimdeck.nvim",
    cmd = { "Vimdeck", "VimdeckFile" },
    opts = {
      use_figlet = true,
      center_slides = true,
    },
  },
  { "dasvh/taskfile.nvim", opts = {
    layout = "v",
    keymaps = {
      rerun = "<leader>or",
    },
  } },
}
