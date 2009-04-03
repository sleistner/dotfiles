# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

# Make bash check its window size after a process completes
shopt -s checkwinsize

complete -C rake-completion -o default rake

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="\e[31m\u\e[m@\e[36m\h\e[m \e[33m\w\e[m\$(parse_git_branch)\n\$ "
 
if [ "$TERM" != "dumb" ]; then
  eval `dircolors ~/.dircolors`
fi

LS='/opt/local/bin/gls'
if [ -x $LS ] ; then
   alias ls='gls'
   alias l='ls --color -C -F'
else
   alias l='ls -CF'
fi
alias ll='l -lh'
alias la='l -a'
alias l1='ls -1'
alias lla='ll -a'
