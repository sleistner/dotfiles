return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- Disable the default Tab mapping
      -- vim.g.copilot_no_tab_map = true

      -- Custom mappings
      -- vim.api.nvim_set_keymap("i", "<C-/>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      -- vim.api.nvim_set_keymap("i", "<C-K>", "copilot#Next()", { silent = true, expr = true })
      -- vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Previous()", { silent = true, expr = true })
    end,
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

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  {
    "zaldih/themery.nvim",
    lazy = false,
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

  { "catppuccin/nvim", name = "catppuccin" },
  { "folke/tokyonight.nvim", name = "tokyonight" },
  { "sainnhe/gruvbox-material", name = "gruvbox-material" },
  { "EdenEast/nightfox.nvim", name = "nightfox" },
}
