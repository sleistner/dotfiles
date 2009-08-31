# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

BASH_DIR=~/Projects/dotfiles/bash
. $BASH_DIR/env
. $BASH_DIR/config
. $BASH_DIR/aliases
. $BASH_DIR/completions/git
. $BASH_DIR/completions/rake
. $BASH_DIR/functions


