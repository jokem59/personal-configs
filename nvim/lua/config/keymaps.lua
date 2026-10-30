-- Vim keys everywhere, with a group-first <Space> layout following LazyVim's
-- conventions: <Space> + group letter + action (f find, s search, c code,
-- g git, b buffer, u toggles, w window). The most frequent actions also get
-- LazyVim's one-key shortcuts. which-key pops up each group's keys after a pause.

local fzf = require("fzf-lua")
local gitsigns = require("gitsigns")
local map = vim.keymap.set

-- Workspace root: the enclosing git repo, else cwd.
local function root()
  return vim.fs.root(0, ".git") or vim.uv.cwd()
end

-- Open a TUI (gitu) in its own tab; the tab closes when the program exits.
local function tab_term(cmd)
  vim.cmd.tabnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart(cmd, {
    term = true,
    cwd = root(),
    on_exit = function()
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    end,
  })
  vim.cmd.startinsert()
end

local function files_root() fzf.files({ cwd = root() }) end
local function grep_root() fzf.live_grep({ cwd = root() }) end

require("which-key").add({
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>gh", group = "hunks" },
  { "<leader>s", group = "search" },
  { "<leader>u", group = "toggle" },
  { "<leader>w", proxy = "<c-w>", group = "window" },
})

-- One-key shortcuts ----------------------------------------------------------
map("n", "<leader><space>", files_root, { desc = "Find files (root)" })
map("n", "<leader>/", grep_root, { desc = "Grep (root)" })
map("n", "<leader>,", fzf.buffers, { desc = "Switch buffer" })
map("n", "<leader>e", function() require("oil").open(root()) end, { desc = "Explorer (root)" })
map("n", "<leader>E", function() require("oil").open(vim.uv.cwd()) end, { desc = "Explorer (cwd)" })
map("n", "-", "<cmd>Oil<cr>", { desc = "Parent directory" })

-- f: find --------------------------------------------------------------------
map("n", "<leader>ff", files_root, { desc = "Files (root)" })
map("n", "<leader>fF", fzf.files, { desc = "Files (cwd)" })
map("n", "<leader>fd", function() fzf.files({ cwd = vim.fn.expand("%:p:h") }) end, { desc = "Files (buffer dir)" })
map("n", "<leader>fg", fzf.git_files, { desc = "Git-tracked files" })
map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })

-- s: search ------------------------------------------------------------------
map("n", "<leader>sg", grep_root, { desc = "Grep (root)" })
map("n", "<leader>sG", fzf.live_grep, { desc = "Grep (cwd)" })
map("n", "<leader>sw", fzf.grep_cword, { desc = "Word under cursor" })
map("x", "<leader>sw", fzf.grep_visual, { desc = "Selection" })
map("n", "<leader>sb", fzf.blines, { desc = "Buffer lines" })
map("n", "<leader>ss", fzf.lsp_document_symbols, { desc = "Symbols" })
map("n", "<leader>sS", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>sd", fzf.diagnostics_document, { desc = "Diagnostics" })
map("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
map("n", "<leader>sj", fzf.jumps, { desc = "Jumplist" })
map("n", "<leader>sm", fzf.marks, { desc = "Marks" })
map("n", "<leader>sk", fzf.keymaps, { desc = "Keymaps" })
map("n", "<leader>sh", fzf.helptags, { desc = "Help pages" })
map("n", "<leader>sC", fzf.commands, { desc = "Commands" })
map("n", "<leader>sc", fzf.command_history, { desc = "Command history" })
map("n", "<leader>sR", fzf.resume, { desc = "Resume last picker" })

-- c: code (LSP) --------------------------------------------------------------
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "x" }, "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- g: git ---------------------------------------------------------------------
map("n", "<leader>gg", function() tab_term({ "gitu" }) end, { desc = "gitu (Magit-style)" })
map("n", "<leader>gs", fzf.git_status, { desc = "Status (changed files)" })
map("n", "<leader>gl", fzf.git_commits, { desc = "Log" })
map("n", "<leader>gf", fzf.git_bcommits, { desc = "Log (current file)" })
map("n", "<leader>gb", gitsigns.blame_line, { desc = "Blame line" })
map("n", "<leader>gm", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame commit message" })
map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("x", "<leader>ghs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage lines" })
map("x", "<leader>ghr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset lines" })
map("n", "<leader>ghp", gitsigns.preview_hunk_inline, { desc = "Preview hunk" })
map("n", "]h", function() gitsigns.nav_hunk("next") end, { desc = "Next hunk" })
map("n", "[h", function() gitsigns.nav_hunk("prev") end, { desc = "Previous hunk" })

-- b: buffer ------------------------------------------------------------------
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Alternate buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- u: toggles -----------------------------------------------------------------
map("n", "<leader>uw", function() vim.wo.wrap = not vim.wo.wrap end, { desc = "Soft wrap" })
map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Diagnostics" })
map("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Inlay hints" })

-- System clipboard -----------------------------------------------------------
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+y$', { desc = "Yank to clipboard (to end of line)" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste clipboard after" })
map({ "n", "x" }, "<leader>P", '"+P', { desc = "Paste clipboard before" })

-- LSP gotos ------------------------------------------------------------------
-- LazyVim's set: gd/gD/gr/gI/gy, with K for hover (a Neovim default). gr replaces
-- Neovim's gr* defaults (grn/gra/grr/...) so it fires without waiting; rename
-- and code action are <Space>cr / <Space>ca.
for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
  for _, mode in ipairs({ "n", "x" }) do
    pcall(vim.keymap.del, mode, lhs)
  end
end
map("n", "gd", fzf.lsp_definitions, { desc = "Goto definition" })
map("n", "gD", fzf.lsp_declarations, { desc = "Goto declaration" })
map("n", "gy", fzf.lsp_typedefs, { desc = "Goto type definition" })
map("n", "gI", fzf.lsp_implementations, { desc = "Goto implementation" })
map("n", "gr", fzf.lsp_references, { desc = "References" })

-- Helix motions kept for muscle memory: line start / end / first non-blank.
map({ "n", "x", "o" }, "gh", "0", { desc = "Goto line start" })
map({ "n", "x", "o" }, "gl", "$", { desc = "Goto line end" })
map({ "n", "x", "o" }, "gs", "^", { desc = "Goto first non-blank" })

-- Misc -----------------------------------------------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
