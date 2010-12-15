" === gui settings =========================== === ==  =

if has("gui_running")

" --- MacVim -------------- --- --  -

  set guioptions=egmrt
  set guioptions-=r

  if has("gui_macvim")

    "set transp=10
    let macvim_skip_cmd_opt_movement=1

    if has("autocmd")
      autocmd GUIEnter * set guifont=Monaco:h12
    endif

 " --- Mappings ------------------- --- --  - "
    macmenu &File.New\ Tab key=<nop>
    map <D-t> :CommandT<CR>

  endif

" --- window size and fonts -------------- --- --  -

    if has("autocmd")
        autocmd GUIEnter * winsize 155 55

        if ! has("gui_macvim")
          autocmd GUIEnter * set guifont=Monospace\ 10
        endif
    endif


" === colors/ colorscheme ============== === ==  =

  colorscheme slate

endif " gui_running

