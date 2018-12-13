let SessionLoad = 1
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
imap <C-BS> 
map! <S-Insert> *
vmap  "*d
nnoremap <silent>   :nohlsearch|:echo
nmap <silent> \w\m <Plug>VimwikiMakeTomorrowDiaryNote
nmap <silent> \w\y <Plug>VimwikiMakeYesterdayDiaryNote
nmap <silent> \w\t <Plug>VimwikiTabMakeDiaryNote
nmap <silent> \w\w <Plug>VimwikiMakeDiaryNote
nmap <silent> \w\i <Plug>VimwikiDiaryGenerateLinks
nmap <silent> \wi <Plug>VimwikiDiaryIndex
nmap <silent> \ws <Plug>VimwikiUISelect
nmap <silent> \wt <Plug>VimwikiTabIndex
nmap <silent> \ww <Plug>VimwikiIndex
vmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX
vnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())
vmap <C-Del> "*d
vmap <S-Del> "*d
vmap <C-Insert> "*y
vmap <S-Insert> "-d"*P
nmap <S-Insert> "*P
let &cpo=s:cpo_save
unlet s:cpo_save
set autoread
set background=dark
set backspace=2
set expandtab
set formatlistpat=^\\s*\\%(\\(-\\|\\*\\|#\\)\\|\\(\\C\\%(\\d\\+)\\|\\d\\+\\.\\|[ivxlcdm]\\+)\\|[IVXLCDM]\\+)\\|\\l\\{1,2})\\|\\u\\{1,2})\\)\\)\\)\\s\\+\\%(\\[\\([\ .oOX-]\\)\\]\\s\\)\\?
set guifont=Lucida_Console:h11:cANSI:qDRAFT
set guioptions=egt
set guitablabel=%N/\ %t\ %M
set helplang=En
set history=1000
set hlsearch
set ignorecase
set incsearch
set isfname=@,48-57,/,\\,.,-,_,+,,,#,$,%,{,},:,@-@,!,~,=
set runtimepath=~/vimfiles,~\\vimfiles\\bundle\\lightline.vim,~\\vimfiles\\bundle\\taglist,~\\vimfiles\\bundle\\vim-ps1,~\\vimfiles\\bundle\\vimwiki,C:\\Program\ Files\ (x86)\\Vim/vimfiles,C:\\Program\ Files\ (x86)\\Vim\\vim81,C:\\Program\ Files\ (x86)\\Vim/vimfiles/after,~/vimfiles/after
set shiftwidth=4
set showmatch
set softtabstop=4
set tabline=%!lightline#tabline()
set tabstop=4
set window=61
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd D:\rdnext\compute\fabric\hostagent\src\agent\agentcore
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +8186 main.cpp
badd +531 agentSettings.h
badd +1 Ex
badd +631 \rdnext\compute\fabric\hostagent\src\agent\AgentMonitoring\AgentMonitoring.cpp
badd +0 \rdnext\compute\fabric\hostagent\src\agent\AgentMonitoring\AgentMonitor.h
badd +0 \rdnext\compute\fabric\hostagent\src\agent\AgentMonitoring\AgentMonitoring.h
badd +6 ~\vimwiki\index.wiki
badd +13 ~\vimwiki\Tasks.wiki
badd +3136 agentSettings.cpp
badd +11 ~\vimwiki\HostAgent.wiki
badd +88 monitor.h
badd +184 monitor.cpp
badd +55 ~\.vimrc
badd +17 ~\vimwiki\Livesite.wiki
badd +1 ~\vimwiki\FcShell.wiki
badd +58 \rdnext\compute\fabric\hostagent\src\lib\ExtendedDetails\src\ExtendedDetailErrors.h
badd +55 \rdnext\compute\fabric\hostagent\src\agent\lib\workqueue\ContainerWorkItems.cpp
badd +1619 agentcoresecurity.cpp
badd +8 ~\vimwiki\Coding\ Standard\ and\ Conventions.wiki
badd +6 ~\vimwiki\NodeService.wiki
badd +526 NodeServiceProvider.cpp
badd +3943 nodeserviceproviders\ContainerManagementProvider.cpp
badd +0 nodeserviceproviders\ContainerManagementProvider.h
badd +1 ~\vimwiki\C\ and\ C++.wiki
badd +35 ~\vimwiki\LX.wiki
badd +127 \rdnext\compute\fabric\hostagent\src\agent\unittests\NodeServiceProviderTest\NodeServiceProviderAgentCoreMock.cpp
badd +0 \rdnext\compute\fabric\hostagent\src\agent\unittests\NodeServiceProviderTest\ContainerManagementProviderTest.cpp
badd +1237 \rdnext\compute\fabric\hostagent\src\agent\VmBillingTest\VmBillingTest.cpp
argglobal
silent! argdel *
set stal=2
edit main.cpp
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
set relativenumber
setlocal relativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=4
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%{lightline#link()}%#LightlineLeft_active_0#%(\ %{lightline#mode()}\ %)%{(&paste)?\"|\":\"\"}%(\ %{&paste?\"PASTE\":\"\"}\ %)%#LightlineLeft_active_0_1#%#LightlineLeft_active_1#%(\ %R\ %)%{(&readonly)&&(1||(&modified||!&modifiable))?\"|\":\"\"}%(\ %t\ %)%{(&modified||!&modifiable)?\"|\":\"\"}%(\ %M\ %)%#LightlineLeft_active_1_2#%#LightlineMiddle_active#%=%#LightlineRight_active_2_3#%#LightlineRight_active_2#%(\ %{&ff}\ %)%{1||1?\"|\":\"\"}%(\ %{&fenc!=#\"\"?&fenc:&enc}\ %)%{1?\"|\":\"\"}%(\ %{&ft!=#\"\"?&ft:\"no\ ft\"}\ %)%#LightlineRight_active_1_2#%#LightlineRight_active_1#%(\ %3p%%\ %)%#LightlineRight_active_0_1#%#LightlineRight_active_0#%(\ %3l:%-2v\ %)
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 6093 - ((29 * winheight(0) + 30) / 61)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
6093
normal! 0
tabedit \rdnext\compute\fabric\hostagent\src\agent\AgentMonitoring\AgentMonitoring.cpp
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 142 + 142) / 284)
exe 'vert 2resize ' . ((&columns * 141 + 142) / 284)
argglobal
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
set relativenumber
setlocal relativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=4
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%{lightline#link()}%#LightlineLeft_active_0#%(\ %{lightline#mode()}\ %)%{(&paste)?\"|\":\"\"}%(\ %{&paste?\"PASTE\":\"\"}\ %)%#LightlineLeft_active_0_1#%#LightlineLeft_active_1#%(\ %R\ %)%{(&readonly)&&(1||(&modified||!&modifiable))?\"|\":\"\"}%(\ %t\ %)%{(&modified||!&modifiable)?\"|\":\"\"}%(\ %M\ %)%#LightlineLeft_active_1_2#%#LightlineMiddle_active#%=%#LightlineRight_active_2_3#%#LightlineRight_active_2#%(\ %{&ff}\ %)%{1||1?\"|\":\"\"}%(\ %{&fenc!=#\"\"?&fenc:&enc}\ %)%{1?\"|\":\"\"}%(\ %{&ft!=#\"\"?&ft:\"no\ ft\"}\ %)%#LightlineRight_active_1_2#%#LightlineRight_active_1#%(\ %3p%%\ %)%#LightlineRight_active_0_1#%#LightlineRight_active_0#%(\ %3l:%-2v\ %)
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 1293 - ((41 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1293
normal! 018|
lcd D:\rdnext\compute\fabric\hostagent\src\agent\agentcore
wincmd w
argglobal
if bufexists('D:\rdnext\compute\fabric\hostagent\src\agent\AgentMonitoring\AgentMonitoring.h') | buffer D:\rdnext\compute\fabric\hostagent\src\agent\AgentMonitoring\AgentMonitoring.h | else | edit D:\rdnext\compute\fabric\hostagent\src\agent\AgentMonitoring\AgentMonitoring.h | endif
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=4
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%{lightline#link()}%#LightlineLeft_inactive_0#%(\ %t\ %)%#LightlineLeft_inactive_0_1#%#LightlineMiddle_inactive#%=%#LightlineRight_inactive_1_2#%#LightlineRight_inactive_1#%(\ %3p%%\ %)%#LightlineRight_inactive_0_1#%#LightlineRight_inactive_0#%(\ %3l:%-2v\ %)
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 112 - ((7 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
112
normal! 0
lcd D:\rdnext\compute\fabric\hostagent\src\agent\agentcore
wincmd w
exe 'vert 1resize ' . ((&columns * 142 + 142) / 284)
exe 'vert 2resize ' . ((&columns * 141 + 142) / 284)
tabedit D:\rdnext\compute\fabric\hostagent\src\agent\AgentCore\agentSettings.cpp
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 142 + 142) / 284)
exe 'vert 2resize ' . ((&columns * 141 + 142) / 284)
argglobal
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\%(\\(-\\|\\*\\|#\\)\\|\\(\\C\\%(\\d\\+)\\|\\d\\+\\.\\|[ivxlcdm]\\+)\\|[IVXLCDM]\\+)\\|\\l\\{1,2})\\|\\u\\{1,2})\\)\\)\\)\\s\\+\\%(\\[\\([\ .oOX-]\\)\\]\\s\\)\\?
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=4
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%{lightline#link()}%#LightlineLeft_active_0#%(\ %{lightline#mode()}\ %)%{(&paste)?\"|\":\"\"}%(\ %{&paste?\"PASTE\":\"\"}\ %)%#LightlineLeft_active_0_1#%#LightlineLeft_active_1#%(\ %R\ %)%{(&readonly)&&(1||(&modified||!&modifiable))?\"|\":\"\"}%(\ %t\ %)%{(&modified||!&modifiable)?\"|\":\"\"}%(\ %M\ %)%#LightlineLeft_active_1_2#%#LightlineMiddle_active#%=%#LightlineRight_active_2_3#%#LightlineRight_active_2#%(\ %{&ff}\ %)%{1||1?\"|\":\"\"}%(\ %{&fenc!=#\"\"?&fenc:&enc}\ %)%{1?\"|\":\"\"}%(\ %{&ft!=#\"\"?&ft:\"no\ ft\"}\ %)%#LightlineRight_active_1_2#%#LightlineRight_active_1#%(\ %3p%%\ %)%#LightlineRight_active_0_1#%#LightlineRight_active_0#%(\ %3l:%-2v\ %)
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 3133 - ((35 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
3133
normal! 014|
lcd D:\rdnext\compute\fabric\hostagent\src\agent\agentcore
wincmd w
argglobal
if bufexists('D:\rdnext\compute\fabric\hostagent\src\agent\agentcore\agentSettings.h') | buffer D:\rdnext\compute\fabric\hostagent\src\agent\agentcore\agentSettings.h | else | edit D:\rdnext\compute\fabric\hostagent\src\agent\agentcore\agentSettings.h | endif
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tcq
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=4
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%{lightline#link()}%#LightlineLeft_inactive_0#%(\ %t\ %)%#LightlineLeft_inactive_0_1#%#LightlineMiddle_inactive#%=%#LightlineRight_inactive_1_2#%#LightlineRight_inactive_1#%(\ %3p%%\ %)%#LightlineRight_inactive_0_1#%#LightlineRight_inactive_0#%(\ %3l:%-2v\ %)
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 275 - ((32 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
275
normal! 032|
lcd D:\rdnext\compute\fabric\hostagent\src\agent\agentcore
wincmd w
exe 'vert 1resize ' . ((&columns * 142 + 142) / 284)
exe 'vert 2resize ' . ((&columns * 141 + 142) / 284)
tabedit ~\vimwiki\index.wiki
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 142 + 142) / 284)
exe 'vert 2resize ' . ((&columns * 141 + 142) / 284)
argglobal
let s:cpo_save=&cpo
set cpo&vim
inoremap <buffer> <expr> <S-Tab> vimwiki#tbl#kbd_shift_tab()
inoremap <buffer> <silent> <S-CR> :VimwikiReturn 2 2
nmap <buffer> <silent> 	 <Plug>VimwikiNextLink
vmap <buffer> <silent>  <Plug>VimwikiNormalizeLinkVisualCR
nmap <buffer> <silent>  <Plug>VimwikiFollowLink
vmap <buffer> <silent> + <Plug>VimwikiNormalizeLinkVisual
nmap <buffer> <silent> + <Plug>VimwikiNormalizeLink
nmap <buffer> <silent> - <Plug>VimwikiRemoveHeaderLevel
nmap <buffer> <silent> <D-CR> <Plug>VimwikiTabnewLink
nmap <buffer> <silent> = <Plug>VimwikiAddHeaderLevel
nnoremap <buffer> <silent> O :call vimwiki#lst#kbd_O()
nmap <buffer> <silent> [= <Plug>VimwikiGoToPrevSiblingHeader
nmap <buffer> <silent> [[ <Plug>VimwikiGoToPrevHeader
nmap <buffer> <silent> [u <Plug>VimwikiGoToParentHeader
nmap <buffer> <silent> \wr <Plug>VimwikiRenameLink
nmap <buffer> <silent> \wd <Plug>VimwikiDeleteLink
nmap <buffer> \whh <Plug>Vimwiki2HTMLBrowse
nmap <buffer> \wh <Plug>Vimwiki2HTML
nmap <buffer> <silent> ]= <Plug>VimwikiGoToNextSiblingHeader
nmap <buffer> <silent> ]] <Plug>VimwikiGoToNextHeader
nmap <buffer> <silent> ]u <Plug>VimwikiGoToParentHeader
vnoremap <buffer> <silent> al :call vimwiki#lst#TO_list_item(0, 1)
onoremap <buffer> <silent> al :call vimwiki#lst#TO_list_item(0, 0)
vnoremap <buffer> <silent> ac :call vimwiki#base#TO_table_col(0, 1)
onoremap <buffer> <silent> ac :call vimwiki#base#TO_table_col(0, 0)
vnoremap <buffer> <silent> a\ :call vimwiki#base#TO_table_cell(0, 1)
onoremap <buffer> <silent> a\ :call vimwiki#base#TO_table_cell(0, 0)
vnoremap <buffer> <silent> aH :call vimwiki#base#TO_header(0, 1, v:count1)
onoremap <buffer> <silent> aH :call vimwiki#base#TO_header(0, 1, v:count1)
vnoremap <buffer> <silent> ah :call vimwiki#base#TO_header(0, 0, v:count1)
onoremap <buffer> <silent> ah :call vimwiki#base#TO_header(0, 0, v:count1)
nnoremap <buffer> gww :VimwikiTableAlignW
nnoremap <buffer> gqq :VimwikiTableAlignQ
noremap <buffer> <silent> gLA :VimwikiChangeSymbolInListTo A)
noremap <buffer> <silent> glA :VimwikiChangeSymbolTo A)
noremap <buffer> <silent> gLa :VimwikiChangeSymbolInListTo a)
noremap <buffer> <silent> gla :VimwikiChangeSymbolTo a)
noremap <buffer> <silent> gLI :VimwikiChangeSymbolInListTo I)
noremap <buffer> <silent> glI :VimwikiChangeSymbolTo I)
noremap <buffer> <silent> gLi :VimwikiChangeSymbolInListTo i)
noremap <buffer> <silent> gli :VimwikiChangeSymbolTo i)
noremap <buffer> <silent> gL1 :VimwikiChangeSymbolInListTo 1.
noremap <buffer> <silent> gl1 :VimwikiChangeSymbolTo 1.
noremap <buffer> <silent> gL# :VimwikiChangeSymbolInListTo #
noremap <buffer> <silent> gl# :VimwikiChangeSymbolTo #
noremap <buffer> <silent> gL\* :VimwikiChangeSymbolInListTo \*
noremap <buffer> <silent> gl\* :VimwikiChangeSymbolTo \*
noremap <buffer> <silent> gL- :VimwikiChangeSymbolInListTo -
noremap <buffer> <silent> gl- :VimwikiChangeSymbolTo -
map <buffer> <silent> gL  <Plug>VimwikiRemoveCBInList
map <buffer> <silent> gl  <Plug>VimwikiRemoveSingleCB
map <buffer> <silent> gLL <Plug>VimwikiIncreaseLvlWholeItem
map <buffer> <silent> gLl <Plug>VimwikiIncreaseLvlWholeItem
map <buffer> <silent> gLH <Plug>VimwikiDecreaseLvlWholeItem
map <buffer> <silent> gLh <Plug>VimwikiDecreaseLvlWholeItem
map <buffer> <silent> gll <Plug>VimwikiIncreaseLvlSingleItem
map <buffer> <silent> glh <Plug>VimwikiDecreaseLvlSingleItem
nmap <buffer> <silent> gLR <Plug>VimwikiRenumberAllLists
nmap <buffer> <silent> gLr <Plug>VimwikiRenumberAllLists
nmap <buffer> <silent> glr <Plug>VimwikiRenumberList
vmap <buffer> <silent> glp <Plug>VimwikiDecrementListItem
nmap <buffer> <silent> glp <Plug>VimwikiDecrementListItem
vmap <buffer> <silent> gln <Plug>VimwikiIncrementListItem
nmap <buffer> <silent> gln <Plug>VimwikiIncrementListItem
vmap <buffer> <silent> glx <Plug>VimwikiToggleRejectedListItem
nmap <buffer> <silent> glx <Plug>VimwikiToggleRejectedListItem
vnoremap <buffer> <silent> il :call vimwiki#lst#TO_list_item(1, 1)
onoremap <buffer> <silent> il :call vimwiki#lst#TO_list_item(1, 0)
vnoremap <buffer> <silent> ic :call vimwiki#base#TO_table_col(1, 1)
onoremap <buffer> <silent> ic :call vimwiki#base#TO_table_col(1, 0)
vnoremap <buffer> <silent> i\ :call vimwiki#base#TO_table_cell(1, 1)
onoremap <buffer> <silent> i\ :call vimwiki#base#TO_table_cell(1, 0)
vnoremap <buffer> <silent> iH :call vimwiki#base#TO_header(1, 1, v:count1)
onoremap <buffer> <silent> iH :call vimwiki#base#TO_header(1, 1, v:count1)
vnoremap <buffer> <silent> ih :call vimwiki#base#TO_header(1, 0, v:count1)
onoremap <buffer> <silent> ih :call vimwiki#base#TO_header(1, 0, v:count1)
nnoremap <buffer> <silent> o :call vimwiki#lst#kbd_o()
nnoremap <buffer> <silent> <Plug>VimwikiGoToPrevSiblingHeader :call vimwiki#base#goto_sibling(-1)
nnoremap <buffer> <silent> <Plug>VimwikiGoToNextSiblingHeader :call vimwiki#base#goto_sibling(+1)
nnoremap <buffer> <silent> <Plug>VimwikiGoToPrevHeader :call vimwiki#base#goto_prev_header()
nnoremap <buffer> <silent> <Plug>VimwikiGoToNextHeader :call vimwiki#base#goto_next_header()
nnoremap <buffer> <silent> <Plug>VimwikiGoToParentHeader :call vimwiki#base#goto_parent_header()
nnoremap <buffer> <silent> <Plug>VimwikiRemoveHeaderLevel :call vimwiki#base#RemoveHeaderLevel()
nnoremap <buffer> <silent> <Plug>VimwikiAddHeaderLevel :call vimwiki#base#AddHeaderLevel()
nmap <buffer> <silent> <M-Right> <Plug>VimwikiTableMoveColumnRight
nmap <buffer> <silent> <M-Left> <Plug>VimwikiTableMoveColumnLeft
vmap <buffer> <silent> <C-Space> <Plug>VimwikiToggleListItem
nmap <buffer> <silent> <C-Space> <Plug>VimwikiToggleListItem
nmap <buffer> <silent> <C-Up> <Plug>VimwikiDiaryPrevDay
nmap <buffer> <silent> <C-Down> <Plug>VimwikiDiaryNextDay
nmap <buffer> <silent> <S-Tab> <Plug>VimwikiPrevLink
nmap <buffer> <silent> <BS> <Plug>VimwikiGoBackLink
nmap <buffer> <silent> <C-S-CR> <Plug>VimwikiTabnewLink
nmap <buffer> <silent> <C-CR> <Plug>VimwikiVSplitLink
nmap <buffer> <silent> <S-CR> <Plug>VimwikiSplitLink
imap <buffer> <silent>  <Plug>VimwikiDecreaseLvlSingleItem
inoremap <buffer> <expr> 	 vimwiki#tbl#kbd_tab()
imap <buffer> <silent>  <Plug>VimwikiListToggle
imap <buffer> <silent>  <Plug>VimwikiListPrevSymbol
imap <buffer> <silent> <NL> <Plug>VimwikiListNextSymbol
inoremap <buffer> <silent>  :VimwikiReturn 1 5
imap <buffer> <silent>  <Plug>VimwikiIncreaseLvlSingleItem
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=
setlocal commentstring=%%%s
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
set conceallevel=2
setlocal conceallevel=2
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'vimwiki'
setlocal filetype=vimwiki
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tcq
setlocal formatlistpat=^\\s*\\%(\\(-\\|\\*\\|#\\)\\|\\(\\C\\%(\\d\\+)\\|\\d\\+\\.\\|[ivxlcdm]\\+)\\|[IVXLCDM]\\+)\\|\\l\\{1,2})\\|\\u\\{1,2})\\)\\)\\)\\s\\+\\%(\\[\\([\ .oOX-]\\)\\]\\s\\)\\?
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=Complete_wikifiles
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
set relativenumber
setlocal relativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=4
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%{lightline#link()}%#LightlineLeft_active_0#%(\ %{lightline#mode()}\ %)%{(&paste)?\"|\":\"\"}%(\ %{&paste?\"PASTE\":\"\"}\ %)%#LightlineLeft_active_0_1#%#LightlineLeft_active_1#%(\ %R\ %)%{(&readonly)&&(1||(&modified||!&modifiable))?\"|\":\"\"}%(\ %t\ %)%{(&modified||!&modifiable)?\"|\":\"\"}%(\ %M\ %)%#LightlineLeft_active_1_2#%#LightlineMiddle_active#%=%#LightlineRight_active_2_3#%#LightlineRight_active_2#%(\ %{&ff}\ %)%{1||1?\"|\":\"\"}%(\ %{&fenc!=#\"\"?&fenc:&enc}\ %)%{1?\"|\":\"\"}%(\ %{&ft!=#\"\"?&ft:\"no\ ft\"}\ %)%#LightlineRight_active_1_2#%#LightlineRight_active_1#%(\ %3p%%\ %)%#LightlineRight_active_0_1#%#LightlineRight_active_0#%(\ %3l:%-2v\ %)
setlocal suffixesadd=.wiki
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'vimwiki'
setlocal syntax=vimwiki
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tags=./tags,tags,~\\vimwiki/.tags
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 16 - ((15 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
16
normal! 08|
wincmd w
argglobal
if bufexists('~\vimwiki\Tasks.wiki') | buffer ~\vimwiki\Tasks.wiki | else | edit ~\vimwiki\Tasks.wiki | endif
let s:cpo_save=&cpo
set cpo&vim
inoremap <buffer> <expr> <S-Tab> vimwiki#tbl#kbd_shift_tab()
inoremap <buffer> <silent> <S-CR> :VimwikiReturn 2 2
nmap <buffer> <silent> 	 <Plug>VimwikiNextLink
vmap <buffer> <silent>  <Plug>VimwikiNormalizeLinkVisualCR
nmap <buffer> <silent>  <Plug>VimwikiFollowLink
vmap <buffer> <silent> + <Plug>VimwikiNormalizeLinkVisual
nmap <buffer> <silent> + <Plug>VimwikiNormalizeLink
nmap <buffer> <silent> - <Plug>VimwikiRemoveHeaderLevel
nmap <buffer> <silent> <D-CR> <Plug>VimwikiTabnewLink
nmap <buffer> <silent> = <Plug>VimwikiAddHeaderLevel
nnoremap <buffer> <silent> O :call vimwiki#lst#kbd_O()
nmap <buffer> <silent> [= <Plug>VimwikiGoToPrevSiblingHeader
nmap <buffer> <silent> [[ <Plug>VimwikiGoToPrevHeader
nmap <buffer> <silent> [u <Plug>VimwikiGoToParentHeader
nmap <buffer> <silent> \wr <Plug>VimwikiRenameLink
nmap <buffer> <silent> \wd <Plug>VimwikiDeleteLink
nmap <buffer> \whh <Plug>Vimwiki2HTMLBrowse
nmap <buffer> \wh <Plug>Vimwiki2HTML
nmap <buffer> <silent> ]= <Plug>VimwikiGoToNextSiblingHeader
nmap <buffer> <silent> ]] <Plug>VimwikiGoToNextHeader
nmap <buffer> <silent> ]u <Plug>VimwikiGoToParentHeader
vnoremap <buffer> <silent> al :call vimwiki#lst#TO_list_item(0, 1)
onoremap <buffer> <silent> al :call vimwiki#lst#TO_list_item(0, 0)
vnoremap <buffer> <silent> ac :call vimwiki#base#TO_table_col(0, 1)
onoremap <buffer> <silent> ac :call vimwiki#base#TO_table_col(0, 0)
vnoremap <buffer> <silent> a\ :call vimwiki#base#TO_table_cell(0, 1)
onoremap <buffer> <silent> a\ :call vimwiki#base#TO_table_cell(0, 0)
vnoremap <buffer> <silent> aH :call vimwiki#base#TO_header(0, 1, v:count1)
onoremap <buffer> <silent> aH :call vimwiki#base#TO_header(0, 1, v:count1)
vnoremap <buffer> <silent> ah :call vimwiki#base#TO_header(0, 0, v:count1)
onoremap <buffer> <silent> ah :call vimwiki#base#TO_header(0, 0, v:count1)
nnoremap <buffer> gww :VimwikiTableAlignW
nnoremap <buffer> gqq :VimwikiTableAlignQ
noremap <buffer> <silent> gLA :VimwikiChangeSymbolInListTo A)
noremap <buffer> <silent> glA :VimwikiChangeSymbolTo A)
noremap <buffer> <silent> gLa :VimwikiChangeSymbolInListTo a)
noremap <buffer> <silent> gla :VimwikiChangeSymbolTo a)
noremap <buffer> <silent> gLI :VimwikiChangeSymbolInListTo I)
noremap <buffer> <silent> glI :VimwikiChangeSymbolTo I)
noremap <buffer> <silent> gLi :VimwikiChangeSymbolInListTo i)
noremap <buffer> <silent> gli :VimwikiChangeSymbolTo i)
noremap <buffer> <silent> gL1 :VimwikiChangeSymbolInListTo 1.
noremap <buffer> <silent> gl1 :VimwikiChangeSymbolTo 1.
noremap <buffer> <silent> gL# :VimwikiChangeSymbolInListTo #
noremap <buffer> <silent> gl# :VimwikiChangeSymbolTo #
noremap <buffer> <silent> gL\* :VimwikiChangeSymbolInListTo \*
noremap <buffer> <silent> gl\* :VimwikiChangeSymbolTo \*
noremap <buffer> <silent> gL- :VimwikiChangeSymbolInListTo -
noremap <buffer> <silent> gl- :VimwikiChangeSymbolTo -
map <buffer> <silent> gL  <Plug>VimwikiRemoveCBInList
map <buffer> <silent> gl  <Plug>VimwikiRemoveSingleCB
map <buffer> <silent> gLL <Plug>VimwikiIncreaseLvlWholeItem
map <buffer> <silent> gLl <Plug>VimwikiIncreaseLvlWholeItem
map <buffer> <silent> gLH <Plug>VimwikiDecreaseLvlWholeItem
map <buffer> <silent> gLh <Plug>VimwikiDecreaseLvlWholeItem
map <buffer> <silent> gll <Plug>VimwikiIncreaseLvlSingleItem
map <buffer> <silent> glh <Plug>VimwikiDecreaseLvlSingleItem
nmap <buffer> <silent> gLR <Plug>VimwikiRenumberAllLists
nmap <buffer> <silent> gLr <Plug>VimwikiRenumberAllLists
nmap <buffer> <silent> glr <Plug>VimwikiRenumberList
vmap <buffer> <silent> glp <Plug>VimwikiDecrementListItem
nmap <buffer> <silent> glp <Plug>VimwikiDecrementListItem
vmap <buffer> <silent> gln <Plug>VimwikiIncrementListItem
nmap <buffer> <silent> gln <Plug>VimwikiIncrementListItem
vmap <buffer> <silent> glx <Plug>VimwikiToggleRejectedListItem
nmap <buffer> <silent> glx <Plug>VimwikiToggleRejectedListItem
vnoremap <buffer> <silent> il :call vimwiki#lst#TO_list_item(1, 1)
onoremap <buffer> <silent> il :call vimwiki#lst#TO_list_item(1, 0)
vnoremap <buffer> <silent> ic :call vimwiki#base#TO_table_col(1, 1)
onoremap <buffer> <silent> ic :call vimwiki#base#TO_table_col(1, 0)
vnoremap <buffer> <silent> i\ :call vimwiki#base#TO_table_cell(1, 1)
onoremap <buffer> <silent> i\ :call vimwiki#base#TO_table_cell(1, 0)
vnoremap <buffer> <silent> iH :call vimwiki#base#TO_header(1, 1, v:count1)
onoremap <buffer> <silent> iH :call vimwiki#base#TO_header(1, 1, v:count1)
vnoremap <buffer> <silent> ih :call vimwiki#base#TO_header(1, 0, v:count1)
onoremap <buffer> <silent> ih :call vimwiki#base#TO_header(1, 0, v:count1)
nnoremap <buffer> <silent> o :call vimwiki#lst#kbd_o()
nnoremap <buffer> <silent> <Plug>VimwikiGoToPrevSiblingHeader :call vimwiki#base#goto_sibling(-1)
nnoremap <buffer> <silent> <Plug>VimwikiGoToNextSiblingHeader :call vimwiki#base#goto_sibling(+1)
nnoremap <buffer> <silent> <Plug>VimwikiGoToPrevHeader :call vimwiki#base#goto_prev_header()
nnoremap <buffer> <silent> <Plug>VimwikiGoToNextHeader :call vimwiki#base#goto_next_header()
nnoremap <buffer> <silent> <Plug>VimwikiGoToParentHeader :call vimwiki#base#goto_parent_header()
nnoremap <buffer> <silent> <Plug>VimwikiRemoveHeaderLevel :call vimwiki#base#RemoveHeaderLevel()
nnoremap <buffer> <silent> <Plug>VimwikiAddHeaderLevel :call vimwiki#base#AddHeaderLevel()
nmap <buffer> <silent> <M-Right> <Plug>VimwikiTableMoveColumnRight
nmap <buffer> <silent> <M-Left> <Plug>VimwikiTableMoveColumnLeft
vmap <buffer> <silent> <C-Space> <Plug>VimwikiToggleListItem
nmap <buffer> <silent> <C-Space> <Plug>VimwikiToggleListItem
nmap <buffer> <silent> <C-Up> <Plug>VimwikiDiaryPrevDay
nmap <buffer> <silent> <C-Down> <Plug>VimwikiDiaryNextDay
nmap <buffer> <silent> <S-Tab> <Plug>VimwikiPrevLink
nmap <buffer> <silent> <BS> <Plug>VimwikiGoBackLink
nmap <buffer> <silent> <C-S-CR> <Plug>VimwikiTabnewLink
nmap <buffer> <silent> <C-CR> <Plug>VimwikiVSplitLink
nmap <buffer> <silent> <S-CR> <Plug>VimwikiSplitLink
imap <buffer> <silent>  <Plug>VimwikiDecreaseLvlSingleItem
inoremap <buffer> <expr> 	 vimwiki#tbl#kbd_tab()
imap <buffer> <silent>  <Plug>VimwikiListToggle
imap <buffer> <silent>  <Plug>VimwikiListPrevSymbol
imap <buffer> <silent> <NL> <Plug>VimwikiListNextSymbol
inoremap <buffer> <silent>  :VimwikiReturn 1 5
imap <buffer> <silent>  <Plug>VimwikiIncreaseLvlSingleItem
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=
setlocal commentstring=%%%s
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
set conceallevel=2
setlocal conceallevel=2
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'vimwiki'
setlocal filetype=vimwiki
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tqn
setlocal formatlistpat=^\\s*\\%(\\(-\\|\\*\\|#\\)\\|\\(\\C\\%(\\d\\+)\\|\\d\\+\\.\\|[ivxlcdm]\\+)\\|[IVXLCDM]\\+)\\|\\l\\{1,2})\\|\\u\\{1,2})\\)\\)\\)\\s\\+\\%(\\[\\([\ .oOX-]\\)\\]\\s\\)\\?
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=Complete_wikifiles
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=4
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%{lightline#link()}%#LightlineLeft_inactive_0#%(\ %t\ %)%#LightlineLeft_inactive_0_1#%#LightlineMiddle_inactive#%=%#LightlineRight_inactive_1_2#%#LightlineRight_inactive_1#%(\ %3p%%\ %)%#LightlineRight_inactive_0_1#%#LightlineRight_inactive_0#%(\ %3l:%-2v\ %)
setlocal suffixesadd=.wiki
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'vimwiki'
setlocal syntax=vimwiki
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tags=./tags,tags,~\\vimwiki/.tags
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 11 - ((10 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
11
normal! 075|
wincmd w
exe 'vert 1resize ' . ((&columns * 142 + 142) / 284)
exe 'vert 2resize ' . ((&columns * 141 + 142) / 284)
tabnext 2
set stal=1
if exists('s:wipebuf') && s:wipebuf != bufnr('%')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
