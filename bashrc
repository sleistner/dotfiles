# vim:syntax=sh

BASH_DIR=`readlink $HOME/.bashrc | xargs dirname`/bash
source $BASH_DIR/env
source $BASH_DIR/config
source $BASH_DIR/aliases
source $BASH_DIR/completions/git
source $BASH_DIR/completions/rake
source $BASH_DIR/functions

