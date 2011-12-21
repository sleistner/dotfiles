" --- colorscheme -=* snowcrystal *=- --------- --- --  -

set background=light

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "snowcrystal"

hi Normal       gui=NONE    guibg=#ffffff  guifg=#000000
hi Comment      gui=italic  guibg=#ffe5f3  guifg=#600010
hi Constant     gui=NONE    guibg=#e0f5f5  guifg=#102050
hi String       gui=NONE    guibg=#ffffea  guifg=#606000
hi Character    gui=NONE    guibg=#efdcce  guifg=#502010
hi Special      gui=NONE    guibg=#fafafa  guifg=#3f0900
hi Identifier   gui=bold                   guifg=#002a67
hi Statement    gui=bold                   guifg=#a00060
hi PreProc      gui=bold                   guifg=#000000
hi Type         gui=NONE                   guifg=#204a87
hi Ignore       gui=NONE    guibg=#e0e8f0  guifg=#0000ff

hi Folded       gui=italic  guibg=#fffff0  guifg=#000000
hi NonText      gui=NONE    guibg=#b5c3df  guifg=#666666
hi LineNr       gui=NONE    guibg=#d0d0e0  guifg=#6068f0
hi Cursor       gui=NONE    guibg=#00ff60  guifg=#ffffff
hi CursorLine   gui=NONE    guibg=#e5f3ff
hi Visual       gui=NONE    guibg=#204070  guifg=#ffffff

"hi StatusLine   gui=NONE    guibg=#000000  guifg=#f0ff60
"hi StatusLineNC gui=italic  guibg=#505050  guifg=#c0cf30
hi StatusLine term=BOLD,reverse cterm=NONE ctermfg=Yellow ctermbg=DarkGray gui=BOLD guibg=#56A0EE guifg=white
hi StatusLineNC gui=NONE guibg=#56A0EE guifg=#E9E9F4
hi! link VertSplit StatusLineNC
hi WildMenu gui=UNDERLINE guifg=#56A0EE guibg=#E9E9F4

hi TabLine      gui=italic  guibg=#90A0B0  guifg=#a00040
hi Pmenu        gui=NONE    guibg=#90A0B0  guifg=#d0e0f0
hi PmenuSel     gui=NONE    guibg=#B0C0D0  guifg=#ffffe0
hi SpecialKey                              guifg=#ffffff

hi rubyConstant             gui=NONE                   guifg=#204a87
hi rubyException            gui=bold                   guifg=#f00000
hi rubyBeginEnd             gui=bold                   guifg=#000000
hi railsMethod              gui=bold                   guifg=#600060
hi rubyInterpolation        gui=NONE    guibg=#e5fff3  guifg=#006010

hi rubyClass                gui=bold                   guifg=#800040
hi rubyBlock                gui=NONE    guibg=#f8f8f8
hi rubyDoBlock              gui=NONE    guibg=#f0f0f0
hi rubyBlockParameterList   gui=bold    guibg=#f0f0f0  guifg=#000000
hi rubyBlockParameter       gui=italic                 guifg=#105020

hi rubyInstanceVariable     gui=bold                   guifg=#204a87
hi rubyClassVariable        gui=bold                   guifg=#002a67
hi rubyGlobalVariable       gui=bold                   guifg=#303030
hi rubyPredefinedVariable   gui=bold    guibg=#000000  guifg=#ffffff
hi rubyPseudoVariable       gui=bold    guibg=#ffffff  guifg=#000000

