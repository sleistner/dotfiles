-- LSP setup using Neovim 0.11's native vim.lsp.config / vim.lsp.enable API.
-- nvim-lspconfig ships per-server presets under `lsp/<name>.lua`; we use
-- those as the base and override only what we need.

-- NvChad's defaults() sets up lua_ls and registers the keybindings
-- NvChad expects; keep calling it before configuring our own servers.
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

-- Global defaults applied to every vim.lsp.enable'd server.
vim.lsp.config("*", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Servers that work with nvim-lspconfig's defaults (install the binaries
-- via :MasonInstall <pkg> or your distro).
local servers = {
  -- Frontend
  "html",
  "cssls",
  -- Backend
  "ruby_lsp",
  -- Config / data
  "bashls",
  "jsonls",
  "yamlls",
  -- rust_analyzer is auto-configured by rustaceanvim — don't enable here.
}

for _, name in ipairs(servers) do
  vim.lsp.enable(name)
end

-- TypeScript + Vue 3 (Volar 2.x hybrid mode). ts_ls handles .ts/.js/.vue
-- with Volar's TS plugin piggy-backing; vue_ls handles SFC-specific
-- features (template expressions, <script setup> macros, scoped CSS).
local mason_pkgs = vim.fn.stdpath "data" .. "/mason/packages"
local vue_ts_plugin = mason_pkgs .. "/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("ts_ls", {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_ts_plugin,
        languages = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
})
vim.lsp.enable "ts_ls"
vim.lsp.enable "vue_ls"
