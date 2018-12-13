set noshowmode               " Setting only if running lightline.vim
set nocompatible             " For vimwiki to work
set number                   "Show number lines
set relativenumber           " Show relative line numbers
set guifont=Lucida_Console:h11:cANSI:qDRAFT
set autoread                 " If another editor changes file, reload
set guitablabel=%N/\ %t\ %M  " Show tab numbers and (+) if file in tab has been edited

syntax on                    " Setting to turn on syntax colors
filetype plugin on           " Setting required for proper syntax highlighting
colorscheme Monokai          " Setting to utilize the colorscheme

set ignorecase               " Setting for case insensitive search
set incsearch                " Setting to search as I type query
" Setting that highlights matches vs underlines
hi search gui=reverse
" Setting, after searcing, press space to remove all other highlights
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set hlsearch                 " Setting to highlight search item
set showmatch                " Setting to show matching braces

filetype plugin indent on    "show existeing tab with 4 spaces width
set tabstop=4		         "when indenting with '>', use 4 spaces
set softtabstop=4            "If tabbed, backspace will delete the 4 spaces
set shiftwidth=4	         "when indenting with tab, use 4 spaces
set expandtab

set backspace=2              "backspace should work as intended
"Ctrl-Backspace deletes previous work like Ctrl-W (default)
imap <C-BS> <C-W>

set guioptions-=m            "remove menu bar
set guioptions-=T            "remove toolbar
set guioptions-=r            "remove right-hand scroll bar
set guioptions-=L            "remove left-hand scroll bar

set history=1000

" This strips all trailing whitespace when saving
autocmd BufWritePre * :call StripTrailingWhitespace()

function! StripTrailingWhitespace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" Enables pathogen plugin
execute pathogen#infect()

" Set vimiwki syntax header coloring
hi VimwikiHeader1 guifg=#FF0000
hi VimwikiHeader2 guifg=#00FF00
hi VimwikiHeader3 guifg=#0000FF
