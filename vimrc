" .vimrc
" created by wolfger@spearwolf.de !2002-2009
" last modified: 05.01.2009
" extended by sleistner@gmail.com

" --- general options -------------- --- --  -

set nocompatible
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set cindent
set foldmethod=marker
set laststatus=2
set cmdheight=2
set hlsearch
set incsearch
set showcmd
set ruler
set nowrap
set wildmode=full
set wildmenu
set ttyfast
set hidden
set display=lastline,uhex

set encoding=utf-8
set termencoding=utf-8

"set background=dark

" no backups
set nobackup
set nowritebackup

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

syntax on

let c_comment_strings = 1

" --- fuzzy_finder_textmate --- --  -

let g:fuzzy_ignore = "*.log;*.png;*.jpg;*.gif;vendor/rails/**;coverage/**;tmp/**;.git/**;.svn/**;javascripts-cc/**"
let g:fuzzy_matching_limit = 30

" --- auto commands -------------- --- --  -

if has("autocmd")

    " Enable file type detection.
    filetype plugin indent on

    autocmd FileType text setlocal textwidth=78

    autocmd FileType html,rhtml,xml,feature,cucumber setlocal ai nosi sw=2 ts=2 sts=2 et

    autocmd FileType ruby,eruby setlocal sw=2 ts=2 sts=2

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif

else

    set autoindent

endif


" --- viminfo -------------- --- --  -

" The idea of "viminfo" is to save info from one editing session for the
" next by saving the data in an viminfo file". So next time I satrt up Vim I
" can use the search patterns from the search history and the commands from
" the command line again. I can also load files again with a simple ":b
" bufname". And Vim also remember where the cursor was in the files I
" edited. See ":help viminfo" for more info on Vim's "viminfo". :-}

set viminfo=%,'50,\"100,:100,n~/.viminfo

set dir=~/.tmp

set grepprg=egrep\ -Hrn\ --mmap\ --no-messages\ --colour=auto\ --exclude=tags\ --exclude=*.o\ --exclude=.*.swp\ --exclude=*.tmp\ --exclude=entries\ --exclude=*.pot\ --exclude=*.po\ --exclude=*.log\ --exclude-dir=tmp\ --exclude=*.svn-base\ --exclude-dir=.svn\ --exclude-dir=build\ --exclude-dir=.git\ $*\ .

set list
set list listchars=tab:»·,trail:·

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menuone
set wildmode=list:longest,list:full
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" case only matters with mixed case expressions
set ignorecase
set smartcase

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

function! GrepCurrentWord()
   exec("grep \"" . expand("<cword>") . "\"")
   exec("copen")
endfunction

" ======== mappings ========================== === ==  =

map <leader>f :call GrepCurrentWord()<CR>
map <leader>l :call JSLint("%")<CR>

" Move complete block one line down or up with <M-Down> and <M-Up> keys
vmap <silent> <M-Up> :m'<-2<CR>gv
vmap <silent> <M-Down> :m'>+1<CR>gv

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

"NERD_Commenter
map <leader>\ ,ci

" --- normal mode -------------- --- --  -

map <leader>i :set invlist<CR>
map <leader>w :set nowrap!<CR>

map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

"Shortcut to :copen
map <leader>c :copen<CR>

" Jump into tags (and <Alt-Left> to go back)
map <silent> <F3> <C-]>
map <silent> <M-Left> <C-T>

" Shortcut to the FuzzyFinderTextMate (plugin)
map <leader>t :FuzzyFinderTextMate<CR>

" NERDTree settings (launch with \nt or \\)
let g:NERDTreeQuitOnOpen = 0
map <silent> <leader>e :NERDTreeToggle<CR>
map <silent> <leader>` :NERDTreeFind <CR>

" Shortcut to the BufExplorer (plugin)
map <silent> <F5> <Esc>\be
map <leader>b :FuzzyFinderBuffer<CR>

" Switch between tabs (vim7 only!)
map <silent> <A-D-Left> :tabprevious<cr>
map <silent> <A-D-Right> :tabnext<cr>

" Create new tab (after current tab)
map <silent> <O-t> :tabnew<CR>
map <silent> <M-t> :tabnew<CR>

map <silent> <S-O-t> :tabnew<CR>:e\ .<CR>
map <silent> <S-M-t> :tabnew<CR>:e\ .<CR>

function! RmTrailingWhitespaces()
  let pos = getpos('.')
  :%s/\s*$//ge
  call setpos('.', pos)
endf

" When editing a file, always jump to the last cursor position
autocmd BufWritePre * call RmTrailingWhitespaces()

" Check ruby syntax
map <leader>v :!ruby -c %:.<CR>

" --- insert mode -------------- --- --  -

" Textmate(ruby) like insert ' => '
imap <silent> <C-l> <Space>=><Space>

" -- abbreviations -------------------------- --- --  -

iabbr <%- <%- -%><Esc>hhhi
iabbr <%= <%= %><Esc>hhi
iabbr <%# <%= %><Esc>hhi

" === gui settings =========================== === ==  =

if has("gui_running")

" --- MacVim -------------- --- --  -
  set guioptions=egmrt

  if has("gui_macvim")

    set transp=15
    let macvim_skip_cmd_opt_movement=1

    if has("autocmd")
      autocmd GUIEnter * set guifont=Monaco:h12
    endif

  endif

" --- window size and fonts -------------- --- --  -

    if has("autocmd")
        autocmd GUIEnter * winsize 140 45

        if ! has("gui_macvim")
          autocmd GUIEnter * set guifont=Monospace\ 10
        endif
    endif


" === colors/ colorscheme ============== === ==  =

  colorscheme macvim

endif " gui_running
