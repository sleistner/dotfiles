" --- colorscheme -=* wolfcrystal *=- --------- --- --  -

set background=light

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "wolfcrystal"

hi Normal       gui=NONE    guibg=#f5faf0  guifg=#000000
hi Comment      gui=italic  guibg=#e5fff3  guifg=#006010
hi Constant     gui=NONE    guibg=#e0f5f5  guifg=#102050
hi String       gui=NONE    guibg=#efefce  guifg=#604010
hi Character    gui=NONE    guibg=#efdcce  guifg=#502010
hi Special      gui=NONE    guibg=#deecff  guifg=#3f0900
hi Identifier   gui=bold                   guifg=#002a67
hi Statement    gui=bold                   guifg=#a00040
hi PreProc      gui=bold                   guifg=#000000
hi Type         gui=NONE                   guifg=#204a87
hi Ignore       gui=NONE    guibg=#e0e8f0  guifg=#0000ff

hi Folded       gui=italic  guibg=#d5dad0  guifg=#000030
hi NonText      gui=NONE    guibg=#b5c3df  guifg=#666666
hi LineNr       gui=NONE    guibg=#d0d0e0  guifg=#6068f0
hi Cursor       gui=NONE    guibg=#00ff60  guifg=#ffffff
hi CursorLine   gui=NONE    guibg=#e5f3ff
hi Visual       gui=NONE    guibg=#204070  guifg=#ffffff

hi StatusLine   gui=NONE    guibg=#000000  guifg=#f0ff60
hi StatusLineNC gui=italic  guibg=#505050  guifg=#c0cf30
hi TabLine      gui=italic  guibg=#90A0B0  guifg=#a00040
hi Pmenu        gui=NONE    guibg=#90A0B0  guifg=#d0e0f0
hi PmenuSel     gui=NONE    guibg=#B0C0D0  guifg=#ffffe0
hi SpecialKey                              guifg=#ffffff

"hi rubyBlock                gui=bold
"hi rubyControl              gui=bold
"hi rubyDoBlock              gui=bold
"hi rubyCurlyBlock           gui=bold

hi rubyBeginEnd gui=bold                   guifg=#000000
"hi rubyBlockParameterList   gui=bold
"hi rubyBlockArgument        gui=bold
"hi rubyMethodDeclaration    gui=bold

"hi rubyRegexpDelimiter xxx cleared
"hi rubyRegexp     xxx cleared
"hi rubyHeredocStart xxx cleared
"hi rubyAliasDeclaration2 xxx cleared
"hi rubyAliasDeclaration xxx cleared
"hi rubyMethodDeclaration xxx cleared
"hi rubyClassDeclaration xxx cleared
"hi rubyModuleDeclaration xxx cleared
"hi rubyCaseExpression xxx cleared
"hi rubyConditionalExpression xxx cleared

