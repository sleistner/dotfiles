require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map('n', '<F2>', vim.lsp.buf.rename, { desc = "Rename symbol" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
