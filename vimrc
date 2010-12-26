" .vimrc
" created by wolfger@spearwolf.de !2002-2009
" last modified: 05.01.2009
" extended by sleistner@gmail.com

" --- general options -------------- --- --  -
filetype off
call pathogen#runtime_append_all_bundles()

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
vmap <silent> <C-M-Up> :m'<-2<CR>gv
vmap <silent> <C-M-Down> :m'>+1<CR>gv

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

"NERD_Commenter Toggle
map <leader>\ <leader>c<space>

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

" NERDTree settings (launch with \nt or \\)
let g:NERDTreeQuitOnOpen = 0
map <silent> <leader>e :NERDTreeToggle<CR>
map <silent> <leader>` :NERDTreeFind<CR>

" Shortcut to the BufExplorer (plugin)
map <silent> <F5> <Esc>\be

" Switch between tabs (vim7 only!)
map <silent> <A-D-Left> :tabprevious<cr>
map <silent> <A-D-Right> :tabnext<cr>

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

