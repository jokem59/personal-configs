set statusline+=%F

set number                   "Show number lines

"filetype plugin on           " Setting required for proper syntax highlighting
syntax on                    " Setting to turn on syntax colors
colorscheme Monokai          " Setting to utilize the colorscheme

filetype plugin indent on    "show existeing tab with 4 spaces width
set tabstop=4		         "when indenting with '>', use 4 spaces
set shiftwidth=4	         "when indenting with tab, use 4 spaces
set expandtab
set clipboard=unnamedplus     "use the system clipboard as default yank/put register

set backspace=2              "backspace should work as intended
"Ctrl-Backspace deletes previous work like Ctrl-W (default)
imap <C-BS> <C-W>

set guioptions-=m            "remove menu bar
set guioptions-=T            "remove toolbar
set guioptions-=r            "remove right-hand scroll bar
set guioptions-=L            "remove left-hand scroll bar

