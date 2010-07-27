#!/bin/bash
/System/Library/Frameworks/JavaScriptCore.framework/Resources/jsc ~/.vim/plugin/jslint/parser.js -- "/Users/sleistner/.vim/plugin/jslint/fulljslint.js" "$1" "$(cat $1)"

