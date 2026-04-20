-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Language servers with the default NvChad config. Install the actual
-- server binaries via Mason (:MasonInstall ...) or your distro.
local servers = {
  -- Frontend
  "html",
  "cssls",
  -- Backend
  "ruby_lsp",  -- Ruby (Shopify's; faster than solargraph)
  -- Config / data
  "bashls",
  "jsonls",
  "yamlls",
  -- rust_analyzer is auto-configured by rustaceanvim — don't list here.
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- TypeScript + Vue 3 (Volar 2.x hybrid mode).
-- ts_ls handles .ts/.js, with Volar's TS plugin piggy-backing so it
-- understands Vue SFCs. vue_ls handles the .vue-specific pieces (template
-- expressions, <script setup> macros, scoped CSS).
local mason_pkgs = vim.fn.stdpath "data" .. "/mason/packages"
local vue_ts_plugin = mason_pkgs .. "/vue-language-server/node_modules/@vue/language-server"

lspconfig.ts_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
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
}

lspconfig.vue_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}
