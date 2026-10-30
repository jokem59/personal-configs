-- Neovim: vim keys, LazyVim-style <Space> groups, LSP for every installed server.
-- Requires Neovim >= 0.12 (built-in `vim.pack' plugin manager). Org/notes stay
-- in Emacs; this is a code editor only.
--
-- ~/.config/nvim symlinks here (setup.sh: setup_neovim), so `vim.pack' writes
-- its lockfile, nvim-pack-lock.json, into the repo -- commit it to pin plugins.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.plugins")
require("config.lsp")
require("config.keymaps")
