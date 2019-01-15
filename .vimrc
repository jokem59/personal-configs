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

set updatetime=100           "Git gutter update time set for 100ms delay

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

" Fzf related settings
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
