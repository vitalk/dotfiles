" File: .vimrc
" Author: Vital Kudzelka <vital.kudzelka@gmail.com>
" Last Modified: June 17, 2013


" Preamble {{{

set nocompatible               " just need
call pathogen#infect()         " runtime path manipulation

" }}}
" Basic options {{{

" Essential {{{

set shellcmdflag=-ic           " enable interactive shell
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set nobackup                   " do not keep a backup file
set noswapfile                 " don't create annoying swap files
set history=1000               " store a lot of cmd history
set gdefault                   " enable g flag on substitute
set hidden                     " don't have to save when switching buffers
set timeout timeoutlen=500     " map sequence timeout
set ttimeout ttimeoutlen=100   " key code timeout
set ttyfast                    " fast terminal connection
set autoread                   " reload while changed outside Vim
set autowrite
let mapleader=','              " use colon as mapleader
let maplocalleader='\'

" }}}
" UI {{{

set lazyredraw                 " don't redraw while executing macros
set nonumber                   " no line numbering
set ruler                      " show the cursor position all the time
set showcmd                    " display incomplete commands
set foldmethod=syntax          " fold based on syntax
set foldnestmax=3              " deepest fold is 3 levels
set nofoldenable               " don't fold by default
set term=screen-256color       " don't change background color inside tmux session
" wildmenus {{{

set wildmenu                   " enable ctrl-n and ctrl-p to scroll thru matches
set wildchar=<Tab>             " tab completion key
set wildmode=full              " make cmdline tab completion similar to bash
" wildignore: stuff to ignore when tab completing {{{

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*/tmp/*
set wildignore+=*.so
set wildignore+=*.sw?          " swap files
set wildignore+=*.py[co]       " python byte code
set wildignore+=*~             " backups

" }}}
" encoding menu {{{

menu Encoding.cp1251    :e ++enc=cp1251<CR>
menu Encoding.utf-8     :e ++enc=utf-8<CR>
menu Encoding.koi8-r    :e ++enc=koi8-r<CR>
menu Encoding.cp866     :e ++enc=cp866<CR>
map <F8> :emenu Encoding.<TAB>

" }}}

" }}}
" color scheme {{{

set background=light
if &t_Co > 2 || has("gui_running")
  syntax on
  colorscheme solarized
endif

" }}}
" mouse {{{

if has('mouse')
  set mouse=a                  " in many terminal emulators the mouse works just
                               " enable it
endif

" }}}

" }}}
" GUI {{{

set go-=T                          " hide GUI panel
set go-=rlL                        " remove all scrollbars except right one
set go=mgR                         " leave menu bar and right scroll
set guifont=Ubuntu\ Mono\ derivative\ Powerline:h15

"}}}
" Text formatting {{{

set textwidth=80     " wrap at 80 chars by default
set shiftwidth=4     " number of spaces used for (auto)indent
set softtabstop=4
set tabstop=4
set smarttab
set smartcase        " sometimes override ignorecase option
set expandtab        " expand tabs to spaces
set autoindent       " indents line relative to the line above it
" formatoptions: how automatic formatting is to be done {{{

set formatoptions+=t " auto-wrap text using textwidth
set formatoptions+=c " auto-wrap comments using textwidth
set formatoptions+=r " auto insert current comment leader after <Enter> in Insert
set formatoptions+=o " auto insert current comment leader after <o/O> in Normal
set formatoptions+=q " allow formatting of comments with "gq"
set formatoptions-=w " trail white space indicates paragraph continues next line
set formatoptions-=a " auto reformat of paragraphs when inserted or deleted
set formatoptions+=n " when formatting, recognize numbered lists
set formatoptions+=m " also break at a multi-byte character above 255
set formatoptions+=2 " when formatting, use second line's indent

" }}}

"}}}
" Visual cues {{{

if &t_Co > 2 || has('gui_running')
  syntax on                  " switch syntax highlighting on
  syntax sync fromstart      " syntax synchronization from file start
  set synmaxcol=600          " skip highlighting long lines
  set hlsearch               " switch on highlighting the last used search pattern
endif
set laststatus=2             " always show status line
set scrolloff=1000           " cursor line will always be in the middle of the window
set visualbell               " shut up
set list                     " display unprintable characters
set listchars=tab:¬·,trail:· " like tabs and trailing spaces
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:×
set showbreak=↪\             " starts wrapped lines at this char
set fillchars=diff:·,fold:·
if v:version >= 703
  set colorcolumn=+1           " mark the ideal max text width
endif

" }}}
" Search {{{

set incsearch        " do incremental searching
set ignorecase       " search is case insensitive when search term is all lower case

" }}}
" Spell {{{

set nospell " no spelling by default
set spelllang=ru_yo,en_us
set spellsuggest=7

" }}}
" WTF {{{

" System copypaste {{{

set clipboard=unnamed        " allow vim commands to copy to system clipboard
if has("unix") && v:version >= 703
  set clipboard+=unnamedplus " use clipboard register in linux when supported
endif

" }}}
set iskeyword+=.
set complete=.,t,i,b,w,k " keyword completion configuration

" file encodings
set encoding=utf8
set termencoding=utf8
set fileencodings=utf8,cp1251

" switch keymap
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

set matchpairs+=<:> " useful bracket for html

" }}}

" }}}
" Abbreviations {{{

iab ME Vital Kudzelka <vital.kudzelka@gmail.com>
iab NOW <C-R>=strftime('%B %d, %Y')<CR>

" }}}
" Key bindings {{{

" File quick nav {{{

" .vimrc edit {{{

" open .vimrc
nnoremap <LocalLeader>ev :e $MYVIMRC<CR>
nnoremap <LocalLeader>sv :so $MYVIMRC<CR>

" }}}
" nmap <Tab> %
noremap H ^
noremap L $
vnoremap L g_
" keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" Visual mode *# search/replace {{{

" save the visual selected text as last search pattern
function! VisualSelection() range " {{{
  let l:original = @@
  normal! gvy
  let l:pattern = escape(@@, '\\/.$^*~[]')
  let @/ = '\V'.substitute(l:pattern, '\n', '\\n', 'g')
  let @@ = l:original
endfunction " }}}

vnoremap * :call VisualSelection()<CR>//<CR>
vnoremap # :call VisualSelection()<CR>??<CR>
vnoremap <Leader>r :call VisualSelection()<CR>:%s///<left>

" }}}
" expand to current file dir
cnoremap %% <C-R>=expand('%:h').'/'<CR>
" open in new buffer
map <Leader>ew :e %%
" open in split pane
map <Leader>es :sp %%
" open in vertical split pane
map <Leader>ev :vsp %%
" open in new tab
map <Leader>et :tabe %%
" open TODO list for project
noremap <Leader>t :noautocmd vimgrep /TODO/j **/*<CR>:cw<CR>
" open vimgrep and open cursor in the right position
map <Leader>vg :vimgrep // **/*<left><left><left><left><left><left>

" }}}
" File edit {{{

" insert new line
nnoremap <Enter> o<Esc>
" delete a line without adding it to the any register
nnoremap <Leader>d "_d
vnoremap <Leader>d "_d
" select all
nnoremap vaa ggvGg_
" select current line excluding identation
nmap vv ^vg_
" duplicate line
vnoremap D y'>p
" keep cursor in place while joining lines
nnoremap J mzJ`z
" start substitution
nnoremap <Leader>s :%s//<left>
vnoremap <Leader>s :s//<left>
" cleanup trailing spaces
nnoremap <Leader>w mz:%s/\s\+$//<CR>:let @/=''<CR>`z
" write through sudo
cnoremap w!! w !sudo dd of=%
" uppercase the world under cursor
" nnoremap <C-u> gUiw`]
" inoremap <C-u> <Esc><C-u>a
" quick fix the last error under cursor
imap <C-f> <Esc>[s1z=`]a
nmap <C-f> [s1z=<C-o>
" global copy/paste
vmap <C-C> "+y
imap <C-V> <Esc>"+p
" copy line under cursor excluding indentation
nmap <Leader>y mz^vg_y`z
" Ctrl+s
map <C-s> <Esc>:w<CR>
imap <C-s> <Esc>:w<CR>
" yank to end of the line
nnoremap Y y$
" move line up/down
nmap <C-up> ddkP
nmap <C-down> ddp
" move multiple lines up/down
vmap <C-up> xkP`[V`]
vmap <C-down> xp`[V`]
" panic button
nnoremap <F9> mzggg?G`z
" reformat the current paragraph or selected text
nnoremap Q gqip
vnoremap Q gq
" quick reindent selected text
" vmap <Tab> >gv
" vmap <S-Tab> <gv
" TODO: keep this line?
map ,a o<Esc>:r!date +'\%A, \%B \%d, \%Y'<CR>:r!date +'\%A, \%B \%d, \%Y' \| sed 's/./-/g'<CR>A<CR><ESC>

" }}}
" UI {{{

" clear the last used search pattern
nnoremap <Esc><Esc> :let @/=""<CR>

nnoremap <LocalLeader>c :call <SID>toggle('cursorline')<CR>
nnoremap <LocalLeader>h :call <SID>toggle('hlsearch')<CR>
nnoremap <LocalLeader>n :call <SID>toggle('number')<CR>
nnoremap <LocalLeader>p :call <SID>toggle('paste')<CR>
nnoremap <LocalLeader>s :call <SID>toggle('spell')<CR>
nnoremap <LocalLeader>i :call <SID>toggle('list')<CR>

" }}}
" Buffers/windows{{{

" moves up/down when line wraps
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
" list buffers
nmap <Leader>bl <Esc>:ls<CR>
" change buffer next/prev
map <Leader>bn <Esc>:bn<CR>
map <Leader>bp <Esc>:bp<CR>
" delete current buffer
map <C-C><C-C> :bd<CR>
" moving between buffers
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" resize current buffer by +/- 5
map <A-left> :vertical resize -5<CR>
map <A-down> :resize +5<cr>
map <A-up> :resize -5<cr>
map <A-right> :vertical resize +5<CR>

" }}}
" Tabs {{{

map <Tab> gt
map <S-Tab> gT
map <C-T> :tabnew<CR>
" close open tab
map <C-W><C-X> :tabclose<CR>
" ff-like tab switching
map 0 :tablast<CR>
imap 0 <Esc>:tablast<CR>
map 1 :tabnext 1<CR>
imap 1 <Esc>:tabnext 1<CR>
map 2 :tabnext 2<CR>
imap 2 <Esc>:tabnext 2<CR>
map 3 :tabnext 3<CR>
imap 3 <Esc>:tabnext 3<CR>
map 4 :tabnext 4<CR>
imap 4 <Esc>:tabnext 4<CR>
map 5 :tabnext 5<CR>
imap 5 <Esc>:tabnext 5<CR>
map 6 :tabnext 6<CR>
imap 6 <Esc>:tabnext 6<CR>
map 7 :tabnext 7<CR>
imap 7 <Esc>:tabnext 7<CR>
map 8 :tabnext 8<CR>
imap 8 <Esc>:tabnext 8<CR>
map 9 :tabnext 9<CR>
imap 9 <Esc>:tabnext 9<CR>

" }}}
" Folding {{{

" open/close fold under cursor
nnoremap <Space> za

" }}}
" Evil-mode: emacs bindings {{{

" emacs bindings in command line mode
cnoremap <C-e> <End>
cnoremap <C-a> <Home>
" save changes
nmap <C-x><C-s> :w<CR>
imap <C-x><C-s> <Esc>:w<CR>
" close without saves
map <C-X><C-C> :qall!<CR>

" }}}
" Shell: git {{{

" show first commit where term under cursor was added
map <Leader>1 :!git log --reverse -p -S <cword> %<CR>
map <Leader>gd :!git diff<CR>
map <Leader>gs :!git status<CR>
map <Leader>gdd :!git diff --cached<CR>

" }}}

" }}}
" Functions {{{

fun! s:toggle(option) " {{{ toggle option and echo current state
  exe 'let &' . a:option . '= !&' . a:option
  exe 'let enabled = ' . '&' . a:option
  if enabled
    echo a:option . ' on'
  else
    echo a:option . ' off'
  endif
endf " }}}
fun! s:activate_venv() " {{{ activate the virtualenv in the embedded
" interpreter for omnicomplete and other things like that.
python << EOF
import os
virtualenv = os.environ.get('VIRTUAL_ENV')
if virtualenv:
  activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py')
  if os.path.exists(activate_this):
    execfile(activate_this, dict(__file__=activate_this))
EOF
endf " }}}
call <SID>activate_venv()

fun! s:define(name, value) " {{{ define variable before set value to it
  if !exists(a:name)
    let {a:name} = a:value
  endif
endf " }}}

" }}}
" Plugin settings {{{

" timestamp {{{

let g:timestamp_regexp = '\v\c%("\s*[lL]ast %([cC]hanged?|[mM]odified):\s+)@<=\a+ \d{2}, \d{4}'
let g:timestamp_rep = '%B %d, %Y'
let g:timestamp_modelines = 13

" }}}
" solarize {{{

set background=light
let g:solarized_termcolors = 256
let g:solarized_contrast   = "high"
let g:solarized_visibility = "high"

" }}}
" lesscss {{{

" save css files to separate css folder (relative to original less)
let g:lesscss_save_to = '../css/'
" enable compression
let g:lesscss_cmd = '/usr/bin/env lessc -x --yui-compress'

"}}}
" snipmate snippets {{{

let g:snips_author = 'Vital Kudzelka'       " override default snipmate author

"}}}
" ctrlp {{{

let g:ctrlp_cmd = 'CtrlPLastMode'               " open ctrlp in the last mode used
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'   " set the directory to store the cache files
let g:ctrlp_clear_cache_on_exit = 0             " enable cross-session caching
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|eggs|*\.py[co]|*\.sw[po])$'

"}}}
" Powerline {{{

set rtp+=~/.powerline/powerline/bindings/vim
let g:Powerline_symbols='fancy' " fancy powerline symbols

" }}}
" neocomplcache {{{

" settings {{{

let g:neocomplcache_enable_at_startup = 1 " use neocomplcache at starup
let g:neocomplcache_enable_smart_case = 1 " use smartcase
let g:neocomplcache_enable_camel_case_completion = 1 " use camel case completion
let g:neocomplcache_enable_underbar_completion = 1 " use underbar completion
let g:neocomplcache_min_syntax_length = 3 " set minimum syntax keyword length
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended)
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
" Enable heavy omni completion
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" disable auto select first candidate in popup menu [1] {{{

let g:neocomplcache_enable_auto_select = 1

call <SID>define('g:neocomplcache_force_omni_patterns', {})
let g:neocomplcache_force_omni_patterns.python = '[^. \t]\.\w*'

call <SID>define('g:neocomplcache_omni_functions', {})
let g:neocomplcache_omni_functions['python'] = 'jedi#complete'

" }}}

" }}}
" mappings {{{

inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"

" }}}

" }}}
" jedi-vim {{{

let g:jedi#goto_command = "gd"
" we use `neocomplcache` plugin configured to work with `jedi` completion [1]
let g:jedi#popup_on_dot = 0

" }}}
" NERDTree {{{

" mappings {{{

map  <F2> :NERDTreeToggle<CR>
vmap <F2> <Esc>:NERDTreeToggle<CR>
imap <F2> <Esc>:NERDTreeToggle<CR>

" }}}

let g:NERDTreeWinSize = 33
" ignore backups and binary compiled python source
let NERDTreeIgnore = ['\~$', '*.pyc', '*.pyo']
let NERDTreeSortOrder = ['\/$', '\.py$', '\.html$', '\.less$',
            \'\.css$', '\.js$', '\.rb$', '\.php$',
            \'*', '\.sw?$',  '\.bak$', '\~$']

"}}}
" simple-commenter {{{

map <silent> ,c <Plug>(do-comment)
map <silent> ,C <Plug>(un-comment)
map <silent> ,, <Plug>(one-line-comment)

" }}}
" gundo {{{

nnoremap ,g :GundoToggle<CR>

" }}}
" auto-pairs {{{

let g:AutoPairsShortcutToggle = '<LocalLeader>a'

" }}}
" syntastic {{{

let g:syntastic_error_symbol='EE'
let g:syntastic_warning_symbol='⚠'
nnoremap <LocalLeader>l :lnext<CR>

" }}}
" WTF {{{

" prettify js
let g:syntax_js=['function', 'return', 'this', 'proto']
" enable brief indentation mode for js
let g:SimpleJsIndenter_BriefMode = 1

au FileType python nmap <buffer> <Leader>l :PyLint<CR>

let g:pymode_syntax_all = 1
let g:pymode_syntax_slow_sync = 1
let g:pymode_lint_cwindow = 1
let g:pymode_lint_write = 0
let g:pymode_run = 0
let g:pymode_run_key = 'E'
let g:pymode_doc_key = 'K'
let g:pymode_lint_onfly = 0

" Rope vim completion
let ropevim_vim_completion=1
let ropevim_enable_shortcuts=1
let ropevim_extended_complete=1
let g:ropevim_autoimport_modules = ["os"]
highlight SpellBad term=underline gui=undercurl guisp=Orange

" }}}
" Pytest {{{

nmap <silent><Leader>f <Esc>:Pytest file verbose<CR>
nmap <silent>E <Esc>:Pytest file<CR>
nmap <silent><Leader>c <Esc>:Pytest class<CR>
nmap <silent><Leader>m <Esc>:Pytest method<CR>

" }}}
" UltiSnips {{{

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:ultisnips_python_style="sphinx"

" }}}
" Zen coding {{{

let g:user_zen_leader_key = '<C-e>'
let g:user_zen_next_key = '<C-n>'
let g:user_zen_prev_key = '<C-N>'

" }}}
" Repeat {{{

silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

" }}}

" }}}
" Mini-plugins: stuff that should be broken into plugins but not yet {{{

" Highlight word {{{

" Provides a few mappings for temporary highlighting words.
function! HiIntrestingWord(n) " {{{
  " save location
  normal! mz
  normal! "zyiw
  " generate unique id (I hope so)
  let l:id = 86750 + a:n

  " clear existing matches
  silent! call matchdelete(l:id)

  " construct literal word pattern
  let l:pattern = '\V\<'.escape(@z, '\').'\>'

  " highlight word
  call matchadd('InterestingWord'.a:n, l:pattern, 1, l:id)

  " restore cursor position
  normal! `z
endfunction " }}}
" Mappings {{{

nnoremap <silent> <Leader>1 :call HiIntrestingWord(1)<CR>
nnoremap <silent> <Leader>2 :call HiIntrestingWord(2)<CR>
nnoremap <silent> <Leader>3 :call HiIntrestingWord(3)<CR>
nnoremap <silent> <Leader>4 :call HiIntrestingWord(4)<CR>
nnoremap <silent> <Leader>5 :call HiIntrestingWord(5)<CR>
nnoremap <silent> <Leader>6 :call HiIntrestingWord(6)<CR>

" }}}
" Default Highlights {{{

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" }}}

" }}}

" Custom commands: only do this part when compiled with support of autocommands {{{

if has("autocmd")
  filetype plugin indent on

  " update split size on resize Vim
  au VimResized * :wincmd =

  " auto change the current directory to the current file
  au BufEnter * lcd %:p:h

  " use skeleton template for new files
  au BufNewFile *.html   0r ~/Templates/skeleton.html
  au BufNewFile *.c      0r ~/Templates/skeleton.c
  au BufNewFile *.h      0r ~/Templates/skeleton.h

  " spell check when writing commit logs
  au FileType svn,*commit* setlocal spell

  " set type specific omni functions
  au FileType mustache set omnifunc=htmlcomplete#CompleteTags
  au FileType xhtml set omnifunc=htmlcomplete#CompleteTags
  au FileType html set omnifunc=htmlcomplete#CompleteTags
  au FileType pt set omnifunc=htmlcomplete#CompleteTags

  " Last position {{{

  " when editing a file, always jump to the last known cursor position
  augroup last_position
    au!
    au BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"zvzz" |
          \ endif
  augroup END

  " }}}
  " Source .vimrc {{{

  augroup source_vimrc
    au!
"     au BufWritePost $MYVIMRC source $MYVIMRC
  augroup END

  " }}}
  " Filetype specific {{{

  " Plain text {{{

  augroup text_width
    au!
    au FileType text setlocal textwidth=78
  augroup END

  " }}}
  " HTML and Jinja templates {{{

  augroup ft_html
    au!
    " more compact markup
    au FileType html,jinja setlocal shiftwidth=2
    " html tag autocompletion
    au FileType html,jinja imap ./ </<C-x><C-o>
  augroup END

  " }}}
  " CSS and LESS {{{

  augroup ft_lesscss
    au!
    au BufNewFile,BufRead *.less setlocal filetype=less

    au FileType less,css setlocal foldmethod=marker
    au FileType less,css setlocal foldmarker={,}
    au FileType less,css setlocal omnifunc=csscomplete#CompleteCSS

    au FileType less,css nnoremap <buffer> <LocalLeader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

    au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>
  augroup END

  " }}}
  " Vim {{{

  augroup ft_vim
    au!
    au FileType vim setlocal sw=2 foldmethod=marker foldmarker={{{,}}}
    au FileType help setlocal textwidth=78
  augroup END

  " }}}
  " Make {{{

  augroup ft_make
    au!
    au FileType make setlocal noexpandtab
  augroup END

  " }}}
  " Lua {{{

  augroup ft_lua
    au!
    au FileType lua setlocal textwidth=78
    au FileType lua setlocal sw=3
  augroup END

  " }}}
  " Python {{{

  augroup ft_python
    au!
    au FileType python setlocal makeprg=python\ %
"     au FileType python nnoremap <silent> <S-e> :silent make<CR>
    " the last line: \%-G%.%# is meant to suppress some late error messages that
    " I found could occur e.g.  with wxPython and that prevent one from using
    " :clast to go to the relevant file and line of the traceback.
    au FileType python setlocal errorformat=
          \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
          \%C\ \ \ \ %.%#,
          \%+Z%.%#Error\:\ %.%#,
          \%A\ \ File\ \"%f\"\\\,\ line\ %l,
          \%+C\ \ %.%#,
          \%-C%p^,
          \%Z%m,
          \%-G%.%#
    au BufNewFile *.py 0r ~/templates/skeleton.py

    " enable neocomplcache supports jedi-vim auto completion
    au FileType python let b:did_ftplugin = 1
  augroup END

  " }}}
  " Javascript {{{

  augroup ft_js
    au!
    au FileType javascript setlocal sw=2
    au FileType javascript setlocal foldmethod=marker
    au FileType javascript setlocal foldmarker={,}
    au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    au FileType javascript syntax sync minlines=200
    au FileType javascript setlocal conceallevel=2 concealcursor=cn
  augroup END

" prettify js
let g:syntax_js=['function', 'return', 'this', 'proto']

" enable brief indentation mode for js
let g:SimpleJsIndenter_BriefMode = 1
  augroup END

  " }}}

  " }}}
else
  set autoindent            " always set autoindenting on
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
" }}}
" References {{{
"
" [1] https://github.com/davidhalter/jedi-vim/issues/26
" [2] http://stackoverflow.com/questions/5312235/how-to-correct-vim-spelling-mistakes-quicker/#16481737
"
" }}}
