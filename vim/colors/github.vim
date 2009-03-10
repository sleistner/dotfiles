
" ----------------------------------------------------------
" a light colorscheme based on syntax hiliting on github.com
" ----------------------------------------------------------
set background=light

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "github"

hi Normal       gui=NONE    guibg=#f8f8ff  guifg=#000000
hi Constant     gui=NONE                   guifg=#990073
hi String       gui=NONE    guibg=#eeeef6  guifg=#DD1144

hi Type         gui=NONE                   guifg=#008080

hi Identifier   gui=bold                   guifg=#445588
hi Statement    gui=bold                   guifg=#000000
hi PreProc      gui=bold                   guifg=#203060

hi Comment      gui=italic                 guifg=#609060

hi Special      gui=NONE    guibg=#eeeef6  guifg=#3f0900
hi SpecialKey   gui=NONE    guibg=#d8d8df  guifg=#ffffff

hi Ignore       gui=NONE    guibg=#e0e8f0  guifg=#0000ff

hi Folded       gui=italic  guibg=#c5d3ef  guifg=#000000
hi NonText      gui=NONE    guibg=#b5c3df  guifg=#666666
"hi NonText      gui=NONE    guibg=#ffffff  guifg=#cccccc
"hi LineNr       gui=NONE    guibg=#d0d0e0  guifg=#6068f0
hi LineNr       gui=NONE    guibg=#eeeef6  guifg=#888888
hi String       gui=NONE    guibg=#eeeef6  guifg=#DD1144

hi Cursor       gui=NONE    guibg=#dd0050  guifg=#ffffff
hi CursorLine   gui=NONE    guibg=#e5f3ff

hi Visual       gui=NONE    guibg=#b5c3df

hi StatusLine   gui=NONE    guibg=#000000  guifg=#f0ff60
hi StatusLineNC gui=italic  guibg=#304050  guifg=#ffffff 
hi TabLine      gui=italic  guibg=#90A0B0  guifg=#a00040 
hi Pmenu        gui=NONE    guibg=#90A0B0  guifg=#d0e0f0 
hi PmenuSel     gui=NONE    guibg=#B0C0D0  guifg=#ffffe0 

"hi VertSplit    gui=NONE    guibg=#c0c0c0  guifg=#204060
hi VertSplit    gui=NONE    guibg=#b5c3df  guifg=#666666

