# vim:syntax=sh

# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

BASH_DIR=`readlink ~/.bashrc | xargs dirname`/bash
. $BASH_DIR/env
. $BASH_DIR/config
. $BASH_DIR/aliases
. $BASH_DIR/completions/git
. $BASH_DIR/completions/rake
. $BASH_DIR/functions

