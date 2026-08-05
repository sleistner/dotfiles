#!/usr/bin/env bash
# Shared prelude for the Raycast script commands in this directory.
# Hidden so Raycast's directory scan skips it.

# Raycast launches scripts from launchd, which has none of the PATH shell/env builds.
PATH="$HOME/.bin:$HOME/.local/bin:$HOME/.cargo/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/config/dotfiles}"

# Run a command in a new Ghostty window that stays up until a keypress.
# Ghostty's +new-window action is unsupported on macOS, so `open -na` it is.
run_in_terminal() {
  open -na Ghostty --args -e /bin/zsh -lic \
    "$*; printf '\n'; read -k1 '?Press any key to close…'"
}
