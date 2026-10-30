-- Editor options, mirroring helix/config.toml where Helix has an opinion.

local opt = vim.opt

-- Font for GUI front-ends (Neovide etc.); in a terminal Alacritty's Roboto Mono
-- applies. Size matches alacritty.toml.
opt.guifont = "Roboto Mono:h16"
opt.termguicolors = true

opt.number = true
opt.relativenumber = true       -- line-number = "relative"
opt.mouse = ""                  -- mouse = false
opt.signcolumn = "yes"          -- keep the gutter from jumping as diagnostics/git signs come and go
opt.cursorline = true
opt.scrolloff = 5
opt.showmode = false            -- lualine shows the mode
opt.laststatus = 3              -- one global statusline, like Helix

-- [editor.soft-wrap] enable = true
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- [editor.cursor-shape]: block in normal, bar in insert, underline in select (visual)
opt.guicursor = "n-c:block,i-ci-ve:ver25,v:hor20,r-cr-o:hor20"

-- 4-space indent (vimrc and the Helix C++ language entry)
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400            -- which-key popup delay, matches Emacs `which-key-idle-delay'
opt.completeopt = { "menu", "menuone", "noselect" }
opt.winborder = "rounded"       -- hover, signature help, diagnostic floats

-- Folds come from treesitter (config/plugins.lua) but start open; `za' toggles.
opt.foldlevelstart = 99

-- Emacs opens .inl in c++-mode (emacs/.emacs.d), Helix lists it under cpp.
vim.filetype.add({ extension = { inl = "cpp" } })

-- [editor.auto-save]: save when the terminal loses focus (tmux has
-- focus-events on), and 5 minutes after the last edit.
local function save_all()
  vim.cmd("silent! wall")
end

vim.api.nvim_create_autocmd("FocusLost", { callback = save_all })

local autosave_delay_ms = 300000
local autosave_timer = assert(vim.uv.new_timer())
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  callback = function()
    autosave_timer:stop()
    autosave_timer:start(autosave_delay_ms, 0, vim.schedule_wrap(save_all))
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})
