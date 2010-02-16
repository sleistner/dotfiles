if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# vim:syntax=sh

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

