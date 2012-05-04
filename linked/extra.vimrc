set wildmode=full
set wildmenu
set list listchars=tab:»·,trail:·

" Vundle
Bundle 'sleistner/vim-jshint'

if has("autocmd")
    filetype plugin indent on

    " Rails plugin autocmds
    autocmd User Rails.javascript* set ai nosi ts=4 sw=4 sts=4
    autocmd User Rails Rnavcommand factory spec/factories -suffix=.rb -default=model()

    autocmd User Rails Rnavcommand jsmodel      app/assets/javascripts/backbone/models      -suffix=.js   -default=javascripts()
    autocmd User Rails Rnavcommand jscollection app/assets/javascripts/backbone/collections -suffix=.js   -default=javascripts()
    autocmd User Rails Rnavcommand jsview       app/assets/javascripts/backbone/views       -suffix=.js   -default=javascripts()
    autocmd User Rails Rnavcommand jsrouter     app/assets/javascripts/backbone/routers     -suffix=.js   -default=javascripts()
    autocmd User Rails Rnavcommand jstemplate   app/assets/javascripts/backbone/templates   -suffix=.haml -default=javascripts()

    autocmd User Rails Rnavcommand jsspec       spec/javascripts -suffix=_spec.js -default=javascripts()

    autocmd FileType js,scss,sass,css setlocal ai nosi sw=4 ts=4 sts=4
endif

" NERDTree settings
map <silent> <leader>` :NERDTreeFind<CR>

" Move complete block one line down or up with <M-Down> and <M-Up> keys
vmap <silent> <C-M-Up> :m'<-2<CR>gv
vmap <silent> <C-M-Down> :m'>+1<CR>gv

function! RmTrailingWhitespaces()
  let pos = getpos('.')
  :%s/\s*$//ge
  call setpos('.', pos)
endf

autocmd BufWritePre * call RmTrailingWhitespaces()

