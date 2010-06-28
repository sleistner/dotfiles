" File:         jslint.vim
" Author:       Steffen Leistner (sleistner@gmail.com)
" Version:      0.1
" Description:  jslint.vim allows the JavaScript Lint (fulljslint.js) from
"               http://www.jslint.com to be tightly integrated with vim.
"               The contents of a javascript file will be passed through the jslint program
"               after the file's buffer is saved.  Any lint warnings will be placed in
"               the quickfix window.  If you're not on a mac SpiderMonkey must be installed on your system
"               for this plugin to work properly.
" Last Modified: April 6, 2010
" Credits: heavily borrowed from Joe Stelmach's javascriptLint.vim

if !exists('jslint_plugin_path')
    let runtimepaths = &runtimepath . ','
    while strlen(runtimepaths) != 0
      let filepath = substitute(runtimepaths, ',.*', '', '') . '/plugin/jslint'
      if filereadable(filepath . '/parser.js')
        let jslint_plugin_path = filepath
        break
      endif
      let runtimepaths = substitute(runtimepaths, '[^,]*,', '', '')
    endwhile
endif

if !exists("jslint_parser")
    let jslint_parser = jslint_plugin_path . '/parser.js'
endif

if !exists("fulljslint")
    let fulljslint = jslint_plugin_path . '/fulljslint.js'
endif

if !exists("jslint_command")
    let jsc = '/System/Library/Frameworks/JavaScriptCore.framework/Resources/jsc'
    if executable(jsc)
        let js_interpreter = jsc
        let sep = ' -- '
    elseif executable('js')
        let js_interpreter = 'js'
        let sep = ' '
    endif
    let jslint_command = js_interpreter . ' ' . jslint_parser . sep . fulljslint
endif

if !exists("jslint_highlight_color")
  let jslint_highlight_color = 'DarkMagenta'
endif

if !exists("jslintrc")
    let jslintrc_file = expand('~/.jslintrc')
    if filereadable(jslintrc_file)
        let jslintrc = readfile(jslintrc_file)
    else
        let jslintrc = []
    end
endif

" set up auto commands
autocmd BufWritePost,FileWritePost *.js call s:JSLint()
autocmd BufWinLeave * call s:MaybeClearCursorLineColor()

" Runs the current file through javascript lint and
" opens a quickfix window with any warnings
function! s:JSLint()
  " run javascript lint on the current file
  let current_file = shellescape(expand('%:p'))
  let cmd_output = system(g:jslint_command . ' ' . current_file, join(g:jslintrc + getline(1, line("$")), "\n") . "\n")
  let &errorformat='%f(%l): %m'
  " if some warnings were found, we process them
  if strlen(cmd_output) > 0

    " write quickfix errors to a temp file
    let quickfix_tmpfile_name = tempname()
    exe "redir! > " . quickfix_tmpfile_name
      silent echon cmd_output
    redir END
    " read in the errors temp file
    execute "silent! cfile " . quickfix_tmpfile_name

    " change the cursor line to something hard to miss
    call s:SetCursorLineColor()

    " open the quicfix window
    botright copen
    let s:qfix_win = bufnr("$")

    " delete the temp file
    call delete(quickfix_tmpfile_name)

  " if no javascript warnings are found, we revert the cursorline color
  " and close the quick fix window
  else
    call s:ClearCursorLineColor()
    cclose
  endif
endfunction

" sets the cursor line highlight color to the error highlight color
function s:SetCursorLineColor()
  call s:ClearCursorLineColor()
  let s:highlight_on = 1

  " find the current cursor line highlight info
  redir => l:highlight_info
    silent highlight CursorLine
  redir END

  " find the guibg property within the highlight info (if it exists)
  let l:start_index = match(l:highlight_info, "guibg")
  if(l:start_index > 0)
    let s:previous_cursor_guibg = strpart(l:highlight_info, l:start_index)

  elseif(exists("s:previous_cursor_guibg"))
    unlet s:previous_cursor_guibg
  endif

  execute "highlight CursorLine guibg=" . g:jslint_highlight_color
endfunction

" Conditionally reverts the cursor line color based on the presence
" of the quickfix window
function s:MaybeClearCursorLineColor()
  if(exists("s:qfix_win") && s:qfix_win == bufnr("%"))
    call s:ClearCursorLineColor()
  endif
endfunction

" Reverts the cursor line color
function s:ClearCursorLineColor()
  " only revert if our highlight is currently enabled
  if(exists("s:highlight_on") && s:highlight_on)
    let s:highlight_on = 0

    " if a previous cursor guibg color was recorded, we use it
    if(exists("s:previous_cursor_guibg"))
      execute "highlight CursorLine " . s:previous_cursor_guibg
      unlet s:previous_cursor_guibg

    " otherwise, we clear the curor line highlight entirely
    else
      highlight clear CursorLine
    endif
  endif
endfunction

