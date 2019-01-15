colorscheme Monokai          " Setting to utilize the colorscheme

set noshowmode               " Setting only if running lightline.vim
set nocompatible             " For vimwiki to work
set number                   "Show number lines
set relativenumber           " Show relative line numbers
set guifont=Lucida_Console:h11:cANSI:qDRAFT
set autoread                 " If another editor changes file, reload
set guitablabel=%N/\ %t\ %M  " Show tab numbers and (+) if file in tab has been edited

syntax on                    " Setting to turn on syntax colors
filetype plugin on           " Setting required for proper syntax highlighting

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
hi VimwikiHeader1 guifg=#FFB433
hi vimwikiHeader2 guifg=#33FFFF
hi VimwikiHeader3 guifg=#FFFF33
hi VimwikiHeader4 guifg=#33FF33
hi vimwikiHeader5 guifg=#FF77EF
hi vimwikiHeader6 guifg=#D033FF

" " Registering clangd LSP with asyncomplete
" let g:LanguageClient_serverCommands = {
"     \ 'cpp': ['clangd'],
"     \ }

" if executable('clangd')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'clangd',
"         \ 'cmd': {server_info->['clangd']},
"         \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
"         \ })
" endif

" " Asyncomplete tab completion
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" let g:asyncomplete_remove_duplicates = 1
" let g:asyncomplete_smart_completion = 1
" let g:asyncomplete_auto_popup = 1

" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')

" " for asyncomplete.vim log
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')
