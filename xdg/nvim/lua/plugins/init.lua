return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
      return require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "github/copilot.vim",
    event = "InsertEnter",
  },

  -- Chat UI on top of the Copilot subscription. No extra API keys.
  -- Commands: :CopilotChat, :CopilotChatExplain, :CopilotChatFix, ...
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    cmd = {
      "CopilotChat",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatTests",
      "CopilotChatCommit",
    },
    opts = {
      debug = false,
    },
  },

  -- Claude Code inside nvim. Uses your `claude` CLI auth (Pro/Max
  -- subscription via `claude login`) — no separate API key needed.
  -- Opens Claude Code in an adjacent terminal and adds commands to
  -- send selections, add buffers/files to context, and accept/deny
  -- diffs it proposes.
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- UI primitives (input/select/picker/notifier). Used by claudecode.nvim
  -- and generally nice to have for modern plugin UX.
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
      "echasnovski/mini.pick", -- optional
    },
    config = true,
    cmd = "Neogit",
  },

  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  --   config = function()
  --     require("chatgpt").setup {
  --       api_key_cmd = "pass show api/tokens/openapi",
  --     }
  --   end,
  -- },

  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  {
    "saecki/crates.nvim",
    event = "BufRead",
    lazy = { "rust", "toml" },
    config = function()
      require("crates").setup {}
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    config = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "matze/vim-move",
    lazy = false,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        -- Config / docs
        "lua", "luadoc", "vim", "vimdoc", "markdown", "markdown_inline",
        "bash", "regex", "gitignore", "dockerfile",
        -- Frontend
        "javascript", "typescript", "tsx", "vue", "html", "css", "scss",
        -- Backend (embedded_template covers ERB)
        "ruby", "embedded_template", "rust", "go",
        -- Data
        "json", "yaml", "toml", "sql",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "zaldih/themery.nvim",
    cmd = "Themery",
    config = function()
      require("themery").setup {
        themes = {
          "catppuccin",
          "tokyonight",
          "gruvbox-material",
          "nightfox",
        },
        livePreview = true,
      }
    end,
  },

  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "folke/tokyonight.nvim", name = "tokyonight", lazy = true },
  { "sainnhe/gruvbox-material", name = "gruvbox-material", lazy = true },
  { "EdenEast/nightfox.nvim", name = "nightfox", lazy = true },
}
