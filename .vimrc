" .vimrc
" created by wolfger@spearwolf.de !2002-2009
" last modified: 05.01.2009
" extended by sleistner@gmail.com

" --- general options -------------- --- --  -

set nocompatible
set tabstop=2
set shiftwidth=2
set softtabstop=2
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

" no backups
set nobackup
set nowritebackup

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

syntax on

let c_comment_strings=1
"let mapleader = ","

" --- rcodetools -------------- --- --  -

"set completeopt=menu,preview
"let g:rct_completion_use_fri=1

" --- fuzzy_finder_textmate --- --  -

let g:fuzzy_ignore = "*.log;*.png;*.jpg;*.gif;vendor/rails/**;coverage/**;tmp/**;.git/**;.svn/**"
let g:fuzzy_matching_limit = 30

" --- auto commands -------------- --- --  -

if has("autocmd")

    " Enable file type detection.
    filetype plugin indent on

    autocmd FileType text setlocal textwidth=78

    autocmd FileType html,rhtml,xml setlocal ai nosi sw=2 ts=2 sts=2 et

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

set grepprg=egrep\ -HErn\ --mmap\ --no-messages\ --colour=auto\ --exclude=tags\ --exclude=.*.swp\ --exclude=*.tmp\ --exclude=entries\ --exclude=*.pot\ --exclude=*.po\ --exclude=*.log\ --exclude=/tmp/*\ --exclude=*.svn-base\ --exclude=.svn\ --exclude=.git\ $*\ .

set list
set list listchars=tab:»·,trail:·

function! GrepCurrentWord()
   exec("grep \"" . expand("<cword>") . "\"")
   exec("copen")
endfunction

" SVN Mappings
map <leader>r :!svn resolved "%"<CR>

map <leader>f :call GrepCurrentWord()<CR>
map <leader>l :call JSLint("%")<CR>

" ======== mappings ========================== === ==  =

" --- visual mode -------------- --- --  -

" Move complete block one line down or up with <M-Down> and <M-Up> keys
vmap <silent> <M-Up> :m'<-2<CR>gv
vmap <silent> <M-Down> :m'>+1<CR>gv

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

"NERD_Commenter
map <silent> <C-c> ,ci

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

" Shortcut to the NERD_tree (plugin)
map <silent> <S-F2> <Esc>:NERDTreeToggle<CR>
map <leader>e :execute 'NERDTreeToggle ' . getcwd()<CR>

" Shortcut to the BufExplorer (plugin)
map <silent> <F5> <Esc>\be
map <leader>b :FuzzyFinderBuffer<CR>

"map <silent> <S-F4> :FilesystemExplorer<CR>

" Switch between tabs (vim7 only!)
map <silent> <A-D-Left> :tabprevious<cr>
map <silent> <A-D-Right> :tabnext<cr>

" Create new tab (after current tab)
map <silent> <O-t> :tabnew<CR>
map <silent> <M-t> :tabnew<CR>

map <silent> <S-O-t> :tabnew<CR>:e\ .<CR>
map <silent> <S-M-t> :tabnew<CR>:e\ .<CR>

" Execute file as ruby
map <silent> <F7> <Esc>:tabnew\|r!ruby #<CR>
map <D-1> <Esc>:!ruby "%"<CR>

" Execute file as ./script/console
map <silent> <D-F7> <Esc>:tabnew\|r!script/runner #<CR>
map <silent> <A-F7> <Esc>:tabnew\|r!script/runner #<CR>

" Run Ruby unit tests with gT (for all) or gt (only test under
" cursor) in command mode
augroup RubyTests
  au!
  autocmd BufRead,BufNewFile *_test.rb,test_*.rb
    \ :nmap gt V:<C-U>!$HOME/.vim/bin/ruby-run-focused-unit-test
    \ % <C-R>=line("'<")<CR>p <CR>|
    \ :nmap gT :<C-U>!ruby %<CR>
augroup END

autocmd BufWritePre * %s/\s\+$//eg

" Check ruby syntax
map <leader>v :!ruby -c %:.<CR>

" --- insert mode -------------- --- --  -

" Textmate(ruby) like insert ' => '
imap <silent> <C-l> <Space>=><Space>

" -- abbreviations -------------------------- --- --  -

"iabbr <% <% %><Esc>hhi
iabbr <%- <%- -%><Esc>hhhi
iabbr <%= <%= %><Esc>hhi
iabbr <%# <%= %><Esc>hhi

" === gui settings =========================== === ==  =

if has("gui_running")

" --- MacVim -------------- --- --  -
  set guioptions=egmrt

  if has("gui_macvim")

    set transp=5
    let macvim_skip_cmd_opt_movement=1

    if has("autocmd")
      autocmd GUIEnter * winsize 140 45
      autocmd GUIEnter * set guifont=Monaco:h12
    endif

  endif

" --- window size and fonts -------------- --- --  -

    if has("autocmd")


        if ! has("gui_macvim")
          autocmd GUIEnter * winsize 110 40
          autocmd GUIEnter * set guifont=Monospace\ 10
        endif
    endif


" === colors/ colorscheme ============== === ==  =

    colorscheme railscast
    "colorscheme github

endif " gui_running


