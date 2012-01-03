" ---------------------------------------------------------------
" a light colorscheme inspired by syntax hiliting from github.com
" created by wolfger@spearwolf.de
" ---------------------------------------------------------------

set background=light

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "github"

hi Normal       gui=NONE    guibg=#f8f8ff  guifg=#000000
"hi Constant     gui=NONE                   guifg=#990073
hi Constant     gui=NONE                   guifg=#bb0023
hi String       gui=NONE    guibg=#f0f0f6  guifg=#dd6688

hi Type         gui=NONE                   guifg=#306090
hi JavaScriptFunction gui=NONE                guifg=#306090

"hi Identifier   gui=bold                   guifg=#445599
"hi PreProc      gui=bold                   guifg=#445599
hi PreProc      gui=bold                   guifg=#555555
hi Statement    gui=bold                   guifg=#000000
"hi PreProc      gui=underline              guifg=#222222
hi Identifier   gui=underline              guifg=#222222

hi coffeeBoolean gui=NONE guifg=#992200
hi JavaScriptValue gui=NONE guifg=#992200
hi coffeeAssignment gui=bold guifg=#111111

hi Comment      gui=italic  guibg=#e8e8ef  guifg=#408050

hi Special      gui=NONE    guibg=#eeeef6  guifg=#3f0900
hi SpecialKey   gui=NONE    guibg=#d8d8df  guifg=#ffffff

hi Ignore       gui=NONE    guibg=#e0e8f0  guifg=#0000ff

hi Folded       gui=italic  guibg=#d5e3ff  guifg=#000000
hi NonText      gui=NONE    guibg=#b5c3df  guifg=#666666
hi LineNr       gui=NONE    guibg=#eeeef6  guifg=#888888
"hi String       gui=NONE    guibg=#eeeef6  guifg=#DD1144
hi String       gui=NONE    guibg=#f0f0e0  guifg=#EE5500

hi Cursor       gui=NONE    guibg=#0050f0  guifg=#ffff70
hi CursorLine   gui=NONE    guibg=#e5f3ff

"hi Visual       gui=NONE    guibg=#b5c3df
hi Visual       gui=NONE    guibg=#333333  guifg=#f0f0f0

hi StatusLine   gui=NONE    guibg=#000000  guifg=#f0ff60
hi StatusLineNC gui=italic  guibg=#304050  guifg=#ffffff 
hi TabLine      gui=italic  guibg=#90A0B0  guifg=#a00040 
hi Pmenu        gui=NONE    guibg=#90A0B0  guifg=#d0e0f0 
hi PmenuSel     gui=NONE    guibg=#B0C0D0  guifg=#ffffe0 

hi VertSplit    gui=NONE    guibg=#b5c3df  guifg=#666666

