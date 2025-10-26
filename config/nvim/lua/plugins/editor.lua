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
  -- {
  --   "ravitemer/mcphub.nvim",
  --   opts = {
  --     extensions = {
  --       copilotchat = {
  --         enabled = true,
  --         convert_tools_to_functions = true,
  --         convert_resources_to_functions = true,
  --         add_mcp_prefix = false,
  --       },
  --     },
  --   },
  -- },
  {
    "Vigemus/iron.nvim",
    cmd = {
      "IronRepl",
      "IronReplHere",
      "IronRestart",
      "IronSend",
      "IronFocus",
      "IronHide",
      "IronWatch",
      "IronAttach",
    },
    keys = {
      "<space>sc",
      "<space>sc",
      "<space>sf",
      "<space>sl",
      "<space>su",
      "<space>sm",
      "<space>mc",
      "<space>mc",
      "<space>md",
      "<space>s<cr>",
      "<space>s<space>",
      "<space>sq",
      "<space>cl",

      { "<space>rs", "<cmd>IronRepl<cr>" },
      { "<space>rr", "<cmd>IronRestart<cr>" },
      { "<space>rf", "<cmd>IronFocus<cr>" },
      { "<space>rh", "<cmd>IronHide<cr>" },
    },
    main = "iron.core", -- <== This informs lazy.nvim to use the entrypoint of `iron.core` to load the configuration.
    opts = {
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "fish" },
          },
        },
        -- How the repl window will be displayed
        -- See below for more information
        -- repl_open_cmd = require('iron.view').bottom(40),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_until_cursor = "<space>su",
        send_mark = "<space>sm",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = { italic = true },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    },
  },
}
