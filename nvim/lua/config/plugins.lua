-- Plugins, via Neovim's built-in `vim.pack'. `:lua vim.pack.update()' to update
-- (review the diff, then `:write' to apply); versions pin in nvim-pack-lock.json.
--
-- No Nerd Font is installed alongside Roboto Mono, so every plugin below has
-- its icons turned off rather than drawing tofu.

local gh = function(repo) return "https://github.com/" .. repo end

vim.pack.add({
  gh("Mofiqul/vscode.nvim"),                                   -- VS Code Dark+ (Helix dark_plus, Emacs doom-dark+)
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  gh("neovim/nvim-lspconfig"),                                 -- server defaults for vim.lsp.config (config/lsp.lua)
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") }, -- tagged so it fetches its prebuilt fuzzy matcher
  gh("ibhagwan/fzf-lua"),                                      -- Helix's pickers / Emacs's consult
  gh("folke/which-key.nvim"),
  gh("lewis6991/gitsigns.nvim"),                               -- Emacs git-gutter, Helix diff gutter + blame
  gh("nvim-lualine/lualine.nvim"),
  gh("stevearc/oil.nvim"),                                     -- dired-style directory editing
  gh("nvim-mini/mini.pairs"),                                  -- Helix auto-pairs
})

-- Theme --------------------------------------------------------------------
require("vscode").setup({ style = "dark" })
vim.cmd.colorscheme("vscode")

require("lualine").setup({
  options = {
    theme = "vscode",
    icons_enabled = false,
    section_separators = "",
    component_separators = "|",
    globalstatus = true,
  },
})

-- Treesitter ---------------------------------------------------------------
-- The `main' branch compiles parsers with the tree-sitter CLI (setup.sh
-- installs it). Installs are async and skip parsers already present.
local parsers = {
  "bash", "c", "cmake", "cpp", "css", "diff", "dockerfile", "git_config",
  "gitcommit", "go", "gomod", "html", "javascript", "json", "lua", "luau",
  "make", "markdown", "markdown_inline", "python", "query", "regex", "rust",
  "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}
if vim.fn.executable("tree-sitter") == 1 then
  require("nvim-treesitter").install(parsers)
else
  vim.notify("tree-sitter CLI not found; run setup.sh (setup_neovim) to get parsers", vim.log.levels.WARN)
end

-- Highlighting, indent and folds for any filetype with a parser.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then return end
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Completion ---------------------------------------------------------------
-- Helix-style: menu pops up as you type, Tab/S-Tab move through it, Enter
-- accepts only once something is selected (otherwise it's a plain newline).
require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
    documentation = { auto_show = true, auto_show_delay_ms = 300 },
    menu = { draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } } } },
  },
  signature = { enabled = true },
  fuzzy = { implementation = "prefer_rust" },
})

-- Pickers ------------------------------------------------------------------
-- [editor.file-picker] hidden = false, git-ignore = false: Helix lists dotfiles
-- and git-ignored files in both the file picker and global search. Flip this to
-- skip build output in large repos.
local show_ignored = true
local fd_extra = show_ignored and " --hidden --no-ignore --exclude .git" or ""
local rg_extra = show_ignored and " --hidden --no-ignore -g '!.git'" or ""

require("fzf-lua").setup({
  fzf_colors = true,                -- take colors from the theme
  defaults = { file_icons = false, git_icons = false },
  files = {
    fd_opts = "--color=never --type f --type l" .. fd_extra,
    rg_opts = "--color=never --files" .. rg_extra,
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096" .. rg_extra .. " -e",
  },
})
require("fzf-lua").register_ui_select()  -- code actions etc. use the picker

-- Misc ---------------------------------------------------------------------
require("which-key").setup({ preset = "helix", icons = { mappings = false } })
require("gitsigns").setup()
require("oil").setup({ columns = {}, view_options = { show_hidden = true } })
require("mini.pairs").setup()
