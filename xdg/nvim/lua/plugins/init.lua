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
