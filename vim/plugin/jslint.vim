"function! s:JSLint()
  "if exists('b:errors')
    "for error in b:errors
      "call matchdelete(error)
    "endfor
  "endif

  "let b:errors = []

  "Set up command and parameters
  "let s:plugin_path = '"' . expand("~/") . '"'
  "let s:plugin_path = s:plugin_path . ".vim"
  "let s:plugin_path = s:plugin_path . "/plugin/jslint/"
  "let s:cmd = s:plugin_path . "jsl"
  "let s:conf_file = s:plugin_path . "jsl.vim.conf"
  "let s:cmd = s:cmd . " -nologo -conf " . s:conf_file .  " -process " . bufname('%')

  "let b:jslint_output = system(s:cmd, join(getline(1, '$'), "\n") . "\n")
  "echo system(s:cmd, join(getline(1, '$'), "\n") . "\n")

  "for error in split(b:jslint_output, "\n")
    "echo "error: " . error
    "let b:parts = matchlist(error, "\\(\\d\\+\\)")
    "if !empty(b:parts)
      "call add(b:errors, matchadd('Error', '\%'.b:parts[1].'l'))
    "elseif error == "All Good."
      "echo "JSLint: " . error
    "endif
  "endfor
  "for error in b:errors
    "echo error
  "endfor
"endfunction

"command! JSLint :call s:JSLint()
"set makeprg='~/.vim/plugin/jslint/jsl -nologo -nofilelisting -nosummary -nocontext -conf ~/.vim/plugin/jslint/jsl.conf -process %'

