" --- colorscheme -=* wolfcrystal *=- --------- --- --  -

set background=light

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "wolfcrystal"

hi Normal       gui=NONE    guibg=#d5e3ff  guifg=#000000
hi Comment      gui=italic  guibg=#e5f3ff  guifg=#006010
hi Constant     gui=NONE    guibg=#cedcef  guifg=#102050
hi Special      gui=NONE    guibg=#deecff  guifg=#3f0900
hi Identifier   gui=bold                   guifg=#002a67
hi Statement    gui=bold                   guifg=#a00000
hi PreProc      gui=bold                   guifg=#000000
hi Type         gui=NONE                   guifg=#204a87
hi Ignore       gui=NONE    guibg=#e0e8f0  guifg=#0000ff

hi Folded       gui=italic  guibg=#c5d3ef  guifg=#000000
hi NonText      gui=NONE    guibg=#b5c3df  guifg=#666666
hi LineNr       gui=NONE    guibg=#d0d0e0  guifg=#6068f0
hi Cursor       gui=NONE    guibg=#f00060  guifg=#f0ff60
hi CursorLine   gui=NONE    guibg=#e5f3ff
hi Visual       gui=NONE    guibg=#ffffff  guifg=#000000

hi StatusLine   gui=NONE    guibg=#000000  guifg=#f0ff60
hi StatusLineNC gui=italic  guibg=#ffffff  guifg=#a00040 
hi TabLine      gui=italic  guibg=#90A0B0  guifg=#a00040 
hi Pmenu        gui=NONE    guibg=#90A0B0  guifg=#d0e0f0 
hi PmenuSel     gui=NONE    guibg=#B0C0D0  guifg=#ffffe0 
hi SpecialKey                              guifg=#0000ff

